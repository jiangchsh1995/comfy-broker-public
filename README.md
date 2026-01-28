# Comfy Broker

ComfyUI 代理服务，支持多 Worker 节点负载均衡和自动故障转移。

## 功能

- 多 Worker 节点管理
- 自动健康检查和故障转移
- 优先级调度
- 客户端粘性会话
- WebSocket 代理支持
- Cloudflare Tunnel 集成

## 快速部署

### Cloudflare worker版 一键部署

[点击这里在 Cloudflare 上部署](https://dash.cloudflare.com/)

Fork 本仓库后，在 Cloudflare Worker 中导入模板即可。

1. 登录 [Cloudflare](https://cloudflare.com) 并创建一个账户（如果还没有的话）。
2. 进入 [Cloudflare Workers](https://workers.cloudflare.com/) 控制台。
3. 点击 **Create a Worker**，然后选择 **Start with an empty worker**。
4. 在新创建的 Worker 页面，点击 **Quick Edit**，将代码替换为本仓库中的代码。
5. 保存并部署。

在 Cloudflare Worker 中配置环境变量：

- 在 Worker 设置页的 **Environment Variables** 部分，添加以下环境变量：
  - `BROKER_SECRET`: 你的 Broker 认证密钥
  - `BROKER_HOSTNAME`: 你的对外域名

配置完后，点击 **Deploy** 即可将 Worker 部署到 Cloudflare。

> 注意：Cloudflare Worker 版不需要 `CF_TUNNEL_TOKEN`，如果你不使用 Tunnel 功能，请将此环境变量留空。

### Zeabur 一键部署

[![Deploy on Zeabur](https://zeabur.com/button.svg)](https://zeabur.com/templates/comfy-broker)

Fork 本仓库后，在 Zeabur 中导入即可。

### Docker 部署

```bash
git clone https://github.com/your-username/comfy-broker.git
cd comfy-broker
docker build -t comfy-broker .
docker run -d \
  -e BROKER_SECRET=your_secret \
  -e BROKER_HOSTNAME=your.domain.com \
  -e CF_TUNNEL_TOKEN=your_cloudflare_tunnel_token \
  -v /path/to/data:/data \
  comfy-broker
```

## 环境变量

| 变量 | 必填 | 默认值 | 说明 |
|------|------|--------|------|
| `BROKER_SECRET` | 是 | - | Broker 认证密钥 |
| `BROKER_HOSTNAME` | 是 | - | 对外域名（仅域名，不含协议） |
| `CF_TUNNEL_TOKEN` | 是 | - | Cloudflare Tunnel Token/Cloudflare worker版不需要 |
| `PORT` | 否 | `8080` | 服务端口 |
| `DATA_DIR` | 否 | `/data` | 数据持久化目录 |
| `HEARTBEAT_TTL` | 否 | `45` | Worker 心跳超时（秒） |
| `MAX_WORKERS` | 否 | `50` | 最大 Worker 数量 |

## 获取 Cloudflare Tunnel Token

1. 登录 [Cloudflare Zero Trust](https://one.dash.cloudflare.com/)
2. 进入 **Networks** > **Tunnels**
3. 创建 Tunnel，选择 **Cloudflared** 类型
4. 复制 Token（`--token` 后面的部分）
5. 在 **Public Hostnames** 添加域名映射到 `http://127.0.0.1:8080`

## kaggle 配置

kaggle 端需要配置：

```python
BROKER_BASE   = "https://your.domain.com"  # 对应 BROKER_HOSTNAME
BROKER_SECRET = "your_secret"               # 与 Broker 一致
```

## API 端点

| 端点 | 方法 | 说明 |
|------|------|------|
| `/healthz` | GET | 健康检查 |
| `/workers` | GET | 查看所有 Worker |
| `/_relay` | GET | 管理界面 |
| `/register` | POST | Worker 注册 |
| `/heartbeat` | POST | Worker 心跳 |
| `/switch/{worker_id}` | POST | 切换 Worker |
| `/unpin` | POST | 取消 Worker 固定 |

## 许可证

Other
