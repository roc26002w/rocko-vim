# app-service-pattern Specification

## Purpose

本專案的 `app/Services/` 下所有 Service 類別遵循統一的 `BoundHandle` 架構模式，透過靜態 `::run()` 入口、反射注入屬性，並以固定的方法命名慣例組織邏輯。

## Requirements

### Requirement: Service 類別繼承與入口

所有 Service 類別 SHALL 繼承 `App\Services\Service`，並透過靜態方法 `ClassName::run(array $args)` 呼叫。

`run()` 由 `BoundHandle` trait 提供，流程為：
1. `app(static::class)` 建立實例
2. `DependencyInjection::buildDependencies()` 從 `handle()` 方法簽名解析所需依賴
3. `assignProperties($dependencies)` 以反射將同名參數賦值給 class 屬性
4. `handle(...$dependencies)` 執行主邏輯

#### Scenario: 呼叫方式
- **WHEN** 外部呼叫一個 Service
- **THEN** 使用 `SomeService::run(['paramName' => $value, ...])` 而非 `new SomeService(...)->handle(...)`

#### Scenario: 測試中的呼叫方式
- **WHEN** 單元測試呼叫 Service
- **THEN** 同樣使用 `SomeService::run([...])` 確保走完完整的 BoundHandle 注入流程

---

### Requirement: 屬性宣告方式

Service 類別 SHALL 在類別頂層以 `private` 宣告所有屬性，不使用 constructor 促進式屬性（constructor property promotion）。

#### Scenario: 正確宣告方式
```php
class MyService extends Service
{
    private array $records = [];
    private array $shiftDuty = [];
    private Collection $result;
}
```

---

### Requirement: handle() 方法參數與屬性對應

`handle()` 的參數名稱 SHALL 與 class 屬性名稱一致，以便 `BoundHandle::assignProperties()` 自動注入。`handle()` 內不需手動賦值，框架在呼叫前已完成注入。

#### Scenario: handle() 簽名
```php
/**
 * @method static Collection run()
 */
public function handle(array $records, array $shiftDuty = [], array $dutyList = []): Collection
{
    // $this->records、$this->shiftDuty、$this->dutyList 已由 BoundHandle 注入
    $this->prepareResult();
    // ...
    return $this->renderResult();
}
```

> **注意**：IDE 可能對 `handle()` 的參數顯示「Unused parameter」警告，因為方法體內未直接使用這些參數（實際已透過反射注入為屬性）。這是預期行為，無需修正。

---

### Requirement: 方法命名慣例

Service 類別 SHALL 遵循以下命名模式組織方法：

| 前綴 | 用途 | 範例 |
|---|---|---|
| `prepare*()` | `handle()` 前的初始化，設定 class 屬性；可直接讀取已由 BoundHandle 注入的 `$this->*` 屬性，不需額外帶入參數 | `prepareResult()`, `prepareRange()`, `prepareDtoMap()`, `prepareStructureKeys()` |
| `init*()` | 迴圈內初始化 per-item 狀態；有兩種用法，見下方說明 | `initUser()`, `initRow()` |
| `update*ToResult()` | 計算並寫入結果 | `updateDutyInfoToResult()` |
| `push*()` | 將單筆資料推入 result | `pushCrossMonthSegments()` |
| `push*IfNeed()` | 有條件地推入 result；搭配 `init*()` 檢查 per-item 狀態是否有效 | `pushResultIfNeed()` |
| `resolve*()` | 查詢或推導單一值（涉及運算或查表） | `resolveMonthBoundary()`, `resolveNextMonthStart()` |
| `get*()` | 從常數或預建 map 直接取值（不含查詢或推導邏輯） | `getRocWeekday()` |
| `build*()` | 建構並回傳一個資料結構 | `buildSegment()` |
| `parse*()` | 解析輸入資料 | `parseDateRange()` |
| `renderResult()` | 最終輸出轉換 | `return $this->result` |
| `is*()`/`has*()` | 布林判斷，封裝條件邏輯；可讀取 `$this->*` 屬性，也可接受區域值作為參數 | `isSameMonth()`, `isScalarType(string $format, mixed $value)` |

#### Scenario: `is*()` 接受參數的情境

當布林條件依賴迴圈內的區域值（非 class 屬性），`is*()` SHALL 接受這些值作為參數：

