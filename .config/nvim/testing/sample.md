# Sample Markdown File for Testing

This is a **sample markdown file** to test markdown linting and formatting.

## Headers

### Header 3
#### Header 4
##### Header 5
###### Header 6

## Text Formatting

This is *italic text* and this is **bold text**. This is ***bold and italic***.

This is ~~strikethrough text~~.

## Lists

### Unordered List
- Item 1
- Item 2
  - Nested item 2.1
  - Nested item 2.2
- Item 3

### Ordered List
1. First item
2. Second item
   1. Nested item 2.1
   2. Nested item 2.2
3. Third item

## Links

[Link text](https://www.example.com)

[Reference link][ref]

[ref]: https://www.example.com/reference

## Images

![Alt text](https://via.placeholder.com/150)

## Code

Inline `code` in text.

```javascript
// Code block with syntax highlighting
function greet(name) {
    console.log(`Hello, ${name}!`);
    return `Welcome, ${name}`;
}

const result = greet("World");
```

```python
# Python code block
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

print(fibonacci(10))
```

## Blockquotes

> This is a blockquote.
> It can span multiple lines.

## Tables

| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |

## Task Lists

- [x] Completed task
- [ ] Incomplete task
- [ ] Another incomplete task

## Horizontal Rule

---

## Footnotes

Here's a sentence with a footnote[^1].

[^1]: This is the footnote content.

## HTML in Markdown

<div align="center">
  <strong>Centered text using HTML</strong>
</div>

## Issues to Test

1.  Multiple spaces after sentence.   
2.  Trailing whitespace in line.   
3.  Mixed list markers
4. Inconsistent header levels

### Missing closing header

This should be flagged as an issue.

## Empty sections

### 

## Bad link syntax

[Broken link](

![Missing alt text]()

## Code block without language

```
function test() {
    return "no syntax highlighting";
}
```
