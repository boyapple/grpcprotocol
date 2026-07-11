# ─── 工具版本 ─────────────────────────────────────────────────
PROTOC_GEN_GO_VERSION       = latest
PROTOC_GEN_GO_GRPC_VERSION  = latest
PROTOC_GEN_VALIDATE_VERSION = latest

# ─── third_party proto 路径（项目内，clone 后直接可用）─────────
THIRD_PARTY = third_party

# ─── protoc 公共参数 ──────────────────────────────────────────
PROTOC_FLAGS = \
  --go_out=. \
  --go-grpc_out=require_unimplemented_servers=false:. \
  --go_opt=paths=source_relative \
  --go-grpc_opt=paths=source_relative

# ─── protoc 公共参数（仅 pb + validate）────────────────────────────
PROTOC_FLAGS_PB_ONLY = \
  --go_out=. \
  --go_opt=paths=source_relative

# ─── 各服务 pb 生成 ───────────────────────────────────────────
.PHONY: blog_common
blog_common:
	@echo ">>> Generating blog_common pb..."
	cd blog_common && protoc -I . -I .. --validate_out=lang=go:. --validate_opt=paths=source_relative $(PROTOC_FLAGS_PB_ONLY) blog_common.proto
	@echo ">>> Done: blog_common"

.PHONY: blog_article_svr
blog_article_svr:
	@echo ">>> Generating blog_article_svr pb..."
	cd blog_article_svr && protoc -I . -I .. --validate_out=lang=go:. --validate_opt=paths=source_relative $(PROTOC_FLAGS) blog_article_svr.proto
	@echo ">>> Done: blog_article_svr"

.PHONY: blog_user_svr
blog_user_svr:
	@echo ">>> Generating blog_user_svr pb..."
	cd blog_user_svr && protoc -I . -I .. --validate_out=lang=go:. --validate_opt=paths=source_relative $(PROTOC_FLAGS) blog_user_svr.proto
	@echo ">>> Done: blog_user_svr"

.PHONY: minio_proxy_svr
minio_proxy_svr:
	@echo ">>> Generating minio_proxy_svr pb..."
	cd minio_proxy_svr && protoc -I . -I .. --validate_out=lang=go:. --validate_opt=paths=source_relative $(PROTOC_FLAGS) minio_proxy_svr.proto
	@echo ">>> Done: minio_proxy_svr"

.PHONY: all
all: blog_user_svr blog_article_svr blog_agent_svr blog_common
	@echo ">>> All pb files generated."

# ─── go mod tidy ─────────────────────────────────────────────

.PHONY: tidy
tidy:
	@echo ">>> Tidying blog_user_svr..."
	cd blog_user_svr && go mod tidy
	@echo ">>> Tidying blog_article_svr..."
	cd blog_article_svr && go mod tidy
	@echo ">>> Tidy done."

# ─── 安装 protoc 插件 ─────────────────────────────────────────

.PHONY: install-tools
install-tools:
	@echo ">>> Installing protoc plugins..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@$(PROTOC_GEN_GO_VERSION)
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@$(PROTOC_GEN_GO_GRPC_VERSION)
	go install github.com/envoyproxy/protoc-gen-validate@$(PROTOC_GEN_VALIDATE_VERSION)
	@echo ">>> Tools installed."
