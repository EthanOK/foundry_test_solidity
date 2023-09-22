// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/YGIO.sol";
import "../src/poolLP/YGIOStaking.sol";
import "../src/poolLP/LPToken.sol";
import "../src/poolLP/PoolsOfLP.sol";

contract PoolsOfLPTest is Test, PoolsOfLPDomain {
    YGIO ygio;
    YGIOStaking ygioStake;
    LPToken lp;
    PoolsOfLP poolsOfLP_1;

    address signer = vm.addr(110);

    function setUp() external {
        ygio = new YGIO(address(1e18));

        uint256 banlence1 = 1000 * 1e18;
        uint256 banlence2 = 2000 * 1e18;
        uint256 banlence3 = 3000 * 1e18;
        uint256 banlence4 = 4000 * 1e18;
        uint256 banlence5 = 5000 * 1e18;

        ygio.mint(address(1), banlence1);
        ygio.mint(address(2), banlence2);
        ygio.mint(address(3), banlence3);
        ygio.mint(address(4), banlence4);
        ygio.mint(address(5), banlence5);

        ygioStake = new YGIOStaking(address(ygio));

        lp = new LPToken();

        poolsOfLP_1 = new PoolsOfLP(
            "Pool_1",
            10_000,
            signer,
            address(ygio),
            address(ygioStake),
            address(lp)
        );

        vm.startPrank(address(1));
        ygio.approve(address(ygioStake), banlence1);
        ygioStake.stakingYGIO(banlence1, 30);
        lp.approve(address(poolsOfLP_1), banlence1);
        vm.stopPrank();

        vm.startPrank(address(2));
        ygio.approve(address(ygioStake), banlence2);
        ygioStake.stakingYGIO(banlence2, 30);
        lp.approve(address(poolsOfLP_1), banlence2);
        vm.stopPrank();

        vm.startPrank(address(3));
        ygio.approve(address(ygioStake), banlence3);
        ygioStake.stakingYGIO(banlence3, 30);
        lp.approve(address(poolsOfLP_1), banlence3);
        vm.stopPrank();

        vm.startPrank(address(4));
        ygio.approve(address(ygioStake), banlence4);
        ygioStake.stakingYGIO(banlence4, 30);
        lp.approve(address(poolsOfLP_1), banlence4);
        vm.stopPrank();

        vm.startPrank(address(5));
        ygio.approve(address(ygioStake), banlence5);
        ygioStake.stakingYGIO(banlence5, 30);
        lp.approve(address(poolsOfLP_1), banlence5);
        vm.stopPrank();

        // sign inviter mine owner
        bytes memory data = abi.encode(address(this), address(poolsOfLP_1));
        bytes32 hash = keccak256(data);
        hash = toEthSignedMessageHash(hash);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(110, hash);
        bytes memory signature = convertToBytesSignature(v, r, s);

        address recover = ecrecover(hash, v, r, s);
        assertEq(recover, signer);

        lp.approve(address(poolsOfLP_1), lp.balanceOf(address(this)));

        poolsOfLP_1.becomeMineOwner(signature);
    }

    function testGetMulFactor() external {
        assertEq(ygioStake.accountStakingTotal(), 5);
        (uint256 n, uint256 d) = ygioStake.getMulFactor(address(1));
        console.log(n, d);
    }

    function testFailBecomeMineOwner() external {
        vm.startPrank(address(1));

        bytes memory data = abi.encode(address(1), address(poolsOfLP_1));
        bytes32 hash = keccak256(data);
        hash = toEthSignedMessageHash(hash);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(110, hash);
        bytes memory signature = convertToBytesSignature(v, r, s);

        address recover = ecrecover(hash, v, r, s);
        assertEq(recover, signer);

        lp.approve(address(poolsOfLP_1), lp.balanceOf(address(1)));

        poolsOfLP_1.becomeMineOwner(signature);

        vm.stopPrank();
    }

    function testStakingLP() external {
        // sign inviter
        bytes memory data = abi.encode(
            address(1),
            address(this),
            address(poolsOfLP_1)
        );
        bytes32 hash = keccak256(data);
        hash = toEthSignedMessageHash(hash);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(110, hash);
        bytes memory signature = convertToBytesSignature(v, r, s);

        vm.startPrank(address(1));
        address _inviter = poolsOfLP_1.getMineOwner();
        poolsOfLP_1.stakingLP(100 * 1e18, _inviter, signature);
        StakeLPData memory stakeLPData = poolsOfLP_1.getStakeLPData(address(1));
        console.log(stakeLPData.startBlockNumber, stakeLPData.endBlockNumber);

        vm.roll(101);
        poolsOfLP_1.getPoolFactor();
        poolsOfLP_1.getInviteTotalBenefit(address(this));
        poolsOfLP_1.getStakeTotalBenefit(address(1));

        poolsOfLP_1.stakingLP(200 * 1e18, _inviter, signature);

        StakeLPData memory stakeLPData_2 = poolsOfLP_1.getStakeLPData(
            address(1)
        );
        console.log(
            stakeLPData_2.startBlockNumber,
            stakeLPData_2.endBlockNumber
        );

        vm.roll(201);
        poolsOfLP_1.getPoolFactor();
        poolsOfLP_1.getInviteTotalBenefit(address(this));
        poolsOfLP_1.getStakeTotalBenefit(address(1));

        vm.stopPrank();
    }

    function convertToBytesSignature(
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public pure returns (bytes memory) {
        bytes memory signature = new bytes(65);
        assembly {
            // 将r复制到前32字节
            mstore(add(signature, 0x20), r)
            // 将s复制到接下来的32字节
            mstore(add(signature, 0x40), s)
            // 将v复制到最后一个字节（最低有效位）
            mstore8(add(signature, 0x60), v)
        }
        return signature;
    }

    function toEthSignedMessageHash(
        bytes32 hash
    ) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            );
    }
}
