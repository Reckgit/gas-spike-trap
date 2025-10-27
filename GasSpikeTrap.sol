// GasSpikeTrap.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

contract GasSpikeTrap is ITrap {

    // Define a threshold in Gwei (Gwei * 1e9) for a significant gas spike
    uint256 private constant GAS_SPIKE_THRESHOLD = 20 ether; // 20 Gwei 

    /**
     * @notice Collects the current block's base fee per gas.
     * @return bytes memory Encoded current base fee (uint256).
     */
    function collect() external view override returns (bytes memory) {
        // Collect the base fee directly from the block header
        uint256 currentBaseFee = block.basefee;
        return abi.encode(currentBaseFee);
    }

    /**
     * @notice Analyzes collected data to determine if a response is needed.
     * @param data Array of encoded uint256 (base fees) from previous blocks.
     * @return (bool, bytes memory) true if spike detected, along with payload.
     */
    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        // We require at least 2 data points: 
        // 1. The prior block's base fee.
        // 2. The most recent block's base fee.
        if (data.length < 2) {
            return (false, abi.encode(uint256(0), uint256(0)));
        }

        // Decode the two most recent samples
        uint256 recentBaseFee = abi.decode(data[data.length - 1], (uint256));
        uint256 priorBaseFee  = abi.decode(data[data.length - 2], (uint256));
        
        // Define spike condition: if recent fee is above threshold AND significantly higher than prior
        bool isSpike = recentBaseFee > GAS_SPIKE_THRESHOLD && recentBaseFee > priorBaseFee * 2;

        if (isSpike) {
            // Payload for GasSpikeResponse.handleAlert(uint256, uint256)
            // MUST exactly match the response function signature.
            return (true, abi.encode(recentBaseFee, priorBaseFee));
        }

        // Return false with a dummy payload if no spike is detected
        return (false, abi.encode(uint256(0), uint256(0)));
    }
}
