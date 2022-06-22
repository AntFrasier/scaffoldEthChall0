pragma solidity >=0.6.0 <0.7.0;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Staker {

  using SafeMath for uint256;

  mapping (address => uint256 ) public balances;
  uint256 public threshold = 1 ether;
  ExampleExternalContract public exampleExternalContract;
  uint256 public deadLine = 30 ;
  //bool public active = true;
  //uint256 public TotalStaked = balances[];

  event Staked (address , uint256);
  event UnStaked (address , uint256);

  constructor(address exampleExternalContractAddress) public {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    deadLine = now + deadLine ;
  }

  modifier IsActive () {
    require ( deadLine < now , "Not active");
    _;
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  function stake () public payable {
    require (address(this).balance <= threshold , "/ Contract allready full !") ;
    balances[msg.sender] += msg.value ;
    emit Staked (msg.sender , balances[msg.sender]);

  }


  function execute () public IsActive {
  //  require (deadLine < now , "times not good");
    require (address(this).balance >= threshold , "/ Not enough funds ! ");
    exampleExternalContract.complete{value: address(this).balance}();
  }

  function withdraw (address payable _sender) public {
  //  require (address(this).balance < threshold , "/ Can t withdraw the contract is full !");
    require (balances[_sender] > 0, "No deposit done yet !");
    _sender.transfer (balances[_sender]);
    balances[_sender] = 0;
    emit UnStaked (_sender, balances[_sender]);
  }

  function timeLeft () public view returns (uint256){
    if (now > deadLine) return 0;
    return deadLine - now;

  }


  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value



  // if the `threshold` was not met, allow everyone to call a `withdraw()` function



  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


}
