#!/usr/bin/env bash
# 发布脚本：把写好的文章提交并推送到 GitHub（手动同步）
# 用法: ./sync.sh "发布说明（可选，默认 'update posts'）"
set -e

if [ -z "$(git status --porcelain)" ]; then
  echo "⚠️ 没有需要同步的改动。"
  exit 0
fi

git add -A
msg="${1:-update posts}"
git commit -m "$msg"
git push
echo "✅ 已同步到 GitHub，稍候 1-2 分钟访问博客即可见新文章。"
