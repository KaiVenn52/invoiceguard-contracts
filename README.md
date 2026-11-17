# InvoiceGuard contracts

Solidity 0.8.28, optimizer 200 runs. Aevum testnet chain 44005 only.

Run `npm ci`, `npm test`, `npm run build`, `npm run sync-artifact`. The seven InvoiceGuard settlement cases cover the contract safety behavior. TestToken is a local test fixture, never the competition stablecoin.

The Ignition InvoiceGuard module defaults to official testnet tUSD8. Set `AEVUM_TESTNET_PRIVATE_KEY` locally only when the operator is ready to deploy, then run `npx hardhat ignition deploy ignition/modules/InvoiceGuard.ts --network aevum`. The repository does not contain a key. The deployment account needs faucet gas. Deployment and wallet signing remain operator actions; no deployment is claimed.

After deployment, preserve the address, creation receipt, chain ID, compiler metadata and transaction links; run a seller create and separate-buyer settlement. Sync the artifact and rebuild the frontend whenever source/compiler settings change, because the app pins runtime code.

The project originated from an official scaffold. Unused Counter/window examples have been removed. MIT licensed.
