#!/bin/bash

uuid=$(uuidgen)
basename=$(basename $1)
extension="${basename##*.}"

mkdir -p ${uuid}/${uuid}.cache
mkdir -p ${uuid}/${uuid}.highlights
mkdir -p ${uuid}/${uuid}.thumbnails

cat <<EOF >>${uuid}.metadata
{
    "deleted": false,
    "lastModified": "$(date +%s)000",
    "metadatamodified": false,
    "modified": false,
    "parent": "",
    "pinned": false,
    "synced": false,
    "type": "DocumentType",
    "version": 1,
    "visibleName": "${basename}"
}
EOF

if [ "$extension" = "pdf" ]; then
	cp "$1" "${uuid}.pdf"
	cat <<EOF >${uuid}.content
{
    "extraMetadata": {
    },
    "fileType": "pdf",
    "fontName": "",
    "lastOpenedPage": 0,
    "lineHeight": -1,
    "margins": 100,
    "pageCount": 1,
    "textScale": 1,
    "transform": {
        "m11": 1,
        "m12": 1,
        "m13": 1,
        "m21": 1,
        "m22": 1,
        "m23": 1,
        "m31": 1,
        "m32": 1,
        "m33": 1
    }
}
EOF

else

	cp "$1" "${uuid}.epub"

	cat <<EOF >${uuid}.content
{
    "fileType": "epub"
}
EOF
fi

echo "[*] scp'ing document"
scp ${uuid}* remarkable:/home/root/.local/share/remarkable/xochitl/
echo "[*] restarting remarkable application"
ssh remarkable "systemctl restart xochitl"
