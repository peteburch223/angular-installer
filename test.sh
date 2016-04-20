#!/bin/bash
dir_name=$1

# need to figure out how to get angular version
printf "%s\n" "{" \
              "  \"name\": \"$dir_name\"," \
              "  \"description\": \"<project description>\"," \
              "  \"main\": \"app/js/app.js\"," \
              "  \"authors\": \"[$USER]\"," \
              "  \"license\": \"ISC\"," \
              "  \"ignore\": [" \
              "    \"**/.*\"," \
              "    \"node_modules\"," \
              "    \"bower_components\"," \
              "    \"test\"," \
              "    \"tests\"" \
              "  ]," \
              "  \"dependencies\": {" \
              "    \"angular\": \"^1.5.5\"" \
              "  }," \
              "  \"devDependencies\": {" \
              "    \"angular-mocks\": \"^1.5.5\"" \
              "  }" \
              "}" \
              > bower.json
