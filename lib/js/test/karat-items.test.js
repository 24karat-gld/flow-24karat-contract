import path from "path";
import { emulator, init, getAccountAddress, shallPass, shallResolve, shallRevert } from "flow-js-testing";

import {
	deployKaratItems,
	getCollectionLength,
	getKaratItemById,
	getKaratItemSupply,
	mintKaratItem,
	setupKaratItemsOnAccount,
	transferKaratItem,
	typeID1,
} from "../src/karat-items";
import { getKaratAdminAddress } from "../src/common";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(50000);

describe("Karat Items", () => {
	// Instantiate emulator and path to Cadence files
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../../");
		const port = 8084;
		init(basePath, port);
		return emulator.start(port, false);
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		return emulator.stop();
	});

	it("shall deploy KaratItems contract", async () => {
		await shallPass(deployKaratItems());
	});

	it("supply shall be 0 after contract is deployed", async () => {
		// Setup
		await deployKaratItems();
		const KaratAdmin = await getKaratAdminAddress();
		await shallPass(setupKaratItemsOnAccount(KaratAdmin));

		await shallResolve(async () => {
			const supply = await getKaratItemSupply();
			expect(supply).toBe(0);
		});
	});

	it("shall be able to mint a karatItems", async () => {
		// Setup
		await deployKaratItems();
		const Alice = await getAccountAddress("Alice");
		await setupKaratItemsOnAccount(Alice);
		const itemIdToMint = typeID1;

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintKaratItem(itemIdToMint, Alice));

		await shallResolve(async () => {
			const amount = await getCollectionLength(Alice);
			expect(amount).toBe(1);

			const id = await getKaratItemById(Alice, 0);
			expect(id).toBe(itemIdToMint);
		});
	});

	it("shall be able to create a new empty NFT Collection", async () => {
		// Setup
		await deployKaratItems();
		const Alice = await getAccountAddress("Alice");
		await setupKaratItemsOnAccount(Alice);

		// shall be able te read Alice collection and ensure it's empty
		await shallResolve(async () => {
			const length = await getCollectionLength(Alice);
			expect(length).toBe(0);
		});
	});

	it("shall not be able to withdraw an NFT that doesn't exist in a collection", async () => {
		// Setup
		await deployKaratItems();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupKaratItemsOnAccount(Alice);
		await setupKaratItemsOnAccount(Bob);

		// Transfer transaction shall fail for non-existent item
		await shallRevert(transferKaratItem(Alice, Bob, 1337));
	});

	it("shall be able to withdraw an NFT and deposit to another accounts collection", async () => {
		await deployKaratItems();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupKaratItemsOnAccount(Alice);
		await setupKaratItemsOnAccount(Bob);

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintKaratItem(typeID1, Alice));

		// Transfer transaction shall pass
		await shallPass(transferKaratItem(Alice, Bob, 0));
	});
});
