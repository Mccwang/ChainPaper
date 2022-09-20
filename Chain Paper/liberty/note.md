Chain paper 链文 NFT 实战

1. 编写IERC165接口
    1) supportInterface

2. 编写ERC721的标准接口--IERC721

3. IERC721 要实现 IERC165

4. ERC协议主要包含 3个事件：
    1)Transfer（from，to，tokenId）
    2)Approval（owner，approved，tokenId）
    3)ApprovalForAll（owner，operator，approved）

5. ERC协议主要包含 9个函数
    1) balanceOf()
    2) ownerOf()
    3) transferFrom(from,to,tokenId)
    4) safeTransferFrom(from,to,tokenId) // 需要对方实现ERC721Receiver 避免打入黑洞
    5) approve(to,tokenId)
    6) getApproved()
    7) setApprovalForAll()
    8) isApprovedForAll()
    9) safeTransferFrom(from,to,tokenId,data) // 重载函数 包含data

6. 实现IERC721Receiver,避免转入黑洞。包含：
    1) onERC721Received(operator,from,tokenId,data)

7. 实现IERC721MetaData, 继承 IERC721，查询3个元数据
    1) name()
    2) symbol()
    3) tokenURI()

8. 实现ERC721主合约，需要继承 IERC721,IERC721Receiver，IERC721MetaData，实现IERC721

    4个状态变量
       1) _owners   uint => address
       2) _balances     address =>uint 
       3) _tokenApprovals   uint => address
       4) _operatorApprovals  address => address => bool 

    17个函数
       1) supportInterface(bytes4 interfaceId) //实现IERC165
       2) balanceOf(address owner)
       3) ownerOf(address tokenId)

       4) isApprovedForAll(address owner,address operator)
       5) setApprovalForAll(address operator,bool approved) //释放ApprovalForAll
       6) getApproved(uint tokenId)  //查询授权地址

       7) _approve(address owner,address to, uint tokenId) //释放Approval事件
       8) approve(address to, uint tokenId)

       9) _isApprovedOrOwner(address owner,address spender,uint tokenId) // 查询spender是否可以使用tokenid

       10) _transfer(address owner, address from ,address to, uint tokenId) // 从from 转到 to  回访Tranfer事件
       11) transferFrom(address from, address to , uint tokenId)

       12) _safeTransfer(address owner, address from, address to ,uint tokenId, bytes memory _data)
       13) safeTransferFrom(address from, address to, uint tokenId, bytes memory _data)  //带data
       14) safeTransferFrom(address from, address to, uint tokenId) // 不带data

       15) _mint(address to , uint tokenId) // 铸造token给to 释放Transfer事件。需要使用时重写
       16) _burn(uint tokenId) //释放Transfer事件 

       17) _checkOnERC721Received(address from, address to, uint tokenId,bytes memory _data) //to为合约时 调用IERC721Receiver-onERC721Received 函数 防止转入黑洞

       18) tokenURI(uint tokenId) // 查询metadata

       19) _baseURI() // 计算tokenURI的baseURI 需要使用时重写    


9. 编写主合约 -- chainpaper

10. 主合约额外实现荷兰拍卖功能
