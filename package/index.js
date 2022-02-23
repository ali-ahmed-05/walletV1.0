const contracts  = require("./contracts/index")
const addresses =  require("./addresses/index")





module.exports = {contracts,
    ...contracts,
    addresses,
    ...addresses
}
