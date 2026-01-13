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
