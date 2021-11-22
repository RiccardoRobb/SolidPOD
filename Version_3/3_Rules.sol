pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Rules
 * @dev Store acl rules of a POD
 */
contract Storage {
    
    struct rule{
        bytes32[] webID;
    }
    
    address private owner;
    address private converter;
    rule[15] private rules;
    
    string public pod;
    
    modifier isOwner(){
        require(msg.sender == owner, "Not allowed!");
        _;
    }
    
    constructor(string memory _pod, address _converter){ // converter address used only for testing purpose.
        owner = msg.sender;
        pod = _pod;
        converter = _converter;
    }
    
    // Uses Converter (pure ?)
    function convertModes(string memory _modes) private returns (uint8 modes){
        (bool success, bytes memory result) = converter.call(abi.encodeWithSignature("convertModes(string)", _modes));
        require(success, "Error in modes!");
        return abi.decode(result, (uint8));
    }
    
    // Uses Converter (pure ?)
    function convertResourceName(string memory _webID) private returns (bytes32 webID){
        (bool success2, bytes memory result2) = converter.call(abi.encodeWithSignature("convertResourceName(string)", _webID));
        require(success2, "Fatal error!");
        return abi.decode(result2, (bytes32));
    }

    function addRule(string memory _modes, string memory _webID) public isOwner{ // possible problem: must see if webID not in rules.
        rules[ convertModes(_modes) - 1 ].webID.push( convertResourceName(_webID) );
    }

    // (view ?)
    function checkRule(string memory _modes, string memory _webID) public returns(int index){
        uint8 modes = convertModes(_modes) - 1;
        bytes32 webID = convertResourceName(_webID);
        for(uint i=0; i<rules[modes].webID.length; i++){
            if(rules[modes].webID[i] == webID) return int(i);
        }
        return -1;
    }
    
    /*
    function viewWeb(string memory _modes) public returns(rule memory){ // only for debug.
        uint8 modes = convertModes(_modes) - 1;
        return rules[modes];
    }
    */
    
    function changeRule(string memory _modes, string memory _webID, string memory new_modes) public isOwner returns(bool response){
        if(removeRule(_modes, _webID)){
            addRule(new_modes, _webID);
            return true;
        }
        return false;
    } 
    
    function removeRule(string memory _modes, string memory _webID) public isOwner returns(bool response){
        int index = checkRule(_modes, _webID);
        uint8 modes = convertModes(_modes) - 1;
        if(index >= 0){
            uint i = uint(index);
            uint last = rules[modes].webID.length - 1; 
            rules[modes].webID[i] = rules[modes].webID[last];
            delete rules[modes].webID[last];
            return true;
        }
        return false;
    }
    
}
