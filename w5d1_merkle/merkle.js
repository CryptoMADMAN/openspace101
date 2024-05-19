const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

// Step 1: Generate some sample data (leaves)
const leaves = ['a', 'b', 'c', 'd','e','f','g'].map(x => keccak256(x));

// Step 2: Create a Merkle tree from the leaves
const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });

// Step 3: Get the root of the Merkle tree
const root = tree.getRoot().toString('hex');
console.log('Root:', root);

// Step 4: Get the proof for a specific leaf
const leaf = keccak256('a');
const proof = tree.getProof(leaf).map(x => x.data.toString('hex'));
console.log('Proof:', proof);

// Step 5: Verify the proof
const isValid = tree.verify(proof, leaf, root);
console.log('Is valid proof:', isValid);
