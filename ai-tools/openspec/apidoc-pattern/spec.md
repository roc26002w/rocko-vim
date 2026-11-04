# apidoc-pattern Specification

## Purpose

定義 Laravel 專案產製 API 文件的通用模式：以 `darkaonline/l5-swagger` 產出 OpenAPI 3 規格、以 `OpenApi\Attributes` 撰寫、集中存放於鏡射 Controller 結構的 `documents/` 資料夾，並以一支 artisan 指令輸出 endpoint 清單作為撰寫時的事實來源。

本規範為**跨專案**的通用模式，不綁定任何專案的模組、tag 或驗證方式。專案專屬的決策（tag 清單、securityScheme、路由前綴、回應外殼欄位）SHALL 寫在該專案自己的 spec，本規範只定義結構與流程。

建置步驟與可直接複製的工具程式碼見 [setup.md](./setup.md)。

## Requirements

### Requirement: 文件以 OpenAPI 3 產製

API 文件 SHALL 由 `darkaonline/l5-swagger` 以 OpenAPI 3 格式產製。

文件內容 SHALL 使用 `OpenApi\Attributes`（PHP 8 attribute）撰寫，SHALL NOT 使用 docblock annotation 形式，SHALL NOT 使用 apidoc 等其他工具。

#### Scenario: 產製文件
- **WHEN** 執行 `php artisan l5-swagger:generate`
- **THEN** 產出 OpenAPI 3 規格檔，且 swagger-php 掃描過程不出現錯誤

#### Scenario: 舊工具設定移除
- **WHEN** 專案改用本模式
- **THEN** 舊工具的設定檔（如 `apidoc.json`）與其產生物一併移除

---

### Requirement: 文件檔案獨立於 Controller

API 文件 SHALL 存放於專案根目錄的 `documents/` 資料夾，SHALL NOT 寫在 Controller 的 docblock 內。

`config/l5-swagger.php` 的 `paths.annotations` SHALL 設定為 `base_path('documents')`。

理由：文件與實作分離後，Controller 的 diff 只剩行為變更，且文件可獨立於 Controller 重構而存在。

#### Scenario: Controller 不含文件註解
- **WHEN** 搜尋 `app/Http/Controllers` 下所有檔案
- **THEN** 找不到任何 API 文件註解

#### Scenario: 掃描路徑設定
- **WHEN** 讀取 `config/l5-swagger.php` 的 `paths.annotations`
- **THEN** 其值為 `base_path('documents')`

---

### Requirement: 文件檔案結構鏡射 Controller 結構

`documents/` 下的檔案路徑 SHALL 對應 Controller 在 `app/Http/Controllers/` 之下的相對路徑，檔名 SHALL 為 Controller 類別名去除 `Controller` 後綴，SHALL NOT 對檔名做大小寫正規化。

目錄名中全大寫的模組縮寫 SHALL 正規化為首字大寫（`DM` → `Dm`、`WF` → `Wf`、`API` → `Api`），已是混合大小寫的段落 SHALL 維持原樣。namespace SHALL 與目錄逐段完全一致（含大小寫），`composer.json` SHALL 註冊 `"Document\\": "documents/"` autoload 對應。

理由：目錄名若原樣沿用全大寫縮寫，namespace 與目錄的大小寫容易在人工撰寫時不一致——在大小寫不敏感的檔案系統可通過，到大小寫敏感的環境才失敗。正規化為單一規則後，路徑可由 Controller 路徑機械推導。

#### Scenario: 巢狀目錄的 Controller
- **WHEN** Controller 為 `app/Http/Controllers/Rpc4/WF/WorkflowController.php`
- **THEN** 文件檔為 `documents/Rpc4/Wf/Workflow.php`，class 為 `Document\Rpc4\Wf\Workflow`

#### Scenario: 全大寫模組縮寫目錄
- **WHEN** Controller 為 `app/Http/Controllers/DM/SearchController.php`
- **THEN** 文件檔為 `documents/Dm/Search.php`，class 為 `Document\Dm\Search`

#### Scenario: PSR-4 合規
- **WHEN** 執行 `composer dump-autoload -o`
- **THEN** 不出現 `documents/` 下任何檔案的 PSR-4 不合規警告

#### Scenario: 大小寫敏感檔案系統
- **WHEN** 在大小寫敏感的檔案系統執行 `php artisan l5-swagger:generate`
- **THEN** 產出的 path 數量與大小寫不敏感環境一致，且輸出中不出現 `Skipping unknown` 警告

---

