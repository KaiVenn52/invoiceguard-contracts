// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface InvoiceToken {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address owner) external view returns (uint256);
}

/// @notice Non-custodial, exact-amount invoices for one configured ERC-20.
/// @dev Invoice metadata stays off chain; referenceHash binds the agreed document.
contract InvoiceGuard {
    struct Invoice { address payee; address payer; uint256 amount; uint64 expiresAt; bytes32 referenceHash; uint8 state; }
    InvoiceToken public immutable token;
    mapping(bytes32 => Invoice) public invoices;
    bool private locked;
    event InvoiceCreated(bytes32 indexed id, address indexed payee, address indexed payer, uint256 amount, uint64 expiresAt, bytes32 referenceHash);
    event InvoicePaid(bytes32 indexed id, address indexed payer, address indexed payee, uint256 amount);
    event InvoiceCancelled(bytes32 indexed id);
    error InvalidInvoice(); error NotPayable(); error Unauthorized(); error TransferFailed(); error Reentrant();
    constructor(address tokenAddress) { if (tokenAddress.code.length == 0) revert InvalidInvoice(); token = InvoiceToken(tokenAddress); }
    function invoiceId(address payee, bytes32 nonce) public view returns (bytes32) { return keccak256(abi.encode(block.chainid, address(this), payee, nonce)); }
    function create(bytes32 nonce, address payer, uint256 amount, uint64 expiresAt, bytes32 referenceHash) external returns (bytes32 id) {
        if (amount == 0 || expiresAt <= block.timestamp || referenceHash == bytes32(0)) revert InvalidInvoice();
        id = invoiceId(msg.sender, nonce);
        if (invoices[id].state != 0) revert InvalidInvoice();
        invoices[id] = Invoice(msg.sender, payer, amount, expiresAt, referenceHash, 1);
        emit InvoiceCreated(id, msg.sender, payer, amount, expiresAt, referenceHash);
    }
    function cancel(bytes32 id) external { Invoice storage v = invoices[id]; if (v.payee != msg.sender) revert Unauthorized(); if (v.state != 1) revert NotPayable(); v.state = 3; emit InvoiceCancelled(id); }
    function pay(bytes32 id) external {
        if (locked) revert Reentrant();
        Invoice storage v = invoices[id];
        if (v.state != 1 || block.timestamp >= v.expiresAt) revert NotPayable();
        if (v.payer != address(0) && v.payer != msg.sender) revert Unauthorized();
        if (msg.sender == v.payee) revert InvalidInvoice();
        locked = true; v.state = 2;
        uint256 beforeBalance = token.balanceOf(v.payee);
        if (!token.transferFrom(msg.sender, v.payee, v.amount)) revert TransferFailed();
        if (token.balanceOf(v.payee) != beforeBalance + v.amount) revert TransferFailed();
        locked = false;
        emit InvoicePaid(id, msg.sender, v.payee, v.amount);
    }
}
