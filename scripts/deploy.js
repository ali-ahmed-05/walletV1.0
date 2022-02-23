
const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat");

async function main() {

    const [deployer,per1,per2] = await ethers.getSigners();
    

    ERC2099starz = await ethers.getContractFactory("ERC2099starz");
    eRC2099starz = await ERC2099starz.deploy("STZclone","STZ",100000000,deployer.address);
    await eRC2099starz.deployed();

    AccountDeployer = await ethers.getContractFactory("AccountDeployer");
    accountDeployer = await AccountDeployer.deploy();
    await accountDeployer.deployed();

    Badge = await ethers.getContractFactory("Badge");
    badge = await Badge.deploy();
    await badge.deployed();

    Wallet = await ethers.getContractFactory("Wallet");
    wallet = await Wallet.deploy(accountDeployer.address , badge.address);
    await wallet.deployed();

    NFT = await ethers.getContractFactory("NFT");
    nft = await NFT.deploy(wallet.address);
    await nft.deployed();

    RentVault = await ethers.getContractFactory("RentVault");
    rentVault = await RentVault.deploy();
    await rentVault.deployed();  

    let tx = await badge._setwalletAddress(wallet.address)
    tx.wait()
    
    const network = hre.network.name

    // const provider = new ethers.providers.JsonRpcProvider(chainId.toString());
    // const network = await provider.send("eth_chainId");
    // console.log(network);
   

    saveFrontendFiles(accountDeployer, badge, wallet ,nft,rentVault,eRC2099starz, network)
    export_address_functions()
    export_contract_functions()
    
    
    
    

}

function saveFrontendFiles(accountDeployer, badge, wallet ,nft,rentVault,eRC2099starz, network) {
    const fs = require("fs");
    const contractsDir = __dirname + "/../package/addresses/";
    console.log(contractsDir)
    if (!fs.existsSync(contractsDir)) {
      fs.mkdirSync(contractsDir);
    }
    let config = `
   const accountDeployer = "${accountDeployer.address}"
   const badge = "${badge.address}"
   const wallet = "${wallet.address}"
   const nft = "${nft.address}"
   const rentVault = "${rentVault.address}"
   const eRC2099starz = "${eRC2099starz.address}"

   module.exports = {accountDeployer,badge,wallet,nft,rentVault,eRC2099starz}
  `

  
    let data = JSON.stringify(config)
    fs.writeFileSync(
      contractsDir +  network.toString()+'.js', JSON.parse(data)
  
    );
  
  }

  const export_contract_functions = () => {
    try {
        let contracts = {}
        var fs = require('fs');

        // delete __dirname + "/../package/contracts/all.json"

        const contractsDir = __dirname + "/../package/contracts/";
        var files = fs.readdirSync(contractsDir);
        const path = require('path');
    
        files.forEach(file => {
            const filename = file
            if (path.parse(filename).name !== "index" && path.parse(filename).name !== "all") {
                const fileRef = contractsDir + path.parse(filename).base
                var tempFile = require(fileRef);
                contracts[path.parse(filename).name] = tempFile
            }
        });

        
        
        const allDir = __dirname + "/../package/contracts/all.json";
      if (fs.existsSync(allDir)) {
        console.log("con ex")
        fs.rmSync(allDir, { recursive: true });
      }
       
        //JSON.parse(data)
        let data = JSON.stringify(contracts)
        fs.writeFileSync(
        contractsDir + 'all.json', data
  
    );
    } catch (error) {
        console.log("error in contracts sdk " , error)
    }
    
}

const export_address_functions = () => {
  try {
      let contracts = {}
      var fs = require('fs');
      delete __dirname + "/../package/addresses/all.json"

      const contractsDir = __dirname + "/../package/addresses/";
      var files = fs.readdirSync(contractsDir);
      const path = require('path');
  
      files.forEach(file => {
          const filename = file
          if (path.parse(filename).name !== "index" && path.parse(filename).name !== "all") {
              const fileRef = contractsDir + path.parse(filename).base
              var tempFile = require(fileRef);
              contracts[path.parse(filename).name] = tempFile
          }
      });

      
      
      const allDir = __dirname + "/../package/addresses/all.json";
      if (fs.existsSync(allDir)) {
        console.log("add ex")
        fs.rmSync(allDir, { recursive: true });
      }
     
      //JSON.parse(data)
      let data = JSON.stringify(contracts)
      fs.writeFileSync(
      contractsDir + 'all.json', data

  );
  } catch (error) {
      console.log("error in addresses sdk " , error)
  }
  
}
  
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
