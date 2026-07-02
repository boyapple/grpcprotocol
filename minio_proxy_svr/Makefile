PROTOC_FLAGS = \
  --go_out=. \
  --go-grpc_out=require_unimplemented_servers=false:. \
  --go_opt=paths=source_relative \
  --go-grpc_opt=paths=source_relative

generate:
	protoc -I . -I .. --validate_out=lang=go:. --validate_opt=paths=source_relative $(PROTOC_FLAGS) minio_proxy_svr.proto