```php
private function isScalarType(string $format, mixed $value): bool
{
    return in_array($format, self::SCALAR_ARRAY_FORMATS)
        && is_array($value)
        && array_is_list($value);
}

// pushFieldPart() 內的使用方式
if ($this->isScalarType($format, $value)) {
    foreach ($value as $scalar) {
        $this->result->push("{$key}={$scalar}");
    }
    return;
}
```

---

### Requirement: 私有方法的粒度與 null 處理

本要求適用於 Service 內**所有**依命名慣例建立的私有方法——`prepare*()`、`init*()`、`resolve*()`、`get*()`、`build*()`、`parse*()`、`push*()`、`update*ToResult()`、`is*()`/`has*()`、`renderResult()`——不限於其中任一前綴。

**粒度**：方法若為單一連貫的流程，SHALL 維持單一方法。抽出子方法的前提 SHALL 為「該子方法具備獨立語意」或「會被重複使用」；SHALL NOT 為了「每一步一個方法」而抽出只被呼叫一次、且命名未增加語意的子方法。

**null 處理**：方法回傳值可能為 null 時，SHALL 以 `is_null()` early return guard 明確表達 null 的來源與去向；SHALL NOT 在 return 敘述以 `?->` 隱式短路帶過。取得來源後的推導 SHALL 以鏈式呼叫寫成單一 return。

理由：early return guard 讓「什麼情況回傳 null」一眼可見，`?->` 串在 return 上會把 guard 條件藏進運算式中；過度拆分則使呼叫端要多跳一層才讀得到實際邏輯，而該層並未換來更清楚的語意。

> **例外**：跨層 relation 存取的目的是「回退到預設值」而非「回傳 null」，此時仍使用 `?->` 搭配 `??`，見「資料查詢與關聯載入」。判準是該運算式最終**有沒有** null 流出到呼叫端。

#### Scenario: `resolve*()` 單一連貫推導維持單一方法

```php
private function resolveExpiryDate(Workflow $workflow): ?Carbon
{
    $baseDate = $workflow->closedate ?? $workflow->finishdate ?? $workflow->duedate;

    if (is_null($baseDate)) {
        return null;
    }

    return Carbon::parse($baseDate)->startOfDay()->addYears((int) $workflow->template->retention_years);
}
```

- **WHEN** 保存到期日的推導為「取基準日 → 加上年限」的單一連貫流程
- **THEN** 寫成單一 `resolveExpiryDate()`，以 `is_null()` guard 處理基準日不存在的情況

#### Scenario: 不正確的過度拆分與隱式短路

```php
// 禁止：resolveBaseDate() 只被呼叫一次且未增加語意；?-> 把 guard 藏進 return
private function resolveExpiryDate(Workflow $workflow): ?Carbon
{
    $baseDate = $this->resolveBaseDate($workflow);

    return $baseDate?->addYears((int) $workflow->template->retention_years);
}

private function resolveBaseDate(Workflow $workflow): ?Carbon
{
    $baseDate = $workflow->closedate ?? $workflow->finishdate ?? $workflow->duedate;

    return $baseDate === null ? null : Carbon::parse($baseDate)->startOfDay();
}
```

- **WHEN** 子方法只被呼叫一次，且呼叫端仍要處理其 null 回傳
- **THEN** 併回單一方法，並以 `is_null()` early return guard 取代 `?->` 短路

#### Scenario: `prepare*()` 同樣適用粒度判準

```php
private function prepareWorkflows(): void
{
    $this->workflows = Workflow::query()
        ->with(['template', 'fromUser.employee'])
        ->get();
}
```

- **WHEN** `prepare*()` 的內容是一段連貫的查詢建構
- **THEN** 直接寫在 `prepare*()` 內，不另外抽出只被呼叫一次的 `buildXxxQuery()`

#### Scenario: `init*()`、`build*()`、`parse*()` 適用同一判準

- **WHEN** 任一命名慣例的私有方法內部被進一步拆成只呼叫一次、名稱僅重述步驟的子方法（如 `initRow()` 內抽出 `initRowDefaults()`）
- **THEN** 併回原方法；僅當子方法具獨立語意或會被重複使用時才抽出

---

### Requirement: 私有常數（private const）

當 `is*()` 方法需要比對一組固定的字串值時，SHALL 使用 `private const` 陣列定義該群組，不在方法內 hard-code 值列表。

