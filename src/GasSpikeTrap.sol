// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

contract GasSpikeTrap is ITrap {
    // Updated response contract address
    address public constant RESPONSE_CONTRACT = 0x1c7065eEe97182801e1C5653eFf75d4F2034A0C8;
    string constant trapType = "GasSpike"; 

    uint256 constant SAMPLE_SIZE = 20;

    // collect() returns current block number and base fee
    function collect() external view override returns (bytes memory) {
        uint256 currentBaseFee = block.basefee;
        uint256 currentBlockNumber = block.number;
        return abi.encode(currentBlockNumber, currentBaseFee);
    }

    // shouldRespond() analyzes 20 blocks for gas spikes
    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length != SAMPLE_SIZE) {
            return (false, "");
        }

        uint256 sumRecent = 0;
        uint256 sumPrior = 0;

        for (uint256 i = 0; i < SAMPLE_SIZE; i++) {
            if (data[i].length == 0) return (false, "");
            (uint256 blockNumber, uint256 baseFee) = abi.decode(data[i], (uint256, uint256));

            if (i < 10) {
                sumRecent += baseFee;
            } else {
                sumPrior += baseFee;
            }
        }

        // Spike if recent average > 1.2 * prior average
        bool spike = sumRecent * 10 > sumPrior * 12;
        uint256 recentAvg = sumRecent / 10;
        uint256 priorAvg = sumPrior / 10;

        return (spike, abi.encode(trapType, recentAvg, priorAvg));
    }
}

