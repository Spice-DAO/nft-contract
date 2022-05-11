// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.11;

import {NFT} from "../NFT.sol";
import "ds-test/test.sol";

interface CheatCodes {
    function prank(address, address) external;

    // Sets the *next* call's msg.sender to be the input address, and the tx.origin to be the second input
    function prank(address) external;

    // Sets the *next* call's msg.sender to be the input address
    function assume(bool) external;

    // When fuzzing, generate new inputs if conditional not met
    function deal(address who, uint256 newBalance) external;
    // Sets an address' balance
}


contract NFTTest is DSTest {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);


    function setUp() public {
        //console.log(unicode"🧪 Testing Mint...");
        //greeter = new Greeter("gm");
        //test = new ErrorsTest();
    }


    function testFailMint() public {
        NFT nft = new NFT("https://ipfs.io/ipfs/QmU7VWfd3DN1Hh8fjALhQyJLgtkwxkYP2zz9MDT4rkyVJ1");
        assertEq(address(nft), address(0));
    }
}