```php
private const SCALAR_ARRAY_FORMATS = [
    'checkbox', 'tag', 'dropdown_multiple',
    'date_range', 'date_range_ROC', 'time_range',
];

private const OBJECT_ARRAY_FORMATS = ['file', 'image'];
```

常數命名使用 `SCREAMING_SNAKE_CASE`，放置於 class 屬性宣告之後、`handle()` 之前。

---

#### init*() 的兩種用法

**Type A：狀態設定型**（用於外層迴圈的 per-item context）
- 僅設定 class 狀態屬性（如 `$this->user = $user`），不做重置
- 不包含條件判斷；guard 以 `if ($this->isXxx()) continue;` 寫在 `handle()` 的迴圈體內
- 範例：`initUser(UserGroup $user)`

**Type B：Row 初始化型**（用於內層迴圈）有兩種寫法，依初始化步驟數量選擇：

**(B1) 集中型**：搭配 `push*IfNeed()`
- 所有初始化步驟集中在單一 `initRow()` 內
- 方法開頭先將狀態屬性重置為空值（`$this->row = []`）
- 條件不符時 early return，狀態保持空值
- 條件符合時填入完整資料
- 範例：`initRow(Carbon $date)`

**(B2) 拆分型**：搭配 `push*()`
- 當初始化步驟較多、各步驟語意不同時，拆為多個 `init*()` 子方法，直接在 `handle()` 迴圈體中顯式呼叫
- 各 guard 條件以 `if ($this->isXxx()) continue;` 在迴圈體中顯式排除；不同類型的 skip 條件可拆為獨立的 guard，讓讀者一目了然哪些情況被跳過
- `buildRow()` 僅在所有條件通過後才呼叫，因此直接使用 `push*()` 推入（不需 `IfNeed` 變體）
- 範例：`initFakeDate()`, `initShift()`, `initDuty()`, `initDutyCode()` 各為獨立子方法

---

### Requirement: handle() 的迴圈結構

`handle()` 的迴圈體 SHALL 只含高階方法呼叫，不得有 inline 運算邏輯（字串比較、直接資料操作等）。

* 例外：無條件判斷的簡單賦值（如 `$dateString = $date->format('Y-m-d')`）可保留在迴圈體內。
* 允許以下四種結構，依複雜度選擇：

#### Scenario: 單層 foreach，body 只有高階呼叫（參考 DutyVacationCardExport）
```php
public function handle(string $yearMonth): Collection
{
    $this->prepareResult();
    // ...prepare methods...

    $this->vacationCards->each(function (VacationCard $card) {
        $this->initRow($card);
        $this->pushResultIfNeed();
    });

    return $this->renderResult();
}
```

#### Scenario: 雙層 foreach，外層含 init + guard(continue)，內層 Type B1 集中型（參考 SimulationGenerator）

當外層以 Type A `init*()` 設定 context、guard 排除無效項目，內層以 Type B1 `initRow()` + `push*IfNeed()` 產生結果時，兩層可直接寫在 `handle()` 內。

```php
public function handle(string $date): Collection
{
    $this->prepareResult();
    // ...prepare methods...

    foreach ($this->users as $user) {
        $this->initUser($user);           // Type A：設定 $this->user
        if ($this->isEmployeeNotExists()) {
            continue;                      // guard：跳過無效項目
        }

        foreach ($this->period as $date) {
            $this->initRow($date);         // Type B1：重置 row，填入或 early return
            $this->pushResultIfNeed();
        }
    }

    return $this->renderResult();
}
```

#### Scenario: 雙層 foreach，外層含 init + guard(continue)，內層 Type B2 拆分型（參考 SimulationGenerator）

當內層初始化步驟語意各異（如班別、班次、假別各為獨立概念），或有多個性質不同的 skip 條件時，改用 Type B2 拆分型，讓每個步驟與每個 guard 都在 `handle()` 中清晰可見。

```php
foreach ($this->users as $user) {
    $this->initUser($user);              // Type A：設定 $this->user
    if ($this->isEmployeeNotExists()) {
        continue;
    }

    foreach ($this->period as $date) {
        $this->initFakeDate($date);      // 各初始化步驟語意分明，逐一顯式呼叫
        $this->initShift();
        $this->initDuty();
        $this->initDutyCode();

        if ($this->isNoGeneral()) {                  // guard：班表不適用（B3、無班表等）
            continue;
        }
        if ($this->isOutsideEmploymentPeriod()) {    // guard：非在職期間（到職前、離職後）
            continue;
        }

        $this->buildRow();      // 所有條件通過，建構 row
        $this->pushToResult();  // 直接推入，不需 IfNeed（條件已在上方排除）
    }
}
```

