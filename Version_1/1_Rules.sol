pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Rules
 * @dev Store acl rules of a POD
 */
contract Storage {
    
    struct rule{
        string[] webID;
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

    function addRule(uint8 _modes, string memory _webID) public isOwner valutateModes(_modes){
        rules[_modes - 1].webID.push(_webID);
    }
    
    function checkRule(uint8 _modes, string memory _webID) public view valutateModes(_modes) returns(int index){
        bytes memory webIDB = bytes(_webID);
        for(uint i=0; i<rules[_modes - 1].webID.length; i++){        // It's useful save the bytes? Possibly waste of memory? 
            bytes memory tmpWebIDB = bytes(rules[_modes - 1].webID[i]);
            if(webIDB.length == tmpWebIDB.length && keccak256(webIDB) == keccak256(tmpWebIDB)) return int(i);
        }
        return -1;
    }
    
    function changeRule(uint8 _modes, string memory _webID) public isOwner returns(bool response){
        if(removeRule(_modes, _webID)){
            addRule(_modes, _webID);
            return true;
        }
        return false;
    } 
    
    function removeRule(uint8 _modes, string memory _webID) public isOwner returns(bool response){
        int index = checkRule(_modes, _webID);
        if(index >= 0){
            uint i = uint(index);
            uint last = rules[_modes - 1].webID.length - 1;  // It's useful save the last element index? Possibly waste of memory? 
            rules[_modes - 1].webID[i] = rules[_modes - 1].webID[last];
            delete rules[_modes - 1].webID[last];
            return true;
        }
        return false;
    }
}
