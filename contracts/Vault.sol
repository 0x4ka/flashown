// SPDX-License-Identifier: agpl-3.0
pragma solidity =0.8.13;

interface IFlashloanReceiver {
    function executeOperation(address tokenAddress, uint256 _tokenId) external payable;
}

interface ICK {
    function canBreedWith(uint256 _matronId, uint256 _sireId) external view returns(bool);
    function breedWithAuto(uint256 _matronId, uint256 _sireId) external payable;
    function transfer(address _to, uint256 _tokenId) external;
    function ownerOf(uint256 _tokenId) external view returns (address owner);
    function approve(address _to, uint256 _tokenId) external;
}

contract Vault {
    function flashloan (address cryptoKittie, uint256 tokenId, address _receiver) public payable {
        IFlashloanReceiver receiver = IFlashloanReceiver(_receiver);
        ICK token = ICK(cryptoKittie);
        address ownerAddressBefore = token.ownerOf(tokenId);

        //transfer funds to the receiver
        token.transfer(_receiver, tokenId);

        //execute action of the receiver
        receiver.executeOperation{
            value:msg.value
        }(cryptoKittie, tokenId);

        //check
        address ownerAddressAfter = token.ownerOf(tokenId);
        require(ownerAddressBefore == ownerAddressAfter, "");
    }

    //collection => tokeneId => address
    mapping(uint256 => address) public _depositUser;

    function deposit (address cryptoKittie, uint256 tokenId) public {
        ICK token = ICK(cryptoKittie);
        require(msg.sender == token.ownerOf(tokenId), "you are not token owner");
        _depositUser[tokenId] = msg.sender;
        token.transfer(address(this), tokenId);
    }

    function withdraw(address cryptoKittie, uint256 _tokenId) public {
        address _owner = _depositUser[_tokenId];
        require(msg.sender == _owner);
        ICK(cryptoKittie).transfer(msg.sender, _tokenId);
    }

    function withdrawDirect(address cryptoKittie, uint256 _tokenId) public {
        ICK(cryptoKittie).transfer(msg.sender, _tokenId);
    }
}