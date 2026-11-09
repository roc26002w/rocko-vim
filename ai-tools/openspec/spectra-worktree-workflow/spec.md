# spectra-worktree-workflow Specification

## Purpose

在 git worktree 上開發 change 時，spectra CLI（3.0.0）只讀寫主倉庫（`git rev-parse --git-common-dir` 所在的 checkout）的 `openspec/`，worktree 內的 change 對 `list`、`status`、`instructions`、`analyze`、`validate`、`archive` 等指令都不可見。本規範定義 worktree 內處理 change artifacts 的分工：artifacts 由 AI 在 worktree 手動編輯，需要 CLI 驗證時才暫時複製到主倉庫。

本規範不含專案專屬名稱，可原樣複製到其他使用 spectra 與 git worktree 的專案。archive 的細節見 `worktree-archive-workflow`，unarchive 見 `openspec-unarchive-workflow`。

## Requirements

### Requirement: 先判斷是否位於 worktree

處理 change 前 SHALL 先確認目前目錄是否為非主倉庫的 worktree。判斷方式：`git rev-parse --git-common-dir` 的上一層目錄不等於 `git rev-parse --show-toplevel`。

#### Scenario: 位於 worktree

- **WHEN** `--git-common-dir` 指向另一個目錄的 `.git`
- **THEN** 視為 worktree，`spectra list --changes` 看不到本地的 change 屬預期結果，改依本規範的分工處理

#### Scenario: 位於主倉庫

- **WHEN** `--show-toplevel` 與 `--git-common-dir` 的上一層相同
- **THEN** 不適用本規範，直接使用 spectra CLI

---

### Requirement: 指令分工

僅讀寫 `openspec/changes/<name>/` 內 artifacts 的工作，SHALL 由 AI 在 worktree 內手動完成；需要程式碼、git 狀態或 worktree 內 `.spectra/` 紀錄的工作，SHALL 在 worktree 內進行，且 SHALL NOT 移到主倉庫執行。

| 工作 | 執行位置 |
|---|---|
| ingest、propose、編輯 proposal／design／specs／tasks | worktree 內手動編輯 |
| `analyze`、`validate`、`status`（CLI 背書） | 暫時複製到主倉庫執行 |
| apply、verify、drift、review、scope | 只在 worktree 內處理，不複製 |
| archive、unarchive | 依 `worktree-archive-workflow` 與 `openspec-unarchive-workflow` |

#### Scenario: 對 worktree 的程式碼做 drift 或 verify

- **WHEN** 需要比對 change 與程式碼
- **THEN** 在 worktree 內以 git 與檔案內容人工比對；SHALL NOT 複製到主倉庫後執行，因為主倉庫檢出的是另一個分支，比對結果會是錯的

---

### Requirement: 手動編輯 artifacts 須遵守 skill 規則

手動編輯 SHALL 等同 CLI 產生的結果。編輯前 SHALL 讀該專案的 `openspec/config.yaml`、`.spectra.yaml`（含 `locale`）與既有 artifacts 作為格式依據；對應 skill（如 `spectra-ingest`）的規則 SHALL 照做。

- 已完成的 `[x]` task 描述不得修改或刪除；被取代的已完成行為以新增待辦補償 task 處理。
- 新 task 以 `[after: <task-number>]` 表達順序，既有 `[P]` 標記保持不動，且不得形成循環。
- 主 spec 與 delta spec 維持英文，其餘 artifacts 依 `locale`。
- 不得寫成只有檔案路徑、沒有可觀察結果的 task，也不得以行號定位工作。

#### Scenario: 已全部完成的 change 收到新需求

- **WHEN** change 的 task 全部為 `[x]`，又加入新需求
- **THEN** 新需求以新增的待辦 task 表達，原有 `[x]` task 不動

#### Scenario: 手動編輯無法更新 CLI 內部紀錄

- **WHEN** 以手動編輯取代 `spectra new artifact`
- **THEN** `.spectra/` 的 task baseline、touched 紀錄與資料庫不會更新，之後 `drift`、`scope` 的結果可能不完整，回報時 SHALL 註明

---

### Requirement: 以暫時複製取得 CLI 驗證

需要 CLI 驗證時，SHALL 將 change 資料夾「複製」到主倉庫的 `openspec/changes/`，SHALL NOT 以 `mv` 搬移，使 worktree 內的原件在任何失敗情況下都保持完整。驗證結束 SHALL 刪除主倉庫的副本。

程序：

1. 記錄主倉庫 `git status --short` 到暫存檔，主倉庫已有同名 change 時停止。
2. 複製 change 資料夾到主倉庫 `openspec/changes/<name>/`。
3. 在主倉庫執行 `spectra analyze <name>` 與 `spectra validate <name>`。
4. 有問題就回 worktree 修正，再重新複製（覆蓋）後重跑，不在主倉庫副本上修。
5. 通過後刪除主倉庫副本，再次記錄 `git status --short`，與步驟 1 比對一致。

#### Scenario: 驗證通過

- **WHEN** `analyze` 無 Critical 且 `validate` 通過
- **THEN** 刪除主倉庫副本，主倉庫 `git status --short` 與驗證前相同

#### Scenario: 主倉庫已有同名 change

- **WHEN** 主倉庫 `openspec/changes/<name>/` 已存在
- **THEN** 停止並回報，SHALL NOT 覆蓋

#### Scenario: 在主倉庫副本上修改

- **WHEN** 驗證出錯後直接修改主倉庫副本
- **THEN** 不被允許，因為修改會與 worktree 原件分岐；一律改 worktree 原件再重新複製

---

### Requirement: 不得污染主倉庫

複製驗證期間，主倉庫的分支、已追蹤檔案與暫存區 SHALL NOT 被修改，SHALL NOT 在主倉庫執行 `git add`、`git commit`、`git checkout` 或 `spectra archive`。

