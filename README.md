# NixOS 配置

个人 NixOS flake 配置。

## 这份配置包含什么

| 配置名 | 用途 |
| --- | --- |
| `wsl` | NixOS-WSL |
| `desktop` | 真实设备桌面安装 |

`desktop` 会安装和配置：

- `niri`、DankMaterialShell、`dms-greeter`
- `fcitx5`、Rime、中文输入
- Clash Verge Rev，已开启自动启动、Service Mode、TUN Mode
- Microsoft Edge、VS Code
- Codex Desktop、Codex CLI、cc-switch、nixos-cli
- Git、GitHub CLI credential helper
- sops-nix secrets

## 1. 安装系统

### 1.1 Live CD 本机安装

这是推荐流程。手机只负责打开这份 README 和复制命令，所有安装命令都在目标机器的 NixOS Live CD 里执行。

#### 1.1.1 启动 Live CD

用 NixOS 安装 U 盘启动目标机器。

确认 Live CD 里能运行 `nix`：

```bash
nix --version
```

确认网络：

```bash
curl -I https://cache.nixos.org
```

#### 1.1.2 可选：给 Live CD 配置代理

如果 Live CD 不能直接访问网络，可以临时走手机代理。先查看手机热点网关：

```bash
ip route
```

然后改开头变量并执行：

```bash
PHONE_IP="192.168.43.1"
PROXY_PORT="7890"
export http_proxy="http://${PHONE_IP}:${PROXY_PORT}"
export https_proxy="http://${PHONE_IP}:${PROXY_PORT}"
export HTTP_PROXY="$http_proxy"
export HTTPS_PROXY="$https_proxy"
```

如果 Live CD 使用 Nix daemon，也给 daemon 配同样的代理：

```bash
mkdir -p /etc/systemd/system/nix-daemon.service.d

cat >/etc/systemd/system/nix-daemon.service.d/proxy.conf <<EOF
[Service]
Environment="http_proxy=http://${PHONE_IP}:${PROXY_PORT}"
Environment="https_proxy=http://${PHONE_IP}:${PROXY_PORT}"
Environment="HTTP_PROXY=http://${PHONE_IP}:${PROXY_PORT}"
Environment="HTTPS_PROXY=http://${PHONE_IP}:${PROXY_PORT}"
EOF

systemctl daemon-reload
systemctl restart nix-daemon
```

再测一次网络：

```bash
curl -I https://cache.nixos.org
```

#### 1.1.3 Clone 仓库

公开仓库可以直接 clone，不需要先登录 GitHub：

```bash
nix --extra-experimental-features "nix-command flakes" shell nixpkgs#git -c \
  git clone https://github.com/Onekki/NixOS.git ~/NixOS
cd ~/NixOS
```

#### 1.1.4 确认安装磁盘

查看磁盘名：

```bash
lsblk -o NAME,SIZE,TYPE,MODEL
```

默认安装磁盘是 `/dev/nvme0n1`。如果你要安装的磁盘不是它，改 `hosts/desktop/disko.nix`：

```bash
vi hosts/desktop/disko.nix
```

只改 `device` 这一行。例如 Live CD 里看到目标磁盘是 `sda`，就改成：

```nix
device = lib.mkDefault "/dev/sda";
```

不要改分区结构，除非你明确想调整 ESP、root 分区大小或文件系统。

#### 1.1.5 恢复 age 私钥

把 age 私钥恢复到 Live CD。这个文件不要提交到 Git，它用于解密 `secrets/cc-switch.yaml`：

```bash
mkdir -p ~/.config/sops/age
vi ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

确认私钥能解密仓库里的 secrets：

```bash
SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
nix --extra-experimental-features "nix-command flakes" shell nixpkgs#sops -c \
  sops -d secrets/cc-switch.yaml >/dev/null
