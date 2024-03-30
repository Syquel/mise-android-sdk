#!/usr/bin/env bats

: "${BATS_TEST_DIRNAME:?BATS_TEST_DIRNAME not specified}"

function setup() {
	bats_require_minimum_version 1.10.0

	load './test_helper/bats-support/load'
	load './test_helper/bats-assert/load'
}

function run_utils_function() {
	local utils_function_name="${1:?Utils function name parameter missing}"
	shift

	local android_sdk_mirror_url="${1?Android SDK mirror url parameter missing}"
	shift

	local -a parameters=()
	for parameter in "${@}"; do
		parameters+=("'${parameter}'")
	done

	ANDROID_SDK_MIRROR_URL="${android_sdk_mirror_url}" \
		bash -c ". \"${BATS_TEST_DIRNAME}/../lib/utils.bash\"; ${utils_function_name} ${parameters[*]}"
}

@test "pass when default Android SDK repository base url returns" {
	run run_utils_function get_android_sdk_base_url ""
	assert_success

	assert_output "https://dl.google.com/android/repository"
}

@test "pass when overridden Android SDK repository base url returns" {
	run run_utils_function get_android_sdk_base_url "http://localhost/android-sdk-repository"
	assert_success

	assert_output "http://localhost/android-sdk-repository"
}

@test "pass when default Android SDK repository metadata url returns" {
	run run_utils_function get_android_sdk_metadata_url ""
	assert_success

	assert_output "https://dl.google.com/android/repository/repository2-3.xml"
}

@test "pass when overridden Android SDK repository metadata url returns" {
	run run_utils_function get_android_sdk_metadata_url "http://localhost/android-sdk-repository"
	assert_success

	assert_output "http://localhost/android-sdk-repository/repository2-3.xml"
}

@test "pass when Android SDK metadata can be downloaded" {
	run run_utils_function fetch_android_sdk_metadata "file://${BATS_TEST_DIRNAME}/resources/android_sdk_repository_minimal"
	assert_success

	output="$(yq --input-format xml --output-format props <<< "${output}")"

	assert_output --stdin <<- EOT
		+p_xml = version='1.0' encoding='utf-8'
		sdk-repository.+@xmlns\:sdk = http://schemas.android.com/sdk/android/repo/repository2/03
		sdk-repository.+@xmlns\:common = http://schemas.android.com/repository/android/common/02
		sdk-repository.+@xmlns\:sdk-common = http://schemas.android.com/sdk/android/repo/common/03
		sdk-repository.+@xmlns\:generic = http://schemas.android.com/repository/android/generic/02
		sdk-repository.+@xmlns\:xsi = http://www.w3.org/2001/XMLSchema-instance
		sdk-repository.channel.0.+content = stable
		sdk-repository.channel.0.+@id = channel-0
		sdk-repository.channel.1.+content = beta
		sdk-repository.channel.1.+@id = channel-1
		sdk-repository.channel.2.+content = dev
		sdk-repository.channel.2.+@id = channel-2
		sdk-repository.channel.3.+content = canary
		sdk-repository.channel.3.+@id = channel-3
		sdk-repository.remotePackage.0.+@path = cmdline-tools;13.0
		sdk-repository.remotePackage.0.type-details.+@xsi\:type = generic:genericDetailsType
		sdk-repository.remotePackage.0.revision.major = 13
		sdk-repository.remotePackage.0.revision.minor = 0
		sdk-repository.remotePackage.0.display-name = Android SDK Command-line Tools
		sdk-repository.remotePackage.0.uses-license.+@ref = android-sdk-license
		sdk-repository.remotePackage.0.channelRef.+@ref = channel-0
		sdk-repository.remotePackage.0.archives.archive.0.complete.size = 157033049
		sdk-repository.remotePackage.0.archives.archive.0.complete.checksum.+content = dcc85e607e53315fa67de2884ff7f623c60f15ae
		sdk-repository.remotePackage.0.archives.archive.0.complete.checksum.+@type = sha1
		sdk-repository.remotePackage.0.archives.archive.0.complete.url = commandlinetools-linux-11479570_latest.zip
		sdk-repository.remotePackage.0.archives.archive.0.host-os = linux
		sdk-repository.remotePackage.0.archives.archive.1.complete.size = 136810605
		sdk-repository.remotePackage.0.archives.archive.1.complete.checksum.+content = 4fe82efec2b7c33f373988f86d353d733698a0a3
		sdk-repository.remotePackage.0.archives.archive.1.complete.checksum.+@type = sha1
		sdk-repository.remotePackage.0.archives.archive.1.complete.url = commandlinetools-mac-11479570_latest.zip
		sdk-repository.remotePackage.0.archives.archive.1.host-os = macosx
		sdk-repository.remotePackage.0.archives.archive.2.complete.size = 136324801
		sdk-repository.remotePackage.0.archives.archive.2.complete.checksum.+content = 938b82035c25633e822bd4e048033a6b7816d3a8
		sdk-repository.remotePackage.0.archives.archive.2.complete.checksum.+@type = sha1
		sdk-repository.remotePackage.0.archives.archive.2.complete.url = commandlinetools-win-11479570_latest.zip
		sdk-repository.remotePackage.0.archives.archive.2.host-os = windows
		sdk-repository.remotePackage.1.+@path = cmdline-tools;13.0-rc01
		sdk-repository.remotePackage.1.type-details.+@xsi\:type = generic:genericDetailsType
		sdk-repository.remotePackage.1.revision.major = 13
		sdk-repository.remotePackage.1.revision.minor = 0
		sdk-repository.remotePackage.1.revision.preview = 01
		sdk-repository.remotePackage.1.display-name = Android SDK Command-line Tools
		sdk-repository.remotePackage.1.uses-license.+@ref = android-sdk-preview-license
		sdk-repository.remotePackage.1.channelRef.+@ref = channel-1
		sdk-repository.remotePackage.1.archives.archive.0.complete.size = 157028144
		sdk-repository.remotePackage.1.archives.archive.0.complete.checksum.+content = 8d8f5c9ccc8746afed262b39c419be3d4e856124
		sdk-repository.remotePackage.1.archives.archive.0.complete.checksum.+@type = sha1
		sdk-repository.remotePackage.1.archives.archive.0.complete.url = commandlinetools-linux-11379558_latest.zip
		sdk-repository.remotePackage.1.archives.archive.0.host-os = linux
		sdk-repository.remotePackage.1.archives.archive.1.complete.size = 157028128
		sdk-repository.remotePackage.1.archives.archive.1.complete.checksum.+content = c7f71dd662115aa2d370508f190e2df6e83884cc
		sdk-repository.remotePackage.1.archives.archive.1.complete.checksum.+@type = sha1
		sdk-repository.remotePackage.1.archives.archive.1.complete.url = commandlinetools-mac-11379558_latest.zip
		sdk-repository.remotePackage.1.archives.archive.1.host-os = macosx
		sdk-repository.remotePackage.1.archives.archive.2.complete.size = 157003999
		sdk-repository.remotePackage.1.archives.archive.2.complete.checksum.+content = 87247876f2c9a7dcf8885e6feb1e5481adccd0e5
		sdk-repository.remotePackage.1.archives.archive.2.complete.checksum.+@type = sha1
		sdk-repository.remotePackage.1.archives.archive.2.complete.url = commandlinetools-win-11379558_latest.zip
		sdk-repository.remotePackage.1.archives.archive.2.host-os = windows
	EOT
}

