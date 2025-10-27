// Deploy.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {GasSpikeTrap} from "src/GasSpikeTrap.sol";
import {GasSpikeResponse} from "src/GasSpikeResponse.sol";

contract DeployScript is Script {
    function run() external {
        // Ensure you have configured your .env file with RPC_URL and PRIVATE_KEY

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy the Response Contract (NO constructor args)
        GasSpikeResponse responseContract = new GasSpikeResponse();
        console.log("Deployed GasSpikeResponse to: ", address(responseContract));

        // 2. Deploy the Trap Contract (NO constructor args)
        GasSpikeTrap trapContract = new GasSpikeTrap();
        console.log("Deployed GasSpikeTrap to: ", address(trapContract));

        vm.stopBroadcast();
        
        // CRITICAL NEXT STEP COMMENT:
        // After running this script, you must take the 'responseContract' address and
        // manually call 'setAuthorizedTrap(TrapConfigAddress)' on it using the Block Explorer.
        // Then, you can run 'drosera apply'.
    }
}
