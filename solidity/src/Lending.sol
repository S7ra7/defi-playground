// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20Like {
    function transferFrom(address, address, uint256) external returns (bool);
    function transfer(address, uint256) external returns (bool);
    function balanceOf(address) external view returns (uint256);
}

contract Lending {
    IERC20Like public immutable collateralToken; // ör. WETH
    IERC20Like public immutable debtToken;       // ör. USDC
    address public owner;
    uint256 public immutable ltvBps;            // ör. 7000 => %70
    uint256 public immutable liqBps;            // ör. 8000 => %80
    uint256 public price;                       // 1 col = ? debt (basit oracle)

    mapping(address => uint256) public collateralOf;
    mapping(address => uint256) public debtOf;

    modifier onlyOwner { require(msg.sender == owner, "owner"); _; }

    constructor(IERC20Like c, IERC20Like d, uint256 _ltvBps, uint256 _liqBps, uint256 _price) {
        collateralToken = c; debtToken = d; owner = msg.sender;
        ltvBps = _ltvBps; liqBps = _liqBps; price = _price;
    }

    function setPrice(uint256 p) external onlyOwner { price = p; }

    function collateralValue(address u) public view returns (uint256) {
        return collateralOf[u] * price / 1e18;
    }

    function depositCollateral(uint256 amount) external {
        require(collateralToken.transferFrom(msg.sender, address(this), amount));
        collateralOf[msg.sender] += amount;
    }

    function borrow(uint256 amount) external {
        // limit: debt + amount <= collateralValue * ltv
        require(debtOf[msg.sender] + amount <= collateralValue(msg.sender) * ltvBps / 10_000, "ltv");
        debtOf[msg.sender] += amount;
        require(debtToken.transfer(msg.sender, amount));
    }

    function repay(uint256 amount) external {
        require(debtToken.transferFrom(msg.sender, address(this), amount));
        uint256 d = debtOf[msg.sender];
        debtOf[msg.sender] = amount >= d ? 0 : d - amount;
    }

    function isLiquidatable(address u) public view returns (bool) {
        return debtOf[u] > collateralValue(u) * liqBps / 10_000;
    }
}
