// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

bytes32 constant ORDER_TYPEHASH = keccak256(
    "Order(uint256 salt,address maker,address signer,address taker,uint256 tokenId,uint256 makerAmount,uint256 takerAmount,uint256 expiration,uint256 nonce,uint256 feeRateBps,uint8 side,uint8 signatureType)"
);

struct Order {
    /// @notice Unique salt to ensure entropy
    uint256 salt;
    /// @notice Maker of the order, i.e the source of funds for the order
    address maker;
    /// @notice Signer of the order
    address signer;
    /// @notice Address of the order taker. The zero address is used to indicate a public order
    address taker;
    /// @notice Token Id of the CTF ERC1155 asset to be bought or sold
    /// If BUY, this is the tokenId of the asset to be bought, i.e the makerAssetId
    /// If SELL, this is the tokenId of the asset to be sold, i.e the takerAssetId
    uint256 tokenId;
    /// @notice Maker amount, i.e the maximum amount of tokens to be sold
    uint256 makerAmount;
    /// @notice Taker amount, i.e the minimum amount of tokens to be received
    uint256 takerAmount;
    /// @notice Timestamp after which the order is expired
    uint256 expiration;
    /// @notice Nonce used for onchain cancellations
    uint256 nonce;
    /// @notice Fee rate, in basis points, charged to the order maker, charged on proceeds
    uint256 feeRateBps;
    /// @notice The side of the order: BUY or SELL
    Side side;
    /// @notice Signature type used by the Order: EOA, POLY_PROXY or POLY_GNOSIS_SAFE
    SignatureType signatureType;
    /// @notice The order signature
    bytes signature;
}

/// @notice: Although signature type 0 says EOA, we have modified the code slightly to enable EIP-1271 for smart contract wallets.
enum SignatureType {
    // 0: ECDSA EIP712 signatures signed by EOAs
    EOA,
    // 1: EIP712 signatures signed by EOAs that own Polymarket Proxy wallets
    POLY_PROXY,
    // 2: EIP712 signatures signed by EOAs that own Polymarket Gnosis safes
    POLY_GNOSIS_SAFE
}

enum Side {
    // 0: buy
    BUY,
    // 1: sell
    SELL
}

interface ICTFExchange {
    struct OutcomeToken {
        uint256 complement;
        bytes32 conditionId;
    }

    event TokenRegistered(uint256 indexed token0, uint256 indexed token1, bytes32 indexed conditionId);

    function fillOrder(Order memory order, uint256 fillAmount) external;
    function getCollateral() external view returns (address);
    function getCtf() external view returns (address);
    function registry(uint256 tokenId) external view returns (uint256 complement, bytes32 conditionId);
}
