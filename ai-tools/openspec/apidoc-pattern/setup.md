# apidoc-pattern 建置指南

`apidoc-pattern` 的落地步驟與可直接複製的工具程式碼。規範本身見 [spec.md](./spec.md)。

## 1. 安裝與設定

```bash
composer require darkaonline/l5-swagger
php artisan vendor:publish --provider "L5Swagger\L5SwaggerServiceProvider"
```

`config/l5-swagger.php` 的掃描路徑指向 `documents/`：

```php
'documentations' => [
    'default' => [
        'api' => ['title' => '<專案名稱> API'],
        'routes' => ['api' => 'api/documentation'],
        'paths' => [
            'docs_json' => 'api-docs.json',
            'annotations' => [
                base_path('documents'),
            ],
        ],
    ],
],
```

`composer.json` 註冊 autoload 後 `composer dump-autoload`：

```json
"autoload": {
    "psr-4": {
        "App\\": "app/",
        "Document\\": "documents/"
    }
}
```

文件路由建議掛上與後台相同的登入 middleware（`defaults.routes.middleware`），避免 API 結構對外公開。

## 2. 全域資訊與共用元件

`documents/Info.php`：

```php
<?php

namespace Document;

use OpenApi\Attributes as OA;

#[OA\Info(version: '1.0.0', title: '<專案名稱> API', description: '...')]
#[OA\Server(url: L5_SWAGGER_CONST_HOST, description: '<環境>')]
#[OA\SecurityScheme(
    securityScheme: 'BearerAuth',
    type: 'http',
    scheme: 'bearer',
    bearerFormat: 'JWT'
)]
#[OA\Tag(name: 'SYS', description: '系統核心')]
class Info
{
}
```

`documents/Components.php` 放共用的 schema、response 與 example：

```php
<?php

namespace Document;

use OpenApi\Attributes as OA;

#[OA\Components(
    schemas: [
        new OA\Schema(
            schema: 'ApiSuccess',
            required: ['status', 'data'],
            properties: [
                new OA\Property(property: 'status', type: 'boolean', example: true),
                new OA\Property(property: 'data', description: '回傳資料，型別依 endpoint 而異'),
            ],
            type: 'object'
        ),
        new OA\Schema(
            schema: 'ApiError',
            description: 'HTTP status 仍為 200，以 status 欄位判斷成敗。',
            required: ['status', 'code'],
            properties: [
                new OA\Property(property: 'status', type: 'boolean', example: false),
                new OA\Property(property: 'code', type: 'integer', example: 400),
                new OA\Property(property: 'msg', type: 'string', nullable: true),
            ],
            type: 'object'
        ),
    ],
    responses: [
        new OA\Response(
            response: 'ApiErrorResponse',
            description: '執行失敗（HTTP 仍為 200）',
            content: new OA\JsonContent(ref: '#/components/schemas/ApiError')
        ),
    ]
)]
class Components
{
}
```

## 3. 單支文件檔的形狀

`app/Http/Controllers/Rpc4/WF/CategoryController.php` → `documents/Rpc4/Wf/Category.php`：

```php
<?php

namespace Document\Rpc4\Wf;

use OpenApi\Attributes as OA;

#[OA\Post(
    path: '/rpc/v4/wf/category/list',
    summary: '表單分類列表',
    security: [['BearerAuth' => []]],
    tags: ['WF'],
    responses: [
        new OA\Response(
            response: 200,
            description: '執行成功',
            content: new OA\JsonContent(ref: '#/components/schemas/ApiSuccess')
        ),
        new OA\Response(response: 'default', ref: '#/components/responses/ApiErrorResponse'),
    ],
)]
class Category
{
}
```

class body 保持空的；說明一律寫在 `summary`／`description`。

## 4. endpoint 清單指令

複製到 `app/Console/Commands/DocumentEndpoints.php`，只需改 `security()` 內的 middleware 對應。

