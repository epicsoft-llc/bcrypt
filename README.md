# bcrypt

This Docker image is managed and kept up to date by [epicsoft LLC](https://epicsoft.one).

[bcrypt-tool](https://github.com/shoenig/bcrypt-tool) by Seth Hoenig in a small BusyBox image: hash a password with
bcrypt, check whether a password matches a hash, and read the cost of a hash - for seeding users into a database or a
config file, or for checking a hash you found there, without installing anything on the host.

* Base image: https://hub.docker.com/_/busybox, platforms `linux/amd64` and `linux/arm64`
* Upstream: https://github.com/shoenig/bcrypt-tool
* Dockerfile: https://gitlab.com/epicsoft-networks/bcrypt/-/blob/master/Dockerfile
* Repository: https://gitlab.com/epicsoft-networks/bcrypt, mirrored to [GitHub](https://github.com/epicsoft-llc/bcrypt) — issues are welcome on both; code changes only as merge requests on GitLab, the mirror overwrites anything pushed to GitHub
* Container registry: https://gitlab.com/epicsoft-networks/bcrypt/container_registry
* Docker Hub: https://hub.docker.com/r/epicsoft/bcrypt
* Changelog: https://gitlab.com/epicsoft-networks/bcrypt/-/blob/master/CHANGELOG.md
* License: MIT

## Versions

The image is rebuilt weekly with the newest release of bcrypt-tool, the current BusyBox image and the current Go
toolchain.

| Tag | Holds |
|---|---|
| `latest` | the newest bcrypt-tool release |
| `1` | the newest 1.x release; once upstream releases 2.0, it keeps the last 1.x build |
| `1.1.11` | exactly this release; rebuilt weekly while it is the newest one, then kept as it is |

The bcrypt-tool version an image holds is written into its labels:

```bash
docker image inspect --format '{{index .Config.Labels "image.bcrypt-tool.version"}}' epicsoft/bcrypt:1
```

## Usage

The image runs `bcrypt` directly - the action and its arguments follow the image name:

```
hash  [password] <cost>   hash the password; cost 4-31, default 10
match [password] [hash]   print "yes" and exit 0 if the password matches the hash, "no" and exit 1 otherwise
cost  [hash]              print the cost of the hash
```

Without an action the image prints this help and exits with 2, as it does on wrong arguments.

### Hash a password

```bash
docker run --rm epicsoft/bcrypt:1 hash 'p4ssw0rd' 12
$2a$12$ft/vurFX2/51HBJQYe5I2uwCsofwMJgyC9fFI93Gm2fn0Kiaj1mbu
```

### Check a password against a hash

Put the hash in single quotes - otherwise the shell takes its `$` signs for variables.

```bash
docker run --rm epicsoft/bcrypt:1 match 'p4ssw0rd' '$2a$12$ft/vurFX2/51HBJQYe5I2uwCsofwMJgyC9fFI93Gm2fn0Kiaj1mbu'
yes
```

### Read the cost of a hash

```bash
docker run --rm epicsoft/bcrypt:1 cost '$2a$12$ft/vurFX2/51HBJQYe5I2uwCsofwMJgyC9fFI93Gm2fn0Kiaj1mbu'
12
```

### Good to know

- **Passwords longer than 72 bytes are refused** (`bcrypt: password length exceeds 72 bytes`, exit 2): bcrypt only
  reads the first 72 bytes, and the tool says so instead of cutting the password without notice.
- **A password on the command line** lands in the shell history and, while the container starts, in the process list
  of the host. For a real password read it without echo first, for example `read -rs PW` in bash, and pass `"$PW"`.

## Migrating from the earlier image

- Until October 2026 the image held bcrypt-tool 1.1.1 from 2021: it installed the tool from its old module path
  `gophers.dev/cmds/bcrypt-tool`, which never got newer releases. The hashes stay compatible - same `$2a$` format,
  same costs - apart from the 72-byte limit above.
- The image moved from `gitlab.com/epicdocker/bcrypt` to `gitlab.com/epicsoft-networks/bcrypt`;
  `registry.gitlab.com/epicdocker/bcrypt` is gone. Docker Hub `epicsoft/bcrypt` stays as it is.

## Reporting problems

Issues are welcome on [GitLab](https://gitlab.com/epicsoft-networks/bcrypt/-/issues) and
[GitHub](https://github.com/epicsoft-llc/bcrypt/issues). Please report a security problem as a **confidential issue**
on GitLab instead of a public one.

## License

[MIT](https://gitlab.com/epicsoft-networks/bcrypt/-/blob/master/LICENSE) — Copyright (c) 2017-2026 epicsoft LLC / Alexander Schwarz

The MIT license applies only to files created by epicsoft LLC. Third-party software in the image — bcrypt-tool and
BusyBox — remains under its own licenses.
