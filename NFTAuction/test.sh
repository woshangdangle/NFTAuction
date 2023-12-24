#!/bin/bash
# set -e
# clear
dfx stop
rm -rf .dfx

dfx start --background --clean 
dfx canister create --all
dfx build

MINTER_PRINCIPAL="$(dfx identity get-principal)"
DEFAULT_PRINCIPAL="$(dfx identity get-principal)"

export TOKEN_NAME="AAAAAAAA"
export TOKEN_SYMBOL="aaaaaaa"

export DEFAULT=$(dfx identity get-principal)


export PRE_MINTED_TOKENS=10_000_000_000_000

export TRANSFER_FEE=0

export FEATURE_FLAGS=true



dfx deploy ICRC2  --argument "(record {
     initial_mints = vec {record{account=record{owner=principal \"${DEFAULT}\";};amount=${PRE_MINTED_TOKENS}:nat}};
     minting_account = record { owner = principal \"${DEFAULT}\"; };
     token_symbol = \"${TOKEN_SYMBOL}\";
     token_name = \"${TOKEN_NAME}\";
     transfer_fee = ${TRANSFER_FEE};
     decimals = 6:nat8;
 })"


dfx deploy DIP721  --argument '(principal "be2us-64aaa-aaaaa-qaabq-cai", record{logo = record{ logo_type= "low"; data= "date";}; name = "DIP721"; symbol = "DIP721"; maxLimit= 500:nat16})'

dfx deploy NFTAuction  


dfx canister call NFTAuction init '(20,principal "bd3sg-teaaa-aaaaa-qaaba-cai",principal "bkyz2-fmaaa-aaaaa-qaaaq-cai",principal "72yqx-w2mss-lyri3-4u3dy-cnjgq-t7wle-afd74-6cbi5-fc7pf-wwpt6-zqe")'

dfx canister call DIP721 mintDip721  '(principal "shho7-m4hkn-r2ox6-an5xr-uk5wa-po4wb-dt4bs-mjih3-74vpg-cujme-fae", vec {})'

dfx canister call NFTAuction CreateAuction '(0,5000000000)'

dfx identity new buyer
dfx identity use buyer
export BUYER=$(dfx identity get-principal)
dfx identity use user1  

dfx canister call ICRC2 icrc1_transfer  '(record {to=record {owner=principal "stied-kejqz-v56ea-s7o2y-iw2kd-uny7f-mv4aw-xyfpv-wjyjv-cqgf7-eqe"; subaccount=null}; fee=null; memo=null; from_subaccount=null; created_at_time=null; amount=500000000000})'
dfx identity use buyer
dfx canister call ICRC2 icrc2_approve  '(record {fee=null; memo=null; from_subaccount=null; created_at_time=null; amount=99999999999999999999999999; expected_allowance=null; expires_at=null; spender=record {owner=principal "be2us-64aaa-aaaaa-qaabq-cai"; subaccount=null}})'

dfx canister call NFTAuction makeBid '(0,50000000000)'










 




