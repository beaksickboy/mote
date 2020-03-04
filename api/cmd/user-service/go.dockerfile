FROM golang:1.13.7-alpine3.10

RUN apk update && apk upgrade && \
    apk add --no-cache git
    # add git so go can get package via git
WORKDIR /go/app

COPY . .

RUN go mod download
# Have no idea why gin fail if i don't call go get gin directly on window
RUN go get github.com/codegangsta/gin

# Must set flag -i to immedietly start server
CMD ["gin", "-i", "--build", "cmd/user-service"]