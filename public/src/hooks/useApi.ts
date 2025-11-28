import { Message } from "../types";

const useApi = () => {
  const getPortfolio = (username: string) => fetch("/portfolios/" + username);

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
    getQuestions,
    postResponses,
    postTheme,
    deleteTheme,
  };
};

export default useApi;
