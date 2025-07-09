# Docker Claude Code

A Docker image for Claude Code with Node.js v22, SSH, and Git support.

## Features

- Node.js v22 runtime environment
- SSH client and server support
- Git version control
- Claude Code AI assistant integration
- Security firewall configuration
- VS Code devcontainer support

## Building the Image

```bash
docker build -t claude-code .
```

## Running the Container

```bash
docker run -it --rm --cap-add=NET_ADMIN --cap-add=NET_RAW claude-code
```

## Using with VS Code

This repository includes a `.devcontainer` configuration for seamless VS Code integration:

1. Open the repository in VS Code
2. Install the "Dev Containers" extension
3. Use "Reopen in Container" command

## Security

The container includes a firewall script that restricts network access to approved domains for enhanced security when using Claude Code.

## Requirements

- Docker
- VS Code with Dev Containers extension (optional)

## License

MIT License - see LICENSE file for details.
