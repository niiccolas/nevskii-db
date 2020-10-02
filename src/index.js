const perf = require("execution-time")();
const chalk = require("chalk");
const { parseCSV, spinnies, log } = require("./utils");
const {
  pool,
  rebootDB,
  buildMainTables,
  buildForeignTables,
  buildUsers,
} = require("./db");

/**
 * Build local nevskii database
 * @param {Object} options - Build options
 * @param {?Array<number, number>} options.range - Range of items to be processed, by default, all.
 * @param {string} options.filepath - Path to the raw CSV source file
 * @param {Array<{}>} options.users - Users to be created
 */
const makeDB = async ({ filepath, range = [0], users }) => {
  perf.start();
  try {
    await rebootDB();
    spinnies.succeed("drop");

    const csv = (await parseCSV(filepath)).slice(...range);
    spinnies.succeed("csv");

    await buildForeignTables(csv);
    await buildUsers(users);
    await buildMainTables(csv);
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
  filepath: "dvd_4412_mint.csv",
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

makeDB(options);