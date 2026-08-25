# tdd-pattern Specification

## Purpose

本專案遵循 TDD (測試驅動開發) 原則，確保所有 Service、Controller、Command 及 Route 均有對應的測試覆蓋。
本規範定義了單元測試 (Unit Test) 與功能測試 (Feature Test) 的結構、命名與實作標準。

## Requirements

### Requirement: 測試類別繼承與命名

所有測試類別 SHALL 放置於 `tests/` 對應目錄下，且檔名必須以 `Test.php` 結尾。

- **Unit Test**: 繼承 `Tests\TestCase`，存放於 `tests/Unit/`。
- **Feature Test**: 繼承 `Tests\Feature\TestCase`，存放於 `tests/Feature/`。

#### Scenario: 測試路徑對應
- **WHEN** 測試 Service `App\Services\WF\FormList\Index`
- **THEN** 測試類別為 `Tests\Unit\Services\WF\FormList\IndexTest`，路徑為 `tests/Unit/Services/WF/FormList/IndexTest.php`

---

### Requirement: 測試方法命名慣例

測試方法 SHALL 以 `test_` 作為前綴，並使用 **純英文 snake_case** 描述測試情境。**嚴格禁止**在方法名稱中使用任何中文。

#### Scenario: 方法命名範例
- **正確**: `public function test_get_form_list_success()`
- **正確**: `public function test_filter_should_exclude_discarded_templates()`
- **錯誤**: `public function test_獲取表單列表_成功()` (禁止包含中文)

---

### Requirement: 測試環境初始化 (Setup)

測試類別應在 `setUp()` 中進行必要的環境初始化，且必須呼叫 `parent::setUp()`。

- **資料庫**: 使用 `RefreshDatabase` trait 確保測試間的資料隔離。
- **認證**: **嚴格禁止**直接使用 `$_COOKIE['u_str']`。必須透過 **JWT** 的方式模擬登入狀態。
    - 在 Feature Test 中，應呼叫繼承自 `TestCase` 的 `$this->loginUser($userId)` 方法。
    - 該方法會自動產生 JWT Token、設定 `Authorization: Bearer {token}` Header 並執行 `actingAs($user)`。
- **Fake**: 使用 `DBMakerFunctionFake` 模擬特定的資料庫函數。

#### Scenario: 標準 Setup 與登入範例
```php
protected function setUp(): void
{
    parent::setUp();
    $this->initAllDBMakerFunction();
    $this->loginUser(1600); // 使用 JWT 模擬登入 ID 1600 的使用者
    Lang::setLocale('tw');
}
```

---

### Requirement: 單元測試 (Unit Test) 標準

單元測試應專注於單一類別的邏輯。對於 Service，應使用 `Service::run([...])` 入口進行測試。

- **斷言 (Assertion)**: 優先使用 Eloquent 模型斷言（如 `$this->assertNotNull($template)`) 與值斷言 (`$this->assertEquals(...)`)。
- **Mocking**: 對於外部依賴（如 API 呼叫或複雜的橫切關注點），應使用 `$this->mock(...)`。

---

### Requirement: 功能測試 (Feature Test) 標準

功能測試應驗證完整的要求與回應流程 (Request/Response Cycle)。

- **請求**: 使用 `$this->get()`, `$this->post()` 等方法發送請求。
- **回應斷言**:
    - 必須檢查狀態碼：`$response->assertOk()` 或 `$response->assertStatus(200)`。
    - 必須檢查回應內容：`$response->assertJson(...)` 或 `$response->assertContent(json_encode([...]))`。
- **資料庫校驗**: 在請求完成後，應校驗資料庫狀態是否符合預期。

---

### Requirement: TDD 循環流程 (Red-Green-Refactor)

新增功能時 SHALL 嚴格遵循 TDD 流程：

1. **Red (撰寫失敗測試)**:
    - 先寫下測試案例，定義預期輸入與輸出。
    - 執行測試，確認其因為功能尚未實作而失敗。
2. **Green (實作功能)**:
    - 撰寫最少量的程式碼使測試通過。
    - 執行測試，確認通過。
3. **Refactor (重構)**:
    - 優化程式碼結構，確保符合 `app-service-pattern` 等規範。
    - 確保測試依然通過。

#### Scenario: TDD 任務分解
- **Step 1**: 建立測試類別與第一個失敗的測試方法。
- **Step 2**: 實作對應的功能代碼。
- **Step 3**: 執行測試並確認 Green。
- **Step 4**: 重構並重複。

---

### Requirement: 斷言訊息與結構

回應內容的斷言 SHALL 驗證關鍵資料是否出現在回應中，建議使用 `assertSee` 確保資料正確性。

#### Scenario: 回應內容校驗
```php
$response->assertOk();
$response->assertSee('"status":true');
$response->assertSee('"name":"測試表單"');
```
