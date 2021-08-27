import { deployContractByName, executeScript, mintFlow, sendTransaction } from "flow-js-testing";
import { getKaratAdminAddress } from "./common";

/*
 * Deploys NonFungibleToken and KaratNFT contracts to KaratAdmin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const deployKaratNFT = async () => {
	const KaratAdmin = await getKaratAdminAddress();
	await mintFlow(KaratAdmin, "10.0");

	await deployContractByName({ to: KaratAdmin, name: "NonFungibleToken" });

	const addressMap = { NonFungibleToken: KaratAdmin };
	return deployContractByName({ to: KaratAdmin, name: "KaratNFT", addressMap });
};

/*
 * Setups KaratNFT collection on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const setupKaratNFTOnAccount = async (account) => {
	const name = "karatNFT/setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};

/*
 * Returns KaratNFT supply.
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64} - number of NFT minted so far
 * */
export const getKaratNFTSupply = async () => {
	const name = "karatNFT/get_nft_supply";

	return executeScript({ name });
};

/*
 * Mints KaratNFT of a specific **itemType** and sends it to **recipient**.
 * @param {UInt64} itemType - type of NFT to mint
 * @param {string} recipient - recipient account address
 * @throws Will throw an error if execution will be halted
 * @returns {Promise<*>}
 * */
export const mintKaratNFT = async (recipient) => {
	const KaratAdmin = await getKaratAdminAddress();

	const name = "karatNFT/mint_nft";
	const args = [recipient];
	const signers = [KaratAdmin];

	return sendTransaction({ name, args, signers });
};

/*
 * Transfers KaratNFT NFT with id equal **itemId** from **sender** account to **recipient**.
 * @param {string} sender - sender address
 * @param {string} recipient - recipient address
 * @param {UInt64} itemId - id of the item to transfer
 * @throws Will throw an error if execution will be halted
 * @returns {Promise<*>}
 * */
export const transferKaratNFT = async (sender, recipient, itemId) => {
	const name = "karatNFT/transfer_nft";
	const args = [recipient, itemId];
	const signers = [sender];

	return sendTransaction({ name, args, signers });
};

/*
 * Returns the type of KaratNFT NFT with **id** in account collection.
 * @param {string} account - account address
 * @param {UInt64} id - NFT id
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getKaratNFTById = async (account, id) => {
	const name = "karatNFT/read_nft_id";
	const args = [account, id];

	return executeScript({ name, args });
};

/*
 * Returns the length of account's KaratNFT collection.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getCollectionLength = async (account) => {
	const name = "karatNFT/get_collection_length";
	const args = [account];

	return executeScript({ name, args });
};
