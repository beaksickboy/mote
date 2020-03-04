FROM golang:1.13.7-alpine3.10

RUN apk update && apk upgrade && \
    apk add --no-cache git
    # add git so go can get package via git
WORKDIR /go/app

COPY . .


# RUN gin -h
# # Must set flag -i to immedietly start server
CMD ["go", "run", "./cmd/user-service/main.go"]