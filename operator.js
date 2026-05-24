const { ethers } = require("ethers");
require("dotenv").config();

const contractAddress = process.env.AVS_CONTRACT_ADDRESS;
const abi = [
    "event NewTaskCreated(uint32 indexed taskId, string dataSpecification)",
    "function respondToTask(uint32 taskId, bytes32 oracleData, bytes calldata signature) external"
];

async function startOperatorNode() {
    console.log("--- Starting EigenLayer AVS Oracle Operator Node ---");
    
    const provider = new ethers.JsonRpcProvider(process.env.ETH_RPC_URL);
    const wallet = new ethers.Wallet(process.env.OPERATOR_PRIVATE_KEY, provider);
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    console.log(`Node listening for new tasks using address: ${wallet.address}`);

    contract.on("NewTaskCreated", async (taskId, dataSpecification) => {
        console.log(`[New Task] ID: ${taskId} | Spec: ${dataSpecification}`);

        // Perform off-chain calculations/data fetching (e.g., getting asset price info)
        const mockFetchedData = ethers.keccak256(ethers.toUtf8Bytes("BTC/USD = 100000"));
        
        // Sign the data hash to commit to the computation
        const signature = await wallet.signMessage(ethers.getBytes(mockFetchedData));

        try {
            console.log(`[Submit] Broadcasting resolution payload for Task ${taskId}...`);
            const tx = await contract.respondToTask(taskId, mockFetchedData, signature);
            await tx.wait();
            console.log(`[Success] Task ${taskId} finalized on-chain.`);
        } catch (error) {
            console.error(`[Error] Execution aborted:`, error.message);
        }
    });
}

// startOperatorNode().catch(console.error);
module.exports = { startOperatorNode };
