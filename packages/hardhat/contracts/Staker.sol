// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;
  mapping (address => uint256 ) public balances;
  uint256 public threshold = 1 ether;
  uint256 public deadLine = 30 seconds;
  bool public openForWithdraw = false;
  bool public executed = false;
  address[] public stakers;

  event Staked (address , uint256);
  // event UnStaked (address , uint256);
  event Reset (uint256);

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
      deadLine = block.timestamp + deadLine ;
  }

  modifier isActive () {
      require ( deadLine < block.timestamp , "Not active");
      _;
    }

  modifier notCompleted () {
    require (exampleExternalContract.completed() == false , "allready completed");
    _;
  }

  function reimburse () internal { //this is just for testing purpose
    for (uint8 i =0; i < stakers.length; i++ ){
      address payable staker = payable(stakers[i]);
      staker.transfer (balances[staker]);
      balances[staker] = 0;
      emit Staked (staker, balances[staker]);
    }
    stakers = []; //oO cha morch po
  }

  function reset (uint256 _newDeadLine ) public { //this is just for testing purpose
    deadLine = block.timestamp + _newDeadLine;
    openForWithdraw = false;
    executed = false;
    if (exampleExternalContract.completed()){
      address payable stakeContract = payable(address(this));
      exampleExternalContract.reset(stakeContract);
    } else { reimburse();
      }
  }

  function getBackFunds () public payable { //this is just for testing purpose
    emit Reset (msg.value);
    reimburse();
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )

  function stake () public payable {
    //require (address(this).balance <= threshold , "/ Contract's allready full !") ;
    require ( block.timestamp < deadLine, "Stacking periode is over ! ");
    if ( balances[msg.sender] == 0 ) {
      stakers.push(msg.sender);
    } //this is for testing purpose only !
    balances[msg.sender] += msg.value ;
    emit Staked (msg.sender , balances[msg.sender]);

  }

  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  function execute () public isActive notCompleted{   
      require (!executed, "Allready executed");
      executed = true;
      if (address(this).balance >= threshold) {
      exampleExternalContract.complete{value: address(this).balance}();}
      else { // if the `threshold` was not met, allow everyone to call a `withdraw()` function
      openForWithdraw = true;
      }
    }

    function withdraw () public notCompleted{ // Add a `withdraw()` function to let users withdraw their balance
      address payable _sender = payable(msg.sender);
      require (balances[_sender] > 0, "You have no fund here !");
      require (openForWithdraw != false, "You could not Withdraw Yet !" );
      _sender.transfer (balances[_sender]);
      balances[_sender] = 0;
      emit Staked (_sender, balances[_sender]);
    }

    function timeLeft () public view returns (uint256) {
      if ( block.timestamp >= deadLine  ) return 0;
      else return deadLine - block.timestamp;
    }

    receive () external payable {
      stake();
    }
    } 

  


  


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


  // Add the `receive()` special function that receives eth and calls stake()



