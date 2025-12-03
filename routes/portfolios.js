const express = require("express");
const router = express.Router();

const getTagsForExperience = (req, experience_id) =>
  req.client
    .query({
      text: "select value from tags where experience_id = $1::integer order by value asc",
      values: [Number(experience_id)],
    })
    .then((response) => response.rows);

const getPubsForExperience = (req, experience_id) =>
  req.client
    .query({
      text: "select * from publications where experience_id = $1::integer order by date asc",
      values: [Number(experience_id)],
    })
    .then((response) => response.rows);

router.param("username", async (req, res, next) => {
  req.user = await req.client
    .query({
      text: "select * from users where username = $1::text",
      values: [req.params.username],
    })
    .then((result) => result.rows[0]);
  next();
});

router.get("/:username", async (req, res, next) => {
  if (req.user) {
    const user = req.user;
    const userId = Number(user.id);
    const factsResult = await req.client.query({
      text: "select * from facts where user_id = $1::integer",
      values: [userId],
    });
    const facts = factsResult.rows;
    const experiencesResult = await req.client.query({
      text: `select * from experiences 
        where user_id = $1::integer
        order by enddate desc, startdate desc`,
      values: [userId],
    });
    let experiences = experiencesResult.rows;
    await Promise.all(
      experiences.map(async (e) => {
        e.tags = await getTagsForExperience(req, e.id);
        e.publications = await getPubsForExperience(req, e.id);
      })
    );
    const education = experiences.filter((exp) => exp.is_education);
    const lastEducation = education.sort((a, b) => a.enddate - b.endddate)[0];
    const professionalExperiences = experiences.filter(
      (exp) => !exp.is_education
    );
    // .filter((exp) => exp.startdate >= lastEducation.startdate);
    const publications = await req.client
      .query({
        text: "select * from publications where user_id = $1::integer",
        values: [userId],
      })
      .then((response) => response.rows);
    const themesResult = await req.client.query({
      text: "select * from themes where user_id = $1::integer",
      values: [userId],
    });
    const themes = themesResult.rows;
    req.client.release();
    return res.json({
      name: user.name,
      email: user.email,
      location: user.location,
      phone: user.phone,
      facts,
      professionalExperiences,
      education,
      publications,
      themes,
    });
  } else {
    req.client.release();
    return res.sendStatus(404);
  }
});

router.patch("/:username/:experienceId", async (req, res, next) => {
  if (req.user) {
    if (req.params.experienceId) {
      const changes = req.body;
      const keys = Object.keys(changes || {});
      if (keys.length === 0) {
        req.client.release();
        return res.sendStatus(400);
      }

      // basic column name validation to avoid injection
      const validKeys = keys.filter((k) => /^[a-z][a-z0-9_]*$/i.test(k));
      if (validKeys.length === 0) {
        req.client.release();
        return res.sendStatus(400);
      }

      const experience = { tags: [] };

      const validKeysWithoutTags = validKeys.filter((k) => k !== "tags");
      if (validKeysWithoutTags.length > 0) {
        const set = validKeysWithoutTags
          .map((k, i) => `"${k}" = $${i + 1}`)
          .join(", ");
        const values = validKeysWithoutTags.map((k) => changes[k]);
        values.push(Number(req.params.experienceId));

        const exp = await req.client
          .query({
            text: `update experiences set ${set} where id = $${values.length} returning *`,
            values,
          })
          .then((result) => result.rows[0]);

        experience = {
          ...experience,
          ...exp,
        };
      }
      if (validKeys.includes("tags")) {
        const { tags: newTags } = changes;

        const newTags2 = await Promise.all(
          newTags.map((nt) =>
            req.client
              .query({
                text: "insert into tags (experience_id, value) values ($1::integer, $2::text) returning *",
                values: [req.params.experienceId, nt.value],
              })
              .then((result) => result.rows[0])
          )
        );

        experience.tags = [...experience.tags, ...newTags2];
      }

      return res.json(experience);
    } else {
      req.client.release();
      return res.sendStatus(400);
    }
  }
  req.client.release();
  return res.sendStatus(404);
});

module.exports = router;
