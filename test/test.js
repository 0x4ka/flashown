const { describe, it, before } = require('mocha');
const { expect } = require('chai');
const { ethers, network } = require('hardhat');
const BN = ethers.BigNumber.from;

describe('結合テスト - CryptoKitties正常系', () => {
  let protocolAdminEOA, collectionOwnerEOA, lenderEOA, renterEOA;
  let flashloan, vault, collection;
  before('デプロイ', async () => {
    // 署名者の取得
    [protocolAdminEOA, collectionOwnerEOA, lenderEOA, renterEOA] = await ethers.getSigners();
    // コントラクトのデプロイ
    const Flashloan = await ethers.getContractFactory('CKflashmoonUse', renterEOA);
    const Vault = await ethers.getContractFactory('Vault', protocolAdminEOA);
    const Collection = await ethers.getContractFactory('KittyCore');
    flashloan = await Flashloan.deploy();
    vault = await Vault.deploy();
    collection = await Collection.attach("0x06012c8cf97BEaD5deAe237070F9587f8E7A266d");
    await Promise.all([flashloan.deployed(), vault.deployed()]);
  });

  describe('Lenderの所有の確認とVaultへの預け入れ', () => {
    it('balanceOfによる所有数確認', async () => {
      expect(await collection.balanceOf("0x6A4814d56038E5EF690D2257732c1EaCfCe19af8")).to.eql(BN(4));
    });

    it('vaultに対してapprove処理', async () => {
      const approved = collection.approve(vault.address, BN(1971713));
      await (await approved).wait();
      await expect(approved).to.emit(collection, 'Approval');
    });

    it('Vaultへトランスファー実行', async () => {
      expect(await collection.balanceOf(vault.address)).to.eql(BN(0));
      await vault.deposit(collection.address, BN(1971713));
      expect(await collection.balanceOf(vault.address)).to.eql(BN(1));
    });
  });

  describe('フラッシュローンの実行', () => {
    it('vaultの設定', async () => {
      await flashloan.setVault(vault.address);
    });

    //Flashloan
    it('借り手がフラッシュローンを実行する', async () => {
      flashloanArgs = {
        collection: collection.address,
        metronId: 2,
        sireId: 1
      };
      expect(await collection.isReadyToBreed(2)).to.be.eql(true);
      const breedFullFilled = await flashloan.flashBreed(...Object.values(flashloanArgs), {
        value: ethers.utils.parseEther('0.02'),
      });
    });
    it('isReadyToBreedがfalseになっていることを確認する', async () => {
      expect(await collection.isReadyToBreed(2)).to.be.eql(false);
    });
    it('Pregnantイベントの発火を確認', async () => {
      await expect(flashloan).to.emit(collection, 'Pregnant');
    });
    it('giveBirthに3を代入', async () => {
      await expect(collection.giveBirth(3)).to.be.revertedWith('');
    });
    it('kittyのisGestatingがtrueである', async () => {
      let kitty = await collection.getKitty(2);
      await expect(kitty.isGestating).to.be.eql(true); //check matron are pregnant
    });
  });
});