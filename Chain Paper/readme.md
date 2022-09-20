项目名称为ChainPaper，旨在能够将我们自己的论文（paper）等文字性文件铸造为NFT，为本人创造更多价值。

本项目主要实现以下功能：
    1、编写ERC721所需的各个接口：IERC165、IERC721、IERC721Receiver、IERC721Metadata
    2、实现ERC721协议
    3、在能正常发行NFT的基础上，增加荷兰拍卖功能，能够实现NFT的“减价拍卖”
    4、文章储存在ipfs上，地址为：ipfs://QmcVgEu5CLpGJeZZEvSF3Lj3RUmkwWKUbRLqiTrQcVVU9w/

使用指南：
    1、在Remix上编译
    2、输入name与symbol后点击Deploy发行NFT
    3、选择参与拍卖的账户，输入竞拍value后，输入所竞拍的tokenId，点击auctionMint参与竞拍。
    4、所竞拍到的NFT可以通过safeTransfer函数转赠与别人。
        以及其他功能...