> **選擇依據**：若單一 `initRow()` 過長、或 skip 條件來自不同業務維度（班表規則 vs 在職期間），B2 更易讀；若初始化步驟少且 guard 單一，B1 更簡潔。

#### Scenario: 雙層 foreach，內層邏輯複雜時封裝為 private 方法（參考 Duty.php）

當內層迴圈不符合單純的 `initRow + push` 配對（含多個 init 或 update 呼叫）時，封裝為獨立 private 方法。

```php
public function handle(...): Collection
{
    // ...
    foreach ($period as $date) {
        $dateString = $date->format('Y-m-d');
        $this->processDate($dateString); // 內層 foreach 封裝在此
    }
    return $this->renderResult();
}

private function processDate(string $dateString): void
{
    foreach ($this->userIds as $uid) {
        $this->initUidGroup($uid);
        $this->initDateGroup($uid, $dateString);
        $this->updateDutyInfoToResult($uid, $dateString);
    }
}
```

#### Scenario: 單層 foreach，含 passthrough guard 的 dispatch 直接寫在 body 內（參考 SplitVacation）

當迴圈需要在「直接推入（passthrough）」與「複雜處理」之間做決策時，該 dispatch 邏輯 SHALL 直接寫在 `handle()` 的迴圈體內，不得額外包裹為單一 `push*OrPassthrough()` 方法。

```php
foreach ($records as $record) {
    $this->initRecord($record);        // Type A：設定 $this->record
    if ($this->isNoProcess()) {
        $this->result->push($record);  // passthrough：直接推入
        continue;
    }
    $this->pushDailyPairsToResult();   // 需要處理：執行複雜邏輯
}
```

以下為不正確的封裝方式：

```php
// 禁止：將 passthrough 決策包裹在另一層方法，隱藏主要 dispatch 邏輯
foreach ($records as $record) {
    $this->pushSplitOrPassthrough($record); // 讀者無法從 handle() 看出決策流程
}
```

#### Scenario: 條件判斷應封裝為命名方法
```php
// 不好：inline 條件
if ($startDt->format('Y-m') === $endDt->format('Y-m')) { ... }

// 正確：封裝
if ($this->isSameMonth($startDt, $endDt)) { ... }
```

---

### Requirement: Collection callback 的 Closure 寫法

使用 Collection 方法（`map()`、`each()`、`filter()`、`flatMap()` 等）時，callback 寫法 SHALL 依邏輯層數選擇：

1. **單一運算式（一層邏輯）**：使用 `fn` arrow function
2. **兩層以上邏輯（含條件分支、多個 statement）**：使用 `function () {}` Closure 寫法，分支決策（dispatch）直接寫在 Closure 內，不得硬塞進 `fn`（巢狀三元、串接），也不得將整個 callback 包成單一 `transform*()` 方法而隱藏決策流程
3. **Closure 內有實質運算邏輯的部分**（聚合、合併、轉換）：抽為具名 private method，讓 Closure 只保留「分支 + 高階呼叫」

#### Scenario: 單一運算式使用 fn（參考 Converter）
```php
$this->containerStructureByKey = collect($this->structure)
    ->filter(fn (array $item) => TypeEnum::isContainerType($item['type'] ?? ''))
    ->keyBy('key');
```

#### Scenario: 兩層以上邏輯使用 function Closure（參考 Converter renderResult()）

分支決策留在 Closure 內清晰可見，實質運算（value 聚合）抽為 `mergeContainerChildValues()`：

```php
private function renderResult(): Collection
{
    return $this->result
        ->groupBy('key')
        ->map(function (Collection $group) {
            if ($group->first()['is_container_child']) {
                return FormResultDTO::transFromArray([
                    'key' => $group->first()['key'],
                    'value' => $this->mergeContainerChildValues($group),
                ]);
            }

            return FormResultDTO::transFromArray((array) $group->first());
        })
        ->values();
}

private function mergeContainerChildValues(Collection $group): array
{
    return $group
        ->flatMap(fn (array $item) => $item['value'])
        ->values()
        ->all();
}
```

