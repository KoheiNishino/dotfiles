#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title FM Translate
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🌐
# @raycast.argument1 { "type": "text", "placeholder": "翻訳するテキスト" }

text="$1"

if printf '%s' "$text" | grep -qE '[ぁ-んァ-ン一-龯]'; then
  instruction="以下の日本語を英語に翻訳してください。英語の翻訳結果だけを出力してください。"
else
  instruction="以下の英語を日本語に翻訳してください。日本語の翻訳結果だけを出力してください。"
fi

fm respond "$instruction

原文の意味を変えず、自然かつ簡潔に翻訳してください。
ソフトウェア開発の文脈では、一般的な技術用語を使用してください。
説明、補足、原文の引用は不要です。

$text" 2>/dev/null
