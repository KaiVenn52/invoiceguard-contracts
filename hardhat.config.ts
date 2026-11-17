import hardhatToolboxViemPlugin from '@nomicfoundation/hardhat-toolbox-viem';
import {configVariable,defineConfig} from 'hardhat/config';
try{process.loadEnvFile()}catch{}
export default defineConfig({plugins:[hardhatToolboxViemPlugin],solidity:{version:'0.8.28',settings:{optimizer:{enabled:true,runs:200}}},networks:{local:{type:'edr-simulated',chainType:'l1'},aevum:{type:'http',chainType:'l1',chainId:44005,url:'https://rpc-test.qday.info',httpHeaders:{'User-Agent':'Mozilla/5.0 InvoiceGuard/0.1'},accounts:[configVariable('AEVUM_TESTNET_PRIVATE_KEY')]}}});