以下為不正確的寫法：

```php
// 禁止：兩層以上邏輯硬塞進 fn（巢狀三元）
->map(fn (Collection $group) => $group->first()['is_container_child']
    ? FormResultDTO::transFromArray([...])
    : FormResultDTO::transFromArray($group->first()))

// 禁止：整個 callback 包成單一 transform*() 方法，讀者無法從呼叫處看出分支決策
->map(fn (Collection $group) => $this->transformGroup($group))
```

---

### Requirement: per-item 狀態的 init/push 模式

內層迴圈（或單層迴圈）中每個項目可能因條件不符而不產生結果列時，依初始化複雜度選擇 Type B1 或 Type B2：
- **Type B1（集中型）**：條件封裝在單一 `initRow()` 內，搭配 `push*IfNeed()`
- **Type B2（拆分型）**：多個 `init*()` 子方法 + 顯式 guard 在迴圈體，搭配 `push*()`

外層迴圈項目若需整批略過（如無效 user），使用 Type A `init*()` + `if (isXxx()) continue` 模式，guard 寫在迴圈體內。

**Type B1 `initRow()`（集中型）規則：**
1. 方法開頭先將狀態屬性重置為空值（`$this->row = []`）
2. 條件不符時 early return，狀態保持空值
3. 條件符合時填入完整資料（通常呼叫 `buildRow()` 或類似方法）

**Type B2 拆分型規則：**
1. 多個 `init*()` 子方法各司其職，依序在迴圈體中呼叫
2. 各 skip 條件以獨立的 `if ($this->isXxx()) continue;` 寫在迴圈體
3. `buildRow()` 僅在所有條件通過後才呼叫

**`push*IfNeed()` 規則（搭配 Type B1）：**
1. 檢查狀態屬性是否有效（非空）
2. 有效時才推入 `$this->result`

**`push*()` 規則（搭配 Type B2）：**
1. 僅在所有 guard 通過、`buildRow()` 確實執行後呼叫
2. 無需 empty 檢查，因條件已在迴圈體中完全排除

#### Scenario: Type B init/push 配對（參考 DutyVacationCardExport）
```php
// 內層迴圈，條件判斷封裝在 initRow()
$this->vacationCards->each(function (VacationCard $card) {
    $this->initRow($card);
    $this->pushResultIfNeed();
});

private function initRow(VacationCard $card): void
{
    $this->row = [];
    $memberNo = $this->employeeNumbers->get($card->user_id, '');
    if (empty($memberNo)) {
        return; // early return，row 維持空陣列
    }
    $this->row = [$memberNo, ...];
}

private function pushResultIfNeed(): void
{
    if (empty($this->row)) {
        return;
    }
    $this->result->push($this->row);
}
```

#### Scenario: Type A + guard(continue) 配對外層迴圈（參考 SimulationGenerator）
```php
foreach ($this->users as $user) {
    $this->initUser($user);             // Type A：只設定 $this->user
    if ($this->isEmployeeNotExists()) { // guard 寫在迴圈體，非 initUser() 內
        continue;
    }
    // ... 內層迴圈
}

private function initUser(UserGroup $user): void
{
    $this->user = $user; // 純狀態設定，無重置、無條件判斷
}
```

#### Scenario: Type B2 拆分型 init + 顯式 guard + push（參考 SimulationGenerator）
```php
// 內層迴圈，各步驟拆為獨立 init*()，guards 顯式排列
foreach ($this->period as $date) {
    $this->initFakeDate($date);
    $this->initShift();
    $this->initDuty();
    $this->initDutyCode();

    if ($this->isNoGeneral()) {               // 班表類 guard
        continue;
    }
    if ($this->isOutsideEmploymentPeriod()) { // 在職期間 guard
        continue;
    }

    $this->buildRow();
    $this->pushToResult(); // 無需 empty 檢查
}

private function pushToResult(): void
{
    $this->result->push($this->row);
}
```

#### Scenario: 不需要條件時直接使用 push*()
- **WHEN** 迴圈內每個項目都必定產生結果列（無略過邏輯）
- **THEN** 直接使用 `push*()` 命名，不需 `push*IfNeed()` 變體

---

### Requirement: result 使用 Collection

