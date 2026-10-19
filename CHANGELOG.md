# Changelog

All notable changes to this image.

This image has no version number of its own. Its tags are the bcrypt-tool versions it holds - `latest`, the major line
such as `1`, and the exact version such as `1.1.11` - and it is rebuilt weekly with the newest release, the current
BusyBox image and the current Go toolchain. Which bcrypt-tool version a particular image holds is written into it:

```
docker image inspect --format '{{index .Config.Labels "image.bcrypt-tool.version"}}' epicsoft/bcrypt:1
```

Entries here are dated, because there is no number to give them.

---

## 2026-10-19

### Breaking

- The image moved from `gitlab.com/epicdocker/bcrypt` to `gitlab.com/epicsoft-networks/bcrypt`;
  `registry.gitlab.com/epicdocker/bcrypt` is gone. Docker Hub `epicsoft/bcrypt` stays as it is.
- Passwords longer than 72 bytes are refused (`bcrypt: password length exceeds 72 bytes`, exit 2) instead of being
  cut to 72 bytes without notice.

### Added

- **Version tags**: `1` and `1.1.11` next to `latest`, so a setup can stay on a major line or on one release. The
  version is in the label `image.bcrypt-tool.version` and in `org.label-schema.version`.
- `linux/arm64` next to `linux/amd64`.
- Every image goes through `test/smoke.sh` before it is pushed, on every platform: `hash` with a given and with the
  default cost, `match` with the right and a wrong password and their exit codes, `cost`, and the refused 73-byte
  password.
- A mirror on GitHub: `github.com/epicsoft-llc/bcrypt`.

### Changed

- **bcrypt-tool 1.1.11 instead of 1.1.1.** The image installed the module from its old path
  `gophers.dev/cmds/bcrypt-tool`, which ends at 1.1.1 from April 2021; upstream has released from
  `github.com/shoenig/bcrypt-tool` since 1.1.2 in October 2022. Every weekly build since then shipped 1.1.1 again,
  with `golang.org/x/crypto` from April 2021. The image now builds from the new path, with `golang.org/x/crypto` 0.54.0.
- Docker Hub gets an access token over stdin instead of a password on the command line; the description on Docker
  Hub is this README, uploaded by the pipeline.
- README rewritten: tags, usage, quoting of hashes, migration notes; quay.io is no longer listed.
