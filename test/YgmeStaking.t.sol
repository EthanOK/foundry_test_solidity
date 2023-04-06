// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/YgmeStaking.sol";
import "../src/Nft.sol";
import "../src/USDT.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract YgmeStakingTest is Test, ERC721Holder, YgmeStakingDomain {
    YgmeStaking ygmeStaking;

    IERC721 _ygme;
    IERC20 _erc20;
    address _withdrawSigner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint64[3] _periods = [uint64(60), uint64(120), uint64(360)];

    function setUp() public {
        _ygme = new Nft("YGME", "YGME");
        _erc20 = new USDT();
        ygmeStaking = new YgmeStaking(
            address(_ygme),
            address(_erc20),
            _withdrawSigner,
            [uint64(60), 120, 360]
        );
        _ygme.setApprovalForAll(address(ygmeStaking), true);

        _erc20.transfer(address(ygmeStaking), _erc20.totalSupply() / 2);

        vm.prank(msg.sender);
        _ygme.setApprovalForAll(address(ygmeStaking), true);
    }

    function testPrint() public view {
        console.log("_ygme:", address(_ygme));
        console.log("_erc20:", address(_erc20));
        console.log("ygmeStaking:", address(ygmeStaking));
        console.log("Test(this):", address(this));
        console.log("msg.sender:", msg.sender);
        //   _ygme: 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
        //   _erc20: 0x2e234DAe75C793f67A35089C9d99245E1C58470b
        //   ygmeStaking: 0xF62849F9A0B5Bf2913b396098F7c7019b51A820a
        //   Test(this): 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
        //   msg.sender: 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
    }

    function testGetMyTokens() public view {
        address account = address(this);
        uint256 a = _erc20.balanceOf(account);
        uint256 b = _erc20.totalSupply();

        console.log("usdt totalSupply:", b);
        console.log("usdt balanceOf:", a);

        uint256 amount = _ygme.balanceOf(account);
        console.log("nft balanceOf:", amount);
    }

    function testStaking() public {
        address account = address(this);
        uint256[] memory tokenIds = new uint256[](3);
        tokenIds[0] = 1;
        tokenIds[1] = 3;
        tokenIds[2] = 5;
        ygmeStaking.staking(tokenIds, 60);
        assertEq(ygmeStaking.accountTotal(), 1);
        assertEq(ygmeStaking.ygmeTotal(), 3);

        uint256[] memory stakingamount = ygmeStaking.getStakingTokenIds(
            account
        );
        assertEq(tokenIds, stakingamount);

        _ygme.safeTransferFrom(account, msg.sender, 7);

        vm.prank(msg.sender);
        uint256[] memory tokenIds_ = new uint256[](1);
        tokenIds_[0] = 7;
        ygmeStaking.staking(tokenIds_, 120);

        console.log("ygmeTotal:", ygmeStaking.ygmeTotal());

        console.log("accountTotal:", ygmeStaking.accountTotal());
    }

    function testUnStake() public {
        // address account = address(this);
        uint256[] memory tokenIds = new uint256[](2);
        tokenIds[0] = 1;
        tokenIds[1] = 3;

        // set block.timestamp
        vm.warp(100);

        testStaking();

        vm.warp(160);

        ygmeStaking.unStake(tokenIds);
        console.log("```````````unStake````````````");
        console.log("ygmeTotal:", ygmeStaking.ygmeTotal());

        console.log("accountTotal:", ygmeStaking.accountTotal());
    }

    function testFailStakingInvalidOwner() public {
        // invalid owner
        address account = address(this);

        _ygme.safeTransferFrom(account, msg.sender, 1);

        uint256[] memory tokenIds = new uint256[](3);
        tokenIds[0] = 1;
        tokenIds[1] = 3;
        tokenIds[2] = 5;

        // set block.timestamp
        vm.warp(100);
        // ownerOf(1) = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38(msg.sender)
        // now: this call ygmeStaking
        ygmeStaking.staking(tokenIds, 60);
    }

    function testFailUnStake() public {
        // too early to unStake
        uint256[] memory tokenIds = new uint256[](3);
        tokenIds[0] = 1;
        tokenIds[1] = 3;
        tokenIds[2] = 5;

        // set block.timestamp
        vm.warp(100);

        ygmeStaking.staking(tokenIds, 60);

        console.log("ygmeTotal:", ygmeStaking.ygmeTotal());

        vm.warp(120);

        ygmeStaking.unStake(tokenIds);

        console.log("ygmeTotal:", ygmeStaking.ygmeTotal());
    }

    function testFailInvalidStakeTime() public {
        // invalid stake time
        uint256[] memory tokenIds = new uint256[](3);
        tokenIds[0] = 1;
        tokenIds[1] = 3;
        tokenIds[2] = 5;
        ygmeStaking.staking(tokenIds, 100);
    }

    function testWithdrawERC20() public {
        uint256 orderId = 1;
        address account = address(1);
        uint256 amount = 100000000;
        string memory random = "rweeftgreyhbn";
        bytes
            memory signature = hex"9959871139ad6a761b8bd21273d81573d115d8ad86b226a943f2dac0172af8d956a4ededd58f32adda35357ca61e75cb065e3580f2d2738143900ceb97bea18a1b";
        bytes memory data = abi.encode(orderId, account, amount, random);
        console.logBytes(data);
        bytes32 hash = getHash(data);
        console.log("Hash");
        console.logBytes32(hash);
        Sig memory sig;
        (sig.r, sig.s, sig.v) = signatureToRSV(signature);

        console.log(_erc20.balanceOf(address(ygmeStaking)));

        vm.prank(account);
        ygmeStaking.withdrawERC20(data, sig);

        console.log(_erc20.balanceOf(address(ygmeStaking)));
        console.log(_erc20.balanceOf(account));
    }

    function getHash(bytes memory data) internal pure returns (bytes32) {
        return keccak256(data);
    }

    function signatureToRSV(
        bytes memory signature
    ) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(signature.length == 65, "Invalid signature length");

        assembly {
            // First 32 bytes are the signature length
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        if (v < 27) {
            v += 27;
        }

        require(v == 27 || v == 28, "Invalid signature value");

        return (r, s, v);
    }
}
