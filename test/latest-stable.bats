#!/usr/bin/env bats

: "${BATS_TEST_DIRNAME:?BATS_TEST_DIRNAME not specified}"

function setup() {
	bats_require_minimum_version 1.10.0

	load './test_helper/bats-support/load'
	load './test_helper/bats-assert/load'
}

function latest_stable() {
	ANDROID_SDK_MIRROR_URL="${1:?Android SDK mirror url parameter missing}" \
		"${BATS_TEST_DIRNAME}/../bin/latest-stable"
}

@test "pass when valid Android SDK repository metadata are available" {
	run latest_stable "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_complex"
	assert_success

	assert_output "13.0"
}

@test "fail when Android SDK repository metadata are not available" {
	run latest_stable "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_empty"
	assert_failure 2
}

@test "fail when Android SDK repository metadata are invalid" {
	run latest_stable "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_invalid"
	assert_failure 3
}
