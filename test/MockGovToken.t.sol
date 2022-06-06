// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.12;

import "forge-std/Test.sol";
import "lib/pancake-swap-lib/contracts/token/BEP20/BEP20.sol";
import "src/MockGovToken.sol";

contract MockGovTokenTest is Test {
    MockGovToken govToken;
    
    address zeroAddress = address(0);
    address delegator1 = address(1);
    address delegator2 = address(2);
    address delegator3 = address(3);
    address delegatee1 = address(4);
    address delegatee2 = address(5);
    address delegatee3 = address(6);

    function setUp() external { 
        govToken = new MockGovToken();
    }

    function testMint() external {
        govToken.mint(address(govToken), 5000);
        assertEq(govToken.balanceOf(address(govToken)), 5000);
    }

    function testDelegate() external {
        govToken.delegate(address(delegatee1));
    }

    function testDelegateForZeroAddress() external {
        // Zero address should not be delegated
        govToken.delegate(address(zeroAddress));
    }

    function testDelegateForDoubleTokenUsageAndNoLock() external {
        /*
            Say if Alice has 100 tokens and she delegates Bob so he has power of 100 tokens. And because there is no lockup for tokens
            Alice can transfer her 100 tokens to Dan and again Dan can delegate Bob. So Bob now has power of 200 tokens with same 100 tokens.
            On other hand Alice can remove the delegated tokens from Bob before he votes for proposal which can make proposal success or failure.
        */
        address user1 = address(1);
        address user2 = address(2);
        address user3 = address(3);

        govToken.mint(user1, 100);
        assertEq(govToken.balanceOf(address(user1)), 100);
        // Alice delegates to Bob 100 tokens 
        govToken.delegate(address(user2));

        govToken.approve(user3, 50);

        // Alice transfers to Charles 50 tokens
        vm.prank(address(user1));
        govToken.transfer(address(user3), 50);

        vm.prank(address(user3));
        govToken.delegate(address(user2));
    }

    function testDelegateForFailure() external {
        /*
            
        */
        address alice = address(1);
        address bob = address(2);
        address charles = address(3);
        address dan = address(4);

        govToken.mint(alice, 1000);
        govToken.mint(charles, 100);
        assertEq(govToken.balanceOf(address(alice)), 1000);
        assertEq(govToken.balanceOf(address(charles)), 100);
        // Alice delegates to Bob 100 tokens 
        vm.prank(address(alice));
        govToken.delegate(address(bob));   

        // Charles sends his tokens to Alice 
        vm.prank(address(charles));
        govToken.transfer(address(alice), 100);

        // Balance after transfer
        assertEq(govToken.balanceOf(address(alice)), 1100);

        vm.prank(address(alice));
        govToken.delegate(address(dan)); 
    }
}
