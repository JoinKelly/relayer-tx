// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TargetToken is ERC20 {

    constructor(
        string memory name
    ) public ERC20(name, name) {
        _mint(msg.sender, 100000 * 10**18);
    }

    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }
}
