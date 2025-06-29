# 🪙 Foundry Fund Me

A decentralized crowdfunding smart contract built with [Foundry](https://book.getfoundry.sh/).  
Anyone can fund the contract in ETH, and the owner can withdraw the funds.  
Uses Chainlink Price Feeds to enforce a minimum USD equivalent contribution.

---

## 🚀 Features

✅ Accepts ETH from multiple funders  
✅ Records each funder’s contribution  
✅ Enforces a configurable minimum funding amount in USD  
✅ Allows only the contract owner to withdraw funds  
✅ Fully tested with Foundry  

---


## 🛠️ Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- An Ethereum node (Alchemy, Infura, etc.)
- A funded wallet private key

---

## ⚙️ Installation

Clone the repository:

```bash
git clone https://github.com/itsvishalyadav/Foundry-Fund-Me.git
cd Foundry-Fund-Me
```
Install dependencies:

```bash
forge install
```

🧪 Running Tests
Run all tests:

```bash
forge test
```
Run tests with gas reporting:

```bash
forge test --gas-report
```
📝 Deployment
🚀 Local Deployment (Anvil)
1️⃣ Start Anvil:

```bash
anvil
```
2️⃣ Deploy contract:

```bash
forge script script/DeployFundMe.s.sol \
  --rpc-url http://localhost:8545 \
  --private-key <YOUR_PRIVATE_KEY> \
  --broadcast
```
🌐 Testnet Deployment (e.g., Sepolia)
```bash
forge script script/DeployFundMe.s.sol \
  --rpc-url <YOUR_RPC_URL> \
  --private-key <YOUR_PRIVATE_KEY> \
  --broadcast \
  --verify
```
## 🔒 Security Considerations
- Uses Chainlink data feeds for reliable price conversion

- Never commit private keys to version control

- Thoroughly test all functionality before deploying to mainnet

## 🙌 Acknowledgements
Inspired by:

- Patrick Collins’s Foundry and Solidity tutorials

- Chainlink Price Feeds

- Foundry’s blazing fast tooling
