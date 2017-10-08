bcrypt CLI for generating and matching bcrypt hashes

[![](https://images.microbadger.com/badges/image/epicsoft/bcrypt.svg)](https://microbadger.com/images/epicsoft/bcrypt "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/license/epicsoft/bcrypt.svg)](https://microbadger.com/images/epicsoft/bcrypt "Get your own license badge on microbadger.com")
----------

## Quick reference ##

```
Usage: bcrypt [action] argument ...
  ACTIONS
    hash  [password] <cost> Generate hash given password and optional cost (4-31)
    match [password] [hash] Print "yes" and return 0 if password is a match
                            for hash, or print "no" and return 1 otherwise
    cost  [hash]            Print the cost of hash (4-31)
```

## Example ##
```
docker run epicsoft/bcrypt hash password 14
> $2a$14$uPMxyauwt6lrPXAW2rXsUeKo0fvcR/PP8dxQmPhcWFZqwoBmArnx2

# you may need to escape the $ characters
docker run epicsoft/bcrypt match password \$2a\$14\$uPMxyauwt6lrPXAW2rXsUeKo0fvcR/PP8dxQmPhcWFZqwoBmArnx2
> yes

# you may need to escape the $ characters
docker run epicsoft/bcrypt cost \$2a\$14\$uPMxyauwt6lrPXAW2rXsUeKo0fvcR/PP8dxQmPhcWFZqwoBmArnx2
> 14
```

## Links ##
- https://bitbucket.org/epicsoft/bcrypt
- https://github.com/shoenig/bcrypt-tool
  
## License ##

All files are covered by the MIT license, see `LICENSE`.