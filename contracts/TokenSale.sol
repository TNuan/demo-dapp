// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSale is Ownable {
    IERC20 public ndToken;
    uint256 public rate = 3600;
    uint256 public tokensSold;

    constructor(address _ndToken, address initialOwner) Ownable(initialOwner) {
        ndToken = IERC20(_ndToken);
    }

    receive() external payable {
        buyTokens();
    }

    function buyTokens() public payable {
        require(msg.value > 0, "Send BNB to buy tokens");
        uint256 amount = msg.value * rate;
        require(ndToken.balanceOf(address(this)) >= amount, "Not enough tokens in contract");
        ndToken.transfer(msg.sender, amount);
        tokensSold += amount;
    }

    function withdrawBNB() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function withdrawUnsoldTokens() public onlyOwner {
        ndToken.transfer(owner(), ndToken.balanceOf(address(this)));
    }
}
