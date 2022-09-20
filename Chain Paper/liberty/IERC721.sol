// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC165.sol";

interface IERC721 is IERC165 {
    event Transfer(address from , address to , uint256 tokenId);
    event Approve(address owner , address approved , uint256 tokenId);
    event ApprovalForALl(address owner , address operator, bool approved);

    function balanceOf(address owner) external view returns(uint256);
    function ownerOf(uint tokenId)external  view returns(address);

    function transferFrom(address from, address to, uint256 tokenId)external;
    function safeTransferFrom(address from, address to , uint256 tokenId , bytes calldata data)external ;
    function safeTransferFrom(address from, address to , uint256 tokenId)external ;

    function approve(address to , uint256 tokenId) external ;
    function getApproved(uint256 tokenId)external view  returns(address operator) ;
    function approvalForAll(address operator , bool _approved)external ;
    function isApprovedForAll(address owner,address operator)external view returns(bool);
    // function setApprovalForAll(address owner,bool approved)external ;


}