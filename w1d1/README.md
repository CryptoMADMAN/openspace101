模拟实现最小的区块链， 包含两个功能：
1.POW 证明出块，难度为 4 个 0 开头
2.每个区块包含previous_hash 让区块串联起来。
代码结构如下：
block = {
'index': 1,
'timestamp': 1506057125,
'transactions': [
    { 'sender': "xxx", 
    'recipient': "xxx", 
    'amount': 5, } ], 
'proof': 324984774000,
'previous_hash': "xxxx"
}