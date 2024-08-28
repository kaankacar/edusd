// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/EdUsd.sol";
import "./mocks/MockV3Aggregator.sol";

contract EdUsdTest is Test {
    EdUsd public edUsd;
    MockV3Aggregator public mockPriceFeed;

    address public owner;
    address public user1;
    address public user2;

    uint8 public constant DECIMALS = 6;
    int256 public constant INITIAL_PRICE = 1000000; // $1.00

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);

        mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        
        vm.prank(owner);
        edUsd = new EdUsd();
        edUsd.setPriceFeed(address(mockPriceFeed));
    }

    function testInitialSetup() public {
        assertEq(edUsd.name(), "Educational USD");
        assertEq(edUsd.symbol(), "edUSD");
        assertEq(edUsd.totalSupply(), 1_000_000_000 * 10**18);
        assertEq(edUsd.getContractBalance(), 1_000_000_000 * 10**18);
    }

    function testClaim() public {
        vm.prank(user1);
        edUsd.claim();
        assertEq(edUsd.balanceOf(user1), 1e18);
        assertEq(edUsd.getContractBalance(), (1_000_000_000 * 10**18) - 1e18);
    }

    function testMultipleClaims() public {
        for(uint i = 0; i < 5; i++) {
            vm.prank(user1);
            edUsd.claim();
        }
        assertEq(edUsd.balanceOf(user1), 5e18);
    }

    function testClaimFailsWhenContractBalanceInsufficient() public {
        // Claim all but 1 wei
        uint256 claimAmount = edUsd.getContractBalance() - 1;
        uint256 claimTimes = claimAmount / 1e18;
        
        for(uint i = 0; i < claimTimes; i++) {
            vm.prank(user1);
            edUsd.claim();
        }

        vm.expectRevert("Insufficient contract balance");
        vm.prank(user2);
        edUsd.claim();
    }

    function testRebase() public {
        // Set price to $1.10
        mockPriceFeed.updateAnswer(1100000);

        vm.warp(block.timestamp + 1 hours + 1);
        edUsd.rebase();

        uint256 expectedSupplyIncrease = (edUsd.totalSupply() * 100000 * edUsd.rebasePercentage()) / (1000000 * 1000000);
        assertEq(edUsd.totalSupply(), 1_000_000_000 * 10**18 + expectedSupplyIncrease);
    }

    function testRebaseCooldown() public {
        vm.expectRevert("Rebase cooldown not met");
        edUsd.rebase();
    }

    function testSetTargetPrice() public {
        uint256 newTargetPrice = 1100000; // $1.10
        vm.prank(owner);
        edUsd.setTargetPrice(newTargetPrice);
        assertEq(edUsd.targetPrice(), newTargetPrice);
    }

    function testSetRebaseCooldown() public {
        uint256 newCooldown = 2 hours;
        vm.prank(owner);
        edUsd.setRebaseCooldown(newCooldown);
        assertEq(edUsd.rebaseCooldown(), newCooldown);
    }

    function testSetRebasePercentage() public {
        uint256 newPercentage = 2 * 1e4; // 2%
        vm.prank(owner);
        edUsd.setRebasePercentage(newPercentage);
        assertEq(edUsd.rebasePercentage(), newPercentage);
    }

    function testSetPriceFeed() public {
        address newPriceFeed = address(0x123);
        vm.prank(owner);
        edUsd.setPriceFeed(newPriceFeed);
        assertEq(address(edUsd.priceFeed()), newPriceFeed);
    }

    function testOnlyOwnerFunctions() public {
        vm.prank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        edUsd.setTargetPrice(1100000);

        vm.prank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        edUsd.setRebaseCooldown(2 hours);

        vm.prank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        edUsd.setRebasePercentage(2 * 1e4);

        vm.prank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        edUsd.setPriceFeed(address(0x123));
    }
}