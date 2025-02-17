<p align="center">
  <img src="aevia.png" alt="Aevia Image"/>
</p>

# Aevia Protocol

A smart contract for Movement Network that enables secure fund management through an authorized AI agent system.

## Overview

The Aevia Protocol provides a secure way to manage funds through a vault system where:

- Users can deposit their tokens into personal vaults
- An authorized agent can manage these funds
- The protocol maintains strict access control through an authority system

## Features

- **Vault System**: Each user has a personal vault for their tokens
- **Agent Authority**: A designated agent can manage funds across vaults
- **Access Control**: Only authorized agents can transfer funds
- **Multi-token Support**: Works with any coin type through Move's generics

## Installation

1. Clone the repository
2. Install Movement CLI
```bash
curl -fsSL https://raw.githubusercontent.com/movemntdev/movement/main/scripts/dev_setup.sh | sh
```

## Testing

Run the test suite:
```bash
movement move test
```

## Contract Structure

- `Vault<CoinType>`: Stores user tokens
- `AgentAuthority`: Manages agent authorization
- `init_agent_authority`: Initializes the authorized agent
- `deposit`: Allows users to deposit funds
- `transfer_from_vault`: Enables authorized transfers
- `get_balance`: Queries vault balances

## Usage

### Initialize Agent Authority
```move
init_agent_authority(&admin, agent_address);
```

### Deposit Funds
```move
deposit<CoinType>(&user, amount);
```

### Transfer Funds (Agent Only)
```move
transfer_from_vault<CoinType>(&agent, from, to, amount);
```

## Security

- Only authorized agents can transfer funds
- All operations are protected by Move's type system
- Access control checks are enforced at the protocol level