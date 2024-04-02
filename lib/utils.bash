#!/usr/bin/env bash
set -eufET -o pipefail
shopt -s inherit_errexit

TOOL_NAME="android-sdk"

function fail() {
	[[ $# -ge 2 ]] || fail 254 "function expects at least two arguments: ${FUNCNAME[0]} <exit_code> <error_message>"

	local -i exit_code
	exit_code=${1:?Exit code parameter is missing}
	shift

	echo -e "asdf-${TOOL_NAME}: $*" >&2
	exit "${exit_code}"
}

function error() {
	echo -e "asdf-${TOOL_NAME}: $*" >&2
}

curl_opts=(--silent --fail --show-error --location)

function get_android_sdk_base_url() {
	echo "${ANDROID_SDK_MIRROR_URL:-https://dl.google.com/android/repository}"
}

function get_android_sdk_metadata_url() {
	# shellcheck disable=SC2312
	echo "$(get_android_sdk_base_url)/repository2-3.xml"
}

function fetch_android_sdk_metadata() {
	local android_sdk_metadata_url
	android_sdk_metadata_url="$(get_android_sdk_metadata_url)"

	curl "${curl_opts[@]}" "${android_sdk_metadata_url}" || {
		error "Could not download Android SDK metadata from ${android_sdk_metadata_url}"
		return 1
	}
}

function parse_android_sdk_metadata() {
	local android_sdk_metadata_xml="${1:?Android SDK metadata parameter missing}"
	local android_sdk_package_name="${2:?Android SDK package name parameter missing}"

	local parse_command='
		# Extract available Android SDK packages
		.sdk-repository.remotePackage |

		# Infer appropriate data types automatically
		(.. | select(tag == "!!str")) |= from_yaml |

		# Filter out Android SDK packages with the "latest" pseudo version
		filter(.+@path != "*;latest") |

		# Filter for the requested Android SDK package
		filter(.+@path == strenv(ANDROID_SDK_PACKAGE_NAME) + ";*") |

		# Sort packages by version
		# Set an artificial high preview version on remote packages without preview version to enable proper sorting of versions,
		# because yq sorts "null" before actual values, which would sort alpha and rc versions after final versions.
		sort_by(.revision.major, .revision.minor, .revision.micro, .revision.preview // 99)
	'

	ANDROID_SDK_PACKAGE_NAME="${android_sdk_package_name}" \
		yq --exit-status --input-format xml --output-format yaml "${parse_command}" <<< "${android_sdk_metadata_xml}" ||
		{
			error "Failed to parse Android SDK tool metadata"
			return 2
		}
}
