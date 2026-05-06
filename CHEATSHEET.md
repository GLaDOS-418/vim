# Cheat Sheet

| Command | Plugin | Notes | Anatomy |
| --- | --- | --- | --- |
| `g<C-g>` | Built-in | Show selection stats. Works in Visual mode. | - `g`: extended normal command prefix.<br>- `<C-g>`: show file or selection info.<br>- Visual mode: reports selected lines, words, chars, bytes. |
| `:%y` | Built-in | Yank whole buffer. Cursor stays put. No Visual selection needed. | - `:`: enter command-line mode.<br>- `%`: whole-file range.<br>- `y`: yank the range. |
