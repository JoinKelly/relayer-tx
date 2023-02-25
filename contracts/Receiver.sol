// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Receiver is AccessControlUpgradeable, ReentrancyGuardUpgradeable {
    // keccak256("SUPER_ADMIN")
    bytes32 public constant SUPER_ADMIN = 0xd980155b32cf66e6af51e0972d64b9d5efe0e6f237dfaa4bdc83f990dd79e9c8;
    // keccak256("SIGNER_ROLE")
    bytes32 public constant SIGNER_ROLE = 0xe2f4eaae4a9751e85a3e4a7b9587827a877f29914755229b07a7b2da98285f70;
    uint256 public nonce;

    function initialize() public initializer {
        __AccessControl_init();
        __ReentrancyGuard_init();

        _setRoleAdmin(SIGNER_ROLE, SUPER_ADMIN);
        _setupRole(SUPER_ADMIN, msg.sender);
    }

    function transferSuperAdmin(address _admin) public onlyRole(SUPER_ADMIN) {
        require(_admin != address(0) && _admin != msg.sender, "Invalid new guardian");
        renounceRole(SUPER_ADMIN, msg.sender);
        _setupRole(SUPER_ADMIN, _admin);
    }

    function grantSigner(address _signer) public onlyRole(SUPER_ADMIN) {
        require(_signer != address(0), "Signer address is invalid!");
        _setupRole(SIGNER_ROLE, _signer);
    }

    function revokeSigner(address _signer) public onlyRole(SUPER_ADMIN) {
        require(_signer != address(0), "Signer address is invalid!");
        revokeRole(SIGNER_ROLE, _signer);
    }

    function execute(
        address[] memory _targets,
        bytes[] memory _calldata,
        uint256 _nonce
    ) external onlyRole(SIGNER_ROLE) nonReentrant {
        verifyInputData(_targets, _calldata, _nonce);
        _executeAction(_targets, _calldata);
        nonce ++;
    }

    function verifyInputData(
        address[] memory _targets,
        bytes[] memory _calldata,
        uint256 _nonce
    ) public view returns (bool) {
        require(_targets.length == _calldata.length, "Invalid Length");
        require(nonce + 1 == _nonce, "Invalid Nonce");
        return true;
    }

    function _executeAction(address[] memory _targets, bytes[] memory _calldata) private {
        for (uint256 i = 0; i < _targets.length; ++i) {
            (bool success, bytes memory data) = _targets[i].call(_calldata[i]);
        }
    }

}
