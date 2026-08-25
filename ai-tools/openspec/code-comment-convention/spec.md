# code-comment-convention Specification

## Purpose

本專案的程式註解以「不寫」為預設。意圖由命名與結構表達，註解只補程式碼表達不了的資訊。

## Requirements

### Requirement: 註解的判準

程式碼 SHALL NOT 加上註解，除非符合以下四種情形之一：

1. 方法本身無法把意圖定義清楚
2. 相依其它 class、method 或其它檔案，且該相依從本檔看不出來
3. 拋出錯誤會讓流程無法繼續往下執行
4. 不寫會造成解讀誤判、程式中斷，或人的角度讀取誤解

判準 SHALL 為：**拿掉這行，讀者會不會做出錯誤的判斷？** 不會，就刪掉。

需要註解才看得懂在做什麼的程式，SHALL 優先改善命名或抽出具名方法，而非補上註解。

#### Scenario: 註解只是複述程式碼

```php
// 取得表單設定          ← 刪除：方法名稱已經說了
private function resolveTemplateSetting(): int
{
    return (int) $this->template->cc_reply;
}
```

- **WHEN** 註解的內容從方法或變數名稱就讀得出來
- **THEN** 刪除該註解

#### Scenario: 標明失敗的後果

```php
return match (self::tryFrom($templateCcReply)) {
    self::ALL => true,
    self::REQUIRE => $userCcReply,
    // 在此拋例外會讓整封回函信寄不出去，比少一個附件嚴重
    default => false,
};
```

- **WHEN** 保守分支的理由無法從程式碼看出，後人可能把它「修正」成拋例外
- **THEN** 以一行說明不這樣做的後果

#### Scenario: 標明本檔看不出來的相依

```php
// 填單頁的 radio 送出的是字串 "0" / "1"
protected function prepareForValidation(): void
{
    $this->merge(['cc_reply' => $this->boolean('cc_reply')]);
}
```

- **WHEN** 一段程式的存在理由來自另一個檔案（此處為 `resources/views/of/open_form.blade.php`）
- **THEN** 以一行標明該相依

---

### Requirement: 註解的形式

必要的註解 SHALL 簡短清晰，不得有多餘綴詞。

- SHALL 使用單行 `//`，不寫成多行 docblock 敘述
- SHALL 只保留「不寫會出事」的那一句
- SHALL NOT 重述設計決策的完整脈絡——脈絡屬於 `openspec/` 的 design.md

#### Scenario: 過長的註解壓成一行

```php
/**
 * 合併「表單設定」與「填單者選擇」，決定這封回函信要不要附上回覆內容副本。
 *
 * 表單設定為權威：只有 REQUIRE 才採用填單者送出的值。
 * 對應不到任何設定的值視同不附副本——判斷在 queue job 內執行，
 * 於此拋例外會讓整封回函信寄不出去，比少一個附件嚴重。
 */
```

- **WHEN** 註解寫成多行、含設計脈絡
- **THEN** 壓成 `// 在此拋例外會讓整封回函信寄不出去，比少一個附件嚴重` 一行，其餘留在 design.md

---

### Requirement: 測試碼適用同一標準

測試檔案 SHALL 適用相同判準。測試方法名稱（依 `tdd-pattern` spec 為 `test_should_<action>_when_<condition>`）已經表達的情境，SHALL NOT 再以註解複述。

測試中的註解 SHALL 只用於標明從測試名稱看不出來的前提，例如對 factory 預設值、外部設定或另一支程式行為的相依。

#### Scenario: 測試名稱已表達的不再註解

```php
// 產 PDF 要驅動 headless 瀏覽器、實測耗時數十秒；結果用不到就不該啟動   ← 刪除
public function test_should_not_generate_pdf_when_setting_is_require_and_user_declines(): void
```

- **WHEN** 註解說的就是測試方法名稱說的事
- **THEN** 刪除該註解

#### Scenario: 標明對 factory 的相依

```php
$template = Template::factory()->create(array_merge([
    'mail_collect' => 1,
    // factory 的 cc_reply 是隨機值，會決定是否產 PDF
    'cc_reply' => TemplateCcReplyEnum::REQUIRE->value,
], $attributes));
```

- **WHEN** 明示某欄位是為了避免測試不確定，移除後測試會時綠時紅
- **THEN** 以一行標明，避免後人當成多餘設定刪掉

---

### Requirement: 既有註解不主動改寫

本規範 SHALL 只適用於新寫或正在修改的程式碼。處理某項變更時，SHALL NOT 順手刪改與該變更無關的既有註解。

#### Scenario: 只整理自己這次寫的註解

- **WHEN** 修改的檔案內同時存在他人先前留下的註解
- **THEN** 只檢視本次新增的註解，既有註解維持原狀
