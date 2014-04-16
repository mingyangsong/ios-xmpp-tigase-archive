#!/bin/bash

read -p "Please Write Commit: " RESP
git add . .gitignore
git add -u .gitignore
git commit -a -m "$RESP"
git push
