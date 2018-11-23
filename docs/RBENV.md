# rbenv

Notes for how to use `rbenv` so I dont have to re-learn this each time I need to use it

## Plugins

Currently installed the following plugins:
  - ruby-build: Installs any version of ruby for local user
  - binstubs: provides executables specific for a projects bundle

### Binstubs

When you run an executable from the command line without bundle exec, this wrapper invokes
Rubygems, which then uses the normal Rubygems activation mechanism to invoke the gem's executable.

Sources:
  - https://github.com/rbenv/rbenv/wiki/Understanding-binstubs
  - https://yehudakatz.com/2011/05/30/gem-versioning-and-bundler-doing-it-right/

## Examples

Show all versions of rbenv install rubies:
```
rbenv versions
```

Find and install a version of ruby via `ruby-build`:
```
rbenv install --list | less
rbenv install 2.2.0
```

Install `gems` for a project:
```
bundle init
bundle add <gem>
```
> NOTE: This will create a `gemfile and gemfile.lock in the local dir
> which should be committed and used later for rebuilding a ruby dev
> environment

Generate `binstubs` for ALL gems in the bundle:
```
bundle install --binstubs
```

Or generate `binstubs` for a SINGLE gem (recommended)
```
bundle binstubs rake
bundle binstubs rspec-core
```
> NOTE: You are encouraged to check these binstubs in the project's version control

To confirm that the `bundler binstub` is being used, run the command:
```
rbenv which COMMAND
```

To show which `gem bundle` will use, run the command:
```
bundle show GEM
```

You can disable the searching for `binstubs` by setting the environment variable DISABLE_BINSTUBS to a non empty string:
```
DISABLE_BINSTUBS=1 rbenv which command
```

You can list the bundles (project directories) and their associated `binstub` directories that have been registered since
the plugin was installed using the command:
```
rbenv bundles
```
