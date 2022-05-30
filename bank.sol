// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}


contract DefiBank {
    
    string public name = "DefiBank";
    
   
    address public usdc;
    address public bankToken;


    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;


    
    constructor() public {
        usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        bankToken = 0xB8c77482e45F1F44dE1745F52C74426C631bDD52;
    }


    
    function stakeTokens(uint _amount) public {

        
        IERC20(usdc).transferFrom(msg.sender, address(this), _amount);

        
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

       
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

      
    
     function unstakeTokens() public {

    	
    	uint balance = stakingBalance[msg.sender];
    
        
        require(balance > 0, "staking balance can not be 0");
    
      
        IERC20(usdc).transfer(msg.sender, balance);
    
        
        stakingBalance[msg.sender] = 0;
    
        
        isStaking[msg.sender] = false;

} 


    
    
    function issueInterestToken() public {
        for (uint i=0; i<stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            
    
            
            if(balance >0 ) {
                IERC20(bankToken).transfer(recipient, balance);
                
            }
            
        }
        
    }
}