```

#### 1.1.6 分区、生成硬件配置、安装

下面的 `disko` 命令会清空 `hosts/desktop/disko.nix` 里 `device` 指向的磁盘。

分区并挂载到 `/mnt`：

```bash
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko ./hosts/desktop/disko.nix
```

生成这台机器自己的硬件配置：

```bash
sudo nixos-generate-config --root /mnt --show-hardware-config > hosts/desktop/hardware-configuration.nix
```

把 sops-nix 运行时私钥放进新系统：

```bash
sudo mkdir -p /mnt/var/lib/sops-nix
sudo install -m 600 ~/.config/sops/age/keys.txt /mnt/var/lib/sops-nix/key.txt
```

安装 NixOS：

```bash
sudo env NIX_CONFIG="experimental-features = nix-command flakes" \
  nixos-install --root /mnt --flake .#desktop --no-root-passwd
```

安装完成后重启：

```bash
sudo reboot
```

### 1.2 控制机远程安装

这是备用流程。只有在另一台控制机的 Nix 环境稳定，并且你想通过 SSH 远程安装目标机器时才用这一套。控制机可以是 NixOS、装了 Nix 的 Linux、macOS、WSL，或者 Android 上的 Nix 环境。

#### 1.2.1 在控制机拉取仓库

控制机需要能运行 `nix`：

```bash
nix --version
```

公开仓库可以直接 clone，不需要先登录 GitHub：

```bash
nix shell nixpkgs#git -c sh -lc 'test -d ~/NixOS || git clone https://github.com/Onekki/NixOS.git ~/NixOS'
cd ~/NixOS
nix shell nixpkgs#git -c git pull --ff-only
```

#### 1.2.2 启动目标机器并开启 SSH

用 NixOS 安装 U 盘启动目标机器。

给 Live CD 里的 `nixos` 用户设置临时密码：

```bash
passwd
```

确保 SSH 服务已启动：

```bash
systemctl start sshd
```

查看目标机器 IP 和磁盘名：

```bash
ip addr
lsblk -o NAME,SIZE,TYPE,MODEL
```

如果要安装的磁盘不是 `/dev/nvme0n1`，回到控制机修改：

```bash
cd ~/NixOS
vi hosts/desktop/disko.nix
```

只改 `device` 这一行。例如 Live CD 里看到目标磁盘是 `sda`，就改成：

```nix
device = lib.mkDefault "/dev/sda";
```

#### 1.2.3 在控制机准备私钥

先把 age 私钥恢复到控制机：

```bash
mkdir -p ~/.config/sops/age
${EDITOR:-vi} ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

确认私钥能解密仓库里的 secrets：

```bash
cd ~/NixOS && \
SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
nix shell nixpkgs#sops -c sops -d secrets/cc-switch.yaml >/dev/null
```

准备安装时要复制到目标系统的私钥：

```bash
cd ~/NixOS && \
mkdir -p ./extra-files/var/lib/sops-nix && \
install -m 600 ~/.config/sops/age/keys.txt ./extra-files/var/lib/sops-nix/key.txt
```

复制下面整段，改开头变量：

```bash
cd ~/NixOS && \
TARGET_IP="192.168.43.123" && \
TARGET_USER="nixos" && \
nix shell nixpkgs#openssh -c nix run github:nix-community/nixos-anywhere -- \
  --build-on remote \
  --flake .#desktop \
  --target-host "${TARGET_USER}@${TARGET_IP}" \
  --extra-files ./extra-files \
  --generate-hardware-config nixos-generate-config ./hosts/desktop/hardware-configuration.nix
```

如果控制机里的仓库不在 `~/NixOS`，把第一行改成实际路径。

这条命令会分区、格式化、安装 NixOS，把检测到的硬件配置写入：

```text
hosts/desktop/hardware-configuration.nix
```

安装完成后，目标机器会重启。

安装成功后，在控制机仓库目录删除临时私钥副本：

```bash
rm -rf ./extra-files
```

## 2. 首次登录

临时账号：

```text
user: nixos
password: nixos
```

第一次登录后立刻改密码：

```bash
passwd
```

确认 secrets 已经解密到 cc-switch 配置目录：

```bash
test -f ~/.config/cc-switch/provider-env && echo ok
```

登录 GitHub。不要把 PAT 写进 Nix、sops、README 或 Git：

```bash
gh auth login
```

推荐选择：

