# commit-convention Specification

## Purpose

本專案所有 git commit 遵循統一的格式規範，以利追蹤 issue 與閱讀變更紀錄，並確保每筆變更在進入版控前都經過人工審核。

## Requirements

### Requirement: Commit 訊息格式

每筆 commit 訊息 SHALL 遵循以下格式：

```
Issue #<號碼> [<模組>] <中文描述>

  * <變更細節 1>
  * <變更細節 2>
```

- 第一行（主旨）：`Issue #<號碼>` 開頭，空一格後接中文描述，不加冒號
- `[<模組>]` 標籤置於號碼與描述之間，為 **RECOMMENDED**，非必填；省略時主旨為 `Issue #<號碼> <中文描述>`
- 標籤有寫時，`<模組>` SHALL 取自 [modules.md](./modules.md)，**縮寫**（如 `WF`）或**模組名稱**（如 `電子簽核`）皆可，但 SHALL 完整寫出，不得截斷或使用表外的簡稱
- Body：與主旨空一行，每條細節以兩個空格 + `*` 開頭

#### Scenario: 正確的 commit 訊息
```
Issue #15691 [電子簽核] 新增保存到期日計算元件

  * 新增 App\Services\WF\NonRetention\Index
  * 保存到期日為基準日加上 wf_template.retention_years 年
  * 發文者跨兩層關聯任一層查無資料時回傳空字串
  * 新增 IndexTest
```

#### Scenario: 省略模組標籤

```
Issue #15691 新增保存到期日計算元件
```

- **WHEN** 主旨未帶 `[<模組>]` 標籤
- **THEN** 仍為合規的 commit 訊息；建議補上標籤，但不強制

#### Scenario: 標籤須取自對應表

```
# 正確：使用模組名稱
Issue #15691 [電子簽核] 新增保存到期日計算元件

# 正確：使用縮寫
Issue #15691 [WF] 新增保存到期日計算元件

# 錯誤：表外的簡稱
Issue #15691 [簽核] 新增保存到期日計算元件
```

- **WHEN** 標籤既非 [modules.md](./modules.md) 的縮寫，也非其模組名稱
- **THEN** 改用該模組在對應表中的縮寫或模組名稱

#### Scenario: 模組標籤不得截斷
```
# 錯誤：標籤少一字，且該字被推入描述
Issue #15691 [電子簽] 核實作已到期簽核的篩選條件

# 正確：
Issue #15691 [電子簽核] 實作已到期簽核的篩選條件
```

- **WHEN** 模組名稱在括號內被截斷，剩餘字元落到描述開頭
- **THEN** 修正為完整標籤，描述從正確的字開始

---

### Requirement: 主旨描述聚焦單一主題

主旨的中文描述 SHALL 只描述該筆 commit 的單一主題，SHALL NOT 以「與」「並」「及」串接多個主題。一筆 commit 涵蓋多個主題時，SHALL 拆成多筆。

#### Scenario: 描述聚焦

```
# 正確：
Issue #15691 [電子簽核] 新增保存到期日計算元件
Issue #15691 [電子簽核] 表單名稱還原

# 錯誤：主旨串接兩個主題
Issue #15691 [電子簽核] 新增保存到期日計算元件與基準日規則
Issue #15691 [電子簽核] 表單名稱還原跳脫字元並調整主旨處理
```

- **WHEN** 主旨以連接詞串接多個主題
- **THEN** 保留主要主題，其餘移入 body，或拆成獨立 commit

---

### Requirement: Body 條列精簡

Body 的每條細節 SHALL 為簡短的短語，只寫「改了什麼」。SHALL NOT 附加理由、實作細節或驗證方式——理由屬於 `openspec/` 的 design.md，實作細節讀 diff 即可。

測試檔的變更以「新增測試」「調整測試」等一行帶過即可，SHALL NOT 逐一列舉測試涵蓋的情境。

變更單純且主旨已足以說明時（如 `更新 spec`），body SHALL 可省略。

#### Scenario: 條列精簡

```
# 正確：
  * 新增 App\Services\WF\NonRetention\Index
  * 新增測試

# 錯誤：附帶理由與實作細節
  * 新增 App\Services\WF\NonRetention\Index，繼承 App\Services\Service
  * 新增 IndexTest 共 6 個測試涵蓋回傳欄位、基準日取用與發文者缺漏
```

- **WHEN** 條列附加了從 diff 或 design.md 就能得知的資訊
- **THEN** 壓成只描述變更本身的短語

#### Scenario: 省略 body

