import { Message, Portfolio } from "../types";

const useApi = () => {
  const getPortfolio = (username: string) => fetch("/portfolios/" + username);

  const patchPortfolio = (
    username: string,
    experienceId: number,
    portfolioChanges: Partial<Portfolio>
  ) =>
    fetch(`/portfolios/${username}/${experienceId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(portfolioChanges),
    }).then((response) => response.json());

  const getQuestions = (username: string) => fetch("/surveys/" + username);

  const postResponses = (username: string, responses: Message[]) =>
    fetch("/surveys/" + username, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(responses),
    });

  const postTheme = (username: string, name: string, tags: string[]) =>
    fetch("/themes/" + username, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        name,
        tags,
      }),
    });

  const deleteTheme = (username: string, themeName: string) =>
    fetch(`/themes/${username}/${themeName}`, { method: "DELETE" });

  return {
    getPortfolio,
    patchPortfolio,
    getQuestions,
    postResponses,
    postTheme,
    deleteTheme,
  };
};

export default useApi;
