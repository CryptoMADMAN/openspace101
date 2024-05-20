const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

// // Step 1: Generate some sample data (leaves)
// const leaves = ['a', 'b', 'c', 'd','e','f','g'].map(x => keccak256(x));

// // Step 2: Create a Merkle tree from the leaves
// const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });

// // Step 3: Get the root of the Merkle tree
// const root = tree.getRoot().toString('hex');
// console.log('Root:', root);

// // Step 4: Get the proof for a specific leaf
// const leaf = keccak256('a');
// const proof = tree.getProof(leaf).map(x => x.data.toString('hex'));
// console.log('Proof:', proof);

// // Step 5: Verify the proof
// const isValid = tree.verify(proof, leaf, root);
// console.log('Is valid proof:', isValid);


// Step 1: Generate some sample data (leaves)
const leaves1 = ["0x0292625602C9A91163D76ACc0e328675433c538d",
 '0xbB4410FFc84F40BEe74BBDb012e88D7057765771', '0xd8F2C77142816A687C47a0952fbE94CA2813D809', '0xd2F7766815C807e3179912287C92b4CE28A9e65B','0x62d6818f26D90Ec826DD90A5137f18983d201f39',
].map(x => keccak256(x));

// Step 2: Create a Merkle tree from the leaves
const tree1 = new MerkleTree(leaves1, keccak256, { sortPairs: true });

// Step 3: Get the root of the Merkle tree
const root1 = tree1.getRoot().toString('hex');
console.log('Root1:', root1);

// Step 4: Get the proof for a specific leaf
const leaf1 = keccak256('0xd8F2C77142816A687C47a0952fbE94CA2813D809');
const proof1= tree1.getProof(leaf1).map(x => x.data.toString('hex'));
console.log('Proof1:', proof1);

// // Step 5: Verify the proof
const isValid1 = tree1.verify(proof1, leaf1, root1);
console.log('Is valid proof1:', isValid1);

// Root1: bab12079dc0e1f375a00d60f6df333c67d20ac55daca0bfe2027244014be7ab3
// Proof1: [
//   '6abcad1b97d6f11299e4f262963fa5e0265362772642a24d54f0ca24907a9d58',
//   'be21de36aac606f3b21ad580080c24cc7713a7dd854adbe16b3535bfeeda744a',
//   '771602f439e0ae89de9c79a85c7641107049b2f15fdd1486f537726ea2b29c63'
// ]
// Is valid proof1: true