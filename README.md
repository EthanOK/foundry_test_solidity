# foundry_demo

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

## WTF-gas-optimization

### 1. use constant and immutable

**Testing**

```
forge test --match-contract ConstantTest --gas-report
```

**Gas report**

| Function Name    | Gas Cost |
| ---------------- | -------- |
| varConstant      | 183 ✅   |
| **varImmutable** | 161 ✅   |
| variable         | 2305     |

1. 应尽量避免使用 variable 对变量进行定义；
2. 对于无需修改的常量，建议使用 immutable 进行定义，其在功能性和 gas 上均为最佳。

### 2. use calldata over memory

**Testing**

```
forge test --match-contract CalldataAndMemoryTest --gas-report
```

**Gas report**

| Function Name       | Gas Cost |
| ------------------- | -------- |
| **writeByCalldata** | 67905 ✅ |
| writeByMemory       | 68456    |

1. 结合实际情况下，建议优先使用 calldata 进行变量写入。

### 3. use Bitmap

**Testing**

```
forge test --match-contract BitmapTest --gas-report
```

**Gas report**

| Function Name       | Gas Cost |
| ------------------- | -------- |
| **writeByCalldata** | 67905 ✅ |
| writeByMemory       | 68456    |

1. 结合实际情况下，建议优先使用 calldata 进行变量写入。
