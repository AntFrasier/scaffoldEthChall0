// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./Staker.sol"; //this is just for testing purpose

contract ExampleExternalContract {

  bool public completed;
  Staker public staker; //this is just for testing purpose

  function complete() public payable {
    completed = true;
  }

  function reset(address payable _Staker) public { //this is just for testing purpose
    completed = false;
    staker = Staker(_Staker);
    staker.getBackFunds{value: address(this).balance}();

  }

}
