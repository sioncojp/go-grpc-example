# go-grpc-example
```shell
$ go get -u github.com/sioncojp/go-grpc-example
$ cd $GOPATH/src/github.com/sioncojp/go-grpc-example

### show help
$ make help

### install dependency packages (need https://github.com/golang/dep)
$ make deps

### run server
$ make run
2017/09/20 20:09:49 [INFO] listening grpc server on :50051

### run client
$ make run/cl
go run cmd/go-grpc-example-client/go-grpc-example-client.go
2017/09/20 20:09:54 Greeting: Hello world

### run gw (with running server)
$ make gw
$ curl localhost:8080/hello -X POST -d '{"name":"world"}'
{"message":"Hello world"}
```
