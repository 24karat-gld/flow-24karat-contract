# flow-24karat-contract

Smart Contract for 24karat collection on FLOW

## Run tests

in `lib/js` run tests using this command:

```shell
npm i //frist time we need install modules
npm test	//this will run jtest for our tests
```

## Testnet Demo

Check out the [live demo of 24Karat collection](http://24karat-develop.netlify.app),
deployed on the Flow Testnet.

## Project Overview

![Project Overview](./24karat-project-overview.png)

## 🔎 Legend

Above is a basic diagram shows this project contains a static web app, a backend REST API in a web server, and how each part interacts with the others.

### Contracts code

This repository is only for the open-sourced smart contracts. It also contains test cases so we can run automated tests.

### Wallet

The wallet is hosted in the backend server. We will take responsibility to keep our client's wallets carefully and safely for this stage. which means we will cover all blockchain-related fees for our clients.

## 💎 What are 24Karat collection?

24Karat collection is an Arts NFT ( [non-fungible tokens](https://github.com/onflow/flow-nft) ) marketplace, which is stored on the Flow blockchain.

The NFT Arts can be purchased from the marketplace with fungible tokens.

---

👹 Happy Hacking!
