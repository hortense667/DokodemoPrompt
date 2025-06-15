;Requires AutoHotkey v2
templates := Map()
templates["あいさつ"] := "　お世話になっております。`n　角川アスキー総研の遠藤です。`n"
templates["誤字・脱字"]         := "誤字・脱字・言い回しのヘンなところを書き直して"
templates["用語確認"]           := "「地名」「大学名」「人名」「団体名」などの固有名詞や、事実に関する記述に間違いがないか、重点的にチェック。 正しい名前に直した方がよい箇所があれば、具体的に指摘して"
templates["丁寧な文体に"]       := "丁寧な文体にしてお礼の気持ちを込めたものに書き直して"
templates["格調高い文体に"]     := "専門家らしい格調の高い、しかしやさしく分かりやすい文章に書き直して"
templates["見出し考えて"]     := "見出しを考えてください。キャッチーなものがよいです。元の文章をその下に続けてください。"
templates["インタビューまとめ"] := "この会話の文字起こしを、読みやすく整形してください。言い直し、脱線、不要語（えっと、あの…）を削除。話者の口調は保ちつつ、文として通るようにしてください。"
templates["英訳して"]           := "文章のテイストを維持したまま英文に翻訳して"

names := []
for name in templates
    names.Push(name)

; グローバル変数として定義
myGui := ""
combo := ""

; ホットキーの設定（Win + Ctrl + P）
#^p::ShowTemplateGui()

; GUIを作成・表示する関数
ShowTemplateGui() {
    global myGui, combo
    
    ; 既にGUIが表示されている場合は前面に持ってくる
    if myGui && WinExist("ahk_id " . myGui.Hwnd) {
        myGui.Show()
        combo.Focus()
        return
    }
    
    ; GUIを作成
    myGui := Gui("+AlwaysOnTop", "定型プロンプト入力")
    myGui.AddText("x10 y10", "キーワードを選択してください:")
    combo := myGui.AddComboBox("x10 y30 w250", names)
    
    ; ボタンの作成
    btnInput := myGui.AddButton("x10 y70 w80", "入力(&I)")
    
    ; イベントハンドラーの設定
    btnInput.OnEvent("Click", sendTemplate)
    myGui.OnEvent("Close", closeGui)
    myGui.OnEvent("Escape", closeGui)
    
    ; コンボボックスでのキーイベント処理
    combo.OnEvent("Change", (*) => "")  ; ダミーイベント
    
    ; GUIを表示してコンボボックスにフォーカス
    myGui.Show("w280 h120")
    combo.Focus()
    
    ; 最初の項目を選択状態にする
    if names.Length > 0 {
        combo.Value := 1
    }
    
    ; ホットキーでEnterとEscapeを処理
    Hotkey("~Enter", HandleEnter, "On")
    Hotkey("~Escape", HandleEscape, "On")
}

; Enterキーの処理
HandleEnter(*) {
    global myGui
    if myGui && WinActive("ahk_id " . myGui.Hwnd) {
        sendTemplate()
    }
}

; Escapeキーの処理
HandleEscape(*) {
    global myGui
    if myGui && WinActive("ahk_id " . myGui.Hwnd) {
        closeGui()
    }
}

; キーボードイベントのハンドラー（不要になったため削除）

; テンプレートを送信する関数
sendTemplate(*) {
    global myGui, combo
    idx := combo.Value
    if idx > 0 {
        name := names[idx]
        template_text := templates[name]
        
        ; GUIを最小化（隠さずに）
        myGui.Minimize()
        
        ; 少し待機してフォーカスが移るのを待つ
        Sleep(300)
        
        ; クリップボードを使用して確実に送信
        A_Clipboard := template_text
        SendInput("^v")  ; Ctrl+V でペースト
        
        ; GUIを復元して再度使用可能にする
        myGui.Restore()
        combo.Focus()
        
    } else {
        MsgBox("何も選択されていません。", "エラー", "OK")
        combo.Focus()
    }
}

; GUIを閉じる関数
closeGui(*) {
    global myGui
    if myGui {
        myGui.Hide()
        ; ホットキーを無効化
        try Hotkey("~Enter", "Off")
        try Hotkey("~Escape", "Off")
    }
}

; システムトレイメニューの設定
A_TrayMenu.Delete()  ; デフォルトメニューを削除
A_TrayMenu.Add("定型文入力を表示", (*) => ShowTemplateGui())
A_TrayMenu.Add()  ; セパレーター
A_TrayMenu.Add("終了", (*) => ExitApp())
A_TrayMenu.Default := "定型文入力を表示"

; プログラム開始時のメッセージ
TrayTip("定型文入力スクリプトが開始されました", "Win+Ctrl+P で呼び出せます", "Mute")