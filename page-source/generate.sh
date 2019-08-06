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
echo "Copy resources/d to output directory"
cp -r src/docs/asciidoc/resources "${OUTPUT_DIR}"

# Generate HTML
echo -n "Generating HTML output: "
docker run --rm -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor -D "${OUTPUT_DIR}" src/docs/asciidoc/index.adoc
docker run --rm -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor -D "${OUTPUT_DIR}/resources/ITT/domain-experts" src/docs/asciidoc/resources/ITT/domain-experts/index.adoc
docker run --rm -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor -D "${OUTPUT_DIR}/resources/ITT/domain-experts/applicable-docs" src/docs/asciidoc/resources/ITT/domain-experts/applicable-docs/index.adoc
docker run --rm -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor -D "${OUTPUT_DIR}/resources/ITT/domain-experts/reference-docs" src/docs/asciidoc/resources/ITT/domain-experts/reference-docs/index.adoc
echo "[done]"

cd "${ORIG_DIR}"
