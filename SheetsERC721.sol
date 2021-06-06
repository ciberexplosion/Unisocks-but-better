// SPDX-License-Identifier: MIT

pragma solidity 0.6.9;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/access/Ownable.sol";
import "./ERC20.sol";

contract SheetsERC721 is ERC721, Ownable {
    using SafeMath for uint256;

    ERC20 public Erc20;

    string public _tokenURI;

    constructor(
        string memory name,
        string memory symbol,
        string memory tokenURI_
    ) public ERC721(name, symbol) {
        _tokenURI = tokenURI_;
    }

    modifier onlySheets() {
        require(_msgSender() == address(Erc20), "Caller must the Owner");
        _;
    }

    function setERC20Address(address erc20Address) external onlyOwner {
        Erc20 = ERC20(erc20Address);
    }

    function tokenURI(uint256 /* tokenId */) public view override returns (string memory) {
        return _tokenURI;
    }

    function mint(address recipient, uint256 amount) external onlySheets returns (bool) {
        for (uint i = 0; i < amount; i = i.add(1)) {
            _safeMint(recipient, totalSupply());
        }

        return true;
    }
}
