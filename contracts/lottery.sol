//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;
 
 contract Lottery{
     address public manager;
     address payable[] public players;

     constructor(){
         manager = msg.sender;
         players.push(payable (manager));
     }

     receive() external payable {
         require(msg.value == 1 ether);
         players.push(payable (msg.sender));
     }
     function getBalance() public view returns(uint){
         require(msg.sender == manager);
         return address(this).balance;
     }
     //Can be manipulated by miners
     function random()public view returns(uint) {
         return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
     }
     function pickWinner() public{
         require(msg.sender== manager);
         require(players.length >= 3);
         address payable winner;
         uint r = random();
        uint index = r % players.length; 
        winner = players[index];
        uint managerFee = (getBalance()*10)/100; //10% cut
        uint winnerPrize =  (getBalance()*90)/100; //90% cut
        winner.transfer(winnerPrize);
        payable(manager).transfer(managerFee);
        players= new address payable[](0);
     }
 }