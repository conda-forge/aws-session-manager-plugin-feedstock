#!/bin/bash
set -eu

# Makefile runs some go commands on native host, then handles cross compilation using build targets
# Unset the cross-compilation variables set by Conda
# https://github.com/conda-forge/go-feedstock/issues/132
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
    unset GOOS
    unset GOARCH
fi

if [[ "${target_platform}" == osx-64 ]]; then
  MACHINE=darwin
  MACHINE_ARCH=amd64
elif [[ "${target_platform}" == osx-arm64 ]]; then
  MACHINE=darwin
  MACHINE_ARCH=arm64
elif [[ "${target_platform}" == linux-64 ]]; then
  MACHINE=linux
  MACHINE_ARCH=amd64
elif [[ "${target_platform}" == linux-aarch64 ]]; then
  MACHINE=linux
  MACHINE_ARCH=arm64
  # Makefile has inconsistently named build-* targets
  MAKE_TARGET=build-${MACHINE_ARCH}
else
  echo "Unsupported platform: ${target_platform}"
  exit 1
fi

if [[ -z "${MAKE_TARGET:-}" ]]; then
  MAKE_TARGET=build-${MACHINE}-${MACHINE_ARCH}
fi
make "${MAKE_TARGET}"

mkdir -p $PREFIX/bin
cp \
  "${SRC_DIR}/bin/${MACHINE}_${MACHINE_ARCH}_plugin/session-manager-plugin" \
  "${SRC_DIR}/bin/${MACHINE}_${MACHINE_ARCH}/ssmcli" \
  "$PREFIX/bin"


# Some vendor directories don't have a licence file
export GOPATH="$( pwd )/vendor"
export GO111MODULE=auto
go-licenses save ./src/sessionmanagerplugin-main/ ./src/ssmcli-main/ --save_path=./license-files || true

test -d license-files/github.com
