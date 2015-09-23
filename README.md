## factfill

Factfill is a fairly dumb tool that bulk-loads cached facts into PuppetDB.

The use case this was built for is to import cached facts from one Puppet master to the PuppetDB of a different master, so that you can compile nodes on the second master that only check in to the first master. This faciliates migrations, such as going from an older Puppet 3.3 to Puppet 4.x, where it's difficult to have nodes submit facts to the new infrastructure directly.

Note that this is pretty rough and has no error handling, test coverage, etc.

```
NAME
    factfill - Submit cached facts to PuppetDB

SYNOPSIS
    factfill [global options] command [command options] [arguments...]

VERSION
    0.0.1

GLOBAL OPTIONS
    --help    - Show this message
    --version - Display the program version

COMMANDS
    help   - Shows a list of commands or help for one command
    submit - Submit yaml-format fact files
```

```shell
factfill submit example.yaml
submitting example.yaml to localhost:8080
Response 200 OK:
      {
  "uuid" : "ebe58ec9-16e5-4828-9398-9b8e33827f87"
}
```
