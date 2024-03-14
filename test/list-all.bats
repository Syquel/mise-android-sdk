#!/usr/bin/env bats

: "${BATS_TEST_DIRNAME:?BATS_TEST_DIRNAME not specified}"

function setup() {
	bats_require_minimum_version 1.10.0

	load './test_helper/bats-support/load'
	load './test_helper/bats-assert/load'
}

function list_all() {
	ANDROID_SDK_MIRROR_URL="${1:?Android SDK mirror url parameter missing}" \
		"${BATS_TEST_DIRNAME}/../bin/list-all"
}

@test "pass when valid Android SDK repository metadata are available" {
	run list_all "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_complex"
	assert_success

	assert_output --stdin <<- EOT
		1.0
		2.0
		2.1
		3.0
		4.0
		5.0
		6.0
		9.0
		10.0
		11.0
		12.0
		13.0-rc01
		13.0
		14.0-alpha01
	EOT
}

@test "fail when Android SDK repository metadata are not available" {
	run list_all "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_empty"
	assert_failure 2
}

@test "fail when Android SDK repository metadata are invalid" {
	run list_all "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_invalid"
	assert_failure 3
}
