// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Bank {
    mapping(address => uint) public bals;
    address[3] public top3;

    function deposit() public payable virtual  {
        updateTop3();
        bals[msg.sender]+=msg.value;
    }

    receive() external payable {
        deposit();
    }

    function getBal(address user) public view returns (uint) {
        return bals[user];
    }

    function withdraw(uint amt) public payable {
        require(amt < bals[msg.sender], "Not enough ");
        bals[msg.sender]-=amt;
        ( bool sent,) = msg.sender.call{value: amt}("");
        // payable(msg.sender).transfer(amt);
        require(sent, "Failed to send Ether");
    }

    function updateTop3() public {
    int insertIndex=-1;
        // 检查新分数是否应该进入前三
    for (int i = 2; i >= 0; i--) {
        if (bals[msg.sender] > bals[top3[uint(i)]]) {
                    insertIndex = i;  // 更新位置
        } else {
            break;
        }
    }
            // 如果新分数应该进入前三，则更新数组
    if (insertIndex != -1) {
        // 向右移动数组元素以为新元素腾出空间
        for (int j = 0; j < insertIndex; j++) {
            top3[uint(j)] = top3[uint(j + 1)];
        }
        // 插入新分数
        top3[uint(insertIndex)] = msg.sender;
    }

}
}


abstract contract  Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract BigBank is Bank,Ownable {

    modifier transLimit {
        require(msg.value >0.001 ether, "transLimit >0.001 ether");
        _;
    }

    event Deposit(address _from, uint _value);
    function  getBal() public view returns (uint){
        return bals[msg.sender];
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);

    }

    function deposit() public transLimit payable override {
        super.deposit();
    }

}
