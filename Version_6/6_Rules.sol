pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Rules
 * @dev Store acl rules of a POD
 */
contract Storage {
    
    //  -webID hashed (SHA256) identifier 
    //  -modes byte in range [0x00, 0x0f]
    //          considering only the first 4 bits of modes such that 1000 = Control, 0100 = Append, 0010 = Write, 0001 = Read.
    //           example 0x05 = Append and Read
    struct rule{
        bytes32 webID;
        bytes1 modes; 
    }

    address private owner;

    //  Array of rules (agents that have permission = modes for this POD)
    rule[] private rules;

    bytes32 public podName;

    //  Modifier to check if caller is owner
    modifier isOwner(){
        require(msg.sender == owner, "Not allowed!");
        _;
    }

    //  Modifier to check if modes in range [0x00, 0x0f]
    modifier modesInRange(bytes1 _modes){
        require((_modes | 0x0f) == 0x0f, "Invalid modes!");
        _;
    }
    
    //  -_podName hashed (SHA256) pod name
    constructor(bytes32 _podName){
        owner = msg.sender;
        podName = _podName;
    }

    //  Allows to add a rule only if it is not already present
    //  Returns true on success
    function addRule(bytes32 _webID, bytes1 _modes) public isOwner modesInRange(_modes) returns(bool response){
        if(checkRule(_webID, _modes) == -1){
            rules.push( rule(_webID, _modes) );
            return true;
        }
        return false;
    }

    //  Returns the index of the first occurrence of the rule(_webID, _modes), or -1 if not present
    function checkRule(bytes32 _webID, bytes1 _modes) public modesInRange(_modes) view returns(int index){
        for(uint i=0; i<rules.length; i++){
            if(rules[i].webID == _webID && (rules[i].modes ^ _modes) == 0x00 ) return int(i);
        }
        return -1;
    }

    //  Allows to change modes of a rule
    //  Returns true on success
    function changeRule(bytes1 _oldModes, bytes32 _webID, bytes1 _newModes) public isOwner modesInRange(_oldModes) modesInRange(_newModes) returns(bool response){
        if(removeRule(_webID, _oldModes)){
            addRule(_webID, _newModes);
            return true;
        }
        return false;
    }

    //  Allows to remove a rule
    //  Returns true on success
    function removeRule(bytes32 _webID, bytes1 _modes) public isOwner modesInRange(_modes) returns(bool response){
        int index = checkRule(_webID, _modes);
        if(index > -1){
            rules[ uint(index) ] = rules[ rules.length - 1 ];
            rules.pop();
            return true;
        }
        return false;
    }

}