### Requirement: 文件檔為純 attribute 容器

`documents/` 下的 class SHALL 只承載 attribute，class body SHALL 為空。

說明文字 SHALL 寫在 attribute 的 `summary`、`description` 欄位，SHALL NOT 以 PHP 註解形式撰寫（見 `code-comment-convention`）。

#### Scenario: 說明文字的位置
- **WHEN** 需要說明某 endpoint 的用途
- **THEN** 文字寫在 operation 的 `summary` 或 `description`，而非檔案內的 `//` 或 `/* */` 註解

---

### Requirement: 共用內容抽為 Component

重複出現於多支 endpoint 的 error message、response、header 與 example SHALL 抽至 `documents/Components.php`，各 endpoint SHALL 以 `$ref` 引用，SHALL NOT 逐支重複定義。

全域資訊（`OA\Info`、`OA\Server`、`OA\SecurityScheme`、`OA\Tag`）SHALL 集中於 `documents/Info.php`。

#### Scenario: 引用共用錯誤回應
- **WHEN** 某 endpoint 會回傳共用的錯誤回應
- **THEN** 其 `OA\Response` 以 `ref: '#/components/responses/...'` 引用 `Components.php` 的定義，而非在該檔內重新展開欄位

#### Scenario: 共用錯誤範例
- **WHEN** 多支 endpoint 共用同一組錯誤碼情境
- **THEN** 該情境定義為 `Components.php` 的 `OA\Examples`，各 endpoint 以 `#/components/examples/...` 引用

---

### Requirement: 以 body 表達成敗的 API 以共用 schema 描述

API 若以 HTTP 200 搭配 body 欄位（如 `status: false` 與 `code`）表達失敗，其回應 SHALL 以共用的回應 schema 描述外殼欄位，成功與各錯誤情境 SHALL 以 `examples` 並列於同一個 200 response 之下，SHALL NOT 為這類錯誤宣告實際不會回傳的 4xx response。

外殼的欄位組成由各專案的 spec 定義。

#### Scenario: 錯誤情境以 200 回應描述
- **WHEN** 某 endpoint 的驗證失敗會回傳 HTTP 200 與 `{"status": false, "code": 100}`
- **THEN** 文件在該 endpoint 的 200 response 下以 example 呈現此錯誤，而非另外宣告 4xx response

---

### Requirement: 文件涵蓋所有 JSON endpoint

`app/Http/Controllers` 下所有回傳 JSON 的 endpoint SHALL 於 `documents/` 有對應文件，涵蓋範圍 SHALL NOT 限於原本已有文件的 Controller。

每支 endpoint 的 method 與 path SHALL 依路由定義加上實際掛載的前綴推導，路徑參數 SHALL 寫成 `{param}` 形式。

回傳 Blade view 或 RedirectResponse 的頁面路由不在涵蓋範圍。

#### Scenario: 原無文件的 Controller
- **WHEN** Controller 原本沒有任何文件註解
- **THEN** 仍為其所有 JSON endpoint 建立對應的 `documents/` 文件

#### Scenario: 路徑前綴
- **WHEN** endpoint 定義於某 route 檔且框架為其掛上前綴
- **THEN** 文件中的 path 為含前綴的完整路徑

#### Scenario: 頁面路由排除
- **WHEN** 路由僅回傳 Blade view
- **THEN** 不為其建立 API 文件

---

### Requirement: 以指令輸出 endpoint 清單作為撰寫依據

專案 SHALL 提供一支 artisan 指令，列出所有 JSON endpoint 由框架可直接讀出的事實，作為撰寫 `documents/` 文件時的來源。

輸出 SHALL 包含：`path`（含掛載的前綴）、HTTP verb、path 參數、`security`（由 middleware 推導）、依 Controller 結構推導的 `documents/` 檔案路徑，以及該 endpoint 是否已出現在該檔案中。

指令 SHALL NOT 產生或寫入任何檔案，SHALL NOT 推導 `summary`、`requestBody` 或回應結構——這些需依實作撰寫，非框架可直接讀出的事實。

回傳 Blade view 或 RedirectResponse 的頁面路由 SHALL 排除於清單之外。

輸出格式 SHALL 為 JSON，因主要使用者為撰寫文件的工具或 AI agent。

理由：`path`、verb、`security` 與檔案路徑由框架的 route table 直接讀出，重新以人工或靜態分析推導容易出錯（少掛前綴、`Route::any` 的多重 verb、目錄大小寫未正規化）；而 `summary` 與回應結構需要判讀實作，機械推導只能產出佔位內容，反而增加辨識「哪些已完成」的成本。

