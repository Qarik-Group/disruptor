// Package main implements a server for the Echoer service.
package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net"

	pb "github.com/Qarik-Group/disruptor/projects/bzl7/go/grpc/proto"
	"google.golang.org/grpc"
)

var (
	port = flag.Int("port", 50051, "The server port")
)

type server struct {
	pb.UnimplementedEchoerServer
}

// SendEcho implements echo.EchoerServer
func (s *server) SendEcho(ctx context.Context, in *pb.EchoRequest) (*pb.EchoReply, error) {
	request := in.GetRequest()
	log.Printf("Received: %v", request)
	return &pb.EchoReply{Message: request}, nil
}

func main() {
	flag.Parse()

	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", *port))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()
	pb.RegisterEchoerServer(grpcServer, &server{})
	log.Printf("server listening at %v", listener.Addr())

	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
