const {ethers} = require("ethers");

const deploy = async() => {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contract with the account: ", deployer.address);

    const TransHumans = await ethers.getContractFactory("TransHumans");
    const deployed =  await TransHumans.deploy();

    console.log("TransHumans NFT is deployed at:", deployed.address);
};

deploy()
    .then(() => process.exit(0))
    .catch ((error) => {
        console.log(error);
        process.exit(1);
    })




