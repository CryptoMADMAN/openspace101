
1.NFT+NFT市场合约
    1.1 用 ERC721 标准发行一个自己 NFT 合约，并用图片铸造几个 NFT ， 请把图片和 Meta Json数据上传到去中心的存储服务中
    1.2编写一个简单的 NFT市场合约，使用自己的发行的 Token 来买卖 NFT， 函数的方法有：
        list() : 实现上架功能，NFT 持有者可以设定一个价格（需要多少个 Token 购买该 NFT）并上架 NFT 到 NFT 市场。
        buyNFT() : 实现购买 NFT 功能，用户转入所定价的 token 数量，获得对应的 NFT。