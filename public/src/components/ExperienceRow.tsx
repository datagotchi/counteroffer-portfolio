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
  const startDate = useMemo(() => {
    const date = new Date(data.startdate);
    return date.toLocaleDateString("en-US");
  }, [data?.startdate]);

  const endDate = useMemo(() => {
    if (data.enddate) {
      const date = new Date(data.enddate);
      return date.toLocaleDateString("en-US");
    }
    return "";
  }, [data?.enddate]);

  const dateFormat = { month: "long" as const, year: "numeric" as const };

  const api = useApi();

  const updatePortfolioField = useCallback(
    (experienceId: number, property: string, newValue: any) =>
      api.patchPortfolio(username, experienceId, {
        [property]: newValue,
      }),
    [data]
  );

  return (
    <div
      style={{ display: "block" }}
      className="experience-row"
      id={`Experience #${data.id}`}
    >
      <h3>
        <EasyEdit
          type="text"
          value={data.title}
          onSave={async (newValue: string) => {
            const changes = await updatePortfolioField(
              data.id,
              "title",
              newValue
            );
            data.title = changes.title;
          }}
        />
        {data.publications.length > 0 && (
          <span
            style={{ float: "right" }}
            className="publications-link tag-item"
          >
            {onPublicationClick && (
              <a
                onClick={(event) => onPublicationClick(data.id)}
                style={{
                  cursor: "pointer",
                  color: "#fff",
                }}
              >
                {data.publications.length} Publications
              </a>
            )}
            {!onPublicationClick && `${data.publications.length} Publications`}
          </span>
        )}
      </h3>
      <h4>
        <EasyEdit
          type="text"
          value={data.company}
          onSave={async (newValue: string) => {
            const changes = await updatePortfolioField(
              data.id,
              "company",
              newValue
            );
            data.company = changes.company;
          }}
        />
      </h4>
      {new Date(startDate).toLocaleDateString("en-US", dateFormat)} -{" "}
      {endDate ? new Date(endDate).toLocaleDateString("en-US", dateFormat) : ""}
      <div className="experience-summary">
        <EasyEdit
          type="textarea"
          inputAttributes={{ rows: 10, cols: 100 }}
          value={data.summary}
          onSave={async (newValue: string) => {
            const changes = await updatePortfolioField(
              data.id,
              "summary",
              newValue
            );
            data.summary = changes.summary;
          }}
        />
      </div>
      <div>
        <ul className="tag-list">
          {data.tags
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
                key={`tag-${data.id}-${tag.value}`}
              >
                {tag.value}
              </li>
            ))}
        </ul>
      </div>
    </div>
  );
};

export default ExperienceRow;
