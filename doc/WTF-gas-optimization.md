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

uint8 二进制表示为 00000000，其中每一位有 0、1 两种情况，我们默认为 1 时则为 true，0 为 false，此时可以达到将 bool 值以位的形式来进行管理。

**Testing**

```
forge test --match-contract BitmapTest --gas-report
```

**Gas report**

| Function Name         | Gas Cost |
| --------------------- | -------- |
| **setDataWithBitmap** | 22366 ✅ |
| setDataWithBoolArray  | 35729    |

1. 结合实际情况下，建议优先使用 位运算符 进行部分变量管理。

### 4. use unchecked

我们知道在 solidity 0.8 版本之前，需要手动引入 SafeMath 库来确保数据的安全性，避免数据发生溢出，从而产生数据溢出攻击。

在 solidity 0.8 版本之后，solidity 会在每一次数据发生变更时，进行一个检查，判断是否溢出，从而决定是否抛出异常。

这样同时也因为检测带了额外的 gas 消耗，通过合理的使用 unchecked，可以有效去掉中间检测环节，从而达到 gas 节省的目的。

**Testing**

```
forge test --match-contract UncheckedTest --gas-report
```

**Gas report**

| Function Name    | Gas Cost  |
| ---------------- | --------- |
| forNormal        | 1910309   |
| **forUnckecked** | 510287 ✅ |

1. 在安全性可控情况下，建议优先选择 unchecked 用于 gas 优化。

### 5. use custom error over require/assert

**Testing**

```
forge test --match-contract ErrorTest --gas-report
```

**Gas report**

| Error Name | Gas Cost |
| ---------- | -------- |
| Assert     | 180      |
| Require    | 268      |
| **Revert** | 164 ✅   |

1. revert 兼顾既可以抛出错误信息又可以抛出相关变量两种优点，优先推荐使用；
2. require 中的字符串会存储在链上，一方面会消耗更多的 gas，一方面会让合约体积更大，建议结合实际需求选用。
3. 如有使用 assert 的场景，建议用 revert 进行平替。