Service 的 `$result` 屬性原則上 SHALL 使用 `Illuminate\Support\Collection`，`prepareResult()` 初始化為 `collect()`，最終由 `renderResult()` 直接回傳該 Collection。

> **Provision**：若有特定的技術考量或需與舊系統介面直接對接，仍可選擇回傳 `array`，但除非必要，應優先考慮使用 `Collection` 以維持後續資料處理的彈性。

#### Scenario: result 生命週期 (優先建議)
```php
private function prepareResult(): void
{
    $this->result = collect();
}

private function renderResult(): Collection
{
    return $this->result;
}
```

---

### Requirement: 資料查詢與關聯載入

Service 內的資料查詢 SHALL 優先使用 Eloquent。有對應 Model 時使用 `Model::query()`，SHALL NOT 使用 `DB::table()`。

需要關聯資料時，若 Model 已定義對應 relation，SHALL 以 `with()` eager loading 取得，並透過 relation 屬性存取，SHALL NOT 手寫 `join()` 搭配欄位別名取值。多層關聯以點記法串接（如 `with(['template', 'fromUser.employee'])`）。

理由：手寫 join 與欄位別名繞過了 Model 已定義的關聯，日後關聯定義調整時不會同步；relation 寫法取得的是 Model 實例而非 `stdClass`，型別更明確。

延伸規則：

- 迭代查詢結果時，型別標註 SHALL 使用具體的 Model 類別，SHALL NOT 使用 `object`
- 需依關聯欄位篩選時 SHALL 使用 `whereHas()`，而非為了篩選而改寫成 join
- 跨多層 relation 存取時，中間層可能查無資料者 SHALL 以 `?->` 短路並給定預設值
- `with()` 為 eager loading，SHALL NOT 在迴圈內逐筆查詢關聯資料

#### Scenario: 以 relation 取代手寫 join

```php
private function prepareWorkflows(): void
{
    $this->workflows = Workflow::query()
        ->with(['template', 'fromUser.employee'])
        ->get();
}

private function pushRow(Workflow $workflow): void
{
    $this->result->push([
        'template_name' => $workflow->template->templatename,
        'sender_name' => $workflow->fromUser?->employee?->chinesename ?? '',
    ]);
}
```

- **WHEN** 需要取得簽核的表單名稱與發文者姓名，且 `Workflow::template()`、`Workflow::fromUser()`、`UserGroup::employee()` 均已定義
- **THEN** 以 `with()` eager loading 並透過 relation 屬性存取

#### Scenario: 不正確的手寫 join 取值

```php
// 禁止：繞過已定義的 relation
$this->workflows = Workflow::query()
    ->join('wf_template', 'wf_workflow.templateid', '=', 'wf_template.templateid')
    ->leftJoin('hr_employee', 'wf_workflow.from', '=', 'hr_employee.ownerid')
    ->get([
        'wf_template.templatename',
        'hr_employee.chinesename',
    ]);
```

- **WHEN** Model 已有對應 relation 卻改以 join 搭配欄位別名取值
- **THEN** 此為不合規範的寫法，且回傳的是 `stdClass` 而非 Model

#### Scenario: 依關聯欄位篩選使用 whereHas

```php
Workflow::query()
    ->with(['template'])
    ->whereHas('template', fn ($query) => $query->whereNotNull('retention_years'))
    ->get();
```

- **WHEN** 需要排除關聯資料中某欄位為 null 的紀錄
- **THEN** 使用 `whereHas()` 表達，不為了篩選而改寫成 join

#### Scenario: 中間層關聯可能查無資料

- **WHEN** `fromUser`（`usergroup`）或 `employee`（`hr_employee`）任一層可能查無對應紀錄
- **THEN** 以 `$workflow->fromUser?->employee?->chinesename ?? ''` 短路並回退為預設值，而非直接串接導致 null property 存取錯誤

---

### Requirement: 單元測試覆蓋

每個 Service 類別 SHALL 配有對應的 Unit Test，測試路徑與 `app/Services/` 結構鏡像於 `tests/Unit/Services/`。

測試規範：
- 測試類別繼承 `Tests\TestCase`
- 使用 `ClassName::run([...])` 呼叫 Service（不直接 `new`）
- 每個 `get*()`/`resolve*()`/`is*()` 等邏輯方法須有對應的測試情境
- 測試命名使用英文 snake_case，格式為 `test_should_<action>_when_<condition>`，例：`test_should_set_empty_payway_and_a4_item_no_when_duty_b1()`

