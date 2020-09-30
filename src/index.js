const perf = require("execution-time")();
const chalk = require("chalk");
const { dropDB, parseCSV, spinnies, log } = require("./utils");
const {
  pool,
  buildMainTables,
  buildForeignTables,
  buildUsers,
  NEVSKII_USERS,
} = require("./db");

const buildDB = async () => {
  perf.start();
  dropDB();
  (await pool.query("SELECT * FROM actors")).rowCount === 0
    ? spinnies.succeed("drop")
    : (pool.end(), process.exit(1));

  try {
    const csv = await parseCSV("dvd_all_8182.csv");
    spinnies.succeed("csv");

    await buildForeignTables(csv);
    await buildUsers(NEVSKII_USERS);
    await buildMainTables(csv);
    spinnies.succeed("tables");

    await pool.end();
    console.log(chalk.bold.green(`🍿 Job done! (${perf.stop().words})`));
  } catch (error) {
    pool.end();
    log(error);
  }
};

buildDB();
