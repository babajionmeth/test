```bash
while true; do

    echo_green ">> Starting swarm trainer..."

    sed -i.bak 's/^\([[:space:]]*\)yarn build/\1# yarn build/' "$ROOT/run_rl_swarm.sh"

    if ! python -m rgym_exp.runner.swarm_launcher \
        --config-path "$ROOT/rgym_exp/config" \
        --config-name "rg-swarm.yaml"; then
        echo_red ">> Swarm trainer exited with error. Restarting in 5 seconds... (Press Ctrl+C to stop)"
    else
        echo_green ">> Swarm trainer exited normally. Restarting in 5 seconds... (Press Ctrl+C to stop)"
    fi

    sed -i -E 's/(startup_timeout: *float *= *)[0-9.]+/\1120/' $(python3 -c "import hivemind.p2p.p2p_daemon as m; print(m.__file__)")
    sleep 5
done
```
```bash 
wget https://github.com/gensyn-ai/rl-swarm/archive/refs/tags/v0.5.5.tar.gz
```
```bash
git clone https://github.com/babajionmeth/rl-swarm-0.5.5 && cd rl-swarm-0.5.5 && chmod +x run_rl_swarm.sh
```
```bash
communications:
  initial_peers:
    - '/ip4/144.91.66.61/tcp/40011/p2p/QmQ2gEXoPJg6iMBSUFWGzAabS2VhnzuS782Y637hGjfsRJ'
    - '/ip4/144.91.66.61/tcp/40012/p2p/QmWhiaLrx3HRZfgXc2i7KW5nMUNK7P9tRc71yFJdGEZKkC'
    - '/ip4/144.91.66.61/tcp/40013/p2p/QmQa1SCfYTxx7RvU7qJJRo79Zm1RAwPpkeLueDVJuBBmFp'
```
```bash
CUDA_VISIBLE_DEVICES=2 ./run_rl_swarm.sh
```
```bash
python3 -m venv .venv && source .venv/bin/activate
```
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash 
```
```bash
source ~/.bashrc
```







