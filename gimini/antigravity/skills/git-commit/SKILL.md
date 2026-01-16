---
name: git-commit-guardian
description: 當使用者要求為當前的程式碼變更撰寫 Git Commit Message 時使用。這會強制執行 Conventional Commits 規範。
---

# Git Commit Message Guidelines

## 1. 核心規則
你必須嚴格遵守 [Conventional Commits](https://www.conventionalcommits.org/) 規範。
格式：`<type>(<scope>): <description>`

## 2. Type 定義
- `feat`: 新功能
- `fix`: 修復 Bug
- `docs`: 僅修改文件
- `style`: 格式修改（不影響邏輯）
- `refactor`: 重構（不是新增功能也不是修 Bug）
- `perf`: 效能優化
- `chore`: 建置過程或輔助工具的變動

## 3. 輸出要求
- **Scope**：根據修改的檔案路徑或模組自動判斷（例如：`auth`, `api`, `ui`）。
- **Description**：
- 使用繁體中文。
- 必須是祈使句（例如：「新增登入按鈕」而不是「新增了登入按鈕」）。
- 不超過 50 個字元。
- **Body (可選)**：如果變更很複雜，請條列式說明「為什麼」要這樣改，而不是「改了什麼」。

## 4. 範例
✅ `feat(auth): 新增 Google OAuth 登入流程`
❌ `update code`
