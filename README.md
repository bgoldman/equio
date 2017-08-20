# equio

Smart contract to invest in ICOs and distribute ICO tokens back to investors in proportion to their contribution.

### Usage

Deploy this EquioGenesis contract.
Call the EquioGenesis generate function with params for

`string _name` - name of the sale
`address _sale`, - address of the sale
`address _token`, - token address the sale will distribute
`bytes32 _password_hash`, - hash of the kill switch password
`uint256 _earliest_buy_block`, - earliest block that the funds can be sent to the sale. If this is not needed set to 0.
`uint256 _earliest_buy_time` - earliest unix time that the funds can be sent to the sale. If this is not needed set to 0.

Record the address of the new Equio contract returned by the generate function.

Share the address and password SHA3 hash or password of the new Equio contract.

Investors should independently verify the sub-contract bytecode / opcode matches the expected code using something like https://etherscan.io/verifyContract

Note: this is not implemented as it may be insecure.
`Investors should call the verifyPassword method to ensure they have kill-permissions over the contract.`

Investments must be made with an amount over 1 finney. Amounts less than this will trigger a withdrawal.

Anyone with the password can call the kill switch.

Someone must call the buy_sale function to trigger sending funds from the contract to the ICO address.
