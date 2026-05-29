#!/bin/bash
#
# slk-ci.sh
#
# Helper functions for Slackware CI workflows running on the forge runner.
# Source this file at the start of a workflow build step:
#
#   source slk-ci.sh
#
# Functions provided:
#   slk_install_deps  PACKAGE [PACKAGE ...]  - install build dependencies
#   slk_build         SLACKBUILDDIR          - run the SlackBuild
#   slk_install       PKGFILE                - install a built package
#   slk_check_version PKGNAME VERSION        - fail if installed version mismatches
#   slk_info                                 - print Slackware version and arch info
#
# Requirements:
#   - Runs as root (containers from registry.slackware.nl default to root)
#   - slackpkg is pre-configured in the base image; the package cache is
#     already built and the GPG key is already imported

# Set a predictable locale so perl (used by slackpkg) does not emit locale
# warnings when the host environment differs from what is installed in the
# minimal container image.
export LC_ALL=C

set -euo pipefail

# ---- Environment ------------------------------------------------------------

# Detect the Slackware version string used throughout the forge tooling.
# /etc/slackware-version reports "Slackware 15.0+" on -current, which is not
# the string we use ("current"). The reliable detection strategy:
#   1. If VERSION_CODENAME=current in /etc/os-release  -> "current"
#   2. Otherwise use VERSION_ID from /etc/os-release   -> e.g. "15.0"
#   3. Fallback: parse /etc/slackware-version, strip any trailing +
_slk_detect_version() {
    if [[ -f /etc/os-release ]]; then
        local _codename _version_id
        _codename=$(  . /etc/os-release 2>/dev/null; echo "${VERSION_CODENAME:-}" )
        _version_id=$( . /etc/os-release 2>/dev/null; echo "${VERSION_ID:-}" )
        if [[ "${_codename}" == "current" ]]; then
            echo "current"; return
        fi
        if [[ -n "${_version_id}" ]]; then
            echo "${_version_id}"; return
        fi
    fi
    # Fallback: strip trailing + from /etc/slackware-version
    awk 'NR==1{ v=$2; sub(/\+$/,"",v); print v }'         /etc/slackware-version 2>/dev/null || echo 'unknown'
}
SLK_VERSION="$(_slk_detect_version)"
SLK_ARCH="$(uname -m)"
SLK_PKGDIR="${PKGDIR:-/tmp/ci-packages}"
SLK_LOG="${CI_LOG:-/tmp/ci-build.log}"

mkdir -p "${SLK_PKGDIR}"

# ---- Logging helpers --------------------------------------------------------

slk_info() {
    echo "==> [slk-ci] Slackware ${SLK_VERSION} (${SLK_ARCH})"
    echo "==> [slk-ci] Kernel: $(uname -r)"
    echo "==> [slk-ci] Date  : $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
}

_log() { echo "[slk-ci] $*"; }
_err() { echo "[slk-ci] ERROR: $*" >&2; exit 1; }

# ---- Package management -----------------------------------------------------

# slk_install_deps PACKAGE [PACKAGE ...]
#
# Installs build dependencies from the configured Slackware mirror using
# slackpkg.  The base image has slackpkg pre-configured with a working
# mirror, a valid GPG key, and an up-to-date package cache.
#
# Packages that are already installed are silently skipped by slackpkg.
# Packages not available in the configured mirror produce a slackpkg
# warning but do not abort the workflow; check the step output if a
# subsequent build step fails due to a missing library or tool.
#
# Example:
#   slk_install_deps cmake ninja python3 libfoo
slk_install_deps() {
    local DEPS=("$@")
    if [[ ${#DEPS[@]} -eq 0 ]]; then
        _log "No dependencies specified."
        return 0
    fi

    _log "Installing build dependencies: ${DEPS[*]}"
    slackpkg -batch=on -default_answer=y install "${DEPS[@]}" || true
    _log "Dependency installation complete."
}

# slk_build SLACKBUILDDIR
#
# Runs the .SlackBuild script found in SLACKBUILDDIR.  Build output is
# streamed to stdout and also saved to SLK_LOG.  Sets OUTPUT=${SLK_PKGDIR}
# so the resulting .txz lands in a predictable location.
slk_build() {
    local BUILDDIR="${1:?Usage: slk_build <slackbuilddir>}"
    local SBSCRIPT
    SBSCRIPT="$(find "${BUILDDIR}" -maxdepth 1 -name '*.SlackBuild' | head -1)"

    [[ -n "${SBSCRIPT}" ]] || _err "No .SlackBuild script found in ${BUILDDIR}"
    [[ -f "${SBSCRIPT}" ]] || _err "${SBSCRIPT} is not a regular file"

    _log "Building: ${SBSCRIPT}"
    _log "Output directory: ${SLK_PKGDIR}"

    chmod +x "${SBSCRIPT}"
    OUTPUT="${SLK_PKGDIR}" bash "${SBSCRIPT}" 2>&1 | tee "${SLK_LOG}"

    local EXIT="${PIPESTATUS[0]}"
    if [[ "${EXIT}" -ne 0 ]]; then
        _err "SlackBuild exited with status ${EXIT}. See ${SLK_LOG} for details."
    fi

    _log "Build succeeded."
}

# slk_install PKGFILE
#
# Installs a built package.  Accepts either a full path to a .txz file or
# a package base name; if a base name is given, the most recently built
# matching package in SLK_PKGDIR is used.
slk_install() {
    local PKG="${1:?Usage: slk_install <package>}"

    if [[ ! -f "${PKG}" ]]; then
        PKG="$(find "${SLK_PKGDIR}" -name "${PKG}*.t?z" | sort -V | tail -1)"
        [[ -n "${PKG}" ]] || _err "Package not found: $1"
    fi

    _log "Installing ${PKG}..."
    installpkg --terse "${PKG}"
}

# slk_check_version PKGNAME EXPECTED_VERSION
#
# Verifies that PKGNAME is installed at EXPECTED_VERSION.  The version is
# read from /var/log/packages/ using the standard Slackware filename
# convention (PKGNAME-VERSION-ARCH-BUILD).  Fails the workflow step if
# the installed version does not match.
slk_check_version() {
    local NAME="${1:?Usage: slk_check_version <pkgname> <version>}"
    local EXPECTED="${2:?Usage: slk_check_version <pkgname> <version>}"

    local INSTALLED
    INSTALLED="$(ls /var/log/packages/${NAME}-* 2>/dev/null \
                  | sed "s|.*/${NAME}-||;s|-[^-]*-[^-]*\$||" \
                  | tail -1)"

    if [[ "${INSTALLED}" == "${EXPECTED}" ]]; then
        _log "Version check passed: ${NAME} ${INSTALLED}"
    else
        _err "Version mismatch: expected ${NAME} ${EXPECTED}, found '${INSTALLED}'"
    fi
}

# Print environment info automatically on source
slk_info
