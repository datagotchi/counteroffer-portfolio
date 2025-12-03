import React, { useCallback, useEffect, useMemo, useState } from "react";
import useLocationHash from "../hooks/useLocationHash";
import usePortfolio from "../hooks/usePortfolio";
import ExperienceRow from "./ExperienceRow";
import Facts from "./Facts";
import Histogram from "./Histogram";
import Navigation from "./Navigation";
import Survey from "./Survey";
import { Publication } from "../types";
import useApi from "../hooks/useApi";

const CURRENT_THEME_KEY = "current_theme";

interface YearsObject {
  [key: number]: Publication[];
}

const Portfolio = () => {
  const currentThemeNameFromStorage = sessionStorage.getItem(CURRENT_THEME_KEY);

  const username = useLocationHash();
  const [currentThemeName, setCurrentThemeName] = useState<string | null>(
    currentThemeNameFromStorage
  );
  const [selectedTags, setSelectedTags] = useState<string[]>([]);

  const portfolio = usePortfolio(username);

  const api = useApi();

  const navigationItems = useMemo(() => {
    // let items = ["All Experiences", "Contact"]; // TODO: when I work on the survey again
    let items = ["All Experiences"];
    if (portfolio?.themes) {
      items.push(...portfolio.themes.map((theme) => theme.name));
    }
    return items;
  }, [portfolio?.themes.length]);

  useEffect(() => {
    sessionStorage.setItem(CURRENT_THEME_KEY, currentThemeName ?? "");
  }, [currentThemeName]);

  const currentThemeObject = useMemo(() => {
    if (portfolio?.themes && currentThemeName) {
      return portfolio.themes.find((theme) => theme.name === currentThemeName);
    }
  }, [portfolio?.themes, currentThemeName]);

  const themedExperiences = useMemo(() => {
    if (currentThemeName && portfolio?.professionalExperiences) {
      return portfolio.professionalExperiences.filter((exp) =>
        currentThemeObject?.tags.some((tag) =>
          exp.tags.map((t) => t.value).includes(tag)
        )
      );
    }
  }, [
    currentThemeName,
    currentThemeObject,
    portfolio?.professionalExperiences,
  ]);

  const filteredExperiences = useMemo(() => {
    let experiences = portfolio?.professionalExperiences;
    if (currentThemeObject) {
      experiences = themedExperiences;
    }
    if (experiences) {
      if (selectedTags.length > 0) {
        return experiences.filter((e) =>
          selectedTags.every((f) => e.tags.map((t) => t.value).includes(f))
        );
      }
      return experiences;
    }
    return [];
  }, [
    themedExperiences,
    portfolio?.professionalExperiences,
    currentThemeObject,
    selectedTags,
  ]);

  const educationExperiences = useMemo(() => {
    if (portfolio?.education) {
      return portfolio.education;
    }
    return [];
  }, [portfolio?.education]);

  const goToElementFromId = (elementId: string) => {
    document.getElementById(elementId)?.scrollIntoView();
  };

  const goToExperience = useCallback(
    (experimentId: number) => {
      const experience = [...filteredExperiences, ...educationExperiences].find(
        (exp) => exp.id === experimentId
      );
      goToElementFromId(`Experience #${experience?.id}`);
    },
    [filteredExperiences, educationExperiences]
  );

  const goToPublication = useCallback(
    (expId: number) => {
      const publicationsForExpId = portfolio?.publications.filter(
        (pub) => pub.experience_id === expId
      );
      if (publicationsForExpId) {
        const lastPublication = publicationsForExpId.sort(
          (a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()
        )[0];
        goToElementFromId(`Publication #${lastPublication.id}`);
      }
    },
    [portfolio]
  );

  const publicationYears = useMemo(() => {
    if (portfolio?.publications && portfolio.publications.length > 0) {
      return portfolio.publications.reduce((yearsObject, pub) => {
        const pubYear = new Date(pub.date).getFullYear();
        if (!(pubYear in yearsObject)) {
          yearsObject[pubYear] = [];
        }
        yearsObject[pubYear].push(pub);
        return yearsObject;
      }, {} as YearsObject);
    }
    return [];
  }, [portfolio?.publications]);

  const createTheme = useCallback(
    async (tags: string[]) => {
      if (username && selectedTags.length > 0) {
        const themeName = prompt("Name of the new theme");
        if (themeName) {
          // create theme in db
          await api.postTheme(username, themeName, selectedTags);
          // go to new theme
          setCurrentThemeName(themeName);
          // reload to show the theme selected on the left
          window.location.reload();
        }
      }
    },
    [username, selectedTags]
  );

  const currentExperiences = useMemo(
    () =>
      themedExperiences && themedExperiences.length > 0
        ? themedExperiences
        : filteredExperiences,
    [themedExperiences, filteredExperiences]
  );

  if (portfolio) {
    const genericFacts = portfolio.facts.filter((fact) => !fact.theme_id);
    const themeFacts = portfolio.facts.filter(
      (fact) => fact.theme_id === currentThemeObject?.id
    );
    return (
      <>
        <div id="nav" className="hideFromPrint">
          <p>
            <input
              type="checkbox"
              onChange={(event) => {
                if (event.target.checked) {
                  Array.from(
                    document.getElementsByClassName("tag-list")
                  ).forEach((tagList) => {
                    tagList.classList.add("hideFromPrint");
                  });
                } else {
                  Array.from(
                    document.getElementsByClassName("tag-list")
                  ).forEach((tagList) => {
                    tagList.classList.remove("hideFromPrint");
                  });
                }
              }}
            />{" "}
            Print: remove experience tags
          </p>
          <Navigation
            items={navigationItems}
            currentThemeInput={currentThemeName || undefined}
            onThemeChange={(newTheme: string) => setCurrentThemeName(newTheme)}
          />
        </div>

        <div id="content">
          <h1 style={{ textAlign: "center" }}>{portfolio.name}</h1>
          <p style={{ textAlign: "center" }}>
            {/* TODO: add portfolio.url */}
            {portfolio.email} · {portfolio.phone}
          </p>
          {username && currentThemeObject && (
            <>
              <p style={{ textAlign: "center" }}>
                <strong>Current Theme:</strong> {currentThemeObject.name}
              </p>
              <p style={{ textAlign: "center" }}>
                <button
                  onClick={async () => {
                    if (confirm("Are you sure?")) {
                      await api.deleteTheme(username, currentThemeObject.name);
                      portfolio.themes = portfolio.themes.filter(
                        (t) => t.name !== currentThemeName
                      );
                      setCurrentThemeName(null);
                    }
                  }}
                  className="btn bg-danger"
                >
                  Delete
                </button>
              </p>
            </>
          )}
          {/* <div id="facts">
          <Facts data={[...genericFacts, ...themeFacts]} />
        </div> */}
          <h2>
            {currentThemeObject ? `Skills in this theme/pitch` : "My Skills"}
          </h2>

          <Histogram
            experiences={currentExperiences}
            selectedThemeTags={currentThemeObject?.tags}
            setSelectedTags={setSelectedTags}
            selectedTags={selectedTags}
            createTheme={createTheme}
          />
          <h2>
            {currentThemeObject
              ? "Experiences With Those Skills"
              : "My Experiences"}
          </h2>
          {currentExperiences.map((exp, i) => (
            <ExperienceRow
              data={exp}
              key={`ExperienceRow #${i}`}
              selectedTags={selectedTags}
              onPublicationClick={goToPublication}
              username={username!}
            />
          ))}
          <h2>Education</h2>
          {portfolio.education.map((edu, i) => (
            <ExperienceRow
              data={edu}
              key={`EducationRow #${i}`}
              selectedTags={selectedTags}
              onPublicationClick={goToPublication}
              username={username!}
            />
          ))}
          <h2 style={{ pageBreakBefore: "always" }}>Appendix: Publications</h2>
          {/* TODO: link publications to companies || projects? */}
          {Object.keys(publicationYears)
            .map((yearString) => parseInt(yearString))
            .sort((a, b) => b - a)
            .map((pubYear) => (
              <React.Fragment key={`pubYear-${pubYear}`}>
                <h3>{pubYear}</h3>
                <ul>
                  {portfolio.publications
                    .filter(
                      (pub) => new Date(pub.date).getFullYear() === pubYear
                    )
                    .filter((pub) =>
                      [...filteredExperiences, ...portfolio.education]
                        .map((exp) => exp.id)
                        .includes(pub.experience_id)
                    )
                    .sort(
                      (a, b) =>
                        new Date(b.date).getTime() - new Date(a.date).getTime()
                    )
                    .map((pub, i) => (
                      <li key={`Publication #${pub.id}`}>
                        {pub.link && (
                          <a
                            href={pub.link}
                            target="_blank"
                            id={`Publication #${pub.id}`}
                            rel="noreferrer"
                            key={`pub ${pub.id} title link`}
                          >
                            {pub.title}
                          </a>
                        )}
                        {!pub.link && pub.title}
                        <ul>
                          <li key={`pub ${pub.id} authors`}>{pub.authors}</li>
                          <li key={`pub ${pub.id} venue and date`}>
                            {pub.venue} (
                            {new Date(pub.date).toLocaleDateString("en-US", {
                              month: "long",
                            })}
                            )
                          </li>
                        </ul>
                      </li>
                    ))}
                </ul>
              </React.Fragment>
            ))}
        </div>
      </>
    );
  }

  return <>Loading...</>;
};

export default Portfolio;
