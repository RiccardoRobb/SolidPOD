pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Rules
 * @dev Store acl rules of a POD
 */
contract Storage {
    
    address private owner;

    // POD root path hashed (SHA256)
    bytes32 public podName;

    // Mapping [path from 'podName'] => [webID] => modes
    //
    // bytes32 "path from 'podName'" indefies a file/directory inside the POD   hashed (SHA256)   
    // bytes32 "webID"               indefies a webID (Agent, AgentClass, AgentGroup ...) hashed (SHA256)
    // bytes1  "modes"               modes associate to a webID for a path, in range [0x00, 0x0f]
    //                                  considering only the first 4 bits of modes such that 1000 = Control, 0100 = Append, 0010 = Write, 0001 = Read.
    //                                     example 0x05 = Append and Read
    mapping (bytes32 => mapping (bytes32 => bytes1)) pathRules;

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
    
    //  _podName hashed (SHA256) pod name
    constructor(bytes32 _podName){
        owner = msg.sender;
        podName = _podName;
    }

    //  Returns true if [path] => [_webID] => _modes is present in Map
    function checkRule(bytes32 path, bytes32 _webID, bytes1 _modes) public view modesInRange(_modes) returns(bool response){
        return (pathRules[path][_webID] & _modes) != 0x00;
    }

    // Allows to add a rule inside the Map
    // returns true
    //
    // 0x01 | 0x02 -> 0x03 We don't overwrite old modes! We need a changeRule to do so.
    // But 0x01 | 0x01 -> 0x01 so it's not necessary to change the 'addRule' function.
    function addRule(bytes32 path, bytes32 _webID, bytes1 _modes) public isOwner modesInRange(_modes) returns(bool response){
        pathRules[path][_webID] |= _modes;
        return true;
    }

    // Allows to change a rule inside the Map
    // return true on success
    //
    // Test scenario:
    // rules: 0x01 | 0x02 -> 0x03
    // changeRule(..., ..., 0x01, 0x02) -> rules: 0x02 after function call
    function changeRule(bytes32 path, bytes32 _webID, bytes1 oldModes, bytes1 newModes) public isOwner modesInRange(oldModes) modesInRange(newModes) returns(bool response){
        if(removeRule(path, _webID, oldModes))
            return addRule(path, _webID, newModes);
        return false;
    }

    // Allows to delete a rule inside the Map
    // returns true on success
    //
    // Test scenario:
    // rules: 0x02
    // removeRule(..., ..., 0x01) -> false
    function removeRule(bytes32 path, bytes32 _webID, bytes1 _modes) public isOwner modesInRange(_modes) returns(bool response){
        if(checkRule(path, _webID, _modes)){
            pathRules[path][_webID] ^= _modes;
            return true;
        }
        return false;
    }

    /* Only for DEBUG purpose
    function printModes(bytes32 path, bytes32 _webID) public view returns(bytes1 modes){
        return pathRules[path][_webID];
    }
    */
}
