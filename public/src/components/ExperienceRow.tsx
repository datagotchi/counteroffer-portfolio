import React, { useCallback, useMemo, useState } from "react";
import EasyEdit from "react-easy-edit";

import { Experience, Tag } from "../types";
import useApi from "../hooks/useApi";

interface Props {
  data: Experience;
  selectedTags?: string[];
  onPublicationClick?: (expId: number) => void;
  username: string;
}

const ExperienceRow = ({
  data,
  selectedTags,
  onPublicationClick,
  username,
}: Props) => {
  const [liveData, setLiveData] = useState(data);

  const startDate = useMemo(() => {
    const date = new Date(liveData.startdate);
    return date.toLocaleDateString("en-US");
  }, [liveData?.startdate]);

  const endDate = useMemo(() => {
    if (liveData.enddate) {
      const date = new Date(liveData.enddate);
      return date.toLocaleDateString("en-US");
    }
    return "";
  }, [liveData?.enddate]);

  const dateFormat = { month: "long" as const, year: "numeric" as const };

  const api = useApi();

  const updatePortfolioField = (
    experienceId: number,
    property: string,
    newValue: any
  ) =>
    api.patchPortfolio(username, experienceId, {
      [property]: newValue,
    });

  const addTag = (tagName: string) => {
    api
      .patchPortfolio(username, liveData.id!, {
        tags: [{ value: tagName }],
      })
      .then((experience: Experience) => {
        setLiveData({
          ...liveData,
          ...experience,
          tags: [...liveData.tags, ...experience.tags],
        });
      });
  };

  return (
    <div
      style={{ display: "block" }}
      className="experience-row"
      id={`Experience #${liveData.id}`}
    >
      <h3>
        <EasyEdit
          type="text"
          value={liveData.title}
          onSave={async (newValue: string) => {
            const changes = await updatePortfolioField(
              liveData.id!,
              "title",
              newValue
            );
            liveData.title = changes.title;
          }}
        />
        {liveData.publications.length > 0 && (
          <span
            style={{ float: "right" }}
            className="publications-link tag-item"
          >
            {onPublicationClick && (
              <a
                onClick={(event) => onPublicationClick(liveData.id!)}
                style={{
                  cursor: "pointer",
                  color: "#fff",
                }}
              >
                {liveData.publications.length} Publications
              </a>
            )}
            {!onPublicationClick &&
              `${liveData.publications.length} Publications`}
          </span>
        )}
      </h3>
      <h4>
        <EasyEdit
          type="text"
          value={liveData.company}
          onSave={async (newValue: string) => {
            const changes = await updatePortfolioField(
              liveData.id!,
              "company",
              newValue
            );
            liveData.company = changes.company;
          }}
        />
      </h4>
      {new Date(startDate).toLocaleDateString("en-US", dateFormat)} -{" "}
      {endDate ? new Date(endDate).toLocaleDateString("en-US", dateFormat) : ""}
      <div className="experience-summary">
        <EasyEdit
          type="textarea"
          inputAttributes={{ rows: 10, cols: 100 }}
          value={liveData.summary}
          onSave={async (newValue: string) => {
            const changes = await updatePortfolioField(
              liveData.id!,
              "summary",
              newValue
            );
            liveData.summary = changes.summary;
          }}
        />
      </div>
      <div>
        <ul className="tag-list">
          {liveData.tags
            .sort((a: Tag, b: Tag) => {
              if (b.value < a.value) {
                return 1;
              }
              if (a.value < b.value) {
                return -1;
              }
              return 0;
            })
            .map((tag) => (
              <li
                className={`tag-item ${
                  selectedTags?.includes(tag.value) && "danger"
                }`}
                key={`tag-${liveData.id}-${tag.value}`}
              >
                {tag.value}
              </li>
            ))}
          <li className={"tag-item"} key={`tag-${liveData.id}-addTag`}>
            <button
              onClick={() => {
                const tagName = prompt("New tag name:");
                if (tagName) {
                  if (liveData.tags.map((t) => t.value).includes(tagName)) {
                    return alert(
                      `Tag ${tagName} already exists in this experience`
                    );
                  }
                  addTag(tagName);
                }
              }}
              style={{
                backgroundColor: "transparent",
                border: 0,
              }}
            >
              ✚
            </button>
          </li>
        </ul>
      </div>
    </div>
  );
};

export default ExperienceRow;
