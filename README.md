# equio

Smart contract to invest in ICOs and distribute ICO tokens back to investors in proportion to their contribution.

### Usage

- This contract is located at `address will be provided when functionality is fully tested`
- Call the generate function of the contract with values for

  `string _name` : Name of the sale. Used for logging and events only.

  `address _sale` : Address of the sale. Must start with 0x.

  `address _token` : Address of the ERC20 token the sale will distribute. Must start with 0x.

  `bytes32 _password_hash` : Keccak256 hash of the kill switch password. Must start with 0x.

  `uint256 _earliest_buy_block` : Earliest block that sale address will accecpt funds. If this is not needed set to 0.

  `uint256 _earliest_buy_time` : Earliest unix time that sale address will accecpt funds. If this is not needed set to 0.


- Record the address of the new Equio contract returned by the generate function.
- Use https://etherscan.io/verifyContract to verify the contract source code.
- Share the contract address and password of the new Equio contract.
- Investors should look up the contract address received to check for the expected verified source code.
- Investments must be made with an amount over 1 finney. Amounts less than this will trigger a withdrawal.
- Anyone with the password can call the kill switch function.
- Someone must call the buy_sale function to trigger sending funds from the contract to the ICO address.
