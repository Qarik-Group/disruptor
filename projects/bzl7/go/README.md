# go

We use Gazelle to generate the `BUILD.bazel` files for this project. You'll notice for the `gazelle/` example, there are no `BUILD.bazel` files in there so simply do the following to create them:
```bash
bazel run //:gazelle
```

## grpc

For the `grpc` examples, you'll need two terminals open. One to run the server:
```bash
bazel run //go/grpc/server
```

Another to act as the client:
```bash
bazel run //go/grpc/client -- --echo="hello"
```
