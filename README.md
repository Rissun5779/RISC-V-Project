# RISC-V-Project
這是一個以 RISC-V 為核心，搭配 FPGA 與嵌入式系統設計的學術/學習型專案。我們目標是實作並驗證一個完整的 RISC-V 處理器系統，支援 RTL 設計、FPU、SoC 整合與嵌入式測試。

---

## 專案結構
RISC-V-Project/
├── RTL/ # Verilog/VHDL 原始碼（處理器、FPU、控制單元等）
├── T_core/ # 測試用核心、模擬模組或工具
├── Docs/ # 參考資料、設計說明書、PDF 教材等（使用 Git LFS 管理）
├── LICENSE # 授權條款（MIT）
└── Makefile # Git 操作與開發自動化腳本

## 團隊協作說明

我們使用 Git 進行版本控制，並結合 Git LFS 管理大型檔案。

### 加入團隊的步驟（僅需一次）：

```bash
# 1. 安裝 Git 與 Git LFS
sudo apt install git git-lfs
git lfs install

# 2. 產生 SSH 金鑰並設定 GitHub
ssh-keygen -t ed25519 -C "your@email.com"
# → 將 ~/.ssh/id_ed25519.pub 貼到 GitHub: https://github.com/settings/keys

# 3. 測試 SSH 連線
ssh -T git@github.com

# 4. Clone 專案
git clone git@github.com:Rissun5779/RISC-V-Project.git
cd RISC-V-Project

# 5. 同步 LFS 檔案
git lfs pull
