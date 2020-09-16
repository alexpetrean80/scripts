#!/usr/bin/env bash

programming_root="$HOME"/Programming
dirs=("js" "go" "go" "rust" "c" "c#" "java" "lisp" "python")
if [ ! -d "$programming_root" ]; then
    mkdir "$programming_root"
fi

for dir in "${dirs[@]}"; do
    mkdir "$programming_root/$dir"
done
