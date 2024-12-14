// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SookieCoin is ERC20, Ownable {
    uint256 public transactionFee = 2; // 2% fee for dog shelters
    address public dogFundWallet; // Wallet for dog shelter fund
    uint256 public constant TOTAL_SUPPLY = 10000000 * 10 ** 18; // 10 million tokens

    constructor(address _dogFundWallet) ERC20("Sookie Coin", "SOOK") Ownable(msg.sender) {
        require(_dogFundWallet != address(0), "Dog fund wallet cannot be the zero address");
        dogFundWallet = _dogFundWallet;

        // Mint the total supply to the contract deployer
        _mint(msg.sender, TOTAL_SUPPLY);
    }

    function setTransactionFee(uint256 _fee) external onlyOwner {
        require(_fee <= 5, "Fee cannot exceed 5%");
        transactionFee = _fee;
    }

    function setDogFundWallet(address _wallet) external onlyOwner {
        require(_wallet != address(0), "Wallet cannot be the zero address");
        dogFundWallet = _wallet;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 fee = (amount * transactionFee) / 100; // Calculate the fee
        uint256 amountAfterFee = amount - fee; // Calculate the amount after deducting the fee

        // Transfer the fee to the dogFundWallet
        _transfer(_msgSender(), dogFundWallet, fee);

        // Transfer the remaining amount to the recipient
        _transfer(_msgSender(), recipient, amountAfterFee);

        return true;
    }
}
