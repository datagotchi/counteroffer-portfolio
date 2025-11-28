const express = require("express");
const router = express.Router();

router.post("/:username", async (req, res, next) => {
  const theme = req.body;
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
        values: [user.id, theme.name, theme.tags],
      })
      .then((result = result.rows[0]));
    req.client.release();
    res.send(newTheme);
  } else {
    req.client.release();
    res.sendStatus(404);
  }
});
