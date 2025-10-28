# ⚡ GasSpikeTrap

## 🧠 Overview

**GasSpikeTrap** is a smart contract that detects sudden spikes in Ethereum gas prices (base fees) across recent blocks.  
It helps identify congestion events or transaction surges, enabling automated responses before network gas fees rise uncontrollably.

---

## ⚙️ Configure Development Environment

### 1️⃣ Install Foundry (for compiling and deploying Solidity contracts)
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
````

### 2️⃣ Install Bun (optional, faster than npm)

```bash
curl -fsSL https://bun.sh/install | bash
```

### 3️⃣ Install Node Modules

```bash
bun install
```

### 4️⃣ Install Drosera CLI

```bash
curl -L https://app.drosera.io/install | bash
droseraup
```

---

## 🔐 SSH Client Setup

You can manage your node or deploy remotely using:

* **[Termius](https://termius.com)** — Cross-platform SSH client with a modern GUI
* **[PuTTY](https://www.putty.org)** — Lightweight SSH client for Windows

Both allow you to securely connect to your Drosera or Foundry environment on a remote server.

---

## 🧩 Solidity Compiler Setup

In your environment (local or remote), set the Solidity compiler version in `foundry.toml`:

```toml
[profile.default]
solc_version = "0.8.20"
```

---

## 🚀 Quick Start

### GasSpikeTrap Example

The `drosera.toml` file is configured to deploy a **GasSpikeTrap** that triggers the
`handleGasSpikeAlert(uint256,uint256)` function when a significant base fee increase is detected.

```toml
response_contract = "0x1c7065eEe97182801e1C5653eFf75d4F2034A0C8"
response_function = "handleGasSpikeAlert(uint256,uint256)"
```

### To deploy the trap:

```bash
# Compile the Trap
forge build
```

---

## 🧱 GasSpikeTrap Setup

### 1️⃣ Build the Contracts

```bash
forge build
```

### 2️⃣ Deploy the Trap Contract

```bash
forge script script/Deploy.sol:DeployScript \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com \
  --private-key $PRIVATE_KEY \
  --broadcast
```

### 3️⃣ Verify Deployment

```bash
cast code 0xeec4ffF298A29F7eBAcbBeE47e0Dc7604bD69A64 \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com
```

---

## 🧮 Technical Details

* **Monitors:** Ethereum base fee (`block.basefee`) over a configurable block sample window
* **Triggers:** When the recent base fee average rises above a threshold (e.g., 20% higher than prior average)
* **Response:** Calls the response contract’s
  `handleGasSpikeAlert(uint256,uint256)` with the current block number and detected base fee

---

## 🌐 Deployment

| Parameter            | Value                                        |
| -------------------- | -------------------------------------------- |
| **Network**          | Hoodi Testnet (560048)                       |
| **Trap Address**     | `0x98bc34449C07bE4A290D3703D672867512aD20B7` |
| **Response Address** | `0x1c7065eEe97182801e1C5653eFf75d4F2034A0C8` |

---

## 🧰 Drosera Setup

### 1️⃣ Create the `drosera.toml` Configuration

```toml
ethereum_rpc = "https://ethereum-hoodi-rpc.publicnode.com"
drosera_rpc = "https://relay.hoodi.drosera.io"
eth_chain_id = 560048
drosera_address = "0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D"

[traps]

[traps.gasspiketr]
address = "0x98bc34449C07bE4A290D3703D672867512aD20B7"
path = "out/GasSpikeTrap.sol/GasSpikeTrap.json"
response_contract = "0x1c7065eEe97182801e1C5653eFf75d4F2034A0C8"
response_function = "handleGasSpikeAlert(uint256,uint256)"
cooldown_period_blocks = 33
min_number_of_operators = 1
max_number_of_operators = 2
block_sample_size = 10
private_trap = true
whitelist = ["YOUR_OPERATOR_ADDRESS"]
```

### 2️⃣ Apply the Trap Configuration

```bash
export DROSERA_PRIVATE_KEY=$PRIVATE_KEY
drosera apply
```

---

## 🧑‍💻 Operator Setup

### 1️⃣ Register Your Operator

```bash
drosera-operator register \
  --eth-rpc-url https://ethereum-hoodi-rpc.publicnode.com \
  --eth-private-key 0xYOUR_OPERATOR_PRIVATE_KEY \
  --drosera-address 0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D
```

### 2️⃣ Check Wallet Balance

```bash
cast balance 0xYOUR_OPERATOR_ADDRESS \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com
```

---

## 🎯 Purpose

**GasSpikeTrap** provides an automated safety mechanism for decentralized systems.
By detecting and reacting to network-wide gas spikes in real time, it ensures that DApps, bots, and relayers can **pause**, **reroute**, or **adapt** during volatile congestion periods — improving reliability and efficiency across Ethereum-based applications.

---

### 🧾 License

MIT © 2025 GasSpikeTrap Contributors | Discord: reckmondela01 | Twitter: ReckmonDela01
