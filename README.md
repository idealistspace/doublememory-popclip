# DoubleMemory for PopClip

A [PopClip](https://www.popclip.app) extension that saves the selected text or link to
[DoubleMemory](https://www.doublememory.com) with one click.

Select text anywhere, click **Save to DoubleMemory** in the PopClip bar, and it lands in your
DoubleMemory inbox. Capture happens in the background, so focus stays where you are reading.

## Install

To install it by hand instead of from the directory:

1. Download this repo (**Code → Download ZIP**) and unzip it.
2. Double-click `DoubleMemory.popclipext`.
3. Confirm in PopClip.

PopClip warns that the extension is unsigned and contains a shell script. That is expected for a
hand-installed package — extensions published through the directory are signed and skip the
warning.

## Options

- **Hashtag** — an optional tag added to every item this extension saves, for example `inbox`.
  Set it in PopClip → Extensions → DoubleMemory.

## How it works

The action percent-encodes the selection and hands it to the running app over DoubleMemory's own
URL scheme, opened with `open -g` so the app never takes focus:

```
doublememory://add?text=<required>&tag=<optional, repeatable>&notes=<optional>
```

That scheme is not PopClip-specific — it works from Raycast and Alfred script commands, browser
bookmarklets, and the Shortcuts "Open URL" action:

```bash
open -g "doublememory://add?text=Hello%20world&tag=inbox"
```

PopClip appears only for **text** selections, so this extension captures text and links. Images
reach DoubleMemory through the share sheet, drag and drop, or the clipboard.

## Requirements

- macOS with [PopClip](https://www.popclip.app) installed
- [DoubleMemory](https://www.doublememory.com) 3.0 or later, with support for the
  `doublememory://` URL scheme

## Publishing

Published through the [PopClip Extensions Directory](https://www.popclip.app/extensions/). The
**PopClip Directory GitHub app** is installed on this repo and `popclip-directory.yaml` points it
at `DoubleMemory.popclipext`.

To release a new version, push a `v`-prefixed tag (for example `v1.0.1`). The directory runs a
Submission Check on the tagged commit and comments with the result.

`popclip version` in `Config.json` is `6221` (PopClip 2026.8.1), the build this was tested against.

Still open: whether PopClip's built-in `POPCLIP_URLENCODED_TEXT` can replace the `url_encode`
helper in `save.sh`. It would remove twenty lines, but only if it escapes `&` — an encoder that
lets query-reserved characters through would truncate any selection containing one. The
hand-rolled encoder escapes everything outside the RFC 3986 unreserved set.

## License

MIT — see [LICENSE](LICENSE).
