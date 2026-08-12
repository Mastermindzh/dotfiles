#!/bin/bash
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# custom (laptop specific) bashrc thingies :)
ln -sf "$MY_PATH/.bashrc" ~/.custom
