import React, { useMemo, useState } from "react";
import { Experience, Tag } from "../types";

interface Props {
  data: Experience;
  selectedTags?: string[];
  onPublicationClick?: (expId: number) => void;
}

const ExperienceRow = ({ data, selectedTags, onPublicationClick }: Props) => {
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

  const filteredTags = useMemo(() => {
    if ("tags" in data) {
      if (selectedTags) {
        return data.tags.filter((tag) => selectedTags?.includes(tag.value));
      } else {
        return data.tags;
      }
    } else {
      return [];
    }
  }, [data.tags, selectedTags]);

  const dateFormat = { month: "long" as const, year: "numeric" as const };

  return (
    <div
      style={{ display: "block" }}
      className="experience-row"
      id={`Experience #${data.id}`}
    >
      <h3>
        {data.title}
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
      <h4>{data.company}</h4>
      {new Date(startDate).toLocaleDateString("en-US", dateFormat)} -{" "}
      {endDate ? new Date(endDate).toLocaleDateString("en-US", dateFormat) : ""}
      <div className="experience-summary">{data.summary}</div>
      <div>
        <ul className="tag-list">
          {filteredTags
            .sort((a: Tag, b: Tag) => {
              if (b.value < a.value) {
                return 1;
              }
              if (a.value < b.value) {
                return -1;
              }
              return 0;
            })
            .map((tag, i) => (
              <li className={"tag-item"} key={`tag ${data.id} - ${i}`}>
                {tag.value}
              </li>
            ))}
        </ul>
      </div>
    </div>
  );
};

export default ExperienceRow;
