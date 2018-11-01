pragma solidity ^0.4.23;
import './ERC721Token.sol';

contract StarNotary is ERC721Token { 

    struct Star { 
        string name; 
        string Dec;
        string Mag;
        string Cent;
        string story;
    }
    
    mapping(uint256 => Star) public tokenIdToStarInfo;
    string[] public starCoordinatorHash; 
    mapping(uint256 => uint256) public starsForSale;

    function createStar(string _name, string _story, string _dec, string _mag, string _cent, uint256 _tokenId) public { 
        bool checkCoord = checkIfStarExist(_dec, _mag, _cent);
        require(!checkCoord, "this coordination has already been registered");
        string memory starHash = _getStarHash(_dec, _mag, _cent);
        starCoordinatorHash.push(starHash);
        Star memory newStar = Star(_name, _dec, _mag, _cent, _story);
        tokenIdToStarInfo[_tokenId] = newStar;

        ERC721Token.mint(_tokenId);
    }

    function checkIfStarExist(string _dec, string _mag, string _cent) internal view returns (bool) {
        
        string memory starHash = _getStarHash(_dec, _mag, _cent);
        for (uint i = 0; i < starCoordinatorHash.length; i++) {
            string memory _hash = starCoordinatorHash[i];
            if (keccak256(_hash) == keccak256(starHash)) {
                return true;
            }
        }
        return false;
    }

    function _getStarHash(string _dec, string _mag, string _cent) internal pure returns (string) {
        string memory starHash = _strConcat(_dec, _mag);
        starHash = _strConcat(starHash, _cent);
        return starHash;
    } 
    
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public { 
        require(this.ownerOf(_tokenId) == msg.sender);

        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable { 
        require(starsForSale[_tokenId] > 0);

        uint256 starCost = starsForSale[_tokenId];
        address starOwner = this.ownerOf(_tokenId);

        require(msg.value >= starCost);

        clearPreviousStarState(_tokenId);

        transferFromHelper(starOwner, msg.sender, _tokenId);

        if(msg.value > starCost) { 
            msg.sender.transfer(msg.value - starCost);
        }

        starOwner.transfer(starCost);
    }

    function clearPreviousStarState(uint256 _tokenId) private {
        //clear approvals 
        tokenToApproved[_tokenId] = address(0);

        //clear being on sale 
        starsForSale[_tokenId] = 0;
    }
    
    function tokenIdToStarInfo(uint256 _tokenId) public constant returns (string,string,string,string,string) {
        Star memory star = tokenIdToStarInfo[_tokenId];
        return (star.name,star.story,star.Cent,star.Dec,star.Mag);
    }
    
    
    function _strConcat(string _str1, string _str2) internal pure returns (string){
        bytes memory _byte1 = bytes(_str1);
        bytes memory _byte2 = bytes(_str2);

        bytes memory _bytes = new bytes(_byte1.length + _byte2.length);
        uint j = 0;
        for (uint i = 0; i < _byte1.length; i++) {
            _bytes[j++] = _byte1[i];
        }
        for (i = 0; i < _byte2.length; i++) {
            _bytes[j++] = _byte2[i];
        } 
        return string(_bytes);
    }
}