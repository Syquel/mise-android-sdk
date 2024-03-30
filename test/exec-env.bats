#!/usr/bin/env bats

: "${BATS_TEST_DIRNAME:?BATS_TEST_DIRNAME not specified}"

function setup() {
	bats_require_minimum_version 1.10.0

	load './test_helper/bats-support/load'
	load './test_helper/bats-assert/load'
}

function exec_env() {
	ASDF_INSTALL_VERSION="${1?install version parameter missing}" \
		ASDF_INSTALL_PATH="${2?install path parameter missing}" \
		bash -c ". \"${BATS_TEST_DIRNAME}/../bin/exec-env\"; env"
}

@test "pass when environment variables are set" {
	run exec_env "13.0" "/tmp/android-home"
	assert_success

	assert_line "ANDROID_HOME=/tmp/android-home"
}

@test "fail when install version is not specified" {
	run exec_env "" "/tmp/android-home"
	assert_failure 2
}

@test "fail when install path is not specified" {
	run exec_env "13.0" ""
	assert_failure 3
}
