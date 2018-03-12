# Development

## Setup environment

```bash
bundle install
```

## Running checks

### rubocop

```base
bundle exec rake rubocop
```

### syntax lint

```base
bundle exec rake syntax lint
```

### metadata lint

```base
bundle exec rake metadata_lint
```

### spec

```base
bundle exec rake spec
```

## Updating documentation

```bash
bundle exec puppet strings generate --out ./doc/reference.md --format markdown manifests/{init,unmanaged,params}.pp
```

## Contributing

Please use [Git Flow](https://github.com/petervanderdoes/gitflow-avh) when
contributing to this project.

1. Fork the reference repository
2. Create a feature branch
   ```bash
   git flow feature start foo
   ```
3. Implement your change
   * Do not forget to also update tests and documentation
4. Run all checks locally
5. Commit
6. Publish your feature branch
   ```bash
   git flow feature publish
   ```
7. Create a pull request toward the ``develop`` branch

## Release

1. Start a new release
   ```bash
   git flow release start MAJOR.MINOR
   ```
2. Bump version in ``metadata.json`` and commit
3. Update ``CHANGELOG.md`` and commit
4. Finish the release
   ```bash
   git flow release finish MAJOR.MINOR -m MAJOR.MINOR.PATCH -T MAJOR.MINOR.PATCH -p
   ```