@test "pass when Android SDK repository metadata can be parsed" {
	local metadata
	metadata="$(< "${BATS_TEST_DIRNAME}/resources/android_sdk_repository_minimal/repository2-3.xml")"

	run run_utils_function parse_android_sdk_metadata "" "${metadata}" "cmdline-tools"
	assert_success

	output="$(yq --input-format yaml --output-format props <<< "${output}")"

	assert_output --stdin <<- EOT
		0.+@path = cmdline-tools;13.0-rc01
		0.type-details.+@xsi\:type = generic:genericDetailsType
		0.revision.major = 13
		0.revision.minor = 0
		0.revision.preview = 01
		0.display-name = Android SDK Command-line Tools
		0.uses-license.+@ref = android-sdk-preview-license
		0.channelRef.+@ref = channel-1
		0.archives.archive.0.complete.size = 157028144
		0.archives.archive.0.complete.checksum.+content = 8d8f5c9ccc8746afed262b39c419be3d4e856124
		0.archives.archive.0.complete.checksum.+@type = sha1
		0.archives.archive.0.complete.url = commandlinetools-linux-11379558_latest.zip
		0.archives.archive.0.host-os = linux
		0.archives.archive.1.complete.size = 157028128
		0.archives.archive.1.complete.checksum.+content = c7f71dd662115aa2d370508f190e2df6e83884cc
		0.archives.archive.1.complete.checksum.+@type = sha1
		0.archives.archive.1.complete.url = commandlinetools-mac-11379558_latest.zip
		0.archives.archive.1.host-os = macosx
		0.archives.archive.2.complete.size = 157003999
		0.archives.archive.2.complete.checksum.+content = 87247876f2c9a7dcf8885e6feb1e5481adccd0e5
		0.archives.archive.2.complete.checksum.+@type = sha1
		0.archives.archive.2.complete.url = commandlinetools-win-11379558_latest.zip
		0.archives.archive.2.host-os = windows
		1.+@path = cmdline-tools;13.0
		1.type-details.+@xsi\:type = generic:genericDetailsType
		1.revision.major = 13
		1.revision.minor = 0
		1.display-name = Android SDK Command-line Tools
		1.uses-license.+@ref = android-sdk-license
		1.channelRef.+@ref = channel-0
		1.archives.archive.0.complete.size = 157033049
		1.archives.archive.0.complete.checksum.+content = dcc85e607e53315fa67de2884ff7f623c60f15ae
		1.archives.archive.0.complete.checksum.+@type = sha1
		1.archives.archive.0.complete.url = commandlinetools-linux-11479570_latest.zip
		1.archives.archive.0.host-os = linux
		1.archives.archive.1.complete.size = 136810605
		1.archives.archive.1.complete.checksum.+content = 4fe82efec2b7c33f373988f86d353d733698a0a3
		1.archives.archive.1.complete.checksum.+@type = sha1
		1.archives.archive.1.complete.url = commandlinetools-mac-11479570_latest.zip
		1.archives.archive.1.host-os = macosx
		1.archives.archive.2.complete.size = 136324801
		1.archives.archive.2.complete.checksum.+content = 938b82035c25633e822bd4e048033a6b7816d3a8
		1.archives.archive.2.complete.checksum.+@type = sha1
		1.archives.archive.2.complete.url = commandlinetools-win-11479570_latest.zip
		1.archives.archive.2.host-os = windows
	EOT
}

@test "fail when Android SDK repository metadata can be parsed" {
	run run_utils_function parse_android_sdk_metadata "" "Invalid: xml" "cmdline-tools"
	assert_failure 2
}
