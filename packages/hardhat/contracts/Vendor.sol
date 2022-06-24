pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;
  uint256 public tokensPerEth = 100;
  //address public owner;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
    // owner = msg.sender;

  }



  // ToDo: create a payable buyTokens() function:

  function buyTokens () public payable {
    address buyer = msg.sender;
    uint256 amountOfEth = msg.value;
    uint256 amountOfTokens =  amountOfEth * tokensPerEth;

    yourToken.transfer(msg.sender, amountOfTokens);
    emit BuyTokens (buyer, amountOfEth, amountOfTokens);
     

  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  function withdraw () public onlyOwner {
    require(msg.sender != address(0x0) );
    require(address(this).balance > 0 , "No Eth here ");
    payable(msg.sender).transfer(address(this).balance);
  }

  // ToDo: create a sellTokens(uint256 _amount) function:

  function sellTokens (uint256 _amount) public {
    require (yourToken.balanceOf(msg.sender) >= _amount, "Not enough tokens to sell");
    require (address(this).balance >= (_amount / tokensPerEth), "Sorry not enough ETH in the contract");
    require (yourToken.allowance(msg.sender, address(this)) >= _amount, "Please Aprouve the amount");
    yourToken.transferFrom (msg.sender, address(this), _amount);
    payable(msg.sender).transfer (_amount / tokensPerEth);
    emit SellTokens(msg.sender, _amount / tokensPerEth, _amount);
  }

}
