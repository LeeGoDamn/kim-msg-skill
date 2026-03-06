#!/usr/bin/env bash
# Kim 消息发送包装脚本
# 自动加载密钥：优先使用环境变量，若无则从 ~/.openclaw/.secrets 读取
# 用法：./send.sh -u <用户名> -m <消息内容>

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_FILE="$HOME/.openclaw/.secrets"

# 优先使用已设置的环境变量
if [ -z "$KIM_APP_KEY" ] || [ -z "$KIM_SECRET_KEY" ]; then
  # 环境变量未设置，尝试从 .secrets 文件读取
  if [ -f "$SECRETS_FILE" ]; then
    export KIM_APP_KEY=$(grep "KIM_APPKEY" "$SECRETS_FILE" | cut -d= -f2)
    export KIM_SECRET_KEY=$(grep "KIM_SECRET" "$SECRETS_FILE" | cut -d= -f2)
  fi
fi

# 最终检查
if [ -z "$KIM_APP_KEY" ] || [ -z "$KIM_SECRET_KEY" ]; then
  echo "❌ 错误：缺少 Kim 密钥配置"
  echo ""
  echo "请用以下任一方式配置："
  echo "  1. 设置环境变量："
  echo "     export KIM_APP_KEY=your_app_key"
  echo "     export KIM_SECRET_KEY=your_secret_key"
  echo ""
  echo "  2. 或将密钥存入 ~/.openclaw/.secrets 文件："
  echo "     KIM_APPKEY=your_app_key"
  echo "     KIM_SECRET=your_secret_key"
  exit 1
fi

exec "$SCRIPT_DIR/message.js" "$@"
