pragma solidity >=0.4.22 <0.7.0;
    /**
     * author:Elviric
     * Novel Lottery Factory.
     */
     
     import "./L.sol";
     
     contract F{
    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    event NewLottery(address Sponsor, address lotteryAddress, uint prize);
    
    address private owner;
    address private lotteryAddress;
    uint256 public factoryFee =  5 * 1e18;
    /**
     * @dev Sponsor's list of lottery instances.
     */
     //address[] public LoL;
    mapping(address => address[]) internal sponsorLoL;
    /**
     * @dev Set contract deployer as owner
     */
    constructor() public {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        //daiToken = IERC20(0xaD6D458402F60fD3Bd25163575031ACDce07538D);
        emit OwnerSet(address(0), owner);
        
    }
    
    /**
     * @dev Create New Lottery Instance
     * 
     * 
     * */

    
    function createLottery(uint256 tP,uint256 _amount, uint256 sB, uint256 eB) public {
        require(tP > 0 && tP < _amount,"price per ticket");
        require(_amount > 0);
        
        L lottery = new L(msg.sender,tP,_amount,sB,eB);
        lotteryAddress = address(lottery);
        sponsorLoL[msg.sender].push(lotteryAddress);
        splitTransfer(owner,lotteryAddress,factoryFee,_amount,0xaD6D458402F60fD3Bd25163575031ACDce07538D);
        emit NewLottery(msg.sender,lotteryAddress,_amount);
        
    }
    
    /**
     * @param toFirst - the address of the first account
     * @param valueFirst - ERC20 tokens to be sent to toFirst
     * @param toSecond - the address of the second account
     * @param valueSecond - ERC20 tokens to be sent to toSecond
     * @param tokenAddress - address of the ERC20 token
    */
    function splitTransfer(
        address toFirst,
        address toSecond,
        uint256 valueFirst,
        uint256 valueSecond,
        address tokenAddress
    )
        internal 
    {
        IERC20(tokenAddress).transferFrom(msg.sender, toFirst, valueFirst);
        IERC20(tokenAddress).transferFrom(msg.sender, toSecond, valueSecond);
        
    }
    
    
    
    function listofLotteryBy(address _sponsor) external view returns(address[] memory){
        
        return sponsorLoL[_sponsor];
    }

    
}