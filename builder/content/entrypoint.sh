#!/bin/bash

set -eu

export PATH="${PATH}:${HOME}/.pub-cache/bin"

exec "$@"