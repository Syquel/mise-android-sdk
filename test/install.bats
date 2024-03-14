#!/usr/bin/env bats

: "${BATS_TEST_DIRNAME:?BATS_TEST_DIRNAME not specified}"

function setup() {
	bats_require_minimum_version 1.10.0

	load './test_helper/bats-support/load'
	load './test_helper/bats-assert/load'
	load './test_helper/bats-file/load'

	TEST_INSTALL_BASE_PATH="$(temp_make)"
	TEST_INSTALL_PATH="${TEST_INSTALL_BASE_PATH}/android-sdk"
	mkdir "${TEST_INSTALL_PATH}"
}

function teardown() {
	temp_del "${TEST_INSTALL_BASE_PATH}"
}

function install() {
	ASDF_INSTALL_TYPE="${1:?install type parameter missing}" \
		ASDF_INSTALL_VERSION="${2:?install version parameter missing}" \
		ASDF_DOWNLOAD_PATH="${3:?download path parameter missing}" \
		ASDF_INSTALL_PATH="${4:?install path parameter missing}" \
		"${BATS_TEST_DIRNAME}/../bin/install"
}

@test "pass when Android SDK package can be installed" {
	run install "version" "13.0" "${BATS_TEST_DIRNAME}/resources/unpacked_cmdline_tools_valid" "${TEST_INSTALL_PATH}"
	assert_success

	assert_dir_exists "${TEST_INSTALL_PATH}/cmdline-tools"
	assert_dir_exists "${TEST_INSTALL_PATH}/cmdline-tools/13.0"
	assert_dir_exists "${TEST_INSTALL_PATH}/cmdline-tools/13.0/bin"
	assert_file_executable "${TEST_INSTALL_PATH}/cmdline-tools/13.0/bin/sdkmanager"
}

@test "fail when install type is not version" {
	run install "ref" "13.0" "${BATS_TEST_DIRNAME}/resources/unpacked_cmdline_tools_valid" "${TEST_INSTALL_PATH}"
	assert_failure 2
}

@test "fail when download directory is empty" {
	run install "version" "13.0" "${BATS_TEST_DIRNAME}/resources/unpacked_cmdline_tools_empty" "${TEST_INSTALL_PATH}"
	assert_failure 3
}

@test "fail when download directory does not contain sdkmanager" {
	run install "version" "13.0" "${BATS_TEST_DIRNAME}/resources/unpacked_cmdline_tools_missing_executable" "${TEST_INSTALL_PATH}"
	assert_failure 4

	assert_dir_not_exists "${TEST_INSTALL_PATH}/cmdline-tools"
}

@test "fail when Android SDK package executable fails to execute" {
	run install "version" "13.0" "${BATS_TEST_DIRNAME}/resources/unpacked_cmdline_tools_failing" "${TEST_INSTALL_PATH}"
	assert_failure 5

	assert_dir_not_exists "${TEST_INSTALL_PATH}/cmdline-tools"
}

@test "fail when Android SDK package has invalid version" {
	run install "version" "12.0" "${BATS_TEST_DIRNAME}/resources/unpacked_cmdline_tools_valid" "${TEST_INSTALL_PATH}"
	assert_failure 6

	assert_dir_not_exists "${TEST_INSTALL_PATH}/cmdline-tools"
}
