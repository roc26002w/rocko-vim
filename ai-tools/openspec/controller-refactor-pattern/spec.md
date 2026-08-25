# controller-refactor-pattern Specification

## Purpose

當 Controller method 混雜「HTTP 輸入處理」與「完整業務邏輯」時，SHALL 依本規範拆分為 `FormRequest`（輸入驗證）與 `app-service-pattern` Service（業務邏輯），讓 Controller method 僅負責輸入驗證、查找路由資源、呼叫 Service、回傳回應。

## Requirements

### Requirement: 拆分時機

Controller method SHALL 在符合以下任一情況時拆分：
- method 內同時包含驗證邏輯（`$request->post()`/`$request->input()` 手動取值判斷）與業務邏輯（查詢組裝、資料轉換、寫入、外部服務呼叫等）
- 業務邏輯無法在不經過完整 HTTP 請求（Feature Test）的情況下被獨立測試

#### Scenario: 需要拆分的 method
- **WHEN** 一個 Controller method 同時做參數驗證、權限判斷、查詢條件組裝、資料庫寫入
- **THEN** 依本規範拆分為 `FormRequest` + Service，Controller method 僅保留查找資源與呼叫 Service 的骨架

---

### Requirement: Request 抽取為 FormRequest

Controller method 對 `Illuminate\Http\Request` 的手動驗證/取值，SHALL 抽取為獨立的 `App\Http\Requests\<Module>\<Action>Request extends FormRequest`。

- 命名 SHALL 為 `<ControllerMethod 對應動作>Request`（如 `store()` → `StoreRequest`、`search()` → `SearchRequest`），首字母大寫、去除底線。
- `authorize()`：無額外授權判斷時回傳 `true`（授權已由路由層 middleware 處理）。
- `rules()`：定義所有欄位的驗證規則；可選欄位使用 `nullable`，欄位間依賴關係使用 `required_with:`/`required_if:` 等規則顯式表達（避免下游程式碼因缺少關聯欄位而拋出未預期的 TypeError）。
- Controller method 的參數型別由 `Request` 改為該 `FormRequest`。

#### Scenario: FormRequest 基本結構
```php
namespace App\Http\Requests\OF;

use Illuminate\Foundation\Http\FormRequest;

class SearchRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'keyword' => 'nullable|string',
            'keyword_method' => 'nullable|array|required_with:keyword',
            'keyword_method.*' => 'in:1,2',
        ];
    }
}
```

#### Scenario: 欄位依賴關係須以驗證規則表達
- **WHEN** 下游邏輯僅在欄位 A 有值時才存取欄位 B（如 `in_array(1, $keywordMethod)` 僅在 `keyword` 有值時執行）
- **THEN** `rules()` SHALL 以 `required_with:`/`required_if:` 顯式宣告 B 對 A 的依賴，讓「A 有值但 B 缺失」在驗證層即回傳 422，而非讓業務邏輯對 `null` 操作拋出未捕捉的例外

---

### Requirement: 業務邏輯抽取為 Service

Controller method 原本的業務邏輯 SHALL 抽取為 `App\Services\<Module>\<Entity>\<Action>` Service，並遵循 [[app-service-pattern]]（繼承 `App\Services\Service`、`private` 屬性、`::run()` 入口、`prepare*/push*/resolve*` 等方法命名慣例）。

- Service 命名空間依「模組／實體／動作」分層（如 `App\Services\OF\Reply\Store`、`App\Services\OF\Template\Search`），與 Controller 所在模組對應但不與 Controller 命名空間重複。
- Controller method 拆分後僅保留：型別提示 `FormRequest`、必要的路由模型/資源查找（Route Model Binding 或簡單 `find`）、前置狀態檢查（如「表單是否開放」）、呼叫 `Service::run([...])`、組裝 HTTP 回應。

