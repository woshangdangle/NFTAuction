import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import List "mo:base/List";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Text "mo:base/Text";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Option "mo:base/Option";
import Error "mo:base/Error";
import Time "mo:base/Time";
import Timer "mo:base/Timer";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Blob "mo:base/Blob";
import Bool "mo:base/Bool";
import Nat64 "mo:base/Nat64";
import Types "./Types";


import ICRC2Lib "./libICRC2/";
import NFTLib "./libDip721/";


shared ({ caller }) actor class NFTAution() = this {

    private stable var _inited : Bool = false;
    private stable var Fee : Nat=0;
    private stable var FeeBase : Nat=10000;

    private stable var BuyToken : Principal=Principal.fromText("aaaaa-aa");
    private stable var NftAddress : Principal=Principal.fromText("aaaaa-aa");
    private stable var FeeAddress : Principal=Principal.fromText("aaaaa-aa");
    private stable var admin : Principal =Principal.fromText("aaaaa-aa");
    private var BuyTokenImpl :Types.Token.ICRC2interface =ICRC2Lib.ICRC2("aaaaa-aa");
    private var DIP721Impl : Types.NFT.NFTInterface =NFTLib.DIP721("aaaaa-aa");
    
    public type PublicAuction = Types.Token.PublicAuction;


    
    private stable var PublicAuctionInfo : [(Nat, PublicAuction)] = [];
    private var PublicAuctionInfoMap : HashMap.HashMap<Nat, PublicAuction> = HashMap.fromIter<Nat, PublicAuction>(PublicAuctionInfo.vals(), 10, Nat.equal, Hash.hash);
   
    
   
    
    
    public shared ({ caller }) func init(
        fee : Nat,
        Tokenaddr : Principal,
        Nftaddr : Principal,
        Feeaddr : Principal,
    ) : async () {
        if (not _inited) {
            Fee := fee; 
            BuyToken :=Tokenaddr;
            NftAddress:=Nftaddr;
            FeeAddress:=FeeAddress;
            admin:=  caller;
            
            BuyTokenImpl:=ICRC2Lib.ICRC2(Principal.toText(BuyToken));
            DIP721Impl:=NFTLib.DIP721(Principal.toText(NftAddress));
            _inited:=true;
        };
    };
    
    //创建拍卖
    public shared ({ caller }) func CreateAuction(tokenID:Nat64,startPrice:Nat ) : async Bool {
        let Owner =  await DIP721Impl.ownerOfDip721(tokenID);
        Debug.print "owner request success:";
        Debug.print(debug_show(Owner));
      
        if ((Owner==caller)and(startPrice > 0)){
            var Info: PublicAuction={
                creater=caller;
                startingPrice = startPrice;
                highestBid =0;
                highestBidder =Principal.fromText("aaaaa-aa");
                auctionEnd =Time.now()+ 3600000000000;
                finished =false;

            };
            PublicAuctionInfoMap.put(Nat64.toNat(tokenID), Info); 
            let canisterId = Principal.fromActor(this);
            Debug.print "NFt transer star";
            let NftTransfer =  await DIP721Impl.safeTransferFromDip721(caller,canisterId,tokenID) ;
            
            

        };
        return true;
    };
/*  */
     //参与拍卖
    public shared ({ caller }) func makeBid(tokenID:Nat64,bidprice:Nat ) : async Bool {
       let BidInfo :PublicAuction= switch (PublicAuctionInfoMap.get(Nat64.toNat(tokenID))) { 
           
            case (?info) { info};   
          
        };
         Debug.print "获取拍卖信息";
         Debug.print(debug_show(BidInfo));
        if ((BidInfo.finished==false)and(Time.now()<=BidInfo.auctionEnd)){  
             Debug.print "状态判断成功111111111111111111111111";
              //判断状态
            if((bidprice > BidInfo.startingPrice)and(bidprice > BidInfo.highestBid)){  //本次出价大于最高出价和起拍价
                Debug.print "状态判断成功222222222222222";
                    var Info: PublicAuction={
                    creater=BidInfo.creater;
                    startingPrice = BidInfo.startingPrice;
                    highestBid =bidprice;
                    highestBidder =caller;
                    auctionEnd =BidInfo.auctionEnd;
                    finished =false;
                };
            PublicAuctionInfoMap.put(Nat64.toNat(tokenID), Info); 
            Debug.print "状态修改成功";
            let canisterId = Principal.fromActor(this);
            Debug.print "ICRC用户向合约开始转账";
            let ICRC2Transfer =  await BuyTokenImpl.icrc2_transfer_from({spender_subaccount = null; from = { owner = caller; subaccount = null }; to = { owner = canisterId; subaccount = null }; amount = bidprice; fee = null; memo = null; created_at_time = null }) ;
            Debug.print "ICRC用户向合约转账结束";


             };
        };
        return true;
    };



    //结束拍卖
 public shared ({ caller }) func FinishBid(tokenID:Nat64 ) : async Bool {
       let BidInfo :PublicAuction= switch (PublicAuctionInfoMap.get(Nat64.toNat(tokenID))) { 
            case (?info) { info};   
        };
       if ((Time.now()>=BidInfo.auctionEnd) or(admin==caller)){  //admin 或者时间超过结束 
        let canisterId = Principal.fromActor(this);

        var Info: PublicAuction={
                    creater=BidInfo.creater;
                    startingPrice = BidInfo.startingPrice;
                    highestBid =BidInfo.highestBid;
                    highestBidder =BidInfo.highestBidder;
                    auctionEnd =BidInfo.auctionEnd;
                    finished =true;
                };
            PublicAuctionInfoMap.put(Nat64.toNat(tokenID), Info); 

        let ICRC2Transfer =  await BuyTokenImpl.icrc1_transfer({ from = { owner = canisterId; subaccount = null }; from_subaccount = null; to = { owner = BidInfo.creater; subaccount = null }; amount = BidInfo.highestBid; fee = null; memo = null; created_at_time = null }) ;
        
        let NftTransfer =  await DIP721Impl.safeTransferFromDip721(canisterId,BidInfo.highestBidder,tokenID);

       };


       return true;


 };
    public query func getPublicAuctionInfo(AuctionID : Nat) : async  PublicAuction{
        return switch (PublicAuctionInfoMap.get(AuctionID)) {
            case (?_p) { return _p};
            
        };
    };

    public shared func setAuctionAddress(Buyaddr: Principal,Nftaddr:Principal,Feeaddr:Principal): async () {
        BuyToken := Buyaddr;
        NftAddress:=Nftaddr;
        FeeAddress:=Feeaddr;      
    };


    public query func getAuctionAddress() : async {
        Buyaddr : Principal;
        Nftaddr : Principal;
        Feeaddr : Principal;
    } {
        return {
            Buyaddr = BuyToken;
            Nftaddr = NftAddress;
            Feeaddr = FeeAddress;
        };
    };




}