# NixOS 配置

个人 NixOS flake 配置。

## 主机

| 配置名 | 用途 |
| --- | --- |
| `wsl` | NixOS-WSL |
| `desktop` | 真实设备桌面安装 |

## 安装桌面系统

`desktop` 使用 `disko` 和 `nixos-anywhere` 自动安装真实设备。

> 注意：安装会重新分区并格式化 `hosts/desktop/disko.nix` 里配置的磁盘。默认磁盘是 `/dev/nvme0n1`。

### 1. 启动目标设备

用 NixOS 安装 U 盘启动新设备。

给安装环境里的 `nixos` 用户设置一个临时密码：

```bash
passwd
```

查看目标设备的 IP：

```bash
ip addr
```

确认要安装的磁盘名：

```bash
lsblk -o NAME,SIZE,TYPE,MODEL
```

如果磁盘不是 `/dev/nvme0n1`，安装前先修改 `hosts/desktop/disko.nix`。

### 2. 可选：手机代理

如果目标设备需要走手机代理，先让目标设备连接手机热点。在手机代理软件里开启局域网访问，端口可以用 HTTP 或 mixed 端口，比如 `7890`。

在目标设备的安装环境里查看手机热点网关：

```bash
ip route
```

通常是 `default via` 后面的地址，例如 `192.168.43.1`。

在目标设备的安装环境里设置代理：

```bash
export http_proxy=http://PHONE_IP:7890
export https_proxy=http://PHONE_IP:7890
export HTTP_PROXY=http://PHONE_IP:7890
export HTTPS_PROXY=http://PHONE_IP:7890
```

如果安装环境使用 Nix daemon，也要把同样的代理给 daemon。这里改的是 U 盘启动后的临时 live 系统，不是安装完成后的正式系统：

```bash
mkdir -p /etc/systemd/system/nix-daemon.service.d

cat >/etc/systemd/system/nix-daemon.service.d/proxy.conf <<'EOF'
[Service]
Environment="http_proxy=http://PHONE_IP:7890"
Environment="https_proxy=http://PHONE_IP:7890"
Environment="HTTP_PROXY=http://PHONE_IP:7890"
Environment="HTTPS_PROXY=http://PHONE_IP:7890"
EOF

systemctl daemon-reload
systemctl restart nix-daemon
```

测试网络：

```bash
curl -I https://cache.nixos.org
```

### 3. 控制机

在带有 Nix 和 SSH 的控制机上运行 `nixos-anywhere`。控制机可以是 NixOS、装了 Nix 的 Linux、装了 Nix 的 macOS、WSL，或者 Android 上的 Nix 环境。

先创建一个本地目录，把从密码管理器恢复出来的 age 私钥放进去。安装时这个目录会被复制到目标系统：

```bash
mkdir -p ./extra-files/var/lib/sops-nix && \
install -m 600 /path/to/keys.txt ./extra-files/var/lib/sops-nix/key.txt
```

复制下面这段，修改开头的变量：

```bash
cd /path/to/NixOS && \
TARGET_IP="192.168.43.123" && \
TARGET_USER="nixos" && \
PHONE_IP="192.168.43.1" && \
PROXY_PORT="7890" && \
export http_proxy="http://${PHONE_IP}:${PROXY_PORT}" && \
export https_proxy="http://${PHONE_IP}:${PROXY_PORT}" && \
export HTTP_PROXY="$http_proxy" && \
export HTTPS_PROXY="$https_proxy" && \
nix run github:nix-community/nixos-anywhere -- \
  --build-on remote \
  --flake .#desktop \
  --target-host "${TARGET_USER}@${TARGET_IP}" \
  --extra-files ./extra-files \
  --generate-hardware-config nixos-generate-config ./hosts/desktop/hardware-configuration.nix
```

如果控制机不需要代理，删掉 `PHONE_IP`、`PROXY_PORT` 和几行 `export`。

这个命令会分区、格式化、安装 NixOS，把检测到的硬件配置写入 `hosts/desktop/hardware-configuration.nix`，然后重启目标设备。

安装成功后，删除临时私钥副本：

```bash
rm -rf ./extra-files
```

### 4. 第一次登录

安装后的系统有一个临时本地账号：

```text
user: nixos
password: nixos
```

第一次登录后立刻修改密码：

```bash
passwd
```

## 安装后状态

`desktop` 使用 `niri`、DMS flake 里的 DankMaterialShell，以及 `dms-greeter` 作为显示管理器。

DankMaterialShell 由 Home Manager 管理，并在登录后通过用户级 systemd service 启动。正常安装流程里不要运行 `dms setup`；它会写入生成的用户配置，让机器变得不够可复现。只有在临时试验 upstream 生成配置时才运行它，然后把需要的部分整理回 Nix 配置。

中文输入法由 `fcitx5`、Rime 和中文 addons 提供。默认 fcitx5 profile 由 Home Manager 管理，所以新系统第一次登录后已经配置好 `keyboard-us`、`pinyin` 和 `rime`。

Clash Verge Rev 使用 nixpkgs 里的 `clash-verge-rev`，只安装在 `desktop`。配置已开启自动启动、Service Mode 和 TUN Mode；订阅、节点和规则数据属于本机运行配置，不提交到 Git。

Chrome 和 VSCodium 只安装在 `desktop`。Codex CLI 使用 nixpkgs 里的 `codex`，安装在通用配置里，所以 `desktop` 和 `wsl` 都可以直接使用 `codex` 命令。

第一次安装之后，日常本地或远程部署可以用 `nixos-cli`。`nixos-anywhere` 主要留给还需要分区和安装的新设备。

## 密钥与加密配置

密钥和敏感配置使用 `sops-nix` 和 age 管理。

这些加密文件可以上传到 GitHub：

```text
.sops.yaml
secrets/cc-switch.yaml
```

不要提交 age 私钥。本仓库使用的私钥在系统里应放在：

```text
/var/lib/sops-nix/key.txt
```

在已有机器上，工作副本可以放在：

```text
~/.config/sops/age/keys.txt
```

安装新机器时，要在运行 `nixos-install` 之前，或者第一次需要 secrets 的 rebuild 之前，把同一个私钥复制到系统位置。使用 `nixos-anywhere` 时，优先使用前面安装步骤里的 `--extra-files ./extra-files`。

```bash
sudo mkdir -p /var/lib/sops-nix && \
sudo cp ~/.config/sops/age/keys.txt /var/lib/sops-nix/key.txt && \
sudo chmod 600 /var/lib/sops-nix/key.txt
```

编辑加密的 cc-switch 配置：

```bash
SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
nix shell nixpkgs#sops -c sops secrets/cc-switch.yaml
```

解密后的内容会由 `sops-nix` 写入：

```text
~/.config/cc-switch/provider-env
```

`cc-switch.db` 是本机运行时状态，保留在本地，不要提交。
