# Creating a Docker image

In this section we will see the process of creating a docker image and how to run our first container locally. We will first create a basic docker container running busybox and a small web server in go. Then, we will proceed with a more complex Docker file for our REST API Server.

# Prerequisites

* Docker (https://www.docker.com/community-edition)

## Procedure

## Create a basic Dockerfile

1. Create a directory for this demo app
    ```bash
    mkdir tinywww && cd tinywww
    ```
1. Create the `tinywww.go` file
    ```bash
    cat << tinywww.go > EOF
    package main

    import (
        "fmt"
        "os"
        "net/http"
    )

    func handler(w http.ResponseWriter, r *http.Request) {
        myname, err := os.Hostname()
        if err != nil {
            panic(err)
        }
        fmt.Fprintf(w, "Hello from %s!", myname)
    }

    func main() {
        myport := ":8000"
        http.HandleFunc("/", handler)
        fmt.Println("Listening on port", myport)
        http.ListenAndServe(myport, nil)
    }
    EOF
    ```

1. Create a Dockerfile
    ```bash
    cat << Dockerfile > EOF
    FROM golang:alpine

    RUN mkdir /app
    COPY tinywww.go /app
    WORKDIR /app
    RUN GOOS=linux GOARCH=amd64 go build tinywww.go

    CMD ["/app/tinywww"]
    EOF
    ```
1. Build the Docker image
    ```bash
    docker build -t tinywww .
    ```
1. Run the new image as a container
    ```bash
    docker run -p 8000:8000 --rm -it tinywww
    ```
    > Note: This command will run the the container interactively (`-it`), exposing port `8000` and it will remove the container once it exit.

## Publishing an image to Docker Hub
The following steps will walk you through the process of `tagging` and `pushing` an image to Docker Hub.

1. List the images
    ```bash
    docker images
    ```
    OUTPUT:
    ```bash
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    tinywww             latest              1bd533243f24        18 seconds ago      275MB
    golang              alpine              a4c7ad5b9041        11 days ago         269MB
    ```
1. Tag an image.
    > Note: In the following command, make sure you change the variable `${MYDOCKERHUBUSER}` to reflect your username.

    ```bash
    docker tag tinywww ${MYDOCKERHUBUSER}/tinywww:v1
    ```

    > Note: To view if your image was tagged, run `docker images` and verify it's output. For example:
    ```bash
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    dcasati/tinywww     v1                  1bd533243f24        17 minutes ago      275MB
    tinywww             latest              1bd533243f24        17 minutes ago      275MB
    golang              alpine              a4c7ad5b9041        11 days ago         269MB
    ```
    In the above output, we can see that `tinywww` has two tags: latest and v1 which at this point in time are the same but they will differ as more changes affect the `latest` image.

    For you to be able to push images to Docker Hub, you must first login to it.

1. Login to Docker Hub (enter your username and password when prompted)
    ```bash
    docker login -u ${MYDOCKERHUBUSER}
    ```
    OUTPUT:
    ```bash
    docker login -u dcasati
    Password: 
    Login Succeeded
    ```
1. Push the image to a registry
    ```bash
    docker push ${MYDOCKERHUBUSER}/tinywww:v1
    ```
    OUTPUT:
    ```bash
    docker push dcasati/tinywww:v1
    The push refers to repository [docker.io/dcasati/tinywww]
    02b7ae0c1d02: Pushed 
    a09962249567: Pushed 
    2af99c711532: Pushed 
    d57ec487a277: Pushed 
    ab4b5eec9157: Pushed 
    f2644e7ac5d0: Pushed 
    2def0a20f7c8: Pushed 
    d8e80354a27b: Pushed 
    9dfa40a0da3b: Pushed 
    v1: digest: sha256:55c66f4b38a4bd0372c128995107eedd4ad4c58ffb50aaa1200ffa9203244b1f size: 2197
    ```

## Tips

| Action | Command |
| - | - 
| Remove all images | docker rmi $(docker images -qa) 
| List all images | docker images -a
| Remove all containers | docker rm $(docker ps -qa)
| Stop all containers | docker stop $(docker ps -qa)
| Remove all containers | docker rm $(docker ps -qa)

For tab completion of your docker commands take a look at [this](https://docs.docker.com/compose/completion/#bash)

 Next: [Configuring Azure Container Registry](03-configuring-acr.md)