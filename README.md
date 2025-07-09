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
# GitHub Personal Access Token を使用して認証
docker login ghcr.io -u YOUR_GITHUB_USERNAME
```

または、GitHub CLI を使用：

```bash
# GitHub CLI で認証（推奨）
gh auth login
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

### 2. イメージの取得

```bash
# 最新版を取得
docker pull ghcr.io/atman-inc/docker-claude-code:latest

# 特定のコミット版を取得
docker pull ghcr.io/atman-inc/docker-claude-code:main-<commit-sha>
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
# カレントディレクトリをマウント
docker run -it --rm \
  -v $(pwd):/workspace \
  ghcr.io/atman-inc/docker-claude-code:latest

# 特定のディレクトリをマウント
docker run -it --rm \
  -v /path/to/your/project:/workspace \
  ghcr.io/atman-inc/docker-claude-code:latest

# 複数のディレクトリをマウント
docker run -it --rm \
  -v /path/to/project:/workspace \
  -v /path/to/config:/config \
  ghcr.io/atman-inc/docker-claude-code:latest
```

### Claude Code の実行

コンテナ内で Claude Code を使用する方法：

```bash
# コンテナ内でシェルを起動
docker run -it --rm \
  -v $(pwd):/workspace \
  ghcr.io/atman-inc/docker-claude-code:latest \
  /bin/bash

# コンテナ内で直接 Claude Code を実行
docker run -it --rm \
  -v $(pwd):/workspace \
  ghcr.io/atman-inc/docker-claude-code:latest \
  claude-code --help
```

### 実用的な使用例

```bash
# Node.js プロジェクトでの開発
docker run -it --rm \
  -v $(pwd):/workspace \
  -p 3000:3000 \
  ghcr.io/atman-inc/docker-claude-code:latest \
  /bin/bash

# Git リポジトリでの作業（SSH キーをマウント）
docker run -it --rm \
  -v $(pwd):/workspace \
  -v ~/.ssh:/home/node/.ssh:ro \
  ghcr.io/atman-inc/docker-claude-code:latest

# 環境変数を設定して実行
docker run -it --rm \
  -v $(pwd):/workspace \
  -e NODE_ENV=development \
  -e TZ=Asia/Tokyo \
  ghcr.io/atman-inc/docker-claude-code:latest
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
      - ~/.ssh:/home/node/.ssh:ro
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

# 認証情報のクリア
docker logout ghcr.io

# 再認証
docker login ghcr.io
```

### パーミッションエラー

```bash
# ユーザー ID を合わせて実行
docker run -it --rm \
  -v $(pwd):/workspace \
  -u $(id -u):$(id -g) \
  ghcr.io/atman-inc/docker-claude-code:latest
```

### ネットワークエラー

```bash
# ホストネットワークを使用
docker run -it --rm \
  --network host \
  -v $(pwd):/workspace \
  ghcr.io/atman-inc/docker-claude-code:latest
```

## 要件

- Docker 20.10 以上
- GitHub アカウント（GHCR アクセス用）
- GitHub Personal Access Token または GitHub CLI（認証用）

## ライセンス

MIT License - 詳細は LICENSE ファイルを参照してください。
