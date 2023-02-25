
## Usage

### Pre Requisites

- Yarn >= v1.22.15
- Node.js >= v12.22.6

```sh
cp .env.example .env
```

Then, proceed with installing dependencies:

```sh
yarn
```

### Compile

Compile the smart contracts with Hardhat:

```sh
$ yarn compile
```



### Deploy

Deploy the target contracts to BSC Testnet Network:

```sh
$ yarn hardhat deploy --network bsctestnet --tags target
```


Deploy the receiver contracts to BSC Testnet Network under proxy:

```sh
$ yarn hardhat deploy --network bsctestnet --tags receiver
```

Verify all contract which deployed

```sh
$ yarn hardhat --network bsctestnet etherscan-verify --api-key H922NUM3RTXX6FDRFFGZIQZX8J7Z441XRF
```
## About Project
The project consists of two contracts: Receiver and Target.
1. Receiver: is a relay contract, receives the meta transaction from the user and executes it.
Signer will send batch tx to this contract, and the contract will execute.
At first, I was also planning to use EIP712 on the contract, but verifying a list of txs would be very gas-consuming,
so I decided for the execute function to be sent only from the signer (I validate meta-tx in BE using EIP712). If you need the EIP712 version,
just ping me and I will send it to you.
2. Target contract: is a mint-able ERC20 contract.

After deploying, you need grant signer role for signer address which you config in Backend