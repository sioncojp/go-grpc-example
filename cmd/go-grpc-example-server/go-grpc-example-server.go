package main

import (
	"log"
	"net"

	pb "github.com/sioncojp/go-grpc-example/proto/message"

	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

const (
	port = ":50051"
)

type server struct{}

func (s *server) Hello(_ context.Context, req *pb.HelloRequest) (*pb.HelloResponse, error) {
	return &pb.HelloResponse{Message: "Hello " + req.Name}, nil
}

func main() {
	s := grpc.NewServer()
	pb.RegisterMessageServer(s, &server{})

	log.Printf("[INFO] listening grpc server on %s", port)

	listener, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("[ERROR] failed to listen: %s", err)
	}

	if err := s.Serve(listener); err != nil {
		log.Fatalf("[ERROR] failed to start server: %v", err)
	}
}
