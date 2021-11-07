pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Rules
 * @dev Store acl rules of a POD
 */
contract Storage {
    
    struct rule{
        uint16 modes;
        string webID;
    }
    
    address private owner;
    string public pod;
    
    // using struct
    rule[] private rules;
    
    modifier isOwner(){
        require(msg.sender == owner, "Not allowed!\n");
        _;
    }
    
    constructor(string memory _pod){
        owner = msg.sender;
        pod = _pod;
    }
    
    //What happens when we pass _modes = 01 ? We cannot have an uint starting with 0! 
    //We have to use R=1, W=2, A=3 and C=4.
    function checkModes(uint16 _modes) private pure returns(bool response){
        bool[4] memory tmpModes = [false, false, false, false];
        uint16 tmpMode = _modes;
        uint8 value;
        
        while(tmpMode > 0){
            value = uint8((tmpMode%10)-1);
            if(value > 4) return false;
            if(tmpModes[value]) return false;
            tmpModes[value] = true;
            tmpMode = tmpMode/10;
        }
        return true;
    }
    

    function checkRule(uint16 _modes, string memory _webID) public view returns(int index){
        bytes memory webIDB = bytes(_webID);
        for(uint i=0; i<rules.length; i++){
            bytes memory tmpWebIDB = bytes(rules[i].webID);
            if(webIDB.length == tmpWebIDB.length && keccak256(webIDB) == keccak256(tmpWebIDB) && _modes == rules[i].modes) return int(i);
        }
        return -1;
    }
    
    function changeRule(uint16 _modes, string memory _webID) public isOwner returns(bool response){
        require(checkModes(_modes), "Error in modes!\n");
        int index = checkRule(_modes, _webID);
        if(index >= 0){
            uint i = uint(index);
            rules[i].modes = _modes;
            rules[i].webID = _webID;
            return true;
        } 
        return false;
    }
    
    function addRule(uint16 _modes, string memory _webID) public isOwner{
        require(checkModes(_modes), "Error in modes!\n");
        rules.push(rule(_modes, _webID));
    }
    
}
