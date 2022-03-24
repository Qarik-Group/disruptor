# Development of GitHub Actions

## Using `act` to run workflow locally

1. Make sure docker is running and available, ex. `docker run hello-world`
2. Run: `docker pull nektos/act-environments-ubuntu:18.04-full` - this will take significant amount of time so make sure it doesn't block your work
3. Run: `act`, it should start container and run workflow!

To specify which workflow to run, use `-w {path_to_yaml}` when running `act`.
Check `act --help` for more informations.