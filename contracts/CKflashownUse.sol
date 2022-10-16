// SPDX-License-Identifier: agpl-3.0
pragma solidity =0.8.13;

interface IVault {
    function flashloan (address tokenAddress, uint256 tokenId, address _receiver) external payable;
}

interface ICK {
    function breedWithAuto(uint256 _matronId, uint256 _sireId) external payable;
    function transfer(address _to, uint256 _tokenId) external;
    function ownerOf(uint256 _tokenId) external view returns (address owner);
    function approve(address _to, uint256 _tokenId) external;
}

contract CKflashmoonUse {
    address _vault;
    uint256 _matronId;

    constructor(){}

    function executeOperation (address cryptoKittie, uint256 tokenId) public payable {
        ICK(cryptoKittie).breedWithAuto{
            value: msg.value
        }(_matronId, tokenId);

        //transfer funds to the receiver
        ICK(cryptoKittie).transfer(_vault, tokenId);
    }

    function flashBreed (address cryptoKittie, uint256 matronId, uint256 tokenId) public payable {
        _matronId = matronId;
        IVault(_vault).flashloan{
            value:msg.value
        }(cryptoKittie, tokenId, address(this));
    }

    function setVault(address vaultAddress) public {
        _vault = vaultAddress;
    }
}