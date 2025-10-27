// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {GasSpikeTrap} from "../src/GasSpikeTrap.sol";
import {GasSpikeResponse} from "../src/GasSpikeResponse.sol";
import {console} from "forge-std/console.sol";

contract DeployScript is Script {
    function run() external returns (address trapAddress, address responseAddress) {
        vm.startBroadcast();

        GasSpikeResponse response = new GasSpikeResponse();
        GasSpikeTrap trap = new GasSpikeTrap();

        vm.stopBroadcast();

        trapAddress = address(trap);
        responseAddress = address(response);

        console.log("------------------------------------------");
        console.log("Trap deployed at: %s", trapAddress);
        console.log("Response deployed at: %s", responseAddress);
        console.log("------------------------------------------");
    }
}
