# worktree-archive-workflow Specification

## Purpose

change 在 git worktree 分支上開發並需要 archive 時，spectra CLI（3.0.0）只讀取主倉庫（git commondir 所在的 checkout）的 `openspec/`，看不到 worktree 內的 change。本規範定義在 worktree 內完成 archive 的統一程序，避免動到主倉庫其他分支的未提交工作區。

## Requirements

### Requirement: 以 worktree 的 git 內容為準

change 與主 spec 的變動 SHALL 完成並提交於 worktree 所屬分支，SHALL NOT 為了讓 spectra 看得到而把 change 資料夾放進主倉庫工作區，唯一例外是 `spectra-worktree-workflow` 規定的「驗證用暫時副本」（複製、驗證後立即刪除，且前後主倉庫 `git status --short` 一致）。主倉庫的未提交內容 SHALL NOT 被修改。worktree 內 artifacts 的編輯與 CLI 驗證分工見 `spectra-worktree-workflow`。

#### Scenario: spectra 在 worktree 找不到 change

- **WHEN** change 資料夾只存在於 worktree，且主倉庫沒有同名 change
- **THEN** 在 worktree 執行 `spectra status`、`spectra instructions`、`spectra archive` 會回報 `Change '<name>' not found`
- **THEN** 以本規範的手動程序完成 archive，不為此修改主倉庫

#### Scenario: 動手前記錄主倉庫狀態

- **WHEN** 需要執行任何可能影響主倉庫的 spectra 指令
- **THEN** 先將主倉庫的 `git status --short` 存入暫存檔，執行後比對，只有 worktree 變動才算正常

---

### Requirement: 手動 archive 的程序

手動 archive SHALL 依序完成下列步驟：

1. change 資料夾位於 `openspec/changes/archive/<date>-<name>/`；若已 archive 過需要調整，沿用原目錄名稱，只更新內容（design、tasks、delta spec），SHALL NOT 新增另一個日期的目錄。
2. 若 change 目前位於 `openspec/changes/<name>/`，以 `git mv` 搬入 `archive/<date>-<name>/`，SHALL NOT 複製。
3. 將 delta spec 的內容套用到 `openspec/specs/<capability>/spec.md`：新增的需求寫成完整 `### Requirement`，既有需求的調整直接改在該需求內，SHALL NOT 貼入 `## ADDED Requirements` 等 delta 標題。
4. 確認 `tasks.md` 的任務全部為 `[x]`。

#### Scenario: 已 archive 的 change 需要調整後再次 archive

- **WHEN** 已 archive 的 change 為了新需求，先以 `git mv` 搬回 `openspec/changes/<name>/` 修改
- **THEN** 修改完成後以 `git mv` 搬回原本的 `archive/<date>-<name>/`，目錄名稱與日期不變，只有內容文件異動

#### Scenario: 調整既有需求

- **WHEN** 調整內容是在既有需求中增加規則或情境
- **THEN** 直接在主 spec 對應的需求內加入同樣的段落與情境，delta spec 與主 spec 的新增文字一致

---

### Requirement: 主 spec 格式複驗

套用 delta 後，主 spec SHALL 人工複驗，因為 worktree 內的 `spectra validate` 讀的是主倉庫檔案，無法驗證 worktree 的修改。

複驗項目：

- 主 spec 內不得出現 `## ADDED Requirements`、`## MODIFIED Requirements`、`## REMOVED Requirements`、`## RENAMED Requirements`。
- 主 spec 結構為 `# <capability> Specification`、`## Purpose`、`## Requirements`，且只有一個 `## Requirements`。
- delta spec 新增的文字已存在於主 spec。
- 主 spec 內不得留有本次 archive 注入的 `<!-- @trace ... -->` 區塊（`source:` 為本次 change 者）；其他 change 留下的 `@trace` 維持原樣。

分支合併後 SHALL 在主倉庫再執行一次 `spectra validate --specs`。

#### Scenario: 主 spec 殘留 delta 標題

- **WHEN** 主 spec 內出現 `## ADDED Requirements`
- **THEN** 視為 delta 被直接貼入，改為標準主 spec 結構（標題、Purpose、Requirements），需求內容不變

#### Scenario: archive 注入 @trace 區塊

- **WHEN** archive 後主 spec 的需求底下出現 `<!-- @trace` 區塊，且 `source:` 為本次 change
- **THEN** 移除該區塊，因為 `code:` 清單可能列入大量與 change 無關的工作區檔案（如 `public/` 的靜態資源），使主 spec 的 diff 膨脹數千行
- **THEN** 只移除區塊本身，需求內容與 `---` 分隔線的原有格式不變，並確認各主 spec 的需求數量與 delta 一致

#### Scenario: 無法在 worktree 驗證

- **WHEN** 在 worktree 執行 `spectra validate --specs` 仍顯示已修正檔案的舊錯誤
- **THEN** 以 `grep` 與結構檢查確認內容，並在合併後於主倉庫重新驗證

---

### Requirement: openspec 變動獨立提交

archive 產生的 openspec 變動（`openspec/changes/archive/` 與 `openspec/specs/`）SHALL 以單一 commit 提交，與 PHP 程式碼、測試、`documents/` 分開。commit 前 SHALL 先取得使用者同意；`git add` 與 `git commit` 分開執行。

#### Scenario: 一併修正他人留下的主 spec 錯誤

- **WHEN** archive 過程發現其他 change 留下的主 spec 格式錯誤並一併修正
- **THEN** 與本次 archive 的 openspec 變動合併為同一筆 commit，commit 訊息的條列註明兩項內容
