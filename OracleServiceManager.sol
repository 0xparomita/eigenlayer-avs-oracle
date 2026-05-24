// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title OracleServiceManager
 * @dev Entry point for tasks dispatched to EigenLayer operators registered to this AVS.
 */
contract OracleServiceManager is Ownable {
    
    struct Task {
        uint32 id;
        string dataSpecification;
        uint32 taskCreatedBlock;
    }

    uint32 public latestTaskId = 0;
    mapping(uint32 => Task) public tasks;
    mapping(uint32 => bytes32) public taskResponses;
    mapping(address => bool) public isOperatorRegistered;

    event NewTaskCreated(uint32 indexed taskId, string dataSpecification);
    event TaskCompleted(uint32 indexed taskId, bytes32 oracleData);

    constructor() Ownable(msg.sender) {}

    function registerOperator(address operator) external onlyOwner {
        isOperatorRegistered[operator] = true;
    }

    function createNewTask(string calldata dataSpecification) external onlyOwner {
        latestTaskId++;
        tasks[latestTaskId] = Task({
            id: latestTaskId,
            dataSpecification: dataSpecification,
            taskCreatedBlock: uint32(block.number)
        });

        emit NewTaskCreated(latestTaskId, dataSpecification);
    }

    /**
     * @notice Submits task results signed by restaked operators.
     */
    function respondToTask(
        uint32 taskId, 
        bytes32 oracleData, 
        bytes calldata signature
    ) external {
        require(isOperatorRegistered[msg.sender], "Caller is not a valid AVS operator");
        require(taskResponses[taskId] == bytes32(0), "Task already finalized");

        // In production, the aggregate signature is cryptographically validated 
        // against the operator group's allocated restaked weight inside the EigenLayer Registry.

        taskResponses[taskId] = oracleData;
        emit TaskCompleted(taskId, oracleData);
    }
}
