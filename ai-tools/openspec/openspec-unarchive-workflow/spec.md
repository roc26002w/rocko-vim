# openspec-unarchive-workflow Specification

## Purpose

archive 代表 Ready to MR。MR 後若需調整，change 會經歷 unarchive → 修改 → 再 archive，可能來回多次。spectra CLI 沒有 `unarchive` 指令，本規範定義統一的搬回程序，避免 `openspec/changes/archive/` 下同一個 change 出現多份。

## Requirements

### Requirement: unarchive 必須搬移而非複製

unarchive SHALL 以 `git mv` 將 `openspec/changes/archive/<date>-<name>` 搬回 `openspec/changes/<name>`，SHALL NOT 以複製方式還原。`.openspec.yaml` SHALL 保留不動。

#### Scenario: 將已 archive 的 change 搬回

```bash
# 1. 確認 archive 下只有一筆
ls openspec/changes/archive | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}-i15384-of-form-widget-transformation$'
# → 2026-07-17-i15384-of-form-widget-transformation

# 2. 搬回（去掉日期前綴）
git mv openspec/changes/archive/2026-07-17-i15384-of-form-widget-transformation \
       openspec/changes/i15384-of-form-widget-transformation

# 3. 驗證
ls openspec/changes/archive | grep i15384-of-form-widget-transformation   # 無輸出
spectra list                                                             # 看得到 i15384-of-form-widget-transformation
git status                                                               # 顯示 renamed:，不是 new file
```

- **WHEN** 已 archive 的 change 在 MR 後需要調整
- **THEN** 以 `git mv` 搬回 `openspec/changes/<name>`，搬移後 `archive/` 下不得再有同名目錄

#### Scenario: 以複製還原

```bash
cp -r openspec/changes/archive/2026-07-17-i15384-of-form-widget-transformation \
      openspec/changes/i15384-of-form-widget-transformation
```

- **WHEN** 以 `cp` 還原 change
- **THEN** 舊目錄仍留在 archive，再次 archive 後同一 change 變成兩份，此做法不被允許

#### Scenario: archive 下已有多筆同名目錄

- **WHEN** 搬回前 `archive/` 下符合 `<date>-<name>` 的目錄不只一筆
- **THEN** 先處理重複（保留最新一份），再執行搬回

#### Scenario: 目標目錄已存在

- **WHEN** `openspec/changes/<name>` 已存在
- **THEN** 停止搬回，先確認該 change 是否仍在進行中

---

### Requirement: 同一 change 在 archive 下只有一份

`openspec/changes/archive/` 下，去掉日期前綴後同名的目錄 SHALL 只有一個。git pre-commit hook SHALL 在 commit 時檢查此條件。

#### Scenario: archive 出現重複

- **WHEN** index 中 `archive/` 下有 `2026-07-16-i15384-…` 與 `2026-07-17-i15384-…` 兩個目錄
- **THEN** pre-commit hook 列出重複的 change 名稱並拒絕 commit

---

### Requirement: 重新 archive 後複驗主 spec

重新 archive 後，主 spec（`openspec/specs/`）SHALL 人工複驗，因為 `ADDED` delta 對已存在的需求會靜默跳過。

#### Scenario: 調整後再次 archive

- **WHEN** 調整內容包含新增或修改需求，並重新 archive
- **THEN** 確認主 spec 已反映最新內容；既有需求的調整使用 `MODIFIED`，不使用 `ADDED`
