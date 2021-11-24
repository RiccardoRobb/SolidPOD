# Version_3
### This version uses:
* Modes encoding R=1, W=2, A=4, C=8
* Agents store as bytes32 generated using 
     ###### Call [Converter](https://github.com/RiccardoRobb/SolidPOD/blob/main/Version_3/Converter.sol)

## Costs:
* `Storage.constructor` Gas: 1050789 -> 0.09 ETH
* `Storage.checkRule` Gas: 83624 -> 0.007 ETH
* `Storage.addRule` Gas: 41891 -> 0.003 ETH
* `Storege.changeRule` Gas: 102504 -> 0.009 ETH
* `Storage.removeRule` Gas: 46678 -> 0.004 ETH
    ###### Calculated using GasPrice (GWEI) of 92 (slow)
    ###### _(gas price * gas) / 1e9_
