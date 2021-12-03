require("@nomiclabs/hardhat-waffle");
require ('dotenv').config();


const infura = process.env.INFURA_ID;
const key = process.env.PRIVATE_KEY;

module.exports = {
  solidity: "0.8.0",
  networks: {
    rinkeby: {
      url : `https://rinkeby.infura.io/v3/${infura}`, 
      accounts : [key]
    }
  }
};






