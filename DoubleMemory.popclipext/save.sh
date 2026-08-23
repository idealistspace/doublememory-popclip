#!/bin/sh
# Sends the PopClip selection to the running DoubleMemory app over its doublememory:// scheme.
#
# `open -g` keeps DoubleMemory in the background so capturing never pulls focus away from
# whatever the user is reading.

set -e

# Percent-encodes stdin. Runs under LC_ALL=C so awk walks raw bytes, which keeps multi-byte
# UTF-8 (accents, CJK, emoji) intact; everything outside the RFC 3986 unreserved set is escaped.
# Newlines survive because awk drops them per record and we re-emit %0A between records.
url_encode() {
	LC_ALL=C awk '
		BEGIN {
			unreserved = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~"
			for (i = 1; i <= length(unreserved); i++) safe[substr(unreserved, i, 1)] = 1
			for (i = 1; i < 256; i++) byte[sprintf("%c", i)] = i
		}
		{
			if (NR > 1) printf "%%0A"
			for (i = 1; i <= length($0); i++) {
				c = substr($0, i, 1)
				if (safe[c]) printf "%s", c
				else printf "%%%02X", byte[c]
			}
		}
	'
}

encoded_text=$(printf '%s' "${POPCLIP_TEXT}" | url_encode)

if [ -z "${encoded_text}" ]; then
	echo "Nothing to save" >&2
	exit 1
fi

url="doublememory://add?text=${encoded_text}"

# PopClip uppercases the option identifier when it exports it; accept either spelling rather
# than silently dropping the tag if that ever differs.
tag="${POPCLIP_OPTION_TAG:-${POPCLIP_OPTION_tag:-}}"

if [ -n "${tag}" ]; then
	encoded_tag=$(printf '%s' "${tag}" | url_encode)
	url="${url}&tag=${encoded_tag}"
fi

open -g "${url}"
