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
  }).fromFile(path.join("raw", sourceFile));

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

  spinnies.add("drop", { text: "Dropping current DB" });
  spinnies.add("csv", { text: "Parsing CSV source" });
  spinnies.add("tables", { text: "Populating tables" });

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

module.exports = {
  getIdIndex,
  parseMonthFR,
  generateIdName,
  parseCSV,
  spinnies: spinner(),
  log,
};
