import React, { useMemo, useState } from "react";
import { Experience, Tag } from "../types";

interface TagCount {
  name: string;
  count: number;
}

interface Props {
  experiences: Experience[];
  selectedThemeTags?: string[];
  selectedTags: string[];
  setSelectedTags: (tags: string[]) => void;
  createTheme: (tags: string[]) => void;
  printStyle?: string;
}

export const EXPERIENCE_YEAR_HEIGHT = 2;

const Histogram = ({
  experiences,
  selectedThemeTags,
  selectedTags,
  setSelectedTags,
  createTheme,
  printStyle,
}: Props) => {
  const [filter, setFilter] = useState<string>("");

  const sortedTagCounts = useMemo(() => {
    return experiences
      .reduce<TagCount[]>((counts, experience) => {
        experience.tags
          .filter((tag: Tag) =>
            selectedThemeTags ? selectedThemeTags?.includes(tag.value) : true
          )
          .forEach((tag: Tag) => {
            if (!counts.find((c) => c.name === tag.value)) {
              counts.push({ name: tag.value, count: 0 });
            }
            const tc = counts.find((c) => c.name === tag.value);
            if (tc) {
              const end = experience.enddate
                ? new Date(experience.enddate)
                : new Date();
              const start = new Date(experience.startdate);
              const time = end.getTime() - start.getTime();
              const years = Math.round(time / (1000 * 60 * 60 * 24 * 365));
              tc.count += years;
            }
          });
        return counts;
      }, [])
      .sort((a, b) => b.count - a.count);
  }, [experiences, selectedThemeTags]);

  return (
    <>
      <div id="histogram_container">
        <div id="histogram_header">
          <strong style={{ float: "left" }}>
            Click one or more bars to filter the experiences below
          </strong>
          {selectedTags.length > 0 && (
            <div>
              <button onClick={() => createTheme(selectedTags)}>
                Create Theme
              </button>
            </div>
          )}
          <div style={{ float: "right" }}>
            <input
              type="text"
              placeholder="Filter tags"
              value={filter}
              onChange={(event) => setFilter(event.target.value)}
            />
            <span
              className="glyphicon glyphicon-remove-circle"
              aria-hidden="true"
              style={{ cursor: "pointer" }}
              onClick={() => setFilter("")}
            ></span>
          </div>
        </div>
        <div style={{ clear: "both", fontSize: "12px" }}>
          {sortedTagCounts
            .filter((tc) =>
              tc.name.toLocaleLowerCase().includes(filter.toLocaleLowerCase())
            )
            .map((tc) => (
              <span
                style={{
                  display: "inline-block",
                  width: "80px",
                  verticalAlign: "bottom",
                  margin: "0 5px",
                }}
                key={`histogram span for ${tc.name}`}
              >
                <div style={{ textAlign: "center" }}>{tc.name}</div>
                <div
                  style={{
                    color: "white",
                    height: tc.count * EXPERIENCE_YEAR_HEIGHT,
                    textAlign: "center",
                    verticalAlign: "bottom",
                    cursor: "pointer",
                  }}
                  className={
                    "histogram-tag " +
                    (selectedTags.includes(tc.name) ? "danger" : "")
                  }
                  onClick={() => {
                    if (selectedTags.includes(tc.name)) {
                      setSelectedTags(
                        selectedTags.filter((st) => st !== tc.name)
                      );
                    } else {
                      setSelectedTags([...selectedTags, tc.name]);
                    }
                  }}
                >
                  {tc.count}
                </div>
              </span>
            ))}
        </div>
      </div>
    </>
  );
};

export default Histogram;
