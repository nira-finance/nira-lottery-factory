# nira-lottery-factory
A PoC and implementation of Veedo Beacon VDF for randomly drawing the lottery.

LINK TO THE PRESENTATION: -> [Google Slide](https://docs.google.com/presentation/d/1ay-UwVKRk5NcidY7aPdZaA-cmKMOT8eBKGSxusW57rI/edit?usp=sharing) <-
![Code Flow Diagram](https://github.com/nira-finance/nira-lottery-factory/blob/master/Screen%20Shot%202020-07-22%20at%2011.05.27%20PM.png)
#### NOTE: F.sol has been Deployed on Rosp Newtork. And you my friend are free to play with it.


F.sol(Lottary Factory) Address:
`0xE85620E65C6D2AE6B5727a87fC7Ce4BB35E6D8c6`

Use the method `createLottery(tP:uint256,_amount:uint256,sB:uint256,eB:uint256)` to create your own lottery contract.
* Method is called by a Sponsor who want to create an Lottery event with some lottery price `_amount`
* `tp` is the price per ticket.
* `sB` Start Block; refers to rospt block number post which user can participate in the lottery.
* `eB` End Block; refers to rospt block number post which no user can participate in the lottery.

#### Note: You would have to `approve` Dai contract some allowance to use the contract.

On successful execution of the contract o/p L.sol contract is generated.

L.sol(Lottary Instance contract bonded by start block and end block) Address:
`generated on successful calling above function`

Use the method :

`function drawLottery() public  onlySponsor over{
        
         require(block.number>endBlock,"Drawing");
         (,bytes32 y) =  rop_b.getLatestRandomness();
        
         winningTicket = uint(y).mod(tickets.length);
         winningAddress= tickets[winningTicket];
         uint256 pot = daiToken.balanceOf(address(this));
         daiTransferto(winningAddress,pot);
         
         isOpen = false;
    
         
        emit Winner(winningTicket,winningAddress,y);
    }
`
To draw post end Block to draw the lottery and winner will be rewarded with pot.

For more queries and connect: DM me with the opening message  `Hi, Code73` on my telegram: [Elviric](https://t.me/Elviric).

P.S: I would appreciate a ⭐️ top right corner which keeps us motivated to grow as open sourced company🙏.
