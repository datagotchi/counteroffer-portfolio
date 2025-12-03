import React from "react";
import { render, screen } from "@testing-library/react";
import "@testing-library/jest-dom";

import Histogram, { EXPERIENCE_YEAR_HEIGHT } from "../components/Histogram";

// eslint-disable-next-line jest/no-mocks-import
import {
  mockExperiences,
  MOCK_EXPERIENCE_LENGTH_YEARS,
} from "../hooks/__mocks__/axios";
const mockExperienceHeight =
  MOCK_EXPERIENCE_LENGTH_YEARS * EXPERIENCE_YEAR_HEIGHT;

describe("Histogram", () => {
  test("Renders the tag as the correctly-sized bar", async () => {
    render(
      <Histogram
        experiences={mockExperiences}
        // selectedThemeTags={[]}
        onTagsSelected={(tags?: string[]) => {}}
        setTags={jest.fn()}
      />
    );
    const bar = await screen.findByText(/1/i);
    expect(bar).toBeInTheDocument();
    expect(bar.innerHTML).toEqual("1");
    expect(bar.tagName.toLowerCase()).toBe("div");
    expect(parseInt(bar.style.height)).toEqual(mockExperienceHeight);
  });
});
