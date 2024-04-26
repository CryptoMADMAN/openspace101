// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Bank{

    mapping(address=>uint) public bals;
    address[3] public top3;



    function  getBal() public view returns (uint){
        return bals[msg.sender];
    }

    function withdraw(uint amount) public payable {
        require(amount <= bals[msg.sender], "Not enough ");
        bals[msg.sender]-=amount;
        ( bool sent,) = msg.sender.call{value: amount}("----");
        require(sent, "Failed to send Ether");

    }

    function deposit() public payable {
        updateTop3();
        bals[msg.sender]+=msg.value;
    }

    receive() external payable {
        deposit();
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