```text
GitHub.com
HTTPS
Paste an authentication token
```

确认 GitHub 登录和 Git credential helper 可用：

```bash
gh auth status
git ls-remote https://github.com/Onekki/NixOS.git
```

确认常用命令可用：

```bash
command -v codex-desktop
test -f /run/current-system/sw/share/applications/codex-desktop.desktop && echo ok
codex --version
cc-switch --help
git config --global user.email
```

## 3. 日常使用

### 3.1 更新系统

```bash
sudo nixos-rebuild switch --flake .#desktop
```

第一次安装之后，日常本地或远程部署可以用 `nixos-cli`。`nixos-anywhere` 主要留给还需要分区和安装的新设备。

### 3.2 编辑 cc-switch 加密配置

如果当前机器只有系统位置的 age 私钥，没有用户工作副本，先复制一份：

```bash
mkdir -p ~/.config/sops/age && \
sudo cp /var/lib/sops-nix/key.txt ~/.config/sops/age/keys.txt && \
sudo chown "$USER:users" ~/.config/sops/age/keys.txt && \
chmod 600 ~/.config/sops/age/keys.txt
```

编辑加密配置：

```bash
SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
nix shell nixpkgs#sops -c sops secrets/cc-switch.yaml
```

rebuild 后，`sops-nix` 会把解密结果写到：

```text
~/.config/cc-switch/provider-env
```

`cc-switch.db` 是本机运行时状态，不要提交。

### 3.3 GitHub PAT

查看登录状态：

```bash
gh auth status
```

撤销这台机器上的登录：

```bash
gh auth logout
```

## 4. 备份

必须备份 age 私钥：

```text
~/.config/sops/age/keys.txt
```

推荐放进密码管理器或离线加密备份。不要放进 GitHub、网盘明文目录、聊天记录或 README。

备份前可以查看 public key，确认它对应 `.sops.yaml` 里的 recipient：

```bash
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```

可以提交到 GitHub 的只有加密文件：

```text
.sops.yaml
secrets/cc-switch.yaml
```

## 5. 恢复到新机器或已有系统

从密码管理器恢复 age 私钥：

```bash
mkdir -p ~/.config/sops/age
$EDITOR ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

复制到 `sops-nix` 使用的系统位置：

```bash
sudo mkdir -p /var/lib/sops-nix && \
sudo cp ~/.config/sops/age/keys.txt /var/lib/sops-nix/key.txt && \
sudo chmod 600 /var/lib/sops-nix/key.txt
```

验证可以解密：

```bash
SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
nix shell nixpkgs#sops -c sops -d secrets/cc-switch.yaml >/dev/null
```

验证通过后再 rebuild：

```bash
sudo nixos-rebuild switch --flake .#desktop
```

再登录 GitHub：

```bash
gh auth login
```

## 6. 配置说明

DankMaterialShell 由 Home Manager 管理，并在登录后通过用户级 systemd service 启动。正常安装流程里不要运行 `dms setup`；它会写入生成的用户配置，让机器变得不够可复现。

中文输入法由 `fcitx5`、Rime 和中文 addons 提供。默认 fcitx5 profile 由 Home Manager 管理，新系统第一次登录后已经有 `keyboard-us`、`pinyin` 和 `rime`。

Clash Verge Rev 使用 nixpkgs 里的 `clash-verge-rev`，只安装在 `desktop`。订阅、节点和规则数据属于本机运行配置，不提交到 Git。

Microsoft Edge、VS Code 和 Codex Desktop 只安装在 `desktop`。Codex Desktop 使用 `github:ilysenko/codex-desktop-linux` 的 NixOS module，并把它使用的 CLI 指向 nixpkgs 里的 `codex`。Codex CLI 安装在通用配置里，所以 `desktop` 和 `wsl` 都可以直接使用 `codex` 命令。

Git 由 Home Manager 管理，用户姓名和邮箱集中写在 `flake.nix` 的 `identity` 里。默认分支是 `main`，`git pull` 默认使用 rebase。GitHub 认证由 `gh` 管理，Git 会使用 GitHub CLI 的 credential helper。
