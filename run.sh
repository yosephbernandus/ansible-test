#!/bin/bash
source .env

# Run whatever application you need
case "$1" in
  "py")
    python files/test.py
    ;;
  "go")
    go run files/test.go
    ;;
  "rust")
    cargo run
    ;;
  *)
    echo "Please specify: py, go, or rust"
    exit 1
    ;;
esac
