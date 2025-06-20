// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Auction {
    address public owner;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public minIncreasePercent = 5;
    uint256 public commissionPercent = 2;

    address public highestBidder;
    uint256 public highestBid;

    struct Bid {
        address bidder;
        uint256 amount;
    }

    Bid[] public bids;
    mapping(address => uint256[]) public userBids;
    mapping(address => uint256) public pendingReturns;
    bool public ended;

    event NewBid(address indexed bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el dueno puede ejecutar esto.");
        _;
    }

    modifier auctionActive() {
        require(block.timestamp < endTime && !ended, "La subasta ya termino.");
        _;
    }

    modifier auctionEnded() {
        require(block.timestamp >= endTime || ended, "La subasta aun esta activa.");
        _;
    }

    constructor(uint256 _durationMinutes) {
        owner = msg.sender;
        startTime = block.timestamp;
        endTime = block.timestamp + (_durationMinutes * 1 minutes);
    }

    function placeBid() external payable auctionActive {
        require(msg.value > 0, "Debes enviar una cantidad mayor a 0.");

        uint256 minRequired = highestBid + ((highestBid * minIncreasePercent) / 100);
        require(msg.value >= minRequired, "La oferta debe superar al menos en 5% la mayor actual.");

        if (highestBidder != address(0)) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        bids.push(Bid(msg.sender, msg.value));
        userBids[msg.sender].push(msg.value);

        if (endTime - block.timestamp <= 10 minutes) {
            endTime += 10 minutes;
        }

        emit NewBid(msg.sender, msg.value);
    }

    function withdrawExcess() external {
        uint256 refundable = pendingReturns[msg.sender];
        require(refundable > 0, "No tienes reembolsos pendientes.");

        pendingReturns[msg.sender] = 0;
        payable(msg.sender).transfer(refundable);
    }

    function endAuction() external onlyOwner auctionActive {
        ended = true;

        uint256 commission = (highestBid * commissionPercent) / 100;
        uint256 ownerAmount = highestBid - commission;

        payable(owner).transfer(ownerAmount);

        emit AuctionEnded(highestBidder, highestBid);
    }

    function getWinner() external view auctionEnded returns (address, uint256) {
        return (highestBidder, highestBid);
    }

    function getAllBids() external view returns (Bid[] memory) {
        return bids;
    }

    function getMyBids() external view returns (uint256[] memory) {
        return userBids[msg.sender];
    }

    function getTimeLeft() external view returns (uint256) {
        if (block.timestamp >= endTime) return 0;
        return endTime - block.timestamp;
    }
}
