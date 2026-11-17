import {buildModule} from '@nomicfoundation/hardhat-ignition/modules';
export default buildModule('InvoiceGuardAevum',m=>{const token=m.getParameter('token','0x456569838f1d43009A91ebA4263147Afd7233483');const guard=m.contract('InvoiceGuard',[token]);return {guard};});
