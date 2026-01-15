---
name: Agent Skills
description: Agent Skills 運作機制及說明
---

## 核心功能與運作機制
Google Antigravity 的 Agent Skills 設計強調簡單與直覺，其核心亮點包括：

* 標準化的結構： 建立一個技能只需創建一個資料夾並包含一個 SKILL.md 文件。
  - 該文件使用 YAML frontmatter 定義技能名稱與描述，並以 Markdown 撰寫具體的指令與步驟。
  - Agent 甚至可以讀取資料夾內的輔助腳本（Scripts）或範例程式碼。
* 彈性的作用範圍（Scopes）： 系統支援兩種類型的技能層級：
  - 工作區技能（Workspace-specific）：
    - 存放於專案根目錄的 .agent/skills/，適用於該專案特定的工作流程（如團隊的 CI/CD 規範）。
  - 全域技能（Global）：
    - 存放於使用者本機的 ~/.gemini/antigravity/skills/，適用於所有專案，適合存放開發者個人的通用工具或習慣配置。
* 智慧觸發（Progressive Disclosure）：
  - 開發者無須每次顯式指令 Agent 使用某項技能。
  - Agent 會在對話開始時掃描可用的技能列表，並根據使用者的任務上下文（Context），自動判斷是否「啟用」某項技能並讀取其詳細指令。


## Google Anget skills 說明
* [Google Antigravity skills 官方網站](https://antigravity.google/docs/skills)
* [agentskills.io](https://agentskills.io/home)

## Gooogle Anget skills 範例結構
以下為 Agent Skills 的目錄結構範例：
```
.agent/skills/my-skill/
├─── SKILL.md       # Main instructions (required)
├─── scripts/       # Helper scripts (optional)
├─── examples/      # Reference implementations (optional)
└─── resources/     # Templates and other assets (optional)

```

```
.agent/skills/
  - deploy-to-production/
    - SKILL.md
  - run-code-analysis/
    - SKILL.md
  - generate-release-notes/
    - SKILL.md

```

## SKILL.md 文件範例
```
---
name: my-skill
description: Helps with a specific task. Use when you need to do X or Y.
---

# My Skill

Detailed instructions for the agent go here.

## When to use this skill

- Use this when...
- This is helpful for...

## How to use it

Step-by-step guidance, conventions, and patterns the agent should follow.
```

以下為一個範例技能的結構與內容：

```
.agent/skills/deploy-to-production/SKILL.md
---
name: Deploy to Production
description: Automates deployment of the application to the production environment.
---
# Deploy to Production
This skill automates the deployment process to the production environment.
## Steps
1. Ensure all tests pass.
2. Build the application.
3. Deploy to the production server.
4. Verify the deployment.
```
透過這樣的結構，開發者可以輕鬆地為 Google Antigravity 定義並擴展各種技能，提升工作效率與自動化程度。

