# AGENTS.md

Guidance for AI coding agents and contributors working in this repository.

## What this repository is

There is no application source code here. The repository packages the upstream Go tool
[shoenig/bcrypt-tool](https://github.com/shoenig/bcrypt-tool) as a multi-platform Docker image. The `Dockerfile` is
the product, `test/smoke.sh` checks it, and `README.md` is the published Docker Hub description, uploaded by the
pipeline - part of the release artifact, not just documentation.

| | |
|---|---|
| **Repository** | developed on `gitlab.com/epicsoft-networks/bcrypt` (branch `master`), mirrored to `github.com/epicsoft-llc/bcrypt` |
| **Registries** | `registry.gitlab.com/epicsoft-networks/bcrypt` and Docker Hub `epicsoft/bcrypt` |
| **Platforms** | `linux/amd64` and `linux/arm64` |

## Rules

- **Public repository, MIT.** No internals in any file: no internal hosts, runner or server names, no credentials, no
  infrastructure details.
- **Everything in English** - Dockerfile, comments, README, CHANGELOG, commit messages.
- **No attribution lines** - no `Co-Authored-By:` trailer, no "Generated with" line and no session link in files,
  commit messages or merge request texts.
- **Never commit, push, merge, rebase or tag** - changes stay in the working tree.
- **`README.md` is part of the release:** every link in it stays absolute, a relative link breaks on Docker Hub, and
  it stays below 25,000 bytes.
- **A change users notice gets a `CHANGELOG.md` entry** under a date heading, `## YYYY-MM-DD` - never
  `## [Unreleased]`; the image has no version of its own.

## Image design

- **Two stages.** `golang:alpine` builds the tool with `go install`; only the binary is copied into `busybox:latest`,
  as `/usr/local/bin/bcrypt`. Nothing Go-related reaches the final image.
- **The module path is `github.com/shoenig/bcrypt-tool`.** The old path `gophers.dev/cmds/bcrypt-tool` still resolves,
  but ends at 1.1.1 from 2021 - the image installed it until 2026-10 and so stayed on 1.1.1 while upstream released ten
  more versions. Never go back to it.
- **Built from source, verified by the Go checksum database.** `go install` checks every module against
  `sum.golang.org`, so the build fails on a tampered release instead of shipping it. `CGO_ENABLED=0` makes the binary
  static, which BusyBox needs; `-trimpath -ldflags "-s -w"` keeps it small. bcrypt-tool has no version flag, so the
  version lives in the labels only.
- **`ENTRYPOINT ["bcrypt"]` with `CMD ["help"]`** - every documented invocation puts the action right after the image
  name (`docker run --rm epicsoft/bcrypt:1 hash ...`), and so do existing users. Without arguments the tool prints its
  help and exits with 2. Keep both.
- **BusyBox has no package manager,** so there is no `apk upgrade` here; the weekly `--pull` build takes the current
  `busybox:latest` and `golang:alpine`.
- Both label blocks, `org.label-schema.*` and `image.*`/`maintainer.*`, are maintained together.

## Tests

```bash
docker build -t bcrypt:test --pull --no-cache --build-arg BCRYPT_TOOL_VERSION=1.1.11 .
sh test/smoke.sh bcrypt:test          # optionally a platform as second argument
```

`test/smoke.sh` checks `hash` with a given cost and with the default cost 10, `match` with the right and a wrong
password and their exit codes, `cost`, and that a 73-byte password is refused. The pipeline runs it for every platform
before the push; a new documented behaviour belongs into it.

Build with `--pull --no-cache` when checking a change the way the pipeline does - the image follows moving targets
(`golang:alpine`, `busybox:latest`, the newest bcrypt-tool), and a cached build hides exactly that drift.

## Tags and pipeline (`.gitlab-ci.yml`)

| Tag | Holds |
|---|---|
| `latest` | the newest bcrypt-tool release |
| `1` | the major line of that release |
| `1.1.11` | that exact release |

The image has no version number of its own; the tags are bcrypt-tool versions, rebuilt weekly. `CHANGELOG.md`
therefore has dated entries.

**Git tags and GitHub releases:** a git tag is the date of a `CHANGELOG.md` entry, such as `2026-10-19`, set on the
green commit of the default branch that carries the entry. Until then the entry may still grow; once tagged it is
fixed, and a correction goes into the next entry. A tag pipeline runs only `github-release`, which waits for the tag on
GitHub and creates the release from that entry. Tags are protected, because `GITHUB_TOKEN` is a protected variable.

The `build` job resolves the newest upstream version once (`go list -m ...@latest`), so both platforms build the same
one, and passes it as `BCRYPT_TOOL_VERSION`. Each platform is built, loaded and smoke-tested before the
multi-platform push, which reuses those layers from the builder cache. The `docker:dind` service runs with TLS, which
buildx only takes from a Docker context - hence `docker context create dind` before `docker buildx create`.
`linux/arm64` on an `amd64` runner needs QEMU (`binfmt_misc`) on the runner host, which is why the jobs carry the
runner tag `imagex`. Publishing happens only from the default branch and the weekly schedule. A new major release
upstream needs no change here: the job derives the tags from the version.

CI variables: `DOCKER_HUB_USER` (protected), `DOCKER_HUB_TOKEN` and `GITHUB_TOKEN` (masked, protected). The tokens go in over stdin and through the
environment, never onto a command line.

**GitHub mirror:** a push mirror in the GitLab project settings (Repository → Mirroring repositories) with its own
token - not part of the pipeline. Changes are never pushed to GitHub directly; the mirror would overwrite them.

## Conventions

- `.editorconfig`: 2-space indent, LF, UTF-8, final newline, trailing whitespace trimmed (except Markdown), 120 columns
  (180 for YAML, off for Markdown); `.gitattributes` keeps LF in the repository.
- `test/smoke.sh` is POSIX `sh`: it runs in the `docker:latest` job image, which has no bash.
- Commit messages follow Conventional Commits (`feat:`, `fix:`, `ci:`, `chore:`).
