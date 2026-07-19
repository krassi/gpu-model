# gpu-model

Discover, serve, snapshot, and restore [llama.cpp](https://github.com/ggml-org/llama.cpp) models from one command. Built for running local LLMs on a Jetson Orin (or any Linux box with llama.cpp).

## What it does

- **Auto-discovers** GGUF files across your model directories (follows Hugging Face cache symlinks, hides split-model parts).
- **Loads** a model into memory as a persistent `llama-server`, with configurable parallel slots, context window, and **GPU or CPU** placement.
- **Snapshots** the set of loaded models to JSON and **restores** it with one command — restore re-resolves each model by name, so it survives path changes.

## Usage

```sh
gpu-model list                                     # list discoverable models + sizes
gpu-model load qwen3-coder --device gpu --slots 4 --ctx 32768
gpu-model load Foundation-Sec-8B-Instruct --device cpu   # keep GPU free for the big model
gpu-model ps                                       # what's loaded
gpu-model stop 8080                                # stop by port, name, or 'all'
gpu-model save  ~/stacks/dev.json                  # snapshot running set
gpu-model restore ~/stacks/dev.json                # recreate it
gpu-model run qwen3-coder                          # interactive one-shot chat
```

`load` options: `--device gpu|cpu`, `--slots N`, `--ctx N`, `--port P`, and `-- <extra args>` passed straight to `llama-server`.

## Configuration

Defaults can be overridden via `/etc/gpu-model/config` or `~/.config/gpu-model/config` (sourced as shell). See `packaging/gpu-model.conf.example`. Key variables:

- `LLAMA_BIN` — directory with `llama-server` / `llama-cli` (default `/home/ghost/llama.cpp/build/bin`).
- `GPU_MODEL_DIRS` — space-separated dirs to scan for `.gguf` files.

## Requirements

`bash`, `python3`, `curl`, `iproute2` (`ss`), plus a built llama.cpp.

## Building a .deb

**Quick (no debhelper needed):**

```sh
make deb
sudo apt install ./build/gpu-model_0.1.0_all.deb
```

**Standard Debian source package (needs debhelper):**

```sh
sudo apt install debhelper
dpkg-buildpackage -us -uc -b
sudo apt install ../gpu-model_0.1.0_all.deb
```

## Install without packaging

```sh
sudo make install     # -> /usr/bin/gpu-model, man page, docs
```

## License

MIT — see [LICENSE](LICENSE).
