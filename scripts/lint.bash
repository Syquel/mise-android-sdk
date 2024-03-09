#!/usr/bin/env bash

shellcheck --check-sourced bin/* scripts/*

shfmt --language-dialect bash --diff ./**/*
