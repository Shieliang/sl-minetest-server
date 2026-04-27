# 变量定义
PROJECT_NAME = sl-minetest
REGION = us-east-1
ECR_REPO_NAME = sl-minetest-server

# 定义 Stack 名称
NETWORK_STACK = $(PROJECT_NAME)-network
STORAGE_STACK = $(PROJECT_NAME)-storage
EKS_STACK = $(PROJECT_NAME)-eks

.PHONY: help deploy-network delete-network deploy-storage delete-storage deploy-eks delete-eks create-ecr delete-ecr

help:
	@echo "SL-minetest-server 2.0 基础设施管理"
	@echo "-----------------------------------"
	@echo "命令:"
	@echo "  make deploy-network  - 部署/更新核心网络层"
	@echo "  make delete-network  - 销毁核心网络层"
	@echo "  make deploy-storage  - 部署/更新 EFS 存储层"
	@echo "  make delete-storage  - 销毁 EFS 存储层"

# ==========================================
# 网络层 (Network)
# ==========================================
deploy-network:
	@echo "🚀 正在部署网络层 [$(NETWORK_STACK)]..."
	aws cloudformation deploy \
		--template-file infra/network.yaml \
		--stack-name $(NETWORK_STACK) \
		--parameter-overrides ProjectName=$(PROJECT_NAME) \
		--region $(REGION) \
		--capabilities CAPABILITY_NAMED_IAM

delete-network:
	@echo "⚠️ 正在删除网络层 [$(NETWORK_STACK)]..."
	aws cloudformation delete-stack --stack-name $(NETWORK_STACK) --region $(REGION)
	aws cloudformation wait stack-delete-complete --stack-name $(NETWORK_STACK) --region $(REGION)
	@echo "✅ 网络层删除完毕。"

# ==========================================
# 存储层 (Storage - EFS)
# ==========================================
deploy-storage:
	@echo "🚀 正在部署存储层 [$(STORAGE_STACK)]..."
	aws cloudformation deploy \
		--template-file infra/storage.yaml \
		--stack-name $(STORAGE_STACK) \
		--parameter-overrides ProjectName=$(PROJECT_NAME) \
		--region $(REGION)

delete-storage:
	@echo "⚠️ 正在删除存储层 [$(STORAGE_STACK)]..."
	aws cloudformation delete-stack --stack-name $(STORAGE_STACK) --region $(REGION)
	aws cloudformation wait stack-delete-complete --stack-name $(STORAGE_STACK) --region $(REGION)
	@echo "✅ 存储层删除完毕。"

# ==========================================
# EKS 集群层 (EKS)
# ==========================================
deploy-eks:
	@echo "🚀 正在部署 EKS 集群 [$(EKS_STACK)] (这通常需要 15-20 分钟)..."
	aws cloudformation deploy \
		--template-file infra/eks.yaml \
		--stack-name $(EKS_STACK) \
		--parameter-overrides ProjectName=$(PROJECT_NAME) \
		--region $(REGION) \
		--capabilities CAPABILITY_NAMED_IAM

delete-eks:
	@echo "⚠️ 正在删除 EKS 集群 [$(EKS_STACK)]..."
	aws cloudformation delete-stack --stack-name $(EKS_STACK) --region $(REGION)
	aws cloudformation wait stack-delete-complete --stack-name $(EKS_STACK) --region $(REGION)
	@echo "✅ EKS 集群删除完毕。"

# ==========================================
# 镜像仓库 (ECR)
# ==========================================
create-ecr:
	@echo "🚀 正在创建 ECR 仓库 [$(ECR_REPO_NAME)]..."
	aws ecr create-repository \
		--repository-name $(ECR_REPO_NAME) \
		--region $(REGION) \
		--image-scanning-configuration scanOnPush=true \
		--encryption-configuration encryptionType=AES256

delete-ecr:
	@echo "⚠️ 正在销毁 ECR 仓库 [$(ECR_REPO_NAME)]..."
	aws ecr delete-repository \
		--repository-name $(ECR_REPO_NAME) \
		--region $(REGION) \
		--force