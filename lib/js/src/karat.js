import { deployContractByName, executeScript, mintFlow, sendTransaction } from "flow-js-testing";
import { getKaratAdminAddress } from "./common";

/*
 * Deploys Karat contract to KaratAdmin.
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const deployKarat = async () => {
	const KaratAdmin = await getKaratAdminAddress();
	await mintFlow(KaratAdmin, "10.0");

	return deployContractByName({ to: KaratAdmin, name: "Karat" });
};

/*
 * Setups Karat Vault on account and exposes public capability.
 * @param {string} account - account address
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const setupKaratOnAccount = async (account) => {
	const name = "karat/setup_account";
	const signers = [account];

	return sendTransaction({ name, signers });
};

/*
 * Returns Karat balance for **account**.
 * @param {string} account - account address
 * @throws Will throw an error if execution will be halted
 * @returns {UFix64}
 * */
export const getKaratBalance = async (account) => {
	const name = "karat/get_balance";
	const args = [account];

	return executeScript({ name, args });
};

/*
 * Returns Karat supply.
 * @throws Will throw an error if execution will be halted
 * @returns {UFix64}
 * */
export const getKaratSupply = async () => {
	const name = "karat/get_supply";
	return executeScript({ name });
};

/*
 * Mints **amount** of Karat tokens and transfers them to recipient.
 * @param {string} recipient - recipient address
 * @param {string} amount - UFix64 amount to mint
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const mintKarat = async (recipient, amount) => {
	const KaratAdmin = await getKaratAdminAddress();

	const name = "karat/mint_tokens";
	const args = [recipient, amount];
	const signers = [KaratAdmin];

	return sendTransaction({ name, args, signers });
};

/*
 * Transfers **amount** of Karat tokens from **sender** account to **recipient**.
 * @param {string} sender - sender address
 * @param {string} recipient - recipient address
 * @param {string} amount - UFix64 amount to transfer
 * @throws Will throw an error if transaction is reverted.
 * @returns {Promise<*>}
 * */
export const transferKarat = async (sender, recipient, amount) => {
	const name = "karat/transfer_tokens";
	const args = [amount, recipient];
	const signers = [sender];

	return sendTransaction({ name, args, signers });
};
