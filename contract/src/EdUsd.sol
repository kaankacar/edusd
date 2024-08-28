// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract EdUsd is ERC20, Ownable {
    AggregatorV3Interface public priceFeed;
    
    uint256 public constant PRICE_PRECISION = 1e6;
    uint256 public targetPrice = 1 * PRICE_PRECISION; // $1 USD
    uint256 public rebaseCooldown = 1 hours;
    uint256 public lastRebaseTime;
    uint256 public rebasePercentage = 1 * PRICE_PRECISION / 100; // 1% rebase
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000 * 10**18; // 1 billion EdUsd with 18 decimals

    event Rebase(uint256 indexed epoch, uint256 totalSupply);

    constructor() ERC20("Educational USD", "edUSD") Ownable(msg.sender) {
        priceFeed = AggregatorV3Interface(0x0153002d20B96532C639313c2d54c3dA09109309);
        lastRebaseTime = block.timestamp;
        _mint(address(this), INITIAL_SUPPLY);
    }

    function getEdUsdChainlinkPrice() public view returns (uint256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        require(price > 0, "Invalid price feed");
        return uint256(price);
    }

    function rebase() public {
        require(block.timestamp >= lastRebaseTime + rebaseCooldown, "Rebase cooldown not met");
        
        uint256 currentPrice = getEdUsdChainlinkPrice();
        
        if (currentPrice != targetPrice) {
            uint256 totalSupply = totalSupply();
            uint256 newTotalSupply;
            
            if (currentPrice > targetPrice) {
                // Inflation: increase supply to decrease price
                uint256 supplyDelta = (totalSupply * (currentPrice - targetPrice) * rebasePercentage) / (targetPrice * PRICE_PRECISION);
                newTotalSupply = totalSupply + supplyDelta;
                _mint(address(this), supplyDelta);
            } else {
                // Deflation: decrease supply to increase price
                uint256 supplyDelta = (totalSupply * (targetPrice - currentPrice) * rebasePercentage) / (targetPrice * PRICE_PRECISION);
                newTotalSupply = (supplyDelta >= totalSupply) ? totalSupply / 2 : totalSupply - supplyDelta;
                _burn(address(this), totalSupply - newTotalSupply);
            }
            
            lastRebaseTime = block.timestamp;
            emit Rebase(lastRebaseTime, newTotalSupply);
        }
    }

    function claim() public {
        require(balanceOf(address(this)) >= 1e18, "Insufficient contract balance");
        _transfer(address(this), msg.sender, 1e18); // Transfer 1 edUsd
    }

    function getContractBalance() public view returns (uint256) {
        return balanceOf(address(this));
    }

    // Owner-only functions to adjust parameters
    function setTargetPrice(uint256 _targetPrice) external onlyOwner {
        targetPrice = _targetPrice;
    }

    function setRebaseCooldown(uint256 _rebaseCooldown) external onlyOwner {
        rebaseCooldown = _rebaseCooldown;
    }

    function setRebasePercentage(uint256 _rebasePercentage) external onlyOwner {
        rebasePercentage = _rebasePercentage;
    }

    function setPriceFeed(address _priceFeed) external onlyOwner {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }
}