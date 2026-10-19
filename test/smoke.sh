#!/bin/sh
#### sh test/smoke.sh <image> [platform]

set -e

export MSYS_NO_PATHCONV=1

readonly IMAGE="$1"
readonly PLATFORM="${2:-}"

PLATFORM_ARG=""
if [ -n "${PLATFORM}" ]; then
  PLATFORM_ARG="--platform=${PLATFORM}"
fi

#### the image's entrypoint is bcrypt, the arguments are its action and parameters
run() {
  docker run --rm ${PLATFORM_ARG} "${IMAGE}" "$@" # ok: optional
}

fail() {
  echo "FAIL: $1"
  exit 1
}

HASH=$(run hash 'smoke-test' 4)
case "${HASH}" in
  '$2a$04$'*) echo "ok: hash with cost 4" ;;
  *) fail "hash with cost 4 gave '${HASH}'" ;;
esac

if [ "$(run match 'smoke-test' "${HASH}")" != "yes" ]; then
  fail "match of the right password"
fi
echo "ok: match says yes"

if run match 'wrong-password' "${HASH}" > /dev/null; then
  fail "match of a wrong password exits 0"
fi
echo "ok: match of a wrong password exits non-zero"

if [ "$(run cost "${HASH}")" != "4" ]; then
  fail "cost"
fi
echo "ok: cost"

if [ "$(run cost "$(run hash 'smoke-test')")" != "10" ]; then
  fail "the default cost is not 10"
fi
echo "ok: default cost 10"

#### bcrypt only reads 72 bytes; the tool refuses a longer password instead of cutting it silently
if run hash "$(printf '%073d' 0)" > /dev/null 2>&1; then
  fail "a 73-byte password was hashed"
fi
echo "ok: a 73-byte password is refused"

echo "smoke test passed${PLATFORM:+ on ${PLATFORM}}"
