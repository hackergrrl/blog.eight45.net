#!/bin/bash

jekyll build
scp -r _site/* sww@eight45.net:/var/www/blog/
