# DokodemoPrompt
　This is the software used to give long prompts for any AI chat, CURSOR, etc.
　 (c) 2025 Satoshi Endo
　https://x.com/hortense667

## 動かすための準備

　1. AutoHotKeyのインストール
　 公式サイト（https://www.autohotkey.com/）から最新版をダウンロードしてインストールしてください。

## 事前のコードの設定と書き換え

　１. テーブルの書き換え
　　templates["キーワード"]         := "プロンプト"
　　の部分を必要に応じて書き換えたり、追加したりしてください。

## 使い方の手順

　1. DokodemoPrompt.ahkをクリックして有効化
　　実行されるとトレイの中にAutoHotKeyのアイコン「H」マークが現れます。

　２. プロンプトの入力
　　　「Win-Ctrl-p」を押す。
　　　プロンプトを選ぶウィンドウ「定型プロンプト入力」が開くので、
　　　「キーワードを選択してください」から欲しいプロンプトを選ぶ。
　　　リターンキー、まいたは「入力」ボタンで入力。
　　　入力しない場合は「x」をクリック、またはエスケープ。
　　　プロンプトが入力される。

　3. 実行型式の作成
　　　AutoHotKey Dashから、ahkファイルをもとにコンパイルしてexeを生成
　　　exeを使えば、AutoHotKeyをインストールしていない環境でも使える。
　　　※コンパイル時にはVer.2以上を指定のこと。

