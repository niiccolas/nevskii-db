const { seedDB } = require("./db");

const options = {
  orders: 500,
  range: [0, 400],
  filepath: "../assets/csv/dvd_4412_mint.csv",
  users: [
    {
      userType: 1, // admin
      firstName: "NEVSKII",
      lastName: "ADMIN",
      email: "admin@nevskii.net",
    },
    {
      firstName: "Sophia",
      lastName: "Cappalo",
      email: "scappalo@mail.com",
      birthDate: "1971-5-14",
    },
    {
      name: "David Lunch",
      email: "dlunch@mail.com",
      birthDate: "1946-1-21",
      gender: "M",
    },
  ],
};

seedDB(options);
