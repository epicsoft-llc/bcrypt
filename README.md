# BCrypt

Docker image for BCrypt CLI for generating and matching BCrypt hashes. Based on the [bcrypt-tool](https://github.com/shoenig/bcrypt-tool) by [Seth Hoenig (shoenig)](https://github.com/shoenig).


## Versions

Of this project, there is always only one version `latest` and so that the version stays up to date, it is rebuilt weekly.

`latest` [Dockerfile]() ToDo Link


## Requirements

- Docker installed - https://www.docker.com/get-docker


## Quick reference

    Usage: bcrypt [action] argument ...
      ACTIONS
        hash  [password] <cost> Generate hash given password and optional cost (4-31)
        match [password] [hash] Print "yes" and return 0 if password is a match
                                for hash, or print "no" and return 1 otherwise
        cost  [hash]            Print the cost of hash (4-31)


## Examples


### Generate a BCrypt hash

    docker run [ToDo docker image] hash password 14
    > $2a$14$uPMxyauwt6lrPXAW2rXsUeKo0fvcR/PP8dxQmPhcWFZqwoBmArnx2


### Compare a BCrypt hash with a password

You may need to escape the `$` characters.

    docker run [ToDo docker image] match password \$2a\$14\$uPMxyauwt6lrPXAW2rXsUeKo0fvcR/PP8dxQmPhcWFZqwoBmArnx2
    > yes


### Detect rounds out of a BCrypt hash

You may need to escape the `$` characters.

    docker run [ToDo docker image] cost \$2a\$14\$uPMxyauwt6lrPXAW2rXsUeKo0fvcR/PP8dxQmPhcWFZqwoBmArnx2
    > 14


## Links

- https://gitlab.com/epicdocker/bcrypt
- https://hub.docker.com/r/epicsoft/bcrypt/
- https://github.com/shoenig/bcrypt-tool


## License

MIT License see [LICENSE]() ToDo Link
