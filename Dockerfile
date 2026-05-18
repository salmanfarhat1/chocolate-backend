# backend/Dockerfile
FROM golang:1.24 AS builder  
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -buildvcs=false -o main .

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/main .
COPY photos ./photos 
COPY admin ./admin  
EXPOSE 3000
CMD ["./main"]