```
Issue #15691 [電子簽核] 更新 spec
```

- **WHEN** 變更單純，主旨已完整說明
- **THEN** 不寫 body

---

### Requirement: git add 與 git commit 分開執行

`git add` 與 `git commit` SHALL 作為獨立指令分別執行，不得以 `&&` 串接在同一行。

#### Scenario: 正確的執行方式
```bash
git add <files>
git commit -m "Issue #XXXXX [<模組>] ..."
```

#### Scenario: 不正確的執行方式
```bash
# 禁止：
git add <files> && git commit -m "..."
```

---

### Requirement: Spec commit 與 code commit 分開

openspec artifacts（`openspec/changes/` 下的 proposal.md、design.md、specs/、tasks.md 等）的異動 SHALL 獨立一筆 commit，不得與 PHP 程式碼（Service、Test 等）混在同一筆。

Spec commit SHALL 在所有 code commit 完成後，於最後統一提交一筆。

#### Scenario: 正確的提交順序
```bash
# 實作完成後：
git add app/Services/...
git commit -m "Issue #XXXXX [<模組>] 實作 XxxService"

git add tests/Unit/...
git commit -m "Issue #XXXXX [<模組>] 新增 XxxService 單元測試"

# 最後統一提交 spec：
git add openspec/changes/iXXXXX-*/
git commit -m "Issue #XXXXX [<模組>] 更新 spec"
```

#### Scenario: 不正確的提交方式
```bash
# 禁止：spec 與 code 混在同一筆
git add openspec/changes/iXXXXX-*/tasks.md tests/Unit/.../XxxTest.php
git commit -m "..."
```

---

### Requirement: Commit 前須通知使用者審核

執行 `git commit` 前 SHALL 先通知使用者審核，並取得同意後才提交。通知內容 SHALL 包含：

- 要提交的檔案清單（或 `git diff --stat`）
- 完整的 commit message 草稿

未取得使用者同意 SHALL NOT 執行 `git commit`。

本要求適用於**每一筆** commit。前一筆已獲同意 SHALL NOT 視為後續 commit 的授權——連續提交多筆時，每一筆都要各自通知並取得同意。

#### Scenario: 提交前先送審

```
## 待審核

**變更**：app/Services/.../XxxService.php +42、tests/Unit/.../XxxServiceTest.php +65

**擬定 commit message**
Issue #XXXXX [<模組>] 新增 XxxService

  * <變更細節>

要我提交嗎？
```

- **WHEN** 程式碼已完成、測試通過，準備提交
- **THEN** 先展示檔案清單與 commit message，等使用者回覆同意後才執行 `git add` 與 `git commit`

#### Scenario: 連續多筆提交仍須逐筆送審

- **WHEN** 一次 apply 中有多個 task group，每組 Green 後各要提交一筆
- **THEN** 每一筆都各自送審，不得因為第一筆已獲同意就自動提交其餘各筆

#### Scenario: 未經同意即提交

- **WHEN** 已執行 `git commit` 但事前未送審
- **THEN** 以 `git reset HEAD~1` 退回該筆 commit（檔案保留），重新送審

---

### Requirement: Commit 粒度

實作階段的 code commit SHALL 以 task group 為單位，每組完成後立即提交一筆，SHALL NOT 把多個 task group 累積成一筆大 commit。

#### Scenario: 依 task group 逐筆提交

- **WHEN** tasks.md 有四個 task group，每組各自完成 Red-Green 循環
- **THEN** 產生四筆 code commit，每筆對應一個 task group 的行為變更

#### Scenario: 不正確的累積提交

- **WHEN** 四個 task group 全部實作完才提交
- **THEN** 違反本規範——應在每組 Green 後即送審並提交

---

### Requirement: TDD 流程的 commit 時機

遵循 TDD 流程時，Red 階段（測試建立但尚未通過）SHALL NOT 單獨 commit；等 Green 階段（測試全數通過）後，將 test 檔案與 implementation 檔案一起提交為一筆 code commit。

#### Scenario: TDD Green 後一起提交
```bash
# Green 後：
git add app/Services/.../XxxService.php
git add tests/Unit/.../XxxServiceTest.php
git commit -m "Issue #XXXXX [<模組>] 新增 XxxService"
```

#### Scenario: 不正確的 TDD commit 方式
```bash
# 禁止：Red 階段單獨 commit test
git add tests/Unit/.../XxxServiceTest.php
git commit -m "Issue #XXXXX [<模組>] 新增 XxxServiceTest"
```
