// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.11;

//this just needs to supply NFTs to some of the contract addresse
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";

error MaxSupplyReached();
error WrongEtherAmount();
error MaxAmountPerTrxReached();
error NoEthBalance();

contract NFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public totalSupply = 0;
    string public baseURI;
    
    uint256 public immutable maxSupply = 10000;
    uint256 public immutable price = 0.15 ether;
    uint256 public immutable maxAmountPerTrx = 5;

    //Change This
    address public vaultAddress = address(1234);

    /*///////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @notice Creates an NFT Drop
    /// @param _baseURI The baseURI for the token that will be used for metadata.
    constructor(
        string memory _baseURI
    ) ERC721("Ancient Enemies", "AE") {
        baseURI = _baseURI;
    }

    /*///////////////////////////////////////////////////////////////
                               MINT FUNCTION
    //////////////////////////////////////////////////////////////*/

    /// @notice Mint NFT function.
    /// @param amount Amount of token that the sender wants to mint.
    function mintNft(uint256 amount) external payable {
        if (amount > maxAmountPerTrx) revert MaxAmountPerTrxReached();
        if (totalSupply + amount > maxSupply) revert MaxSupplyReached();
        if (msg.value < price * amount) revert WrongEtherAmount();

        unchecked {
            for (uint256 index = 0; index < amount; index++) {
                uint256 tokenId = totalSupply + 1;
                _mint(msg.sender, tokenId);
                totalSupply++;
            }
        }
    }


    /*///////////////////////////////////////////////////////////////
                            ETH WITHDRAWAL
    //////////////////////////////////////////////////////////////*/

    /// @notice Withdraw all ETH from the contract to the vault address.
    function withdraw() external onlyOwner {
        if (address(this).balance == 0) revert NoEthBalance();
        SafeTransferLib.safeTransferETH(vaultAddress, address(this).balance);
    }


}

