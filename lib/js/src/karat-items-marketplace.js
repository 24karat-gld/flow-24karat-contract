import { deployContractByName, executeScript, sendTransaction } from "flow-js-testing";
import { getKaratAdminAddress } from "./common";
import { deployKarat, setupKaratOnAccount } from "./karat";
import { deployKaratItems, setupKaratItemsOnAccount } from "./karat-items";

/*
 * Deploys Karat, KaratItems and KaratItemsMarket contracts to KaratAdmin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const deployMarketplace = async () => {
	const KaratAdmin = await getKaratAdminAddress();

	await deployKarat();
	await deployKaratItems();

	const addressMap = {
		NonFungibleToken: KaratAdmin,
		Karat: KaratAdmin,
		KaratItems: KaratAdmin,
	};

	return deployContractByName({ to: KaratAdmin, name: "KaratItemsMarket", addressMap });
};

/*
 * Setups KaratItemsMarket collection on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const setupMarketplaceOnAccount = async (account) => {
	// Account shall be able to store karat items and operate Karats
	await setupKaratOnAccount(account);
	await setupKaratItemsOnAccount(account);

	const name = "karatItemsMarket/setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};

/*
 * Lists item with id equal to **item** id for sale with specified **price**.
 * @param {string} seller - seller account address
 * @param {UInt64} itemId - id of item to sell
 * @param {UFix64} price - price
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const listItemForSale = async (seller, itemId, price) => {
	const name = "karatItemsMarket/create_sale_offer";
	const args = [itemId, price];
	const signers = [seller];

	return sendTransaction({ name, args, signers });
};

/*
 * Buys item with id equal to **item** id for **price** from **seller**.
 * @param {string} buyer - buyer account address
 * @param {UInt64} itemId - id of item to sell
 * @param {string} seller - seller account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const buyItem = async (buyer, itemId, seller, feeReceiver) => {
	const name = "karatItemsMarket/buy_market_item";
	const args = [itemId, seller, feeReceiver];
	const signers = [buyer];

	return sendTransaction({ name, args, signers });
};

/*
 * Removes item with id equal to **item** from sale.
 * @param {string} owner - owner address
 * @param {UInt64} itemId - id of item to remove
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const removeItem = async (owner, itemId) => {
	const name = "karatItemsMarket/remove_sale_offer";
	const signers = [owner];
	const args = [itemId];

	return sendTransaction({ name, args, signers });
};

/*
 * Returns the length of list of items for sale.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UInt64}
 * */
export const getMarketCollectionLength = async (account) => {
	const name = "karatItemsMarket/get_collection_length";
	const args = [account, account];

	return executeScript({ name, args });
};
