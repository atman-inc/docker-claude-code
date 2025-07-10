# Docker Claude Code

Node.js v22、SSH、Git をサポートした Claude Code 用の Docker イメージです。

## 機能

- Node.js v22 ランタイム環境
- SSH クライアント・サーバーサポート
- Git バージョン管理
- Claude Code AI アシスタント統合（`@anthropic-ai/claude-code` パッケージ）

## GitHub Container Registry からの利用

### 1. 認証

プライベートリポジトリのため、GitHub Container Registry への認証が必要です：

```bash
# 既にログインしている場合はログアウト
gh auth logout

# write:packages スコープ付きでログイン
gh auth login -s write:packages

# GHCRにログイン
docker login ghcr.io -u <GitHubユーザー名> -p$(gh auth token)
```

### 2. イメージの取得

```bash
# 最新版を取得
docker pull ghcr.io/atman-inc/docker-claude-code:latest
```

### 3. 基本的な実行

```bash
# 基本実行（一時的なコンテナ）
docker run -it --rm ghcr.io/atman-inc/docker-claude-code:latest

# バックグラウンド実行
docker run -d --name claude-code ghcr.io/atman-inc/docker-claude-code:latest
```

## ローカル開発での利用

### ローカルディレクトリのマウント

ローカルのプロジェクトディレクトリをコンテナ内の作業ディレクトリ（`/workspace`）にマウントして使用：

```bash
# 推奨設定（全機能を含む）
docker run -it --rm \
  -v ${PWD}:/workspace \
  -v ${HOME}/.ssh:/home/claude/.ssh:ro \
  -v ${HOME}/.claude.json:/home/claude/.claude.json \
  -v ${HOME}/.claude:/home/claude/.claude \
  ghcr.io/atman-inc/docker-claude-code:latest
```

### Claude Code の実行

コンテナ内で Claude Code を使用する方法：

```bash
# コンテナ内で直接 Claude を実行（基本的な使い方）
docker run -it --rm \
  -v $(pwd):/workspace \
  ghcr.io/atman-inc/docker-claude-code:latest \
  claude --help

# コンテナ内でシェルを起動（オプション）
docker run -it --rm \
  -v $(pwd):/workspace \
  ghcr.io/atman-inc/docker-claude-code:latest \
  /bin/bash
```

## Docker Compose での利用

`docker-compose.yml` の例：

```yaml
version: '3.8'
services:
  claude-code:
    image: ghcr.io/atman-inc/docker-claude-code:latest
    volumes:
      - .:/workspace
      - ${HOME}/.ssh:/home/claude/.ssh:ro
      - ${HOME}/.claude.json:/home/claude/.claude.json
      - ${HOME}/.claude:/home/claude/.claude
    environment:
      - NODE_ENV=development
      - TZ=Asia/Tokyo
    ports:
      - "3000:3000"
    stdin_open: true
    tty: true
```

実行：

```bash
docker-compose up -d
docker-compose exec claude-code /bin/bash
```

## ローカルビルド（開発者向け）

### イメージのビルド

```bash
docker build -t claude-code .
```

### ローカルビルド版の実行

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  claude-code
```

## トラブルシューティング

### 認証エラー

```bash
# 認証状態の確認
docker system info | grep -i registry

# GitHub CLI からログアウト
gh auth logout

# 再認証（write:packages スコープ付き）
gh auth login -s write:packages
docker login ghcr.io -u <GitHubユーザー名> -p$(gh auth token)
```

### パーミッションエラー

```bash
# ユーザー ID を合わせて実行
docker run -it --rm \
  -v $(pwd):/workspace \
  -u $(id -u):$(id -g) \
  ghcr.io/atman-inc/docker-claude-code:latest
```

## 要件

- Docker 20.10 以上
- GitHub アカウント（GHCR アクセス用）
- GitHub Personal Access Token または GitHub CLI（認証用）

## ライセンス

MIT License - 詳細は LICENSE ファイルを参照してください。
