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
    rule[15] private rules;

    bytes32 public podName;

    modifier isOwner(){
        require(msg.sender == owner, "Not allowed!");
        _;
    }
    
    constructor(bytes32 _podName){
        owner = msg.sender;
        podName = _podName;
    }

    function convertModes(bool r, bool w, bool a, bool c) private pure returns(uint8 modes){
        uint8 _modes = 0;
        if(r) _modes += 1;
        if(w) _modes += 2;
        if(a) _modes += 4;
        if(c) _modes += 8;
        return _modes - 1;
    }

    function addRule(bytes32 _webID, bool r, bool w, bool a, bool c) public isOwner returns(bool response){
        if(checkRule(_webID, r, w, a, c) == -1){
            rules[ convertModes(r, w, a, c) ].webID.push( _webID );
            return true;
        }
        return false;
    }

    function checkRule(bytes32 _webID, bool r, bool w, bool a, bool c) public view returns(int index){
        uint8 modes = convertModes(r, w, a, c);
        for(uint i=0; i<rules[ modes ].webID.length; i++){
            if(rules[ modes ].webID[i] == _webID) return int(i);
        }
        return -1;
    }

    function changeRule(bool r, bool w, bool a, bool c, bytes32 _webID, bool newR, bool newW, bool newA, bool newC) public isOwner returns(bool response){
        if(removeRule(_webID, r, w, a, c)){
            addRule(_webID, newR, newW, newA, newC);
            return true;
        }
        return false;
    } 

    function removeRule(bytes32 _webID, bool r, bool w, bool a, bool c) public isOwner returns(bool response){
        int index = checkRule(_webID, r, w, a, c);
        if(index > -1){
            uint8 modes = convertModes(r, w, a, c);
            rules[ modes ].webID[uint(index)] = rules[ modes ].webID[rules[ modes ].webID.length - 1];
            rules[ modes ].webID.pop();
            return true;
        }
        return false;
    } 

    function getWebID(bool r, bool w, bool a, bool c) public view returns(uint len){
        return rules[ convertModes(r, w, a, c) ].webID.length;
    }
}
