pragma solidity ^0.4.13;

// ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
contract ERC20 {
  function transfer(address _to, uint256 _value) returns (bool success);
  function balanceOf(address _owner) constant returns (uint256 balance);
}

contract Buyer {
  // Store the amount of ETH deposited by each account.
  mapping (address => uint256) public balances;
  // Track whether the contract has bought the tokens yet.
  bool public bought_tokens;
  // Record the time the contract bought the tokens.
  uint256 public time_bought;
  // Record ETH value of tokens currently held by contract.
  uint256 public contract_eth_value;
  // Emergency kill switch in case a critical bug is found.
  bool public kill_switch;

  // SHA3 hash of kill switch password.
  bytes32 password_hash = // config.get('password');
  // Earliest time contract is allowed to buy into the crowdsale.
  uint256 earliest_buy_block = // config.get('block');
  // The crowdsale address.
  address public sale = // config.get('saleAddress');
  // The token address.
  ERC20 public token = // config.get('tokenAddress');

  // Allows anyone with the password to shut down everything except withdrawals in emergencies.
  function activate_kill_switch(string password) {
    // Only activate the kill switch if the password is correct.
    if (sha3(password) != password_hash) throw;
    // Irreversibly activate the kill switch.
    kill_switch = true;
  }

  // Withdraws all ETH deposited or tokens purchased by the user.
  // "internal" means this function is not externally callable.
  function withdraw(address user) internal {
    // If called before the ICO, cancel user's participation in the sale.
    if (!bought_tokens) {
      // Store the user's balance prior to withdrawal in a temporary variable.
      uint256 eth_to_withdraw = balances[user];
      // Update the user's balance prior to sending ETH to prevent recursive call.
      balances[user] = 0;
      // Return the user's funds. Throws on failure to prevent loss of funds.
      user.transfer(eth_to_withdraw);
    }
    // Withdraw the user's tokens if the contract has already purchased them.
    else {
      // Retrieve current token balance of contract.
      uint256 contract_token_balance = token.balanceOf(address(this));
      // Disallow token withdrawals if there are no tokens to withdraw.
      if (contract_token_balance == 0) throw;
      // Store the user's token balance in a temporary variable.
      uint256 tokens_to_withdraw = (balances[user] * contract_token_balance) / contract_eth_value;
      // Update the value of tokens currently held by the contract.
      contract_eth_value -= balances[user];
      // Update the user's balance prior to sending to prevent recursive call.
      balances[user] = 0;
      // Send the funds.  Throws on failure to prevent loss of funds.
      if(!token.transfer(user, tokens_to_withdraw)) throw;
    }
  }

  // Automatically withdraws on users' behalves
  function auto_withdraw(address user){
    // TODO: why wait 1 hour
    // Only allow automatic withdrawals after users have had a chance to manually withdraw.
    if (!bought_tokens || now < time_bought + 1 hours) throw;
    // Withdraw the user's funds for them.
    withdraw(user, true);
  }

  // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
  function buy_crowdsale(){
    // Short circuit to save gas if the contract has already bought tokens.
    if (bought_tokens) return;
    // Short circuit to save gas if the earliest buy time hasn't been reached.
    if (block.number < earliest_buy_block) return;
    // TODO: short circuit based on unix time?
    // if (now < some target time) return;
    // Short circuit to save gas if kill switch is active.
    if (kill_switch) return;
    // Record that the contract has bought the tokens.
    bought_tokens = true;
    // Record the time the contract bought the tokens.
    time_bought = now;
    // Record the amount of ETH sent as the contract's current value.
    contract_eth_value = this.balance;
    // Transfer all the funds to the crowdsale address
    // to buy tokens.  Throws if the crowdsale hasn't started yet or has
    // already completed, preventing loss of funds.
    if(!sale.call.value(contract_eth_value)()) throw;
  }

  // A helper function for the default function, allowing contracts to interact.
  function default_helper() payable {
    // TODO: what's up with this? do we want to do this?
    // Treat near-zero ETH transactions as withdrawal requests.
    if (msg.value <= 1 finney) {
      withdraw(msg.sender, false);
    }
    // Deposit the user's funds for use in purchasing tokens.
    else {
      // Disallow deposits if kill switch is active.
      if (kill_switch) throw;
      // Only allow deposits if the contract hasn't already purchased the tokens.
      if (bought_tokens) throw;
      // Update records of deposited ETH to include the received amount.
      balances[msg.sender] += msg.value;
    }
  }

  // Default function.  Called when a user sends ETH to the contract.
  function () payable {
    // Prevent sale contract from refunding ETH to avoid partial fulfillment.
    if (msg.sender == address(sale)) throw;
    // Delegate to the helper function.
    default_helper();
  }
}