// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;
  mapping (address => uint256 ) public balances;
  uint256 public threshold = 1 ether;
  uint256 public deadLine = 30 seconds;
  bool private openForWithdraw = false;

  event Staked (address , uint256);
  event UnStaked (address , uint256);

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
      deadLine = block.timestamp + deadLine ;
  }

  modifier IsActive () {
      require ( deadLine < block.timestamp , "Not active");
      _;
    }


  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake () public payable {
    //require (address(this).balance <= threshold , "/ Contract's allready full !") ;
    balances[msg.sender] += msg.value ;
    emit Staked (msg.sender , balances[msg.sender]);

  }

  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  function execute () public IsActive {
      require (exampleExternalContract.completed == false , "allready completed");
      if (address(this).balance >= threshold) {
      exampleExternalContract.complete{value: address(this).balance}();}
      else { // if the `threshold` was not met, allow everyone to call a `withdraw()` function
      openForWithdraw = true;
      }
    }

    function withdraw (address payable _sender) public{ // Add a `withdraw()` function to let users withdraw their balance
      require (balances[_sender] > 0, "No deposit done yet !");
      require (openForWithdraw != false, "You could not Withdraw Yet !" );
      _sender.transfer (balances[_sender]);
      balances[_sender] = 0;
      emit UnStaked (_sender, balances[_sender]);
    }


    } 

  


  


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


  // Add the `receive()` special function that receives eth and calls stake()



