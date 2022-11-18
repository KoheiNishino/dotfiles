"言語設定
language en_US

"コマンドの際にはzshを使う
set shell=/bin/zsh

"行番号を表示
set number

"画面を縦分割する際に右に開く
set splitright

"Indentの幅
set shiftwidth=2

"タブに変換されるサイズ
set tabstop=2

"タブの入力の際にスペース
set expandtab

"ワードラッピングなし
set textwidth=0

"自動インデント :set pasteで解除可能
set autoindent

"Searchのハイライト
set hls

"クリップボードへの登録
set clipboard=unnamed

"SyntaxをEnable
syntax on

"ESC の代わりに jj で Insert mode -> Normal mode
inoremap <silent> jj <ESC>

"InsertモードからNormalモードへ戻った時に日本語能力を解除
autocmd InsertLeave * :silent !/usr/local/bin/im-select com.google.inputmethod.Japanese.Roman

"vim-plug
"call plug#begin([PLUGIN_DIR])

"call plug#end()
