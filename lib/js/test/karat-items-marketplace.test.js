import path from "path";
import { emulator, init, getAccountAddress, shallPass } from "flow-js-testing";

import { toUFix64 } from "../src/common";
import { getKaratBalance, mintKarat, setupKaratOnAccount } from "../src/karat";
import { getCollectionLength, mintKaratItem, typeID1337 } from "../src/karat-items";
import {
	buyItem,
	deployMarketplace,
	listItemForSale,
	removeItem,
	setupMarketplaceOnAccount,
	getMarketCollectionLength,
} from "../src/karat-items-marketplace";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(50000);

describe("Karat Items Marketplace", () => {
	beforeEach(async () => {
		const basePath = path.resolve(__dirname, "../../../");
		const port = 8085;
		init(basePath, port);
		return emulator.start(port, false);
	});

	// Stop emulator, so it could be restarted
	afterEach(async () => {
		return emulator.stop();
	});

	it("shall deploy KaratItemsMarket contract", async () => {
		await shallPass(deployMarketplace());
	});

	it("shall be able to create an empty Collection", async () => {
		// Setup
		await deployMarketplace();
		const Alice = await getAccountAddress("Alice");

		await shallPass(setupMarketplaceOnAccount(Alice));
	});

	it("shall be able to create a sale offer and list it", async () => {
		// Setup
		await deployMarketplace();
		const Alice = await getAccountAddress("Alice");
		await setupMarketplaceOnAccount(Alice);

		// Mint KaratItem for Alice's account
		await shallPass(mintKaratItem(typeID1337, Alice));

		await shallPass(listItemForSale(Alice, 0, toUFix64(1.11)));
	});

	it("shall be able to accept a sale offer", async () => {
		// Setup
		await deployMarketplace();

		// Setup seller account
		const Alice = await getAccountAddress("Alice");
		await setupMarketplaceOnAccount(Alice);
		await mintKaratItem(typeID1337, Alice);

		// Setup buyer account
		const Bob = await getAccountAddress("Bob");
		await setupMarketplaceOnAccount(Bob);

		// Setup fee receiver account
		const feeReceiver = await getAccountAddress("feeReceiver");
		await setupKaratOnAccount(feeReceiver);

		await shallPass(mintKarat(Bob, toUFix64(100)));

		// Bob shall be able to buy from Alice
		await shallPass(listItemForSale(Alice, 0, toUFix64(10)));
		await shallPass(buyItem(Bob, 0, Alice, feeReceiver));

		const length = await getCollectionLength(Bob);
		expect(length).toBe(1);

		const itemsListed = await getMarketCollectionLength(Alice);
		expect(itemsListed).toBe(0);

		const balance = await getKaratBalance(feeReceiver);
		expect(balance).toBe("0.50000000");
	});

	it("shall be able to remove a sale offer", async () => {
		// Deploy contracts
		await shallPass(deployMarketplace());

		// Setup Alice account
		const Alice = await getAccountAddress("Alice");
		await shallPass(setupMarketplaceOnAccount(Alice));

		// Mint instruction shall pass
		await shallPass(mintKaratItem(typeID1337, Alice));

		// Listing item for sale shall pass
		await shallPass(listItemForSale(Alice, 0, toUFix64(1.11)));

		// Alice shall be able to remove item from sale
		await shallPass(removeItem(Alice, 0));
	});
});