#### Scenario: Controller method 拆分後的骨架
```php
public function search(SearchRequest $request): JsonResponse
{
    $templates = Search::run([
        'uid' => auth('rpc')->id(),
        'creator' => $request->validated('creator', 0),
        'keyword' => $request->validated('keyword', ''),
        // ...其餘欄位
    ]);

    return response()->json([
        'status' => true,
        'data' => ['templates' => $templates],
    ]);
}
```

---

### Requirement: Service::run() 呼叫時明確列出 key

呼叫 `Service::run()` SHALL 明確列出每個 key 及其來源，不得以 `...$request->validated()` 展開傳遞。

- **Rationale**: 明確列出 key 讓呼叫端與 Service 的 `handle()` 簽名可直接對照，欄位增減時能立即在呼叫處看出差異；`...$request->validated()` 會讓「Service 實際依賴哪些欄位」隱藏在展開語法背後，且無法在呼叫處提供逐欄位的預設值。

#### Scenario: 禁止的寫法
```php
// 禁止：展開傳遞，無法逐欄位提供 default，且欄位依賴不透明
Search::run([...$request->validated(), 'uid' => auth('rpc')->id()]);
```

---

### Requirement: 預設值職責歸屬於 Controller（HTTP 輸入邊界）

Service 的 `handle()` 參數 SHALL 為必填、不帶 PHP 預設值（不使用 `= null`、`= 0`、`= ''` 等）；可選欄位的預設值 SHALL 由 Controller 呼叫端透過 `FormRequest::validated(string $key, mixed $default)` 的二參數形式明確提供。

- **Rationale**: `validated($key)`（單參數）在欄位未提交時回傳 `null`，若 Service 屬性型別為非 nullable（如 `int`、`string`、`array`），指派 `null` 會拋出 `TypeError`。將預設值收斂在 Controller 一處，比在 Service 內部散落 `?int $x = null` 後又於方法體內判斷 `$x ?? 0` 更集中、更符合「HTTP 輸入邊界負責填補預設值，Service 內部信任已收到合法型別資料」的分工。
- 若某欄位的合法值域無法表達「未指定」語意（如 `open_status` 合法值恰為 `0`/`1`，兩者皆有意義），Service SHALL 定義 `public const UNSET_<FIELD> = <不在值域內的哨兵值>`，供 Controller 呼叫 `$request->validated($key, Service::UNSET_<FIELD>)` 使用。

#### Scenario: Controller 提供逐欄位 default
```php
Search::run([
    'creator' => $request->validated('creator', 0),
    'open_status' => $request->validated('open_status', Search::UNSET_OPEN_STATUS),
    'keyword_method' => $request->validated('keyword_method', []),
]);
```

#### Scenario: 值域無法表達「未指定」時定義 sentinel 常數
```php
class Search extends Service
{
    public const UNSET_OPEN_STATUS = -1; // 合法值為 0/1，皆有意義，需獨立 sentinel

    private function whereOpenStatusIfNeed(): void
    {
        if ($this->openStatus === self::UNSET_OPEN_STATUS) {
            return;
        }
        $this->templateBuilder->where('open_status', $this->openStatus);
    }
}
```

---

### Requirement: 魔術字串/數字改用 Enum

Service 內對固定選項值的字串/數字比對（如 `'2'`、`'3'` 等前端表單選項值），SHALL 改用 `App\Enum\<Module>\<Name>Enum`（PHP 8.1+ backed enum）定義，並以 `Enum::tryFrom($value)` 轉型後與 enum case 比較，不得在條件判斷中直接寫入字面值。

- Enum 檔案放置於 `app/Enum/<Module>/`，`case` 命名使用語意化英文（`ALL`/`NONE`/`CUSTOM` 而非數字），value 對應前端實際傳遞的字面值。

