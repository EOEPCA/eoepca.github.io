#!/usr/bin/env bash

ORIG_DIR="$(pwd)"
cd "$(dirname "$0")"
BIN_DIR="$(pwd)"

BUILD_ROOT="build"
OUTPUT_DIR="${BUILD_ROOT}/asciidoc/html5"

echo "Remove existing output directory"
find "${BUILD_ROOT}" -type f -exec rm -f {} \;

# Create output dirs and copy resources
echo "Create output directory: ${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}"
echo "Copy images/ to output directory"
cp -r src/docs/asciidoc/images "${OUTPUT_DIR}"
echo "Copy stylesheets/ to output directory"
cp -r src/docs/asciidoc/stylesheets "${OUTPUT_DIR}"
echo "Copy resources/ to output directory"
cp -r src/docs/asciidoc/resources "${OUTPUT_DIR}"

# Generate HTML
echo -n "Generating HTML output: "
for indexfile in $(find src -name index.adoc)
do
  relpath="$(realpath --relative-to=./src/docs/asciidoc "${indexfile}")"
  reldir="$(dirname "${relpath}")"
  docker run --rm -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor -D "${OUTPUT_DIR}/${reldir}" "src/docs/asciidoc/${relpath}"
done
echo "[done]"

cd "${ORIG_DIR}"
