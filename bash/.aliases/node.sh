#!/bin/bash

alias clean-node-modules='find . -not -path "*/.*" -name "node_modules" -type d -print0 | xargs -0 rm -rf'
alias organize-package-json='npx format-package -w && npx sort-package-json'
