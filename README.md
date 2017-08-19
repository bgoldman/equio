# equio

smart contract that people send ETH to and then receive tokens back in proportion to their ETH contributions
This smart contract is what makes the investment on the group’s behalf in the ETH depositied

Use this as a template, remove the fee, and make it generic
https://etherscan.io/address/decentraland.icobuyer.eth#code

instead of the claim_bounty function? That function was written to allow many users to race to execute the contract to make sure it executes in the very first block. But for pre-ICOs we don't race. So what triggers the send? Maybe a time stamp?

We also need a deployment script that runs as a command line tool where we enter the ICO name, timestamp of future send, max total amount, and ICO address, and then it modifies the template and deploys it

npm run deploy -- --iconame decentraland --sendtime 1503014400 --maxamount 250 --address 0xCe5cEF13215534d5C1852f3fC81E1B2aeC0D1DE1



- cleanup
  - selfdestruct
  - refund remaining ether proportionally to all investing addresses
  - no ether should remain at this point.
  - use suicide or another operation which uses negative gas
