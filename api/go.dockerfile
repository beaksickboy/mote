FROM golang:1.13.7-alpine3.10

RUN apk update && apk upgrade && \
    apk add --no-cache git
    # add git so go can get package via git
WORKDIR /go/app

COPY . .

RUN go mod download

# Must set flag -i to immedietly start server
CMD ["gin", "-i", "run", "main.go"]