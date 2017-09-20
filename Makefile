REVISION := $(shell git describe --always)
DATE := $(shell date +%Y-%m-%dT%H:%M:%S%z)
LDFLAGS	:= -ldflags="-X \"main.Revision=$(REVISION)\" -X \"main.BuildDate=${DATE}\""

.PHONY: build-cross dist build deps clean run

name		:= go-grpc-example
linux_name	:= $(name)-linux-amd64
darwin_name	:= $(name)-darwin-amd64

help:
	@awk -F ':|##' '/^[^\t].+?:.*?##/ { printf "\033[36m%-22s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST)


build-cross: ## compile to linux and darwin
	GOOS=linux GOARCH=amd64 go build -o bin/$(linux_name) $(LDFLAGS) cmd/$(name)/*.go
	GOOS=darwin GOARCH=amd64 go build -o bin/$(darwin_name) $(LDFLAGS) cmd/$(name)/*.go

dist: build-cross ## compress compile files to .tar.gz
	cd bin && tar zcvf $(linux_name).tar.gz $(linux_name) && rm -f $(linux_name)
	cd bin && tar zcvf $(darwin_name).tar.gz $(darwin_name) && rm -f $(darwin_name)

build: ## compile
	go build -o bin/$(name) $(LDFLAGS) cmd/$(name)/*.go

clean: ## clean bin/*
	rm -f bin/*

deps: ## install the project's dependencies
	dep ensure

deps/update: ## update the locked versions of all dependencies
	dep ensure -update

gen: ## generate .proto service definition
	$(MAKE) -C proto/message all

run: ## run server
	go run cmd/$(name)-server/$(name)-server.go

run/cl: ## run client
	go run cmd/$(name)-client/$(name)-client.go

run/gw: ## run grpc-gateway
	go run cmd/$(name)-gateway/$(name)-gateway.go
