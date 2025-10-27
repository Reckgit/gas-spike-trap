// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GasSpikeResponse {

    event GasSpikeAlert(
        uint256 indexed recentAvg,
        uint256 indexed priorAvg,
        string message
    );

    // Called by Drosera when trap triggers
    function handleGasSpikeAlert(uint256 recentAvg, uint256 priorAvg) external {
        emit GasSpikeAlert(
            recentAvg,
            priorAvg,
            "Gas spike detected! Recent avg > 20% higher than prior avg."
        );
    }
}
