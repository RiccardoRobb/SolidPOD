# Version
### This version uses:
* Modes encoding using one byte
* path, webID hashed (SHA256)
* Mapping [path from root] => [webID] => modes

## Costs:
* `Storage.constructor` Gas: 613542 -> 0.05 ETH
* `Storage.checkRule` Gas: 25606 -> 0.002 ETH
* `Storage.addRule` Gas: 47905 -> 0.004 ETH
* `Storege.changeRule` Gas: 32847 -> 0.003 ETH
* `Storage.removeRule` Gas: 26422 -> 0.002 ETH
    ###### Calculated using GasPrice (GWEI) of 92 (slow)
    ###### _(gas price * gas) / 1e9_
