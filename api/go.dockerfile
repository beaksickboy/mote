FROM golang:1.13.7-alpine3.10

RUN apk update && apk upgrade && \
    apk add --no-cache git && \
    go get github.com/codegangsta/gin

WORKDIR /go/app

COPY . .


CMD ["gin", "run", "main.go"]