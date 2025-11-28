const express = require("express");
const path = require("path");
const logger = require("morgan");
const bodyParser = require("body-parser");
const http = require("http");
const { Pool } = require("pg");
const dotenv = require("dotenv");
const cors = require("cors");
const nodemailer = require("nodemailer");
const aws = require("@aws-sdk/client-ses");
const { defaultProvider } = require("@aws-sdk/credential-provider-node");

const app = express();
app.use(cors()); // FIXME: why would I need CORS? /public is on the same host

dotenv.config();

app.use("/", (req, res, next) => next(), express.static("public/dist"));

app.use(logger("dev"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

const ses = new aws.SES({
  apiVersion: "2010-12-01",
  region: "us-east-2",
  credentials: {
    accessKeyId: "AKIATHV3XCGRX3MRFNDJ",
    secretAccessKey: "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",
    // sessionToken
  },
  defaultProvider,
});

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

// pool.on("error", (err) => {
//   console.error("pg pool error: ", err);
//   process.exit();
// });

app.use(async (req, res, next) => {
  try {
    req.client = await pool.connect();
    next();
  } catch (err) {
    console.error(err);
    console.error("*** totalCount", pool.totalCount);
    console.error("*** idleCount", pool.idleCount);
    console.error("*** waitingCount", pool.waitingCount);
    console.error("*** so, restarting server...");
    process.exit();
  }
});

// app.use((req, res, next) => {
//   console.log(`*** requesting: , ${req.url}`);
//   next();
// });

app.use((req, res, next) => {
  try {
    const transporter = nodemailer.createTransport({
      SES: { ses, aws },
    });
    req.smtp = transporter;
    next();
  } catch (err) {
    next(err);
  }
});

const indexRouter = require("./routes/index");
const portfoliosRouter = require("./routes/portfolios");
const surveysRouter = require("./routes/surveys");
app.use("/", indexRouter);
app.use("/portfolios", portfoliosRouter);
app.use("/surveys", surveysRouter);

const server = http.createServer(app);
server.listen(process.env.PORT || 8000);
server.on("listening", () => {
  console.log("Listening on ", server.address());
});

app.use((err, req, res, next) => {
  // console.log("error! " + err);
  return res.status(err.status || 500).json({
    message: err.message,
    error: err,
  });
});

module.exports = app;
