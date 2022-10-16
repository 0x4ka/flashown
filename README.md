### **tl;dr**

Receive and return NFTs within 1Tx, and in the process perform arbitrage by manipulating Breed and NFT AMM liquidity pools by owning NFTs for a moment by executing any process specified by the user.

### Flash Loans

A flash loan is a transaction technique that borrows an asset without collateral, which is originally required when borrowing an asset, and completes the processing and repayment of the debt within the transaction, and is often used in the DeFi protocol.

The core concept of Flash Loan is to complete the debt within 1Tx, which is a unique Blockchain transaction method that takes advantage of Blockchain's characteristics.

In other words, flash loans are effective for NFTs traded on Blockchain, and could be a topic of interest in the coming NFT market, where Peer to Pool transactions are being explored.

### Unsecured Loan Methodology and Issues

- Support by Contract Wallet
    - Requires support for specific wallets such as Wallet Connect and Argent
- Wrap solution
    - Requires technical support on the part of project founders as the contract address changes
- New standards for rentals such as ERC-4907
    - Existing non-upgradable contracts cannot be supported, and technical support is still required for ERC-4907, including the adoption of a new role "User" by project founders.

### Flash loans as traditional unsecured loans

Flash loans, by their nature, can only be used for instantaneous transactions, but if one considers that they can be used for arbitrage by enhancing instantaneous game items or manipulating the NFT's liquidity pool, one can see sufficient economic benefit in their use.

NFT flash loans have the potential to disrupt the gaming ecosystem or pose a threat to the NFT protocol, as in the case of the attack on DeFi.

However, as long as it is established as a common method in DeFi, those who implement it will eventually come as the NFT domain matures.

The proposal in this hackathon is intended to propose a behavior that should be looked at once and generate discussion at this stage when the NFT market is moving into the next area of finance.

### Demonstration.

**How it works** (very simple in itself)

1. Liquidity pool transfers NFTs to users.
2. User sends it to a smart contract
3. User performs any transaction and returns it to the pool.

**Example**.

1. take out a loan with CryptoKitties.
2. use the loan to breed the kitties you own.
3. return the borrowed kitty.
4. lay eggs from the kitty. 5.
5. sell the CryptoKitties.
