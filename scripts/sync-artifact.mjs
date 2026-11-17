import fs from 'node:fs';
const source=JSON.parse(fs.readFileSync(new URL('../artifacts/contracts/InvoiceGuard.sol/InvoiceGuard.json',import.meta.url),'utf8'));
fs.writeFileSync(new URL('../../invoiceguard/src/contract.json',import.meta.url),JSON.stringify(Object.fromEntries(['abi','bytecode','deployedBytecode','immutableReferences'].map(k=>[k,source[k]])),null,2)+'\n');
console.log('Synced InvoiceGuard ABI, creation code and runtime immutable references.');
