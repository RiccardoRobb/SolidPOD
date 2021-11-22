pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Converter
 * @dev Contract used by 3_Rules.sol
 */
contract Converter {
    
    function convertModes(string memory _modes) public pure returns(uint8 outModes){ // Accepts only UpperCase letters
        bool r; bool w; bool a; bool c;
        r = w = a = c = false;
        
        uint8 modes = 0;
   
        bytes memory tmpModesBytes = bytes(_modes);
        
        require(tmpModesBytes.length < 5 && tmpModesBytes.length > 0, "Error in modes!");
        
        for(uint i = 0; i < tmpModesBytes.length; i++){
            if(!r && tmpModesBytes[i] ==  0x52){
                r = true;
                modes += 1;
            }else if(!w && tmpModesBytes[i] == 0x57){
                w = true;
                modes += 2;
            }else if(!a && tmpModesBytes[i] == 0x41){
                a = true;
                modes += 4;
            }else if(!c && tmpModesBytes[i] == 0x43){
                c = true;
                modes += 8;
            }else
                revert("Error in modes!");
        }
        
        return modes;
    }
   
   function convertResourceName(string memory _resource) public pure returns(bytes32 outName){
       return sha256(bytes(_resource));
   }
    
}
