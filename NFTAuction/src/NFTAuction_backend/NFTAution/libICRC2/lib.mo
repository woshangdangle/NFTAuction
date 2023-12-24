import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Principal "mo:base/Principal";
import Option "mo:base/Option";
import Error "mo:base/Error";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Types "../Types";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

module ICRC2Lib{
    public type Account = Types.Token.Account;
    public type Subaccount = Types.Token.Subaccount;
    public type Amount = Types.Token.Amount;
    public type Memo = Types.Token.Memo;
    public type Timestamp = Types.Token.Timestamp;
    public type Duration = Types.Token.Duration;
    public type TxIndex = Types.Token.TxIndex;
    public type Value = { #Nat : Nat; #Int : Int; #Blob : Blob; #Text : Text; };
    public type TransferArgs = Types.Token.TransferArgs;
    public type TransferFromArgs = Types.Token.TransferFromArgs;
    public type TransferError = Types.Token.TransferError;
    public type TransferResult = Types.Token.TransferResult;
    public type TransferFromResult = Types.Token.TransferFromResult;
    public type ApproveArgs = Types.Token.ApproveArgs;
    public type ApproveResult = Types.Token.ApproveResult;



    public class ICRC2(addr: Text): Types.Token.ICRC2interface = this {
        let canister = actor(addr): actor { 
            icrc1_transfer: shared (TransferArgs) -> async TransferResult;
            icrc1_balance_of: query (Account) -> async Amount;
            icrc1_total_supply: query () -> async Amount;
            icrc1_symbol: query () -> async Text;
            icrc1_decimals: query () -> async Nat8;
            icrc1_fee: query () -> async Nat;
            icrc2_approve : shared (ApproveArgs) -> async ApproveResult;
            icrc2_transfer_from : shared (TransferFromArgs) -> async TransferFromResult;
         
        };
        public func icrc1_balance_of(account : Account): async Amount { await canister.icrc1_balance_of(account)};
        public func icrc1_total_supply(): async Amount { await canister.icrc1_total_supply()};
        public func icrc1_symbol(): async Text { await canister.icrc1_symbol() };
        public func icrc1_decimals(): async Nat8 { await canister.icrc1_decimals()  };
        public func icrc1_fee(): async Nat { await canister.icrc1_fee() };
      
        public func icrc1_transfer(args: TransferArgs): async TransferResult { await canister.icrc1_transfer(args)  };
        public func icrc2_approve(args: ApproveArgs): async ApproveResult { await canister.icrc2_approve(args)  };
        public func icrc2_transfer_from(args: TransferFromArgs): async TransferFromResult { await canister.icrc2_transfer_from(args) };
     
    }
    
}