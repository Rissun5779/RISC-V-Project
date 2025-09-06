# Makefile for git operations + basic setup + Git LFS support

MSG ?= update
REMOTE ?= git@github.com:Rissun5779/RISC-V-Project.git

.PHONY: help setup status add commit pull push all lfs-install lfs-track lfs-files

help:
	@echo "Usage:"
	@echo "  make setup                                  # 設定 git username/email，產生 SSH key 並提醒後續手動操作"
	@echo "  make status                                 # 顯示 git 狀態"
	@echo "  make add                                    # 加入全部變更（新增、修改、刪除）"
	@echo "  make commit MSG=\"msg\"                      # 提交改動，訊息由 MSG 參數決定，預設為 'update'"
	@echo "  make pull                                   # 拉取遠端 main 分支最新改動並 rebase"
	@echo "  make push                                   # 推送 main 分支到遠端"
	@echo "  make all MSG=\"msg\"                         # 一次執行加入、提交、拉取、推送"
	@echo ""
	@echo "  make lfs-install                            # 安裝並初始化 Git LFS"
	@echo "  make lfs-track                              # 使用 Git LFS 追蹤 pdf/zip 檔案"
	@echo "  make lfs-files                              # 列出目前由 Git LFS 管理的檔案"

setup:
	@echo "設定 git 使用者名稱跟 email"
	@git config --global user.name "Your Name"
	@git config --global user.email "you@example.com"
	@echo ""
	@echo "檢查是否已存在 SSH key"
	@if [ -f ~/.ssh/id_ed25519.pub ]; then \
		echo "找到已有的 SSH 公鑰：~/.ssh/id_ed25519.pub"; \
	else \
		echo "找不到 SSH key，開始產生新的 SSH key..."; \
		ssh-keygen -t ed25519 -C "you@example.com" -f ~/.ssh/id_ed25519 -N ""; \
	fi
	@echo ""
	@echo "請將以下公鑰內容複製並貼到 GitHub SSH keys 網頁：https://github.com/settings/keys"
	@echo "----- 以下是你的公鑰 -----"
	@cat ~/.ssh/id_ed25519.pub || echo "(無法讀取 ~/.ssh/id_ed25519.pub)"
	@echo "-------------------------"
	@echo ""
	@echo "完成後，請執行 ssh -T git@github.com 測試連線"
	@echo "例如： ssh -T git@github.com"

status:
	git status

add:
	git add .

commit:
	git commit -m "$(MSG)"

pull:
	git pull origin main --rebase

push:
	git push origin main

all: add commit pull push

# Git LFS 操作相關
lfs-install:
	@echo "安裝 Git LFS 並初始化（需 root 權限）"
	sudo apt update && sudo apt install -y git-lfs
	git lfs install
	@echo "✅ Git LFS 安裝完成"

lfs-track:
	@git lfs track "*.pdf"
	@git lfs track "*.zip"
	@git add .gitattributes
	@echo "✅ 已設定 Git LFS 追蹤 *.pdf, *.zip"

lfs-files:
	@git lfs ls-files