```php
<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Routing\Route as RoutingRoute;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Str;
use ReflectionClass;
use ReflectionMethod;
use ReflectionNamedType;

/**
 * 輸出 endpoint 清單供撰寫 documents/ 下的 OpenAPI 文件時當事實來源。
 *
 * 只輸出可由框架直接讀出的事實（path、verb、security、文件檔路徑），不推導任何內容——
 * summary、requestBody 與回應結構需人工或 AI agent 依實作撰寫。
 */
class DocumentEndpoints extends Command
{
    private const PAGE_RETURN_PATTERN = '/return\s+(?:view|redirect)\(/';

    private const JSON_RETURN_PATTERN = '/responseSuccess|responseError|->json\(/';

    private const CONTROLLER_NAMESPACE = 'App\Http\Controllers\\';

    private const CONTROLLER_ROOT = 'app/Http/Controllers/';

    protected $signature = 'document:endpoints
                            {controller? : Controller 路徑或片段，省略則列出全部}';

    protected $description = '以 JSON 列出所有 JSON endpoint 的 path、verb、security 與對應的 documents 檔案路徑';

    /** @var array<string, string> 同一個方法會被多個判斷讀取，快取避免重複讀檔 */
    private array $sourceCache = [];

    public function handle(): int
    {
        $endpoints = $this->collectEndpoints($this->argument('controller'));

        if ($endpoints === []) {
            $this->error('找不到符合的 Controller 路由');

            return self::FAILURE;
        }

        $this->line(json_encode($endpoints, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));

        return self::SUCCESS;
    }

    private function collectEndpoints(?string $filter): array
    {
        $endpoints = [];

        foreach (Route::getRoutes() as $route) {
            $endpoint = $this->buildEndpoint($route, $filter);

            if ($endpoint !== null) {
                $endpoints[] = $endpoint;
            }
        }

        usort($endpoints, fn (array $a, array $b): int => [$a['document'], $a['path']] <=> [$b['document'], $b['path']]);

        return $endpoints;
    }

    private function buildEndpoint(RoutingRoute $route, ?string $filter): ?array
    {
        $class = $this->controllerClass($route);

        if ($class === null || ! $this->matchesFilter($class, $filter)) {
            return null;
        }

        $reflection = new ReflectionClass($class);
        $methodName = Str::after($route->getActionName(), '@');

        if (! $reflection->hasMethod($methodName) || $this->isPageRoute($reflection->getMethod($methodName))) {
            return null;
        }

        $path = '/' . ltrim($route->uri(), '/');
        $verb = $this->primaryVerb($route);
        $document = $this->documentPath($reflection);

        return [
            'controller' => $class,
            'method' => $methodName,
            'verb' => $verb,
            'path' => $path,
            'parameters' => $this->pathParameters($route),
            'security' => $this->security($route),
            'tag' => $this->tagFromNamespace($reflection),
            'document' => $document,
            'documented' => $this->isDocumented($document, $verb, $path),
        ];
    }

    private function controllerClass(RoutingRoute $route): ?string
    {
        $action = ltrim($route->getActionName(), '\\');

        if (! str_contains($action, '@') || ! str_starts_with($action, self::CONTROLLER_NAMESPACE)) {
            return null;
        }

        return Str::before($action, '@');
    }

    private function matchesFilter(string $class, ?string $filter): bool
    {
        return $filter === null || str_contains($class, str_replace(['/', '.php'], ['\\', ''], $filter));
    }

    /** 回傳 Blade view 或導轉的路由不屬 API 文件範圍 */
    private function isPageRoute(ReflectionMethod $method): bool
    {
        $returnType = $this->returnTypeName($method);

        if (str_contains($returnType, 'View') || str_contains($returnType, 'RedirectResponse')) {
            return true;
        }

        if ($returnType !== '') {
            return false;
        }

        $source = $this->methodSource($method);

        return preg_match(self::PAGE_RETURN_PATTERN, $source) === 1
            && preg_match(self::JSON_RETURN_PATTERN, $source) !== 1;
    }

    private function returnTypeName(ReflectionMethod $method): string
    {
        $returnType = $method->getReturnType();

        return $returnType instanceof ReflectionNamedType ? $returnType->getName() : '';
    }

    private function primaryVerb(RoutingRoute $route): string
    {
        $methods = array_diff($route->methods(), ['HEAD']);

        return (string) (reset($methods) ?: 'GET');
    }

    private function tagFromNamespace(ReflectionClass $reflection): string
    {
        $segments = explode('\\', Str::after($reflection->getName(), self::CONTROLLER_NAMESPACE));
        array_pop($segments);

        return $segments === [] ? 'SYS' : end($segments);
    }

    /** 專案專屬：依各自的 middleware 名稱對應到 Info.php 宣告的 securityScheme */
    private function security(RoutingRoute $route): ?string
    {
        $middleware = $route->gatherMiddleware();

        return match (true) {
            in_array('auth:api', $middleware, true) => 'BearerAuth',
            default => null,
        };
    }

    private function pathParameters(RoutingRoute $route): array
    {
        preg_match_all('/\{(\w+)\??\}/', $route->uri(), $matches);

        return $matches[1];
    }

    /**
     * 目錄的全大寫模組縮寫正規化為首字大寫（DM → Dm），已是混合大小寫者維持原樣（Rpc4）；
     * 檔名取類別名去掉 Controller 後綴，不做大小寫正規化。
     */
    private function documentPath(ReflectionClass $reflection): string
    {
        $relative = Str::after($reflection->getFileName(), base_path() . '/');
        $segments = explode('/', Str::after($relative, self::CONTROLLER_ROOT));

        $class = Str::before(array_pop($segments), 'Controller');
        $directories = array_map($this->resolveSegment(...), $segments);

        return implode('/', ['documents', ...$directories, $class . '.php']);
    }

    private function resolveSegment(string $segment): string
    {
        $letters = preg_replace('/[^A-Za-z]/', '', $segment);

        return $letters !== '' && ctype_upper($letters)
            ? Str::ucfirst(Str::lower($segment))
            : $segment;
    }

    /** 該 endpoint 是否已出現在對應的文件檔中，供辨識尚待補寫的項目 */
    private function isDocumented(string $document, string $verb, string $path): bool
    {
        $file = base_path($document);

        if (! File::exists($file)) {
            return false;
        }

        $attribute = '#[OA\\' . Str::ucfirst(Str::lower($verb)) . "(\n    path: '{$path}',";

        return str_contains(File::get($file), $attribute);
    }

    private function methodSource(ReflectionMethod $method): string
    {
        $key = $method->getFileName() . ':' . $method->getStartLine();

        return $this->sourceCache[$key] ??= implode(PHP_EOL, iterator_to_array(
            File::lines($method->getFileName())
                ->slice($method->getStartLine() - 1, $method->getEndLine() - $method->getStartLine() + 1)
        ));
    }
}
```

