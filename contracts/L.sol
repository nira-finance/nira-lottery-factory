pragma solidity >=0.4.22 <0.7.0;

import "./IERC20.sol";
import "./SafeMath.sol";


    /**
     * author:Elviric
     * Nira Lottery Contract.
     */

interface IBeaconContract {
    /*
      If there is a randomness that was calculated based on blockNumber, returns it.
      Otherwise, returns 0.
    */
    function getRandomness(uint256 blockNumber) external view returns (bytes32);

    /*
      Returns the latest pair of (blockNumber, randomness) that was registered.
    */
    function getLatestRandomness() external view returns (uint256, bytes32);
}

contract L {
    using SafeMath for uint256;
    
    /**
     * Lottery Contract begins Otherwise
     * @dev includes Veedo Beacon Interface, IERC20 and math safety
     * */
    
    event TransferDai(address indexed from, address indexed to, uint256 value);
    event Deposited(address indexed from, uint256 value);
    event Winner(uint256 ticketNumber, address indexed user, bytes32 beaconHash);
     IBeaconContract public rop_b;
    

    /**
     * Ticket price to be participate in the pool
     */
    uint public ticketPrice;
    
    /**
     * ERC20 Dai Token that this pool bonded
     */
     
     IERC20 public daiToken;
    
    /**
     * The array of tickets bought by a user.
     */
    address[] public tickets;
    
    /**
     *Map user to list of tickets he owns.
     */
     mapping(address => uint256[]) internal ticketUser;
    
    /**
     * Tickets counter
     */
    uint256 public tCounter;
    
    
    bool public isOpen;
    address public sponsorAddr;
    uint256 public prizeAmount;
    uint public endBlock;
    uint public startBlock;
    uint public winningTicket;
    address public winningAddress;
    uint public sponsorpool;
    modifier onlySponsor() {
        require(msg.sender == sponsorAddr, "Funding/is-sponsor");
        _;
    }
    
    
    modifier open() {
      require((startBlock < block.number)&& (block.number < endBlock), "Fuding/open");
      _;
    }
    
    modifier over(){
        require(isOpen,"live/over");
        _;
    }


    constructor(
        address spnr,uint256 _ticketPrice,uint256 _prizeAmount,uint _startBlk,uint _endBlk
        ) 
        public{
        
        require(_startBlk < _endBlk && _endBlk > block.number,"Invalid endBlock");
        require(spnr != address(0));
        
        
        
        sponsorAddr = spnr;
        rop_b = IBeaconContract(0x79474439753C7c70011C3b00e06e559378bAD040);
        ticketPrice = _ticketPrice;
        prizeAmount = _prizeAmount;
        startBlock = _startBlk;
        endBlock = _endBlk;
        daiToken = IERC20(0xaD6D458402F60fD3Bd25163575031ACDce07538D); //DAI Token 
        isOpen = true;
        tickets.push(spnr);
        ticketUser[spnr].push(tickets.length.sub(1));
        
        
    }
    

    
    
    function poolBalance() public view returns(uint256) {
        
        return daiToken.balanceOf(address(this));
        
    }
    
    function daiTransferto(address _to, uint256 value) internal {
        
        daiToken.transfer( _to,  value);
        emit TransferDai(address(this), _to,  value);
    }
    
    function boolOpen() public view returns(bool){
        return ( block.number>startBlock)&& (block.number < endBlock);
    }
    
    function buyTicket(uint256 value) public open{
        
        require(value == ticketPrice,"Funding error");
        
        daiToken.transferFrom(msg.sender,address(this),value);
        newTicket();
        emit Deposited(msg.sender,value);
        
    
        
    }
    
    function myTickets() public view returns(uint256[] memory) {
        return ticketUser[msg.sender];
        
    }
    
    function newTicket() internal {
        tickets.push(msg.sender);
        tCounter = tickets.length;
        ticketUser[msg.sender].push(tickets.length.sub(1));
    }
    
    function drawLottery() public  onlySponsor over{
        
         require(block.number>endBlock,"Drawing");
         (,bytes32 y) =  rop_b.getLatestRandomness();
        
         winningTicket = uint(y).mod(tickets.length);
         winningAddress= tickets[winningTicket];
         uint256 pot = daiToken.balanceOf(address(this));
         daiTransferto(winningAddress,pot);
         
         isOpen = false;
    
         
        emit Winner(winningTicket,winningAddress,y);
    }
       
}