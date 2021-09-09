# BCrypt

<!-- vscode-markdown-toc -->
* 1. [Versions](#Versions)
* 2. [Requirements](#Requirements)
* 3. [Quick reference](#Quickreference)
* 4. [Examples](#Examples)
	* 4.1. [Generate a BCrypt hash](#GenerateaBCrypthash)
	* 4.2. [Compare a BCrypt hash with a password](#CompareaBCrypthashwithapassword)
	* 4.3. [Detect rounds out of a BCrypt hash](#DetectroundsoutofaBCrypthash)
* 5. [Links](#Links)
* 6. [License](#License)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

Docker image for BCrypt CLI for generating and matching BCrypt hashes. Based on the [bcrypt-tool](https://github.com/shoenig/bcrypt-tool) by [Seth Hoenig (shoenig)](https://github.com/shoenig).

##  1. <a name='Versions'></a>Versions

Of this project, there is always only one version `latest` and so that the version stays up to date, it is rebuilt weekly.

`latest` [Dockerfile](https://gitlab.com/epicdocker/bcrypt/blob/master/Dockerfile)


##  2. <a name='Requirements'></a>Requirements

- Docker installed - https://www.docker.com/get-started

##  3. <a name='Quickreference'></a>Quick reference

```
Usage: bcrypt [action] argument ...
  ACTIONS
    hash  [password] <cost> Generate hash given password and optional cost (4-31)
    match [password] [hash] Print "yes" and return 0 if password is a match
                            for hash, or print "no" and return 1 otherwise
    cost  [hash]            Print the cost of hash (4-31)
```

##  4. <a name='Examples'></a>Examples

###  4.1. <a name='GenerateaBCrypthash'></a>Generate a BCrypt hash

```
docker run --rm registry.gitlab.com/epicdocker/bcrypt:latest hash password 14
> $2a$14$uPMxyauwt6lrPXAW2rXsUeKo0fvcR/PP8dxQmPhcWFZqwoBmArnx2
```

###  4.2. <a name='CompareaBCrypthashwithapassword'></a>Compare a BCrypt hash with a password

You may need to escape the `$` characters.

```
docker run --rm registry.gitlab.com/epicdocker/bcrypt:latest match password \$2a\$14\$uPMxyauwt6lrPXAW2rXsUeKo0fvcR/PP8dxQmPhcWFZqwoBmArnx2
> yes
```

###  4.3. <a name='DetectroundsoutofaBCrypthash'></a>Detect rounds out of a BCrypt hash

You may need to escape the `$` characters.

```
docker run --rm registry.gitlab.com/epicdocker/bcrypt:latest cost \$2a\$14\$uPMxyauwt6lrPXAW2rXsUeKo0fvcR/PP8dxQmPhcWFZqwoBmArnx2
> 14
```

##  5. <a name='Links'></a>Links

- https://gitlab.com/epicdocker/bcrypt
- https://hub.docker.com/r/epicsoft/bcrypt/
- https://quay.io/repository/epicsoft/bcrypt
- https://github.com/shoenig/bcrypt-tool

##  6. <a name='License'></a>License

MIT License see [LICENSE](https://gitlab.com/epicdocker/bcrypt/blob/master/LICENSE)
