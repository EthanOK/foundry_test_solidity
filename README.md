# foundry_demo

### Foundry Book

https://learnblockchain.cn/docs/foundry/i18n/zh/index.html

## Solidity 静态分析

https://learnblockchain.cn/docs/foundry/i18n/zh/config/static-analyzers.html

### Slither

slither.config.json

```json
{
  "filter_paths": "lib",
  "solc_remaps": [
    "ds-test/=lib/ds-test/src/",
    "forge-std/=lib/forge-std/src/",
    "@openzeppelin/=lib/openzeppelin-contracts/"
  ]
}
```

Prepare:

```
pip3 install slither-analyzer
pip3 install solc-select
solc-select install 0.8.18
solc-select use 0.8.18
```

Run Code:

`slither src/NFT.sol`

### Mythril

(Python 3.6-3.9)

```
rustup default nightly
pip3 install mythril
```

Run Code:

`myth analyze src/BankReen.sol --solc-json mythril.config.json`

Or Docker:(--solc-json /tmp/mythril.config.json 无效)

`docker run -v ${PWD}:/tmp mythril/myth analyze /tmp/src/BankReen.sol --solc-json /tmp/mythril.config.json --solv 0.8.18`

`docker run mythril/myth analyze -a 0x0000007eE460B0928c2119E3B9747454A10d1557 --rpc infura-mainnet --infura-id 39d28365cddf40f5ba2b714ee9ba3df1`

————————————————————————————————————————————————————————————————————

```
git clone https://github.com/EthanOK/foundry_demo.git
```

```
cd foundry_demo

forge install

forge build

forge test -vv

forge test --match-path test/YgmeStaking.t.sol -vvv

forge test --gas-report
```

## 合约部署与验证

foundry.toml

```
[rpc_endpoints]
goerli = "${GOERLI_RPC_URL}"
sepolia = "${SEPOLIA_RPC_URL}"
localhost = "http://127.0.0.1:8545"

[etherscan]
goerli = { key = "${ETHERSCAN_API_KEY}" }
sepolia = { key = "${ETHERSCAN_API_KEY}" }
```

### 1.1 部署:

```
forge script script/NFT.s.sol --rpc-url sepolia --broadcast
```

### 1.2 测试

(1) 将在名称中带有 testStakingLP_address_2 的 PoolsOfLPTest 测试合约中运行测试

```
forge test --match-contract PoolsOfLPTest --match-test testStakingLP_address_2 -vvvv --gas-report
```

(2) 运行路径为`test/PoolsOfLP.T.sol`的测试合约

```
forge test --match-path test/PoolsOfLP.T.sol -vvvv --gas-report
```

### 1.3 验证:

```
forge verify-contract --chain-id 5 --watch 0xf1425D05bFb4c7Fa33D8aa2289De18676Aa1B4C5 src/Counter.sol:Counter

```

### 2 部署与验证

```
forge script script/NFT.s.sol --rpc-url sepolia --broadcast --verify -vvvv
```

```

```

# 查看智能合约 storage 布局

`forge inspect --pretty src/YGIO.sol:YGIO storage`
