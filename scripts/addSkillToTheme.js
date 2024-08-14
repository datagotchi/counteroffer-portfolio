const { Pool } = require("pg");
const dotenv = require("dotenv");

dotenv.config({ path: "../.env" });

const pool = new Pool({
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  host: process.env.DATABASE_HOST,
  port: process.env.DATABASE_PORT,
  database: process.env.DATABASE_NAME,
  max: 50, // 10 is default
  idleTimeoutMillis: 10000, // 10000 is default
  connectionTimeoutMillis: 2000, // 0 (no timeout!) is default
});

async function main() {
  let client;
  try {
    client = await pool.connect();
  } catch (err) {
    console.error(err);
    console.error("*** totalCount", pool.totalCount);
    console.error("*** idleCount", pool.idleCount);
    console.error("*** waitingCount", pool.waitingCount);
    console.error("*** so, exiting!");
    process.exit();
  }
  if (process.argv.length < 4) {
    console.log("Usage: node addSkillToTheme.js [theme] [skill]");
    process.exit();
  }
  const themeName = process.argv[2];
  const skill = process.argv[3];
  try {
    let tags = await client
      .query({
        text: "select tags from themes where name = $1::text",
        values: [themeName],
      })
      .then((response) => {
        return response.rows[0].tags;
      });

    // console.log("*** tags: ", tags);

    if (!tags) {
      tags = [];
    }

    if (!tags.map((tag) => tag.value).includes(skill)) {
      tags.push(skill);
      // console.log("*** tags(2): ", tags);
      tags = await client
        .query({
          text: "update themes set tags = $1::text[] where name = $2::text returning tags",
          values: [tags, themeName],
        })
        .then((response) => response.rows[0].tags);
    }

    console.log("*** final tags: ", tags);
  } catch (err) {
    console.error(err);
  }

  client.end();
}

main();
