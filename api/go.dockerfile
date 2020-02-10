FROM golang:1.13.7-alpine3.10

WORKDIR /go/app

COPY . .

CMD ["go", "run", "main.go"]