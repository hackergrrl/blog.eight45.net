#!/usr/bin/env bash

ecstatic &
onchange layout.html '*.md' 'articles/*.md' -- node index.js
