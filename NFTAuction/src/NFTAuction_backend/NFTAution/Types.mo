import Blob "mo:base/Blob";
import Bool "mo:base/Bool";
import Time "mo:base/Time";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Error "mo:base/Error";

module  Token{
  //   /////////////////ICRC2 
  public type Account = { owner : Principal; subaccount : ?Subaccount };
  public type Subaccount = Blob;
  public type Tokens = Nat;
  public type Memo = Blob;
  public type Timestamp = Nat64;
  public type Duration = Nat64;
  public type TxIndex = Nat;
  public type Amount = Nat;
  public type Value = { #Nat : Nat; #Int : Int; #Blob : Blob; #Text : Text };



 //   /////////////////Auction
    public type PublicAuction = {   
        creater:Principal;
        startingPrice : Nat;
        highestBid : Nat;
        highestBidder : Principal;
        auctionEnd : Int;
        finished :Bool;
    };



    public type CycleInfo = {
        balance : Nat;
        available : Nat;
    };

    //   /////////////////ICRC2 Args
    //   /////////////////ICRC2 Args
    //   /////////////////ICRC2 Args
    public class ICRC2interface() {
  
        public func icrc1_balance_of(account : Account): async Amount { throw Error.reject("Unsupport method 'balanceOf'.") };
        public func icrc1_total_supply(): async Amount { throw Error.reject("Unsupport method 'totalSupply'.") };
        public func icrc1_symbol(): async Text { throw Error.reject("Unsupport method 'symbol'.") };
        public func icrc1_decimals(): async Nat8 { throw Error.reject("Unsupport method 'decimals'.") };
        public func icrc1_fee(): async Nat { throw Error.reject("Unsupport method 'fee'.") };
      
        public func icrc1_transfer(args: TransferArgs): async TransferResult { throw Error.reject("Unsupport method 'transfer'.") };
        public func icrc2_approve(args: ApproveArgs): async ApproveResult { throw Error.reject("Unsupport method 'approve'.") };
        public func icrc2_transfer_from(args: TransferFromArgs): async TransferFromResult { throw Error.reject("Unsupport method 'transferFrom'.") };
    };
    
     public type TransferArgs = {
        from: Account;
        from_subaccount : ?Subaccount;
        to : Account;
        amount : Amount;
        fee : ?Amount;
        memo : ?Memo;
        created_at_time : ?Timestamp;
    };
    public type TransferFromArgs = {
        spender_subaccount :?Subaccount;
        from: Account;
        to : Account;
        amount : Amount;
        fee : ?Amount;
        memo : ?Memo;
        created_at_time : ?Timestamp;
    };
    public type ApproveArgs = {
        from_subaccount : ?Subaccount;
        spender : Principal;
        amount : Amount;
        fee : ?Amount;
        memo : ?Memo;
        created_at_time : ?Timestamp;
    };

    public type TransferResult = {
        #Ok  : TxIndex;
        #Err : TransferError;
    };
        public type ApproveResult = {
        #Ok  : TxIndex;
        #Err : ApproveError;
    };
    public type TransferFromResult = {
        #Ok  : TxIndex;
        #Err : TransferFromError;
    };
        public type ApproveError = {
        #BadFee : { expected_fee : Amount };
        #InsufficientFunds : { balance : Amount };
        #TooOld;
        #CreatedInFuture : { ledger_time: Timestamp };
        #Duplicate : { duplicate_of : TxIndex };
        #TemporarilyUnavailable;
        #GenericError : { error_code : Nat; message : Text };
    };
    public type TransferFromError = {
        #BadFee : { expected_fee : Amount };
        #BadBurn : { min_burn_amount : Amount };
        #InsufficientFunds : { balance : Amount };
        #InsufficientAllowance : { allowance : Amount };
        #TooOld;
        #CreatedInFuture : { ledger_time: Timestamp };
        #Duplicate : { duplicate_of : TxIndex };
        #TemporarilyUnavailable;
        #GenericError : { error_code : Nat; message : Text };
    };
    public type TransferError = {
        #BadFee : { expected_fee : Amount };
        #BadBurn : { min_burn_amount : Amount };
        #InsufficientFunds : { balance : Amount };
        #TooOld;
        #CreatedInFuture : { ledger_time: Timestamp };
        #Duplicate : { duplicate_of : TxIndex };
        #TemporarilyUnavailable;
        #GenericError : { error_code : Nat; message : Text };
    };


    

};


module NFT{

    public class NFTInterface() {
  
        public func ownerOfDip721(token_id: TokenId): async OwnerResult { throw Error.reject("Unsupport method 'balanceOf'.") };
        public func safeTransferFromDip721(from: Principal, to: Principal, token_id: TokenId): async TxReceipt { throw Error.reject("Unsupport method 'totalSupply'.") };
        public func mintDip721(to: Principal, metadata: MetadataDesc): async MintReceipt { throw Error.reject("Unsupport method 'totalSupply'.") };
        
    };
  public type Dip721NonFungibleToken = {
    logo: LogoResult;
    name: Text;
    symbol: Text;
    maxLimit : Nat16;
  };

  public type ApiError = {
    #Unauthorized;
    #InvalidTokenId;
    #ZeroAddress;
    #Other;
  };
  public type Error = {
    #Not_NFT_Owner;
    #InvalidTokenId;
    #ZeroAddress;
    #Other;
    #CalllError : Text;
  };
  public type Result<S, E> = {
    #Ok : S;
    #Err : E;
  };

  public type OwnerResult = Result<Principal, ApiError>;
  public type TxReceipt = Result<Nat, ApiError>;
  
  public type TransactionId = Nat;
  public type TokenId = Nat64;

  public type InterfaceId = {
    #Approval;
    #TransactionHistory;
    #Mint;
    #Burn;
    #TransferNotification;
  };

  public type LogoResult = {
    logo_type: Text;
    data: Text;
  };

  public type Nft = {
    owner: Principal;
    id: TokenId;
    metadata: MetadataDesc;
  };

  public type ExtendedMetadataResult = Result<{
    metadata_desc: MetadataDesc;
    token_id: TokenId;
  }, ApiError>;

  public type MetadataResult = Result<MetadataDesc, ApiError>;

  public type MetadataDesc = [MetadataPart];

  public type MetadataPart = {
    purpose: MetadataPurpose;
    key_val_data: [MetadataKeyVal];
    data: Blob;
  };

  public type MetadataPurpose = {
    #Preview;
    #Rendered;
  };
  
  public type MetadataKeyVal = {
    key: Text;
    val: MetadataVal;
  };

  public type MetadataVal = {
    #TextContent : Text;
    #BlobContent : Blob;
    #NatContent : Nat;
    #Nat8Content: Nat8;
    #Nat16Content: Nat16;
    #Nat32Content: Nat32;
    #Nat64Content: Nat64;
  };

  public type MintReceipt = Result<MintReceiptPart, ApiError>;

  public type MintReceiptPart = {
    token_id: TokenId;
    id: Nat;
  };

}


