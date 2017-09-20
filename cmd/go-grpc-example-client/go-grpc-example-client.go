package main

import (
	"flag"
	"log"

	pb "github.com/sioncojp/go-grpc-example/proto/message"

	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

var (
	addrFlag = flag.String("addr", "localhost:50051", "server address host:post")
)

func main() {
	conn, err := grpc.Dial(*addrFlag, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("Connection error: %v", err)
	}
	defer conn.Close()

	c := pb.NewMessageClient(conn)

	resp, err := c.Hello(context.Background(), &pb.HelloRequest{Name: "world"})
	if err != nil {
		log.Fatalf("RPC error: %v", err)
	}
	log.Printf("Greeting: %s", resp.Message)
}