專案若採 `app-service-pattern`，`documentPath()` 與 `resolveSegment()` 可抽為 `App\Services\Document\DocumentPath` Service。

## 5. 撰寫迴圈

```bash
# 1. 取一支 Controller 的待辦清單
php artisan document:endpoints Rpc4/WF/CategoryController

# 2. 依 route／FormRequest／Controller／Service 撰寫 documents/ 下對應檔案

# 3. 產製，確認無警告
php artisan l5-swagger:generate

# 4. 回頭確認該 Controller 已全數 documented
php artisan document:endpoints Rpc4/WF/CategoryController | grep documented
```

全專案進度：

```bash
php artisan document:endpoints | grep -c '"documented": false'
```

## 6. 合成端點（依 payload 分派的 legacy 入口）

需要時才做。主規格排除合成端點目錄，另立一份 documentation：

```php
'documentations' => [
    'default' => [
        // ...
        'scanOptions' => [
            'exclude' => [base_path('documents/LegacyDispatch')],
        ],
    ],

    'legacy' => [
        'api' => ['title' => '<專案名稱> 分派端點'],
        'routes' => [
            'api' => 'api/documentation/legacy',
            'docs' => 'docs/legacy',
        ],
        'paths' => [
            'docs_json' => 'legacy-docs.json',
            'annotations' => [base_path('documents/LegacyDispatch')],
        ],
    ],
],
```

產製兩份：

```bash
php artisan l5-swagger:generate --all
```

合成端點與對照表 SHALL 由產生器產出（以 PHP tokenizer 解析分派結構），不手工編輯；規則見 spec.md 的「由 legacy 靜態推導的產生物須可重製」。

## 7. 驗證清單

- `composer dump-autoload -o` 無 PSR-4 警告
- `php artisan l5-swagger:generate` 無 `Skipping unknown` 等警告
- 在大小寫敏感的檔案系統（Linux container）重跑，path 數量一致
- `php artisan document:endpoints` 無 `"documented": false`
