# equio

Smart contract to invest in ICOs and distribute ICO tokens back to investors in proportion to their contribution.

### Usage

Deploy this EquioGenesis contract.
Call the EquioGenesis generate function with params for


`string _name` - Name of the sale. Used for logging and events only.

`address _sale` - Address of the sale. Must start with 0x.

`address _token` - Address of the ERC20 token the sale will distribute. Must start with 0x.

`bytes32 _password_hash` - hash of the kill switch password. Must start with 0x.

`uint256 _earliest_buy_block` - earliest block that the funds can be sent to the sale. If this is not needed set to 0.

`uint256 _earliest_buy_time` - earliest unix time that the funds can be sent to the sale. If this is not needed set to 0.


Record the address of the new Equio contract returned by the generate function.

Share the address and password SHA3 hash or password of the new Equio contract.

Investors should independently verify the sub-contract bytecode / opcode matches the expected code using something like https://etherscan.io/verifyContract

Investments must be made with an amount over 1 finney. Amounts less than this will trigger a withdrawal.

Anyone with the password can call the kill switch.

Someone must call the buy_sale function to trigger sending funds from the contract to the ICO address.
