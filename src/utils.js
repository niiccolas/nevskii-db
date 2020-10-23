const path = require("path");
const csv = require("csvtojson");
const Spinnies = require("spinnies");
const chalk = require("chalk");

/**
 * Return array-like position of string in Set
 * @param {Set} set
 * @param {string} string
 */
const getIdIndex = (set, string) =>
  string ? Array.from(set).indexOf(string) : null;

/**
 * Return PostgreSQL-friendly equivalent of given French month
 * @param {string} month
 */
const parseMonthFR = (month) => {
  const MONTHS_FR = {
    janvier: "jan",
    février: "feb",
    mars: "mar",
    avril: "apr",
    mai: "may",
    juin: "jun",
    juillet: "jul",
    aout: "aug",
    août: "aug",
    septembre: "sep",
    octobre: "oct",
    novembre: "nov",
    décembre: "dec",
  };

  return month.replace(/[a-zéû]+/, MONTHS_FR[month.split(" ")[1]]);
};

/**
 * Return singular equivalent of given table name for use as primary ID name
 * @param {string} tableName
 * @returns {string}
 */
const generateIdName = (tableName) => {
  switch (tableName.slice(-3)) {
    case "ies":
      return "id_" + tableName.slice(0, -3) + "y";
    case "ses":
      return "id_" + tableName.slice(0, -2);
    default:
      return "id_" + tableName.slice(0, -1);
  }
};

/**

 * Parse CSV to an array of JSON objects
 * @param {string} sourceFile
 */
const parseCSV = async (sourceFile) =>
  await csv({
    delimiter: ";",
    checkType: true,
  })
    .fromFile(path.join("raw", sourceFile))
    .on("done", () => spinnies.succeed("csv"));

/**
 * CLI spinner
 */
const spinner = () => {
  const CINE_SNACKS = {
    interval: 150,
    frames: ["🍿", "🍭", "🍩", "🎬", "🍦", "🥤", "🍏"],
  };

  const spinnies = new Spinnies({
    succeedColor: "white",
    spinner: CINE_SNACKS,
  });

  // spinnies.add("drop", { text: "Drop DB" });
  spinnies.add("csv", { text: "Parse CSV" });
  spinnies.add("seed", { text: "Seed tables" });
  spinnies.add("dump", { text: "Dump local DB" });
  spinnies.add("upload", { text: "Upload dump to S3" });
  spinnies.add("sign", { text: "Sign URL" });
  spinnies.add("deploy", { text: "Deploy to Heroku" });

  return spinnies;
};

/**
 * Log EAN of problematic item and/or error
 * @param {string} error
 * @param {string} EAN
 */
const log = (error, EAN = "") => {
  if (EAN) console.log(chalk.bold.red(`Item EAN: ${EAN}`));
  console.log("\n", error);
  process.exit(1);
};

const randomInt = (min, max) =>
  Math.floor(Math.random() * (max + 1 - min) + min);

const spinnies = spinner();

module.exports = {
  getIdIndex,
  parseMonthFR,
  generateIdName,
  parseCSV,
  spinnies,
  log,
  randomInt,
};
