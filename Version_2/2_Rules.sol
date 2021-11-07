pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Rules
 * @dev Store acl rules of a POD
 */
contract Storage {
    
    struct rule{
        uint[] webID;
    }
    
    address private owner;
    string public pod;

    rule[15] private rules;
    
    modifier isOwner(){
        require(msg.sender == owner, "Not allowed!\n");
        _;
    }
    
    modifier valutateModes(uint8 _modes){
        require(_modes < 16 && _modes != 0, "Error in modes!\n");
        _;
    }
    
    constructor(string memory _pod){
        owner = msg.sender;
        pod = _pod;
    }
    
    function convert(string memory _webID) private pure returns(uint code){
        uint out = 0;
        bytes memory tmpWebID = bytes(_webID);
        assembly{
            out := mload(add(tmpWebID, 0x20))
        }
        return code;
    }

    function addRule(uint8 _modes, string memory _webID) public isOwner valutateModes(_modes){
        rules[_modes - 1].webID.push(convert(_webID));
    }
    
    function checkRule(uint8 _modes, string memory _webID) public view valutateModes(_modes) returns(int index){
        uint tmpCode = convert(_webID);
        for(uint i=0; i<rules[_modes - 1].webID.length; i++){
            if(rules[_modes - 1].webID[i] == tmpCode) return int(i);
        }
        return -1;
    }
    
    function changeRule(uint8 _modes, string memory _webID, uint8 new_modes) public isOwner returns(bool response){
        if(removeRule(_modes, _webID)){
            addRule(new_modes, _webID);
            return true;
        }
        return false;
    } 
    
    function removeRule(uint8 _modes, string memory _webID) public isOwner returns(bool response){
        int index = checkRule(_modes, _webID);
        if(index >= 0){
            uint i = uint(index);
            uint last = rules[_modes - 1].webID.length - 1; 
            rules[_modes - 1].webID[i] = rules[_modes - 1].webID[last];
            delete rules[_modes - 1].webID[last];
            return true;
        }
        return false;
    }
}
