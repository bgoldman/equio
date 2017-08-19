# equio

Smart contract to invest in ICOs and distribute ICO tokens back to investors in proportion to their contribution.

### Usage

Deploy this smart contract.
Call the contract create sub contract function with params for
- list of allowed investor addresses
- ICO name
- ICO deposit address
- One of:
  - Unix timestamp when to invest in the ICO
  - Block number when to invest in ICO
- Max investment amount

Get the address of the sub contract?

Verify the sub-contract bytecode / opcode matches the expected code

Send Ether to the sub-contract address?

Design
- setup
  - initialize list of allowed addresses

- cleanup
  - selfdestruct
  - refund remaining ether proportionally to all investing addresses
  - no ether should remain at this point.
  - use suicide or another operation which uses negative gas


- Seed notes

  Use this as a template, remove the fee, and make it generic
  https://etherscan.io/address/decentraland.icobuyer.eth#code

  instead of the claim_bounty function? That function was written to allow many users to race to execute the contract to make sure it executes in the very first block. But for pre-ICOs we don't race. So what triggers the send? Maybe a time stamp?

  We also need a deployment script that runs as a command line tool where we enter the ICO name, timestamp of future send, max total amount, and ICO address, and then it modifies the template and deploys it

  npm run deploy -- --iconame decentraland --sendtime 1503014400 --maxamount 250 --address 0xCe5cEF13215534d5C1852f3fC81E1B2aeC0D1DE1
