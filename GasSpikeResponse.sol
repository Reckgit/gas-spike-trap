// GasSpikeResponse.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GasSpikeResponse {

    // CRITICAL: Since NO constructors are allowed, the owner must be set 
    // manually or managed through an inherited Ownable contract (not shown here).
    // For simplicity, we hardcode the deployment address for an initial owner check.
    address public owner = msg.sender; 
    
    // Address of the authorized Trap Config contract
    address public authorizedTrapConfig; 

    // --- ACCESS CONTROL MODIFIER ---
    modifier onlyAuthorizedTrap() {
        require(msg.sender == authorizedTrapConfig, "Caller is not the authorized Trap Config");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    /**
     * @notice Allows the owner to set the address of the Trap Config contract.
     * This is the manual whitelisting step required due to the 'no constructor' rule.
     * @param _trapConfigAddress The address of the deployed Trap Config Contract.
     */
    function setAuthorizedTrap(address _trapConfigAddress) external onlyOwner {
        authorizedTrapConfig = _trapConfigAddress;
    }

    /**
     * @notice The function called by the Drosera Operators upon spike detection.
     * Matches the payload from GasSpikeTrap.shouldRespond(uint256, uint256).
     */
    function handleAlert(uint256 recentBaseFee, uint256 priorBaseFee) 
        external 
        onlyAuthorizedTrap 
    {
        // 💡 Incident Response Logic: 
        // A simple example: log the spike and take an action if the spike is extreme.
        
        // Emit an event to log the detected spike
        emit GasSpikeDetected(recentBaseFee, priorBaseFee);

        if (recentBaseFee > priorBaseFee * 5) { // If it's a 5x spike, take an extreme measure
            // Example Action: Set a very low gas limit or pause a critical contract
            // (e.g., TargetContract(0x...address).pause())
        }
    }
    
    // Event for off-chain monitoring
    event GasSpikeDetected(uint256 indexed recentFee, uint256 priorFee);
}
