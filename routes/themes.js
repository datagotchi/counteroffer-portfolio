const express = require("express");
const router = express.Router();

router.post("/:username", async (req, res, next) => {
  const reqTheme = req.body;
  const user = await req.client
    .query({
      text: "select * from users where username = $1::text",
      values: [req.params.username],
    })
    .then((result) => {
      if (result.rows.length === 1) {
        return result.rows[0];
      }
      return undefined;
    });
  if (user) {
    const newTheme = await req.client
      .query({
        text: "insert into themes (user_id, name, tags) values ($1::integer, $2::text, $3::text[]) returning *",
        values: [user.id, reqTheme.name, reqTheme.tags],
      })
      .then((result) => {
        if (result.rows.length === 1) {
          return result.rows[0];
        }
        return undefined;
      });
    req.client.release();
    res.send(newTheme);
  } else {
    req.client.release();
    res.sendStatus(404);
  }
});

router.delete("/:username/:themeName", async (req, res, next) => {
  const user = await req.client
    .query({
      text: "select * from users where username = $1::text",
      values: [req.params.username],
    })
    .then((result) => {
      if (result.rows.length === 1) {
        return result.rows[0];
      }
      return undefined;
    });
  if (user) {
    try {
      console.log("*** req.params: ", req.params);
      console.log("*** user: ", user);
      await req.client.query({
        text: "delete from themes where user_id = $1::integer and name = $2::text",
        values: [user.id, req.params.themeName],
      });
      req.client.release();
      res.sendStatus(204);
    } catch (err) {
      console.error(err);
      req.client.release();
      res.sendStatus(404);
    }
  } else {
    req.client.release();
    res.sendStatus(404);
  }
});

module.exports = router;
