// SPDX-License-Identifier: MIT

pragma solidity 0.6.9;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/token/ERC20/ERC20.sol";
import {SheetsERC721} from './SheetsERC721.sol';

contract SheetsERC20 is ERC20 {
    using SafeMath for uint256;

    event Burn(address indexed burner, uint256 amount);

    mapping (address => uint256) public burnedTokens;

    SheetsERC721 public nftToken;

    uint256 public maxNFTSupply;

    uint256 public ONE = 10 ** 18;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply,
        address bagHolder,
        address nftTokenAddress_,
        uint256 maxNFTSupply_
    )
        public
        ERC20(name_, symbol_)
    {
        _mint(bagHolder, maxSupply);
        nftToken = SheetsERC721(nftTokenAddress_);
        maxNFTSupply = maxNFTSupply_;
    }

    function burn(uint256 amount) external returns (bool) {
        _burn(_msgSender(), amount);
        emit Burn(_msgSender(), amount);
        burnedTokens[_msgSender()] = burnedTokens[_msgSender()].add(amount);

        uint256 nftSupply = nftToken.totalSupply();
        if (nftSupply < maxNFTSupply) {
            uint256 mintAmount = amount.div(ONE);
            uint256 newNFTSupply = mintAmount.add(nftSupply);
            if (newNFTSupply > maxNFTSupply) {
                mintAmount = mintAmount.sub(newNFTSupply.sub(maxNFTSupply));
            }

            nftToken.mint(_msgSender(), mintAmount);
        }

        return true;
    }
}
