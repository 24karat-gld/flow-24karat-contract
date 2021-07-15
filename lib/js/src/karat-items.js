import { deployContractByName, executeScript, mintFlow, sendTransaction } from "flow-js-testing";
import { getKaratAdminAddress } from "./common";

// KaratItems types
export const typeID1 = 1000;
export const typeID2 = 2000;
export const typeID1337 = 1337;

/*
 * Deploys NonFungibleToken and KaratItems contracts to KaratAdmin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const deployKaratItems = async () => {
	const KaratAdmin = await getKaratAdminAddress();
	await mintFlow(KaratAdmin, "10.0");

	await deployContractByName({ to: KaratAdmin, name: "NonFungibleToken" });

	const addressMap = { NonFungibleToken: KaratAdmin };
	return deployContractByName({ to: KaratAdmin, name: "KaratItems", addressMap });
};

/*
 * Setups KaratItems collection on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const setupKaratItemsOnAccount = async (account) => {
	const name = "karatItems/setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};

/*
 * Returns KaratItems supply.
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64} - number of NFT minted so far
 * */
export const getKaratItemSupply = async () => {
	const name = "karatItems/get_karat_items_supply";

	return executeScript({ name });
};

/*
 * Mints KaratItem of a specific **itemType** and sends it to **recipient**.
 * @param {UInt64} itemType - type of NFT to mint
 * @param {string} recipient - recipient account address
 * @throws Will throw an error if execution will be halted
 * @returns {Promise<*>}
 * */
export const mintKaratItem = async (itemType, recipient) => {
	const KaratAdmin = await getKaratAdminAddress();

	const name = "karatItems/mint_karat_item";
	const args = [recipient, itemType];
	const signers = [KaratAdmin];

	return sendTransaction({ name, args, signers });
};

/*
 * Transfers KaratItem NFT with id equal **itemId** from **sender** account to **recipient**.
 * @param {string} sender - sender address
 * @param {string} recipient - recipient address
 * @param {UInt64} itemId - id of the item to transfer
 * @throws Will throw an error if execution will be halted
 * @returns {Promise<*>}
 * */
export const transferKaratItem = async (sender, recipient, itemId) => {
	const name = "karatItems/transfer_karat_item";
	const args = [recipient, itemId];
	const signers = [sender];

	return sendTransaction({ name, args, signers });
};

/*
 * Returns the type of KaratItems NFT with **id** in account collection.
 * @param {string} account - account address
 * @param {UInt64} id - NFT id
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getKaratItemById = async (account, id) => {
	const name = "karatItems/get_karat_item_type_id";
	const args = [account, id];

	return executeScript({ name, args });
};

/*
 * Returns the length of account's KaratItems collection.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getCollectionLength = async (account) => {
	const name = "karatItems/get_collection_length";
	const args = [account];

	return executeScript({ name, args });
};
