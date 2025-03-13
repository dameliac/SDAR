FROM golang:latest AS build-stage
WORKDIR /app

COPY . .
RUN go mod download

RUN go build

FROM golang:latest AS final-stage
WORKDIR /app
COPY --from=build-stage /app/backend .
RUN adduser app
USER app
ENTRYPOINT [ "./backend" ]