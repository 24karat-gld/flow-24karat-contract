import path from "path";
import { emulator, init, getAccountAddress, shallPass, shallResolve, shallRevert } from "flow-js-testing";

import {
	deployKarat,
	setupKaratOnAccount,
	getKaratBalance,
	getKaratSupply,
	mintKarat,
	transferKarat,
} from "../src/karat";

import { toUFix64, getKaratAdminAddress } from "../src/common";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(50000);

describe("Karat", () => {
	// Instantiate emulator and path to Cadence files
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../../");
		const port = 8083;
		init(basePath, port);
		return emulator.start(port, false);
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		return emulator.stop();
	});

	it("shall have initialized supply field correctly", async () => {
		// Deploy contract
		await shallPass(deployKarat());

		await shallResolve(async () => {
			const supply = await getKaratSupply();
			expect(supply).toBe(toUFix64(0));
		});
	});

	it("shall be able to create empty Vault that doesn't affect supply", async () => {
		// Setup
		await deployKarat();
		const Alice = await getAccountAddress("Alice");
		await shallPass(setupKaratOnAccount(Alice));

		await shallResolve(async () => {
			const supply = await getKaratSupply();
			const aliceBalance = await getKaratBalance(Alice);
			expect(supply).toBe(toUFix64(0));
			expect(aliceBalance).toBe(toUFix64(0));
		});
	});

	it("shall not be able to mint zero tokens", async () => {
		// Setup
		await deployKarat();
		const Alice = await getAccountAddress("Alice");
		await setupKaratOnAccount(Alice);

		// Mint instruction with amount equal to 0 shall be reverted
		await shallRevert(mintKarat(Alice, toUFix64(0)));
	});

	it("shall mint tokens, deposit, and update balance and total supply", async () => {
		// Setup
		await deployKarat();
		const Alice = await getAccountAddress("Alice");
		await setupKaratOnAccount(Alice);
		const amount = toUFix64(50);

		// Mint Karat tokens for Alice
		await shallPass(mintKarat(Alice, amount));

		// Check Karat total supply and Alice's balance
		await shallResolve(async () => {
			// Check Alice balance to equal amount
			const balance = await getKaratBalance(Alice);
			expect(balance).toBe(amount);

			// Check Karat supply to equal amount
			const supply = await getKaratSupply();
			expect(supply).toBe(amount);
		});
	});

	it("shall not be able to withdraw more than the balance of the Vault", async () => {
		// Setup
		await deployKarat();
		const KaratAdmin = await getKaratAdminAddress();
		const Alice = await getAccountAddress("Alice");
		await setupKaratOnAccount(KaratAdmin);
		await setupKaratOnAccount(Alice);

		// Set amounts
		const amount = toUFix64(1000);
		const overflowAmount = toUFix64(30000);

		// Mint instruction shall resolve
		await shallResolve(mintKarat(KaratAdmin, amount));

		// Transaction shall revert
		await shallRevert(transferKarat(KaratAdmin, Alice, overflowAmount));

		// Balances shall be intact
		await shallResolve(async () => {
			const aliceBalance = await getKaratBalance(Alice);
			expect(aliceBalance).toBe(toUFix64(0));

			const KaratAdminBalance = await getKaratBalance(KaratAdmin);
			expect(KaratAdminBalance).toBe(amount);
		});
	});

	it("shall be able to withdraw and deposit tokens from a Vault", async () => {
		await deployKarat();
		const KaratAdmin = await getKaratAdminAddress();
		const Alice = await getAccountAddress("Alice");
		await setupKaratOnAccount(KaratAdmin);
		await setupKaratOnAccount(Alice);
		await mintKarat(KaratAdmin, toUFix64(1000));

		await shallPass(transferKarat(KaratAdmin, Alice, toUFix64(300)));

		await shallResolve(async () => {
			// Balances shall be updated
			const KaratAdminBalance = await getKaratBalance(KaratAdmin);
			expect(KaratAdminBalance).toBe(toUFix64(700));

			const aliceBalance = await getKaratBalance(Alice);
			expect(aliceBalance).toBe(toUFix64(300));

			const supply = await getKaratSupply();
			expect(supply).toBe(toUFix64(1000));
		});
	});
});
