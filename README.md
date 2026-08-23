# DoubleMemory for PopClip

A [PopClip](https://www.popclip.app) extension that saves the selected text or link to
[DoubleMemory](https://www.doublememory.com) with one click.

Select text anywhere, click **Save to DoubleMemory** in the PopClip bar, and it lands in your
DoubleMemory inbox. Capture happens in the background, so focus stays where you are reading.

## Install

Until this is published in the PopClip Extensions Directory, install it by hand:

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

Not yet submitted to the [PopClip Extensions Directory](https://www.popclip.app/extensions/).
`popclip-directory.yaml` is in place. What remains:

1. Install the **PopClip Directory GitHub app** on this repo.
2. Set `popclip version` in `DoubleMemory.popclipext/Config.json` to the PopClip build actually
   tested against — it currently claims `6159`, the shipping version at the time of writing
   rather than one that was verified.
3. Push a `v1.0.0` tag to trigger submission.

Two things to confirm on a real install first:

- That the **Hashtag** option arrives as `POPCLIP_OPTION_TAG`. PopClip documents options as
  `POPCLIP_OPTION_*` without stating whether the identifier is uppercased, so `save.sh` accepts
  either spelling.
- Whether PopClip's built-in `POPCLIP_URLENCODED_TEXT` can replace the `url_encode` helper in
  `save.sh`. It would remove twenty lines, but only if it escapes `&` — an encoder that lets
  query-reserved characters through would truncate any selection containing one. The hand-rolled
  encoder escapes everything outside the RFC 3986 unreserved set.

## License

MIT — see [LICENSE](LICENSE).
