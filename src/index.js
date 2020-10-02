const perf = require("execution-time")();
const chalk = require("chalk");
const { parseCSV, spinnies, log } = require("./utils");
const {
  pool,
  rebootDB,
  seedMainTables,
  seedForeignTables,
  seedUsers,
} = require("./db");

/**
 * Seed local nevskii database
 * @param {Object} options - Seed options
 * @param {?Array<number, number>} options.range - Range/limit of items to be processed
 * @param {string} options.filepath - Path to CSV source file
 * @param {Array<{}>} options.users - Users to be created
 */
const seed = async ({ filepath, range = [0], users }) => {
  perf.start();
  try {
    await rebootDB();
    spinnies.succeed("drop");

    const csv = (await parseCSV(filepath)).slice(...range);
    spinnies.succeed("csv");

    await seedForeignTables(csv);
    await seedUsers(users);
    await seedMainTables(csv);
    spinnies.succeed("tables");

    await pool.end();
    console.log(chalk.bold.green(`🍿 Job done! (${perf.stop().words})`));
  } catch (error) {
    spinnies.stopAll("fail");
    pool.end();
    log(error);
  }
};

const options = {
  range: [0, 400],
  filepath: "../assets/csv/dvd_4412_mint.csv",
  users: [
    {
      type: 1, // admin
      name: "nevskii admin",
      email: "admin@nevskii.net",
    },
    {
      name: "Sophia Cappalo",
      email: "scappalo@mail.com",
      birthDate: "1971-5-14",
    },
    {
      name: "David Lunch",
      email: "dlunch@mail.com",
      birthDate: "1946-1-21",
    },
  ],
};

seed(options);
