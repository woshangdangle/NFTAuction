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

module NFTLib{
    public type TokenId = Types.NFT.TokenId;
    public type OwnerResult=Types.NFT.OwnerResult;
    public type TxReceipt=Types.NFT.TxReceipt;
    public type MetadataDesc=Types.NFT.MetadataDesc;
    public type MintReceipt=Types.NFT.MintReceipt;

    public class DIP721(addr: Text): Types.NFT.NFTInterface = this {
        let canister = actor(addr): actor { 
            ownerOfDip721: shared (Types.NFT.TokenId) -> async Types.NFT.OwnerResult;
            safeTransferFromDip721: shared (from: Principal, to: Principal, token_id: Types.NFT.TokenId) -> async Types.NFT.TxReceipt;
            mintDip721: shared (to: Principal, metadata: Types.NFT.MetadataDesc) -> async Types.NFT.MintReceipt;
           
         
        };
    
        public func ownerOfDip721( DipID:TokenId): async OwnerResult {  await canister.ownerOfDip721(DipID) };
        public func safeTransferFromDip721(from: Principal, to: Principal, DipID:TokenId): async TxReceipt { await canister.safeTransferFromDip721(from,to,DipID) };
        public func mintDip721(to: Principal, metadata: MetadataDesc): async MintReceipt { await canister.mintDip721(to,metadata) };
        
 
    }
    
}