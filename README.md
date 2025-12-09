```bash
while true; do

    echo_green ">> Starting swarm trainer..."

    sed -i.bak 's/^\([[:space:]]*\)yarn build/\1# yarn build/' "$ROOT/run_rl_swarm.sh"

    if ! python -m rgym_exp.runner.swarm_launcher \
        --config-path "$ROOT/code_gen_exp/config" \
        --config-name "code-gen-swarm.yaml"; then
        echo_red ">> Swarm trainer exited with error. Restarting in 5 seconds... (Press Ctrl+C to stop)"
    else
        echo_green ">> Swarm trainer exited normally. Restarting in 5 seconds... (Press Ctrl+C to stop)"
    fi

   
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
```bash
grafana-server --homepath=/usr/share/grafana web
```
```bash
-- 1. Create or alter the worker role
DO
$$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = 'worker'
  ) THEN
    CREATE ROLE worker LOGIN;
  END IF;
  ALTER ROLE worker WITH PASSWORD 'password';
END
$$;

-- 2. Create the taskdb database (must be top-level SQL, not inside DO)
CREATE DATABASE taskdb OWNER worker;

```
```bash
sudo cat init_worker.sql | sudo -u postgres /usr/lib/postgresql/16/bin/psql
```
## to start the postergs before the do database command or postsql16
```bash
sudo supervisord -c /etc/supervisor/supervisord.conf
```











