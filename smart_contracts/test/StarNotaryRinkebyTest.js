const StarNotary = artifacts.require('StarNotary')

contract('StarNotary', accounts => { 

    beforeEach(async function() { 
        this.contract = await StarNotary.new({from: accounts[0]})
    })
    
    // describe('can create a star', () => { 
    //     it('can create a star and get its name', async function () { 
    //         let tokenId = 110000

    //         await this.contract.createStar("Awesome Star!", "ra_032.155", "dec_121.874", "mag_245.978", "I love my Awesome star", tokenId, {from: accounts[0]})
    //         let starInfo = await this.contract.tokenIdToStarInfo(tokenId, {from: accounts[0]});
    //         console.log(starInfo)
    //         console.log(tokenId)
    //         assert.equal(starInfo[1], 'Awesome Star!')
    //     })
    // })
    describe('show star info', () => { 
        let starId = 210000;
        it('can show star info from token', async function () { 
            await this.contract.createStar("Star power 104!", "I love my wonderful star 104", "ra_132.155", "dec_141.874", "mag_244.978", starId, {from: accounts[0]})
            
            let starInfo = await this.contract.tokenIdToStarInfo(starId, {from: accounts[0]});
            console.log(starInfo)
            
            assert.equal(starInfo[0], 'Star power 104!')
        })
    })

    
    describe('check star owner', () => { 
        let starId = 210000;
        it('user1 should be the owner', async function () { 
            await this.contract.createStar("Star power 104!", "I love my wonderful star 104", "ra_132.155", "dec_141.874", "mag_244.978", starId, {from: accounts[0]})
            var addr = await this.contract.ownerOf(starId, {from: accounts[0]})
        
            assert.equal(addr, accounts[0])
        })
    })

    describe('user can sell a star', () => { 
        let starId = 210000;
        it('user can put up their star for sale', async function () { 
            await this.contract.createStar("Star power 104!", "I love my wonderful star 104", "ra_132.155", "dec_141.874", "mag_244.978", starId, {from: accounts[0]})
            
            let starPrice = web3.toWei(.01, "ether");
            
            await this.contract.putStarUpForSale(starId, starPrice, {from: accounts[0]})
        
            assert.equal(await this.contract.starsForSale(starId), starPrice)
        })
    })
})