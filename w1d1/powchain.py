import hashlib
import time
from typing import List, Dict, Any


class Block:
    def __init__(self, index: int, transactions: List[Dict[str, Any]], proof: int, previous_hash: str):
        self.index = index
        self.timestamp = time.time()
        self.transactions = transactions
        self.proof = proof
        self.previous_hash = previous_hash

    def compute_hash(self):
        block_string = f"{self.index}{self.timestamp}{self.transactions}{self.proof}{self.previous_hash}"
        return hashlib.sha256(block_string.encode()).hexdigest()


class Blockchain:
    def __init__(self):
        self.unconfirmed_transactions = []
        self.chain = []
        self.create_genesis_block()

    def create_genesis_block(self):
        genesis_block = Block(0, [], 0, "0")
        genesis_block.hash = genesis_block.compute_hash()
        self.chain.append(genesis_block)

    def add_new_transaction(self, transaction: Dict[str, Any]):
        self.unconfirmed_transactions.append(transaction)

    def add_block(self, block: Block, proof: int):
        previous_hash = self.last_block.hash
        if previous_hash != block.previous_hash:
            return False
        if not self.is_valid_proof(block, proof):
            return False

        block.hash = block.compute_hash()
        self.chain.append(block)
        return True

    @staticmethod
    def is_valid_proof(block: Block, block_proof: int):
        guess_block = Block(block.index, block.transactions, block_proof, block.previous_hash)
        guess_hash = guess_block.compute_hash()
        return guess_hash.startswith('0000')

    def proof_of_work(self):
        proof = 0
        while True:
            if self.is_valid_proof(
                    Block(len(self.chain), self.unconfirmed_transactions, proof, self.last_block.compute_hash()),
                    proof):
                return proof
            proof += 1

    @property
    def last_block(self):
        return self.chain[-1]


if __name__ == '__main__':

    # Initialize the blockchain
    blockchain = Blockchain()

    # Simulate adding transactions and mining a block
    blockchain.add_new_transaction({'sender': 'alice', 'recipient': 'bob', 'amount': 25})
    new_proof = blockchain.proof_of_work()
    new_block = Block(len(blockchain.chain), blockchain.unconfirmed_transactions, new_proof,
                      blockchain.last_block.compute_hash())
    blockchain.add_block(new_block, new_proof)

    # Display the blockchain
    for b in blockchain.chain:
        print(f"Index: {b.index}")
        print(f"Timestamp: {b.timestamp}")
        print(f"Transactions: {b.transactions}")
        print(f"Proof: {b.proof}")
        print(f"Previous Hash: {b.previous_hash}")
        print(f"Hash: {b.hash}")
        print("\n")
