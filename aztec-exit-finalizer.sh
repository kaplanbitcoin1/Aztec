
import requests
import subprocess
import time

url = "https://api.testnet.aztecscan.xyz/v1/temporary-api-key/l1/l2-validators"

try:
    response = requests.get(url)
    response.raise_for_status()
    data = response.json()
except Exception as e:
    print(f"❌ Failed to fetch data from API: {e}")
    exit(1)

exiting = [v for v in data if v.get("status") == 3]

print(f"✅ {len(exiting)} EXITING validators found.")

for v in exiting:
    addr = v["attester"]
    print(f"> Finalizing: {addr}")
    try:
        subprocess.run(["aztec", "finalize-exit", "--validator", addr], check=True)
        time.sleep(1)
    except subprocess.CalledProcessError as e:
        print(f"❌ Error: {e}")