#### Scenario: 輸出的欄位
- **WHEN** 執行該指令
- **THEN** 每筆含 controller、method、verb、path、parameters、security、tag、document、documented

#### Scenario: 辨識尚待補寫的 endpoint
- **WHEN** 某 endpoint 的 path 與 verb 尚未出現在對應的 `documents/` 檔案中
- **THEN** 該筆的 `documented` 為 false

#### Scenario: 不產生檔案
- **WHEN** 執行該指令
- **THEN** `documents/` 下沒有任何檔案被新增或修改

---

### Requirement: 撰寫流程與完成判準

撰寫文件 SHALL 依下列流程，以 Controller 為單位逐支完成：

1. 以 endpoint 指令取得該 Controller 的清單（`documented` 為 false 者即待辦）
2. 讀 route 定義、FormRequest、Controller 與其呼叫的 Service，據以撰寫 attribute
3. 執行 `php artisan l5-swagger:generate`，確認無警告
4. 重跑 endpoint 指令，確認該 Controller 各筆 `documented` 皆為 true

一次變更的完成判準 SHALL 為：涵蓋範圍內所有 endpoint 的 `documented` 為 true，且產製過程無警告。

#### Scenario: 單支 Controller 的完成
- **WHEN** 某 Controller 的文件撰寫完畢
- **THEN** 重跑指令時其所有 endpoint 的 `documented` 為 true，且 `l5-swagger:generate` 無警告

#### Scenario: 尚未完成不算完成
- **WHEN** 產製成功但仍有 endpoint 的 `documented` 為 false
- **THEN** 該變更未完成，繼續補寫

---

### Requirement: 文件內容須反映實作現況

文件內容 SHALL 以實作為準。既有註解與實作不符之處 SHALL 於撰寫時一併修正，SHALL NOT 原樣搬進 OpenAPI。

核對依據的優先順序 SHALL 為：route 定義決定 method 與 path、FormRequest 的 `rules()` 決定 requestBody 欄位與必填、Controller 與其呼叫的 Service 決定回應結構與錯誤碼。

修正 SHALL 僅限於文件。核對時發現的實作疑似 bug SHALL 記錄回報，SHALL NOT 於撰寫文件的變更中修改程式。

#### Scenario: 既有註解的必填標示與 FormRequest 不符
- **WHEN** 舊註解將某欄位標為必填，但對應 FormRequest 的 `rules()` 未含 `required`
- **THEN** 新文件依 `rules()` 標示為非必填

#### Scenario: 既有註解描述了已不存在的欄位
- **WHEN** 舊註解的成功範例含有實作已不再回傳的欄位
- **THEN** 新文件不包含該欄位

#### Scenario: 核對發現實作疑似有問題
- **WHEN** 核對時發現不符的原因是實作本身有問題，而非文件寫錯
- **THEN** 文件依實作現況撰寫，該問題另行記錄回報，不在本次修改程式

---

### Requirement: 撰寫文件不變更執行期行為

撰寫或遷移文件 SHALL NOT 變更任何路由、Request 驗證規則、Service 邏輯或資料庫結構。Controller 的異動 SHALL 僅限於移除舊文件註解。

#### Scenario: Controller 僅移除註解
- **WHEN** 檢視任一 Controller 的 diff
- **THEN** 只有舊文件註解被刪除，方法簽章與方法內容維持原狀

#### Scenario: 既有測試不受影響
- **WHEN** 執行既有測試
- **THEN** 測試結果與變更前一致，且不需為此變更修改任何既有測試

---

### Requirement: payload 分派端點以合成路徑表達

依 payload 而非路徑分派的端點（單一 URL 依 body 欄位決定執行內容，常見於 legacy 入口），其各組合 SHALL 同時以三種形式文件化：

1. 一條**真實**的 operation，描述分派機制、合法的分派欄位值與回應外殼——此為權威定義
2. 一份**對照表**，列出完整組合、各組合實際執行的腳本與靜態推導的輸入欄位
3. 每個組合一條**合成路徑**的 operation，供 API reference 依模組瀏覽

合成路徑 SHALL NOT 被視為真實端點。每條合成 operation SHALL 於 description 開頭標明該路徑不存在與實際的請求方式，且其 `requestBody` SHALL 為真正要送出的 payload（含分派欄位）。

合成 operation 的 tag SHALL 與真實端點的模組 tag 區隔，SHALL NOT 併入既有模組 tag。

