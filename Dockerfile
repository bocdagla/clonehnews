# syntax=docker/dockerfile:1
FROM golang:1.19 AS build-stage

WORKDIR /app
COPY ./app ./
RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /docker-hnclone

FROM gcr.io/distroless/base-debian11  as release
WORKDIR /app
COPY --from=build-stage /app/index.gohtml ./index.gohtml
COPY --from=build-stage /docker-hnclone ./docker-hnclone

EXPOSE 3000
ENTRYPOINT [ "/app/docker-hnclone" ]