import ethers from '@nomiclabs/hardhat-ethers'

const getBox = async () => {
    const NftMarketplace = await ethers.getContractFactory('NftMarketplace');
    const nftMarketplace = await NftMarketplace.attach('0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0');
    nftMarketplace.fetchMarketItems();

    const Nft = await ethers.getContractFactory('Nft');
    const nft = await Nft.attach('0x5FbDB2315678afecb367f032d93F642f64180aa3');
    await nft.createToken("")
    console.log(box)
}