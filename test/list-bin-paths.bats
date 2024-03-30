#!/usr/bin/env bats

: "${BATS_TEST_DIRNAME:?BATS_TEST_DIRNAME not specified}"

function setup() {
	bats_require_minimum_version 1.10.0

	load './test_helper/bats-support/load'
	load './test_helper/bats-assert/load'
}

function list_bin_paths() {
	ASDF_INSTALL_VERSION="${1:?install version parameter missing}" \
		ASDF_INSTALL_PATH="${2:?install path parameter missing}" \
		"${BATS_TEST_DIRNAME}/../bin/list-bin-paths"
}

@test "pass when Android SDK cmdline tools is properly installed" {
	local android_home="${BATS_TEST_DIRNAME}/resources/installed_cmdline_tools_minimal"

	run list_bin_paths "13.0" "${android_home}"
	assert_success

	assert_output "cmdline-tools/13.0/bin"
}

@test "pass when Android SDK platform-tools is recognized" {
	local android_home="${BATS_TEST_DIRNAME}/resources/installed_cmdline_tools_complex"

	run list_bin_paths "13.0" "${android_home}"
	assert_success

	assert_output "cmdline-tools/13.0/bin platform-tools"
}

@test "fail when Android SDK cmdline-tools is not installed" {
	run list_bin_paths "13.0" "${BATS_TEST_DIRNAME}/resources/installed_cmdline_tools_empty"
	assert_failure 2
}
