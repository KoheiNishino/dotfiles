#!/usr/bin/env swift

// @raycast.schemaVersion 1
// @raycast.title Copy Chrome Link
// @raycast.mode silent
// @raycast.packageName Browser
// @raycast.description Copy the current Chrome page as a rich link
// @raycast.icon 🔗

import AppKit
import Foundation

// MARK: - Chrome

func getChromeTab() -> (title: String, url: String)? {
    let script = """
    tell application "Google Chrome"
        set pageTitle to title of active tab of front window
        set pageURL to URL of active tab of front window
        return pageTitle & "\\n" & pageURL
    end tell
    """

    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
    process.arguments = ["-e", script]

    let outputPipe = Pipe()
    process.standardOutput = outputPipe

    do {
        try process.run()
        process.waitUntilExit()
    } catch {
        return nil
    }

    guard let output = String(
        data: outputPipe.fileHandleForReading.readDataToEndOfFile(),
        encoding: .utf8
    ) else {
        return nil
    }

    let lines = output.components(separatedBy: .newlines)

    guard lines.count >= 2 else {
        return nil
    }

    let title = lines[0]
    let url = lines[1]

    guard !title.isEmpty, !url.isEmpty else {
        return nil
    }

    return (title, url)
}

// MARK: - HTML

func escapeHTML(_ value: String) -> String {
    value
        .replacingOccurrences(of: "&", with: "&amp;")
        .replacingOccurrences(of: "<", with: "&lt;")
        .replacingOccurrences(of: ">", with: "&gt;")
        .replacingOccurrences(of: "\"", with: "&quot;")
        .replacingOccurrences(of: "'", with: "&#39;")
}

// MARK: - Main

guard let tab = getChromeTab() else {
    exit(1)
}

let title = tab.title
let url = tab.url

let html = """
<a href="\(escapeHTML(url))">\(escapeHTML(title))</a>
"""

// RTF with an actual link attribute.
let attributedString = NSMutableAttributedString(string: title)

attributedString.addAttribute(
    .link,
    value: URL(string: url)!,
    range: NSRange(location: 0, length: title.utf16.count)
)

guard let rtf = try? attributedString.data(
    from: NSRange(location: 0, length: attributedString.length),
    documentAttributes: [
        .documentType: NSAttributedString.DocumentType.rtf
    ]
) else {
    exit(1)
}

// MARK: - Pasteboard

let pasteboard = NSPasteboard.general
let item = NSPasteboardItem()

pasteboard.clearContents()

item.setString(title, forType: .string)
item.setString(html, forType: .html)
item.setData(rtf, forType: .rtf)

pasteboard.writeObjects([item])
