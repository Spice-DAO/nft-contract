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
    NFT nft;


    function setUp() public {
        //console.log(unicode"🧪 Testing Mint...");
        //greeter = new Greeter("gm");
        //test = new ErrorsTest();
        nft = new NFT("https://ipfs.io/ipfs/QmU7VWfd3DN1Hh8fjALhQyJLgtkwxkYP2zz9MDT4rkyVJ1");
    }

    function testContractGas() public {
        NFT testNFT = new NFT("https://ipfs.io/ipfs/QmU7VWfd3DN1Hh8fjALhQyJLgtkwxkYP2zz9MDT4rkyVJ1");
    }


    function testFailLaunch() public {
        assertEq(address(nft), address(0));
    }

    function testMint() public {
        cheats.prank(address(1));
        cheats.deal(address(1), 2 ether);
        nft.mintNft{value: 0.15 ether}(1);
        assertEq(nft.balanceOf(address(1)), 1);
    }

    function testFailMintPrice() public {
        cheats.prank(address(1));
        cheats.deal(address(1), 2 ether);
        nft.mintNft{value: 0.12 ether}(1);
        assertEq(nft.balanceOf(address(1)), 1);
    }

    function testMultiMint() public {
        cheats.prank(address(1));
        cheats.deal(address(1), 2 ether);
        nft.mintNft{value: 0.3 ether}(2);
        assertEq(nft.balanceOf(address(1)), 2);
    }

    function testFailMultiMintPrice() public {
        cheats.prank(address(1));
        cheats.deal(address(1), 2 ether);
        nft.mintNft{value: 0.1 ether}(2);
    }
    
    function testFailMultiMintQuantity() public {
        cheats.prank(address(1));
        cheats.deal(address(1), 2 ether);
        nft.mintNft{value: 0.3 ether}(5);
    }

    function testWithdraw() public {
        cheats.prank(address(1));
        cheats.deal(address(1), 2 ether);
        nft.mintNft{value: 0.15 ether}(1);
        nft.withdraw();
        assertGt(address(1234).balance, 0);
    }

    function testReveal() public {
        cheats.prank(address(1));
        cheats.deal(address(1), 2 ether);
        nft.mintNft{value: 0.15 ether}(1);
        assertEq(nft.tokenURI(1), "NOTREVEALED.JPG");
    }

    
    function testReveal2() public {
        cheats.prank(address(1));
        cheats.deal(address(1), 2 ether);
        nft.mintNft{value: 0.15 ether}(1);
        nft.reveal();
        assertEq(nft.tokenURI(1), "https://ipfs.io/ipfs/QmU7VWfd3DN1Hh8fjALhQyJLgtkwxkYP2zz9MDT4rkyVJ11.json");
    }

    //Only owner can set contract to revealed
    function testFailReveal() public {
        cheats.prank(address(1));
        cheats.deal(address(1), 2 ether);
        nft.mintNft{value: 0.15 ether}(1);
        cheats.prank(address(1));
        nft.reveal();
    }

    function testTransfer() public 
    {
        cheats.prank(address(1));
        cheats.deal(address(1), 2 ether);
        nft.mintNft{value: 0.15 ether}(1);
        cheats.prank(address(1));
        nft.safeTransferFrom(address(1), address(2), 1);
        assertEq(nft.balanceOf(address(2)), 1);
    }


    function testMaxMint() public {
        for(uint160 i = 1; i < 10000; i++){
            cheats.prank(address(i));
            cheats.deal(address(i), 2 ether);
            nft.mintNft{value: 0.15 ether}(1);
        }

        bool testResult = true;
        for(uint160 i= 1; i < 10000; i++){
            if(nft.balanceOf(address(i)) == 0){
                testResult = false;
            }
        assertTrue(testResult);
        }
    }

    function testFailMaxMint() public {
        for(uint160 i = 1; i < 10000; i++){
            cheats.prank(address(i));
            cheats.deal(address(i), 2 ether);
            nft.mintNft{value: 0.15 ether}(1);
        }

    }

}