#### Scenario: Enum 取代魔術字串
```php
enum CategoryMethodEnum: string
{
    case ALL = '1';
    case NONE = '2';
    case CUSTOM = '3';
}

private function whereCategoryIfNeed(): void
{
    $categoryMethod = CategoryMethodEnum::tryFrom($this->categoryMethod);

    if ($categoryMethod === CategoryMethodEnum::NONE) {
        $this->templateBuilder->whereNull('category_id');
        return;
    }

    if ($categoryMethod === CategoryMethodEnum::CUSTOM && $this->categoryId) {
        $this->templateBuilder->where('category_id', $this->categoryId);
    }
}
```

---

### Requirement: 測試涵蓋

拆分後 SHALL 補齊以下兩層測試：

- **Service 的 Unit Test**：路徑鏡像於 `tests/Unit/Services/<Module>/<Entity>/<Action>Test.php`，依 [[app-service-pattern]] 的測試規範，以 `Service::run([...])` 呼叫；當 `handle()` 參數眾多且每個測試僅關注其中一兩個欄位時，SHALL 提供私有 helper（如 `runSearch(array $overrides = [])`）合併基準預設值與逐測試覆寫值，避免每個測試都重複列出全部必填欄位。
- **FormRequest 的驗證 Feature Test**：於既有 Controller 的 `tests/Feature/<Module>/<Controller>Test.php` 中，針對每條非顯而易見的驗證規則（尤其是 `required_with`/`required_if` 等欄位依賴規則）新增 `assertInvalid([...])` 情境。

#### Scenario: Service 測試以 helper 合併預設值
```php
private function runSearch(array $overrides = []): Collection
{
    return Search::run(array_merge([
        'uid' => 1600,
        'creator' => 0,
        'open_status' => Search::UNSET_OPEN_STATUS,
        'keyword_method' => [],
        'keyword' => '',
    ], $overrides));
}

public function test_should_filter_by_open_status(): void
{
    $result = $this->runSearch(['open_status' => 1]);
    // ...
}
```

#### Scenario: FormRequest 驗證規則的 Feature Test
- **WHEN** `SearchRequest` 新增 `keyword_method` 的 `required_with:keyword` 規則
- **THEN** 新增 Feature Test 提交僅有 `keyword` 無 `keyword_method` 的請求，斷言 `$response->assertInvalid(['keyword_method'])`

---

### Requirement: Commit 範圍

一次 Controller method 的拆分（新增 FormRequest、新增 Service、修改 Controller、新增/調整測試）SHALL 視為一個邏輯單元，以單一 commit 提交，訊息依 [[commit-convention]]。若拆分過程中順帶修復潛藏缺陷（如欄位缺失導致的未捕捉例外），SHALL 於 commit body 以獨立 bullet 說明。

#### Scenario: Commit 訊息範例
```
Issue #15384 OpenFormController@search 抽取為 SearchRequest 與 Service

  * 新增 SearchRequest 驗證智造表單列表查詢參數
  * 新增 Search Service 依 app-service-pattern 封裝查詢邏輯,Controller 呼叫時明確傳入 key 與 default 值
  * 新增 CategoryMethodEnum 取代 categoryMethod 內的 '2'、'3' 魔術字串
  * 新增 SearchTest 涵蓋分類、關鍵字、狀態、建立者、日期區間篩選及非管理員權限限制情境
  * 新增 keyword 缺少 keyword_method 時回傳驗證錯誤的 Feature 測試
```

---

### Requirement: 現有參考實作

以下為標準實作範例，設計新的 Controller 拆分前應先閱讀：

- `App\Http\Requests\OF\StoreRequest` + `App\Services\OF\Reply\Store` — `ReplyController@store` 拆分：檔案搬移、內容轉換、簽核流程掛載、寄送感謝信等多步驟業務邏輯封裝
- `App\Http\Requests\OF\SearchRequest` + `App\Services\OF\Template\Search` + `App\Enum\OF\CategoryMethodEnum` — `OpenFormController@search` 拆分：權限判斷、多欄位篩選組裝、`UNSET_OPEN_STATUS` sentinel 常數、Controller 提供逐欄位 default 值
