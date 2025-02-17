import { AptosClient, AptosAccount, FaucetClient, HexString } from "aptos";
import fs from 'fs';
import path from 'path';

const NODE_URL = "https://fullnode.testnet.aptoslabs.com";
const FAUCET_URL = "https://faucet.testnet.aptoslabs.com";

const client = new AptosClient(NODE_URL);
const faucetClient = new FaucetClient(NODE_URL, FAUCET_URL);

async function deploy() {
  const privateKeyHex = process.env.PRIVATE_KEY;
  const deployer = new AptosAccount(new HexString(privateKeyHex).toUint8Array());

  console.log(`Deployer Address: ${deployer.address()}`);

  await faucetClient.fundAccount(deployer.address(), 100000000);

  const modulePath = path.join(__dirname, 'build', 'movement', 'aevia');
  const moduleBytes = fs.readFileSync(`${modulePath}.mv`);

  const txnHash = await client.publishPackage(deployer, {
    modules: [{ bytecode: moduleBytes }],
    metadata: new Uint8Array(),
  });

  console.log(`Deploy Transaction Hash: ${txnHash}`);
}

deploy().catch(console.error);
