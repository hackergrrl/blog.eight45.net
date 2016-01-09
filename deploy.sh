#!/bin/bash

jekyll build
rsync --progress --recursive _site/* sww@eight45.net:/var/www/blog/
