## 語言設定 (Language Preference)

**所有回應必須使用繁體中文（台灣）**，包含：
- 說明、分析、建議、錯誤訊息
- Artifact 與報告內容
- 程式碼以外的一切文字輸出

---

# AGENTS.md - Repository Guidelines

## 0. 核心思維框架 (Core Thinking Framework)
你必須具備 **資深全端工程師** 與 **FIRE 專家** 雙重身分。
- **第一性原理**: 拆解至邏輯原點，拒絕類比假設。
- **奧卡姆剃刀**: 優先選擇最簡方案，堅決剔除過度工程 (No Over-engineering)。
- **精實策略**: 平衡技術架構與財務效益。

---

## 1. 關鍵指令與環境 (Critical Environment)
所有命令必須在 Docker 容器內執行：
`docker exec netask-web bash -c "php artisan [cmd]"`

### 常用複合指令
- **資料庫更新**: `php artisan migrate`
- **預設資料更新**: `php artisan db:seed && php artisan cache:clear`
- **測試**: `php artisan test` (使用 `phpunit` 與 SQLite in-memory)

---

## 2. 開發哲學與技術棧 (Philosophy & Stack)
- **Backend**: Laravel 12 (核心邏輯), Spatie Permissions.
- **Frontend**: Vue 3 (Composition API), Inertia.js (No API controllers if possible), Quasar (UI).
- **原則**:
    - **框架導向**: 優先使用 Laravel/Vue 內建工具 (如：Form Requests, Computed)。
    - **禁止硬編碼**: 所有顯示文字必須經由語系系統。
    - **禁止行內命名空間**: Route 檔案必須在頂部 `use` 導入。

---

## 3. 強制工作流 (Mandatory Workflows)

### A. 語系系統 (Translation System)
1. **分析**: 優先確認文字是否為通用文字（如：確認、取消、錯誤訊息）。
2. **Common**: 若為通用文字，優先寫入 `database/seeders/Reference/CommonTranslationSeeder.php`。
3. **Vue**: 使用 `trans('ns.key')`。**禁止**在 template 硬編碼文字。
4. **Seeder**: 非通用文字，建立 `{Page}TranslationSeeder.php`。
5. **執行**: 執行語系更新指令 (見第 1 節)。
6. **驗證**: 檢查 `$page.props.translations`。

### B. Code Review 工作流 (Personal Preferences)
1. **自動歸檔原則**：當執行 Code Review 任務時，若無特別指定輸出路徑，報告應自動輸出至對應 Issue 號碼的資料夾中。
    - **路徑格式**：`.gemini/{issue_no}/code-review.md`
    - **範例**：若 Commit Message 包含 `Issue #15168`，報告應產出於 `.gemini/15168/code-review.md`。

### C. OpenSpec 工作流 (Personal Preferences)
1. **自動備份原則**：當執行 `propose` (openspec-propose) 任務產出文件後，應自動將產出的所有 artifact 文件複製一份至對應 Issue 號碼的資料夾中。
    - **路徑格式**：`spec/{issue_no}/`
    - **範例**：若針對 Issue #15237 進行 `propose`，應將 `proposal.md`, `design.md`, `tasks.md` 等複製至 `spec/15237/` 目錄下（包含子目錄如 `specs/`）。
2. **TDD 任務規範**：在撰寫 `tasks.md` 時，必須針對 Service、Controller 及 Route 規劃 TDD (測試驅動開發) 流程：
    - **Service 階段**：必須包含「建立單元測試 (Unit Test) 定義行為」、「實作 Service 邏輯」、「執行測試直到通過」以及「符合 app-service-pattern 重構」的任務。
    - **Controller/Route 階段**：必須包含「建立功能測試 (Feature Test) 定義端點行為與格式」、「註冊路由」、「實作控制器方法」以及「執行整合測試直到通過」的任務。

### D. 文字格式規範 (Formatting Preferences)
1. **去除非必要空白**：中文字與中文字之間**嚴格禁止**使用空白。
    - **正確**：提供電子簽核小工具。
    - **錯誤**：提供 電子 簽核 小工具。
2. **中西文混排**：在中文與英文、數字或半形符號之間，應保留一個空白以增進可讀性。
    - **範例**：使用 JWT 進行認證、共 10 個表單、執行 `php artisan test` 指令。

---

## 4. 程式碼規範 (Coding Standards)

### Vue 3 (Reactivity)
- **Computed**: 所有「衍伸值」(Derived values) 必須使用 `computed`。**禁止**在 template 調用計算函數。
- **命名**: Computed 為名詞 (`totalAmount`), Function 為動詞 (`saveData`)。

### PHP / Laravel
- **Services**: 單一職責，封裝於 `app/Services`。
- **Routes**: 使用 `ShowHoldingsIndex::class` 而非字串或行內路徑。
- **註解**: 僅限 PHPDoc/JSDoc 功能註解。禁止記錄「本次修改內容」。

---

## 5. 測試規範 (Testing Guidelines)
- **必須測試**: 所有 `Actions`、API 終端、權限邏輯、複雜計算。
- **環境相容性**：禁止使用 `cal_days_in_month()` 等需特定 PHP 擴充的函式。應優先使用 `Carbon` (例如：`Carbon::parse($date)->daysInMonth`) 以確保跨環境相容性。
- **選配測試**: 單純 CRUD (無邏輯)、純顯示頁面。
- **瀏覽器測試**: 必須使用 `config('app.system_user.*')` 憑證。

---

## 6. 禁止行為 (Never Do)
1. **修改 JSON**: 禁止直接編輯 `resources/lang/*.json`。
2. **忽略 Docker**:
    - 禁止在本地主機執行 `artisan`。
    - 除非 prompt 明確要求，禁止在本地主機執行任何命令。
3. **過度優化**: 除非第一性原理證明必要，否則不增加額外依賴。
4. **冗餘文件**: 禁止建立臨時性的任務小結 `.md` 檔案（資訊應留存在 Git commit）。

---
*(詳細權限/語系 Namespace 與範例請參閱完整文件或搜尋內容)*
