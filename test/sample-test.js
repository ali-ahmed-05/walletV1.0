// const { expect } = require("chai");
// const { ethers } = require("hardhat");

// describe("Wallet", function () {

//     let NFT;
//     let nft;
//     let Wallet;
//     let wallet;
//     let Account;
//     let account



//     let [_, person1, person2] = [1, 1, 1]


//     it("Should deploy NFT minter and Wallet contract ", async function () {
//         [_, person1, person2] = await ethers.getSigners()

//          Wallet = await ethers.getContractFactory("Wallet");
//          wallet = await Wallet.deploy();
//         await wallet.deployed();

//          NFT = await ethers.getContractFactory("NFT");
//          nft = await NFT.deploy(wallet.address);
//         await nft.deployed();
  
      

//     });
//     it("Create NFT", async function () {    
//          let Tx = await nft.createToken("asd");
//         Tx.wait()

//         let balance =await nft.balanceOf(_.address);
//         balance = await ethers.BigNumber.from(balance).toString()
//         expect(balance).to.equal('1');

//     });
//     it("Lock NFT", async function () {
//        Tx = await wallet.LockItem(nft.address,1);
//        Tx.wait()
//         Tx = await wallet.NFTexist(nft.address,1);
//         console.log(Tx)
//  //       Tx.wait()
//    });
//    it("transfer NFT", async function () {
//     Tx = await wallet.SendNFT(nft.address,1,person1.address);
//     Tx.wait()
//     let balance =await nft.balanceOf(person1.address);
//         balance = await ethers.BigNumber.from(balance).toString()
//         expect(balance).to.equal('1');
// //       Tx.wait()
// });
// it("Create another NFT", async function () {    
//     Tx = await nft.createToken("asd");
//    Tx.wait()

//    let balance =await nft.balanceOf(_.address);
//    balance = await ethers.BigNumber.from(balance).toString()
//    expect(balance).to.equal('1');

// });
// it("transfer Paused", async function () {
//     Tx = await wallet.pause();
//     Tx.wait()
// });
// it("Lock second NFT", async function () {
//     Tx = await wallet.LockItem(nft.address,2);
//     Tx.wait()
    
// //       Tx.wait()
// });
// it("transfer NFT :: must fail", async function () {
//     Tx = await wallet.SendNFT(nft.address,2,person1.address);
//     Tx.wait()
//     let balance =await nft.balanceOf(person1.address);
//         balance = await ethers.BigNumber.from(balance).toString()
//         expect(balance).to.equal('1');
// //       Tx.wait()
// });

// it("transfer unPaused", async function () {
//     Tx = await wallet.unpause();
//     Tx.wait()
// });
// it("transfer second NFT ", async function () {
//     Tx = await wallet.SendNFT(nft.address,2,person1.address);
//     Tx.wait()
//     let balance =await nft.balanceOf(person1.address);
//         balance = await ethers.BigNumber.from(balance).toString()
//         expect(balance).to.equal('2');
// //       Tx.wait()
// });
// it("Create another NFT", async function () {    
//     Tx = await nft.createToken("asd");
//    Tx.wait()

//    let balance =await nft.balanceOf(_.address);
//    balance = await ethers.BigNumber.from(balance).toString()
//    expect(balance).to.equal('1');

// });
// it("Create another NFT", async function () {    
//     Tx = await nft.createToken("asd");
//    Tx.wait()

//    let balance =await nft.balanceOf(_.address);
//    balance = await ethers.BigNumber.from(balance).toString()
//    expect(balance).to.equal('2');

// });
// it("Create another NFT", async function () {    
//     Tx = await nft.createToken("asd");
//     Tx.wait()

//    let balance =await nft.balanceOf(_.address);
//    balance = await ethers.BigNumber.from(balance).toString()
//    expect(balance).to.equal('3');

// });
// it("Lock NFT", async function () {
//     Tx = await wallet.LockItem(nft.address,3);
//     Tx.wait()
//      Tx = await wallet.NFTexist(nft.address,3);
//      console.log(Tx)
// //       Tx.wait()
// });
// it("Lock NFT", async function () {
//     Tx = await wallet.LockItem(nft.address,4);
//     Tx.wait()
//      Tx = await wallet.NFTexist(nft.address,4);
//      console.log(Tx)
// //       Tx.wait()
// });
// it("Lock NFT", async function () {
//     Tx = await wallet.LockItem(nft.address,5);
//     Tx.wait()
//      Tx = await wallet.NFTexist(nft.address,5);
//      console.log(Tx)
// //       Tx.wait()
// });

// it("Fetch my NFts", async function () {    
//     let items = await wallet.fetchMyNFTs()
//     items = await Promise.all(items.map(async i => {
//       let item = {
//         itemId: i.itemId.toString(),
//         nftaddress: i.nftContract
//       }
//       return item
//     }))
//     console.log('items: ', items)

// });
// it("transfer Third NFT ", async function () {
//     Tx = await wallet.SendNFT(nft.address,3,person1.address);
//     Tx.wait()
//     let balance =await nft.balanceOf(person1.address);
//         balance = await ethers.BigNumber.from(balance).toString()
//         expect(balance).to.equal('3');
// //       Tx.wait()
// });

// it("Fetch my NFts after transfer", async function () {    
//     let items = await wallet.fetchMyNFTs()
//     items = await Promise.all(items.map(async i => {
//       let item = {
//         itemId: i.itemId.toString(),
//         nftaddress: i.nftContract
//       }
//       return item
//     }))
//     console.log('items: ', items)

// });
   
    
    
// });
