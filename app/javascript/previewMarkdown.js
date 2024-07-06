import { marked } from "marked";

document.addEventListener('DOMContentLoaded', () => {
    const selector = document.querySelector('#markdown_preview');
    if (!selector) {
        return null;
    }

    const rawMarkdown = document.querySelector('#raw_markdown');
    selector.innerHTML = marked(rawMarkdown.innerHTML);
});
