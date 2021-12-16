pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Rules
 * @dev Store acl rules of a POD
 */
contract Storage {
    
    struct rule{
        bytes32 webID;
        bool r;
        bool w;
        bool a;
        bool c;
    }

    address private owner;
    rule[] private rules;

    bytes32 public podName;

    modifier isOwner(){
        require(msg.sender == owner, "Not allowed!");
        _;
    }
    
    constructor(bytes32 _podName){
        owner = msg.sender;
        podName = _podName;
    }

    function addRule(bytes32 _webID, bool r, bool w, bool a, bool c) public isOwner returns(bool response){
        if(checkRule(_webID, r, w, a, c) == -1){
            rules.push( rule(_webID, r, w, a, c) );
            return true;
        }
        return false;
    }

    function checkRule(bytes32 _webID, bool r, bool w, bool a, bool c) public view returns(int index){
        for(uint i=0; i<rules.length; i++){
            if(rules[i].webID == _webID && rules[i].r == r && rules[i].w == w && rules[i].a == a && rules[i].c == c) return int(i);
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
            rules[ uint(index) ] = rules[ rules.length - 1 ];
            rules.pop();
            return true;
        }
        return false;
    } 

/*Only for debug
    function getWebID() public view returns(uint len){
        return rules.length;
    }
*/
}
