// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./liberty/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./other/Strings.sol";

contract CP is Ownable, ERC721 {
    uint public constant MAX_CPS = 10000;
    uint public constant START_PRICE = 1 ether;
    uint public constant END_PRICE = 0.1 ether;
    uint public constant TIME = 10 minutes;  //拍卖时长
    uint public constant DROP_INTERVAL = 1 minutes; //衰减期
    uint public constant DROP_PER_STEP = (START_PRICE - END_PRICE)/(TIME/DROP_INTERVAL); //每次价格衰减步长

    uint public startTime;

    mapping(uint256 => string) private _tokenURIs;
    string baseURI = "ipfs://QmcVgEu5CLpGJeZZEvSF3Lj3RUmkwWKUbRLqiTrQcVVU9w/";  //IPFS地址
    string public baseExtension = ".docx";

    uint[] public _allTokens;

    using Strings for uint; //使用toString拼接URI

    constructor(string memory name_ , string memory symbol_) ERC721(name_, symbol_){
        startTime = block.timestamp;
    }

    //两种开始拍卖的方式
    function setStartTime(uint _timestamp) external onlyOwner{
        startTime = _timestamp;
    }

    function totalSupply()public view virtual returns(uint){
        return _allTokens.length;
    }

    // 添加一个新的token
    function _addTokenToAllTokensEnumeration(uint tokenId)private{
        _allTokens.push(tokenId);
    }

    //获得拍卖实时价格
    function getPrice()public view returns(uint){
        uint _startTime = startTime;
        if(block.timestamp < _startTime){
            return START_PRICE;  // 拍卖未开始的价格
        }else if(block.timestamp >= _startTime + TIME){
            return END_PRICE;   // 拍卖结束的价格
        }else{
            uint steps = (block.timestamp - _startTime) /DROP_INTERVAL; //计算过了几个衰退期
            return START_PRICE - steps*DROP_PER_STEP; 
        }
    }

    //拍卖mint函数
    function auctionMint(uint tokenId)external payable{

        uint _startTime = uint(startTime); //local变量 减少gas
        
        require(_startTime != 0 && block.timestamp >= _startTime,"sale has not started yet");  //拍卖是否开始
     
        require(totalSupply() + 1 <= MAX_CPS,"not enough remaining reserved for auction to support desired mint amount"); // 检查是否超过NFT上限

           uint cost = getPrice();
       
        // 用户钱足够，则把nft铸造给他
        require(msg.value >= cost, "Need to send more ETH."); // 检查用户是否支付足够ETH
        _mint(msg.sender,tokenId);
        _addTokenToAllTokensEnumeration(tokenId);

        // 退款多余的ETH
         if (msg.value > cost) {
            payable(msg.sender).transfer(msg.value - cost);
        }

    }

    function _baseURI() internal view virtual override returns(string memory){
        // return "ipfs://QmcVgEu5CLpGJeZZEvSF3Lj3RUmkwWKUbRLqiTrQcVVU9w/";
        return baseURI;
    }

    function setTokenURI(uint256 tokenId)public view virtual returns (string memory){
        // require(condition);
        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        //如果没有URI 返回token的URI
        if(bytes(base).length == 0){
            return _tokenURI;
        }

        //如果都有了，则连接起来
        if(bytes(_tokenURI).length > 0){
            return string(abi.encodePacked(base,_tokenURI));
        }

        return  string(abi.encodePacked(base,tokenId.toString(),baseExtension));
    }

    // 提款
    function withdrawMoney()external onlyOwner{
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success,"Transfer failed");
    }
}