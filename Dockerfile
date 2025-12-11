#####################################
# STAGE 1: BUILD GO BINARY
#####################################
FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app

ENV GO111MODULE=on

COPY . .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .


#####################################
# STAGE 2: FINAL RUNTIME IMAGE
#####################################
FROM alpine:3.19

RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=builder /app/main .

ENTRYPOINT ["./main"]
