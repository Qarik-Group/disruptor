// Package main implements a client for the Echoer service.
package main

import (
	"context"
	"flag"
	"log"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"

	pb "github.com/Qarik-Group/disruptor/projects/bzl7/go/grpc/proto"
)

var (
	address = flag.String("address", "localhost:50051", "connection address")
	echo    = flag.String("echo", "", "Echo")
)

func main() {
	flag.Parse()

	connection, err := grpc.Dial(
		*address,
		grpc.WithTransportCredentials(
			insecure.NewCredentials(),
		),
	)
	if err != nil {
		log.Fatalln("error: ", err)
	}
	defer connection.Close()

	echoClient := pb.NewEchoerClient(connection)
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()

	response, err := echoClient.SendEcho(ctx, &pb.EchoRequest{Request: *echo})
	if err != nil {
		log.Fatalln("error: ", err)
	}
	log.Println("Response: ", response.GetMessage())
}