#### Scenario: 測試路徑對應規則
- **WHEN** Service 位於 `app/Services/Vacation/Report/Custom/Haushin/OvertimeFields.php`
- **THEN** 測試位於 `tests/Unit/Services/Vacation/Report/Custom/Haushin/OvertimeFieldsTest.php`

---

### Requirement: TDD 循環開發流程

新增 Service 時 SHALL 遵循 Red → Green 循環，每個邏輯方法（`resolve*()`、`get*()`、`is*()`、`prepare*()`、`renderResult()` 等）都須先寫失敗測試，再實作使其通過，不得先完成 Service 骨架後才補寫測試。

開發順序規則：
1. **建立骨架**：先建立測試檔與空的 Service 類別（僅含空的 `handle()` 與屬性宣告），確保測試可載入
2. **Red**：針對第一個要實作的方法撰寫失敗測試
3. **Green**：實作最少程式碼使測試通過
4. **Commit 審核**：每完成一個 Green（測試通過）後，暫停等待使用者審核，確認無誤後才進行 commit，不得自行 commit 或連續完成多個 Green 才統一 commit
5. **重複**：對每個後續方法循環 Red → Green → Commit 審核，不跳過任一步驟

#### Scenario: 正確的 TDD 建立順序
- **WHEN** 新增一個含有 `resolveProjectInfo()` 與 `resolveWorkday()` 的 Service
- **THEN** 先建立空 Service，再寫 `resolveProjectInfo` 的失敗測試，實作使通過後暫停等待 commit 審核，審核通過後 commit，再寫 `resolveWorkday` 的失敗測試，最後實作使通過並再次等待審核

#### Scenario: 每個 Green 獨立 commit
- **WHEN** 一個 Green 完成（測試通過）
- **THEN** 立即暫停，告知使用者「等待審核後 commit」，不繼續實作下一個 Red，直到使用者確認可以 commit

#### Scenario: 禁止先完成實作再補測試
- **WHEN** 開發者完整實作 Service 所有方法後才新增測試
- **THEN** 此為不合規範的開發流程，無法確認測試確實曾失敗過（Red 階段）

#### Scenario: 禁止連續完成多個 Green 才統一 commit
- **WHEN** 開發者連續完成 Red → Green → Red → Green 後才進行 commit
- **THEN** 此為不合規範的流程，每個 Green 完成後都須獨立等待 commit 審核

---

### Requirement: 現有參考實作

以下檔案為標準實作範例，設計新 Service 前應先閱讀：

- `app/Services/Vacation/Card/Report/Collects/Duty.php` — 雙層迴圈內層封裝為 private 方法、prepare/init/update 分工
- `app/Services/Vacation/Card/Report/Collects/DutyBuffer.php` — prepare 初始化、全域/個別資料合併
- `app/Services/Vacation/Report/SplitByCalendarMonth.php` — parse/resolve/build/push 分工、Collection result
- `app/Services/Vacation/Report/Custom/Haushin/DutyVacationCardExport.php` — Type B initRow/pushResultIfNeed 配對、get* 常數查表、prepare* 直接讀取 BoundHandle 注入屬性
- `app/Services/Vacation/Report/Custom/Haushin/Attendance/SimulationGenerator.php` — 雙層迴圈直接在 handle()、Type A initUser + guard(continue) 外層、Type B2 拆分型（initFakeDate/initShift/initDuty/initDutyCode 逐步呼叫 + 顯式 guard + pushToResult）內層、resolve*/build* 分工
- `app/Services/Vacation/Report/Custom/Haushin/SplitVacation.php` — 單層 foreach 含 passthrough guard 直接寫在 body 內、Type A initRecord + isNoProcess() guard + pushDailyPairsToResult() dispatch
- `app/Services/OF/Transform/FormResult/Converter.php` — Collection callback 寫法：單一運算式用 fn、兩層以上邏輯用 function Closure（renderResult() 分支留在 Closure 內、聚合運算抽為 mergeContainerChildValues()）
- `app/Services/WF/NonRetention/Index.php` — 以 `with()` eager loading 取關聯資料取代手寫 join、跨層 relation 存取以 `?->` 短路、私有方法維持單一連貫流程並以 `is_null()` early return guard 處理 null
