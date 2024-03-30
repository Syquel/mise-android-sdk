#!/usr/bin/env bash

shellcheck --check-sourced bin/* scripts/* test/*.bats

shfmt --diff ./bin ./scripts ./test/*.bats
