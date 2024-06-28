import React from 'react'
import Markdown from 'react-markdown'

export default function minutePreview({ markdown }) {

    return (
        <>
            <div>
                <MarkdownPreview
                    markdown={markdown}
                />
            </div>
            <div>
                <RawMarkdown
                    markdown={markdown}
                />
            </div>
        </>
    )
}

function MarkdownPreview({ markdown }) {
    return (
        <>
            <div>プレビュー</div>
            <div id="markdown_preview">
                <Markdown>{markdown}</Markdown>
            </div>
        </>
    )
}

function RawMarkdown({ markdown }) {
    return (
        <>
            <div>議事録の内容</div>
            <pre id="raw_markdown">{markdown}</pre>
        </>
    )
}