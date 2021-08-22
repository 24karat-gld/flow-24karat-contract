import path from "path";
import { emulator, init, getAccountAddress, shallPass, shallResolve, shallRevert } from "flow-js-testing";

import {
	deployKaratNFT,
	getCollectionLength,
	getKaratNFTById,
	getKaratNFTSupply,
	mintKaratNFT,
	setupKaratNFTOnAccount,
	transferKaratNFT,
} from "../src/karat-nft";
import { getKaratAdminAddress } from "../src/common";

// We need to set timeout for a higher number, because some transactions might take up some time
jest.setTimeout(50000);

describe("Karat NFT", () => {
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

	it("shall deploy KaratNFT contract", async () => {
		await shallPass(deployKaratNFT());
	});

	it("supply shall be 0 after contract is deployed", async () => {
		// Setup
		await deployKaratNFT();
		const KaratAdmin = await getKaratAdminAddress();
		await shallPass(setupKaratNFTOnAccount(KaratAdmin));

		await shallResolve(async () => {
			const supply = await getKaratNFTSupply();
			expect(supply).toBe(0);
		});
	});

	it("shall be able to mint a karatNFT", async () => {
		// Setup
		await deployKaratNFT();
		const Alice = await getAccountAddress("Alice");
		await setupKaratNFTOnAccount(Alice);

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintKaratNFT(Alice));

		await shallResolve(async () => {
			const amount = await getCollectionLength(Alice);
			expect(amount).toBe(1);
		});

		await shallResolve(async () => {
			const id = await getKaratNFTById(Alice, 0);
			expect(id).toBe(0)
		});
	});

	it("shall be able to create a new empty NFT Collection", async () => {
		// Setup
		await deployKaratNFT();
		const Alice = await getAccountAddress("Alice");
		await setupKaratNFTOnAccount(Alice);

		// shall be able te read Alice collection and ensure it's empty
		await shallResolve(async () => {
			const length = await getCollectionLength(Alice);
			expect(length).toBe(0);
		});
	});

	it("shall not be able to withdraw an NFT that doesn't exist in a collection", async () => {
		// Setup
		await deployKaratNFT();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupKaratNFTOnAccount(Alice);
		await setupKaratNFTOnAccount(Bob);

		// Transfer transaction shall fail for non-existent item
		await shallRevert(transferKaratNFT(Alice, Bob, 1337));
	});

	it("shall be able to withdraw an NFT and deposit to another accounts collection", async () => {
		await deployKaratNFT();
		const Alice = await getAccountAddress("Alice");
		const Bob = await getAccountAddress("Bob");
		await setupKaratNFTOnAccount(Alice);
		await setupKaratNFTOnAccount(Bob);

		// Mint instruction for Alice account shall be resolved
		await shallPass(mintKaratNFT(Alice));

		// Transfer transaction shall pass
		await shallPass(transferKaratNFT(Alice, Bob, 0));
	});
});