#### Scenario: 為探測行為建立測試 change

- **WHEN** 為了探測 CLI 行為，在 worktree 內執行 `spectra new change <probe>`
- **THEN** 該指令實際寫入主倉庫，結束後 SHALL 立即刪除該資料夾，並以 `git status --short` 確認主倉庫無殘留

#### Scenario: 驗證留下 spectra 內部檔案

- **WHEN** 驗證後主倉庫出現 `.spectra/` 之類的內部檔案
- **THEN** 若已被 `.gitignore` 忽略可保留，否則回報給使用者，SHALL NOT 自行清除

---

### Requirement: 在 worktree 實作時遵守專案規範

在 worktree 內手動執行 apply（實作 `tasks.md` 的待辦）時，CLI 不會提示專案規範，AI SHALL 自行依下列清單處理；專案若沒有對應的 spec，該條不適用。

- 依照 `commit-convention` spec 規範撰寫 commit message。
- 依照 `app-service-pattern` spec 規範撰寫 service 程式碼。
- 依照 `tdd-pattern` spec 規範撰寫程式碼。
- 若有新增或更新端點，依照 `api-documentation` 規範撰寫並更新 API document。

#### Scenario: 開始實作前

- **WHEN** 在 worktree 內開始 apply 一個 change
- **THEN** 先讀清單中該專案存在的 spec，再動手撰寫程式碼、測試與 commit message

#### Scenario: commit 前

- **WHEN** 準備提交
- **THEN** 對照 `commit-convention` 擬定訊息並先送使用者審核；只 `git add` 該筆 commit 的檔案，並以 `git status` 確認暫存區沒有夾帶其他已暫存的檔案（如 unarchive 的 `git mv` 搬移）

#### Scenario: 專案沒有某份 spec

- **WHEN** 專案的 `openspec/specs/` 沒有清單中的某份 spec
- **THEN** 略過該條，不自行臆測規則

---

### Requirement: 在 worktree 以 container 驗證

worktree 的程式碼 SHALL 以 `docker run` 掛載該 worktree 目錄驗證，SHALL NOT 使用已啟動的 demo container，因為 demo container 掛載的是主倉庫，執行的是另一個分支的程式碼。映像、網路名稱以下為本專案範例，其他專案替換為自己的值。

| 用途 | 映像 | 能力 |
|---|---|---|
| 單元測試、格式檢查、跨平台（大小寫敏感）驗證 | `registry.d.netask.net/novax-utility/docker-gitlab-ci-runner-php:8.4` | PHP 8.4，含 `pdo_sqlite`、`pdo_pgsql`、`odbc`；**沒有 `pdo_mysql`**，連不上 MySQL |
| 連 demo 資料庫跑 `artisan`、Seeder、migration 往返 | `registry.d.netask.net/novax-utility/novax-kumay-docker-compose:netask` | 含 `pdo_mysql` |

```bash
# 單元測試（SQLite），任何 worktree 都能掛載
docker run -it --rm -v$(pwd):/data \
  registry.d.netask.net/novax-utility/docker-gitlab-ci-runner-php:8.4

# 加入 demo 網路，掛載 worktree 連 demo 資料庫
docker run -it --rm -v$(pwd):/data -w /data \
  --network novax-kumay-docker-compose_backend \
  --entrypoint bash \
  registry.d.netask.net/novax-utility/novax-kumay-docker-compose:netask
```

- 加入網路用 `--network <compose 專案名>_<網路名>`（例如 `novax-kumay-docker-compose_backend`），名稱以 `docker network ls` 為準；compose 未啟動或已 `down` 時網路不存在。
- 掛載的 worktree 需有 `vendor/` 與 `.env`，且 `.env` 的資料庫設定要與 demo 相同。

#### Scenario: 用 runner 映像連 MySQL

- **WHEN** 在 runner 映像內執行 `php artisan migrate:status`，而 `.env` 為 `DB_CONNECTION=mysql`
- **THEN** 會出現 `could not find driver`，改用含 `pdo_mysql` 的映像

#### Scenario: 驗證前確認連線與 migration 狀態

- **WHEN** 要在 demo 資料庫驗證 worktree 的 Seeder 或 migration
- **THEN** 先用唯讀的 `php artisan migrate:status` 確認連線與目前已執行的 migration，再決定是否 `migrate:rollback`、`--step` 多少，不憑印象計算

#### Scenario: 驗證前備份

- **WHEN** 驗證會寫入或降級 demo 資料
- **THEN** 先以 `mysqldump` 備份相關資料表，再執行驗證

---

### Requirement: 保留 archive 紀錄

unarchive 後 `.openspec.yaml` SHALL 保留原內容，包含 `archived_by`、`archived_at`，與 `openspec-unarchive-workflow` 一致。

#### Scenario: spectra 看不到 unarchive 後的 change

- **WHEN** 在 worktree 內 unarchive 後 `spectra list` 無輸出
- **THEN** 原因是 CLI 讀主倉庫，不是 `archived_at` 欄位；SHALL NOT 為了讓 CLI 看見而刪除該欄位

---

### Requirement: 套用到其他專案

將本規範套用到其他專案時，SHALL 複製整個 `openspec/specs/spectra-worktree-workflow/` 目錄，並確認該專案的 spectra 版本行為相同。

#### Scenario: 新專案或新版 spectra

- **WHEN** 新專案的 spectra 版本與 3.0.0 不同
- **THEN** 先在 worktree 內執行 `spectra list --changes` 與 `spectra new change <probe>`（完成後立即刪除探測資料夾），確認 CLI 是否仍讀主倉庫；若已支援 worktree，則不再適用本規範