#### Scenario: 合成路徑的辨識
- **WHEN** 讀者在 API reference 看到合成路徑
- **THEN** 該 operation 的 description 開頭即說明此路徑不存在、實際的請求 method 與 URL，並列出該組合的分派欄位值

#### Scenario: 照著 requestBody 送出
- **WHEN** 使用者複製合成 operation 的 requestBody 內容，送往真實入口
- **THEN** 該請求即為正確的呼叫，無須額外補欄位

#### Scenario: 真實入口不被取代
- **WHEN** 合成端點存在
- **THEN** 真實入口的 operation 仍存在於主規格，且為權威定義

---

### Requirement: 合成端點獨立為另一份 OpenAPI 規格

合成路徑的 operation SHALL 產出為與主規格分離的另一份 OpenAPI 規格，SHALL NOT 併入主規格。

主規格的 documentation SHALL 以 `scanOptions.exclude` 排除合成端點的來源目錄，兩份 documentation 的 `docs` 路由 SHALL 各自獨立。

理由：合成端點動輒數百條，併入主規格會讓規格膨脹到部分 OpenAPI 工具無法建立模型。

#### Scenario: 主規格不含合成路徑
- **WHEN** 產製主規格
- **THEN** 其 paths 不含任何合成路徑

#### Scenario: 規格體積可被工具處理
- **WHEN** 合成端點數量達數百條
- **THEN** 兩份規格各自維持在一般 OpenAPI 工具可建立模型的體積，不因合併而超出

---

### Requirement: 由 legacy 靜態推導的產生物須可重製

由 legacy 程式碼靜態推導而來的文件產物（分派組合對照表、合成端點）SHALL 由產生器產出並進版控，SHALL NOT 手工編輯。

產生器 SHALL 以 PHP tokenizer 依巢狀深度解析分派結構，SHALL NOT 僅以正則比對——分派程式碼常混用 `if/elseif` 條件與巢狀 `switch` 兩種寫法，正則無法區分外層與內層的 `case`。

泛用 dispatcher 的清單 SHALL 由程式特徵（如「腳本是否含對分派欄位的 `switch`」）判定，SHALL NOT 以人工列舉——人工列舉一旦漏列，該腳本的全部組合會整批未產出。

欄位推導 SHALL 遞迴進被 require 的腳本，因為部分 case 只是薄 wrapper（例如僅 require 另一支腳本）。

以既有請求集合（如 Postman collection）補充欄位時，SHALL 依「欄位名是否出現在該腳本內」分流標示：出現者視為靜態掃描盲點、屬有效欄位；未出現者 SHALL 標為可能過時，SHALL NOT 與實作已驗證的欄位混列。

產生物 SHALL 標明其推導限制（無法解析的寫法、未涵蓋的來源）。

legacy 的分派程式碼異動後，產生器 SHALL 重跑並提交產出。

#### Scenario: 產生物與實作一致的驗證
- **WHEN** 驗證對照表是否涵蓋所有組合
- **THEN** 以 tokenizer 追蹤分派檔內每一個 `require` 陳述式並逐一比對，不使用與產生器相同的比對方式，避免共用盲點

#### Scenario: 新增的泛用 dispatcher
- **WHEN** legacy 新增一支符合分派特徵的腳本
- **THEN** 產生器自動將其納入，無須修改人工維護的清單

#### Scenario: 薄 wrapper 的欄位
- **WHEN** 某組合對到的腳本本身不讀輸入，僅 require 另一支腳本
- **THEN** 欄位取自被 require 的腳本

#### Scenario: 外部請求集合的欄位與實作不符
- **WHEN** 請求集合送出的欄位名在該腳本內完全找不到
- **THEN** 該欄位標示為可能過時，並於說明中指出實作實際讀取的欄位名

#### Scenario: 推導限制的揭露
- **WHEN** 部分腳本以變數化的 key 讀取輸入而無法靜態解析
- **THEN** 產生物於檔頭標明此限制與受影響的腳本數量

---

### Requirement: 專案專屬決策不寫進本規範

tag 清單、securityScheme、路由前綴、回應外殼欄位、模組縮寫對照等專案專屬決策 SHALL 寫在該專案自己的 spec（如 `api-documentation`），SHALL NOT 寫進本規範。

本規範異動時 SHALL 同步至各 AI 工具共用的 pattern 目錄。

#### Scenario: 專案採用本模式
- **WHEN** 某專案要導入本模式
- **THEN** 依 [setup.md](./setup.md) 建置，另立一份自己的 spec 記錄該專案的 tag、securityScheme 與涵蓋範圍
