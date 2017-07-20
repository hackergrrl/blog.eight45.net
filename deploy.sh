#!/usr/bin/env bash

node index.js
rsync --progress --recursive build/* sww@eight45.net:/var/www/blog/
