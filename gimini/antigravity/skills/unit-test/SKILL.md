---
name: unit-test-generation
description: 當使用者要求為現有程式碼撰寫單元測試 (Unit Tests) 時使用。確保覆蓋邊界情況 (Edge Cases)。
---

# Unit Test Generation Strategy

## 1. 測試框架選擇
- 若是 JavaScript/TypeScript，預設使用 **Jest** + **React Testing Library**。
- 若是 Python，預設使用 **Pytest**。
- 惹是 PHP 預設使用 **Phpunit**。

## 2. 測試案例設計 (AAA 模式)
每個測試必須遵循 Arrange-Act-Assert 結構：
1. **Arrange**: 準備資料與 Mock。
2. **Act**: 執行目標函式。
3. **Assert**: 驗證結果。

## 3. 必須覆蓋的情境
除了 Happy Path (正常情況)，你**必須**主動生成以下測試案例：
- **Edge Cases**: 輸入為空、null、undefined、負數、超大數值。
- **Error Handling**: 當 API 失敗或拋出異常時，程式是否優雅處理？

## 4. 程式碼要求
- 變數名稱清楚說明測試意圖（如 `should_return_zero_when_input_is_negative`）。
- **不要** 測試實作細節，只測試公開介面 (Public Interface)
