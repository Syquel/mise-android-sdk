#!/usr/bin/env bats

: "${BATS_TEST_DIRNAME:?BATS_TEST_DIRNAME not specified}"

function setup() {
	bats_require_minimum_version 1.10.0

	load './test_helper/bats-support/load'
	load './test_helper/bats-assert/load'
	load './test_helper/bats-file/load'

	TEST_DOWNLOAD_PATH="$(temp_make)"
}

function teardown() {
	temp_del "${TEST_DOWNLOAD_PATH}"
}

function download() {
	ANDROID_SDK_MIRROR_URL="${1:?Android SDK mirror url parameter missing}" \
		ASDF_INSTALL_VERSION="${2:?Android SDK tool version parameter missing}" \
		ASDF_DOWNLOAD_PATH="${TEST_DOWNLOAD_PATH}" \
		OSTYPE="linux-gnu" \
		HOSTTYPE="x86_64" \
		"${BATS_TEST_DIRNAME}/../bin/download"
}

@test "pass when Android SDK package can be downloaded" {
	run download "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_minimal" "13.0" "${TEST_DOWNLOAD_PATH}"
	assert_success

	assert_dir_exists "${TEST_DOWNLOAD_PATH}/cmdline-tools"
	assert_dir_exists "${TEST_DOWNLOAD_PATH}/cmdline-tools/bin"
	assert_file_exists "${TEST_DOWNLOAD_PATH}/cmdline-tools/bin/sdkmanager"
	assert_file_executable "${TEST_DOWNLOAD_PATH}/cmdline-tools/bin/sdkmanager"
}

@test "fail when Android SDK repository metadata are not available" {
	run download "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_empty" "13.0" "${TEST_DOWNLOAD_PATH}"
	assert_failure 4
}

@test "fail when Android SDK repository metadata are invalid" {
	run download "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_invalid" "13.0" "${TEST_DOWNLOAD_PATH}"
	assert_failure 5
}

@test "fail when Android SDK package archive is missing" {
	run download "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_minimal" "13.0-rc01" "${TEST_DOWNLOAD_PATH}"
	assert_failure 10
}

@test "fail when Android SDK package archive checksum is invalid" {
	run download "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_invalid_checksum" "13.0" "${TEST_DOWNLOAD_PATH}"
	assert_failure 11
}

@test "fail when Android SDK package archive is invalid ZIP file" {
	run download "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_broken_package" "13.0" "${TEST_DOWNLOAD_PATH}"
	assert_failure 12
}
