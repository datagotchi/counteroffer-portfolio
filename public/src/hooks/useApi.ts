import { Message } from "../types";

const useApi = () => {
  const getPortfolio = (username: string) => fetch("/portfolios/" + username);

  const getQuestions = (username: string) => fetch("/surveys/" + username);

  const postResponses = (username: string, responses: Message[]) =>
    fetch("/surveys/" + username, {
      method: "POST",
      body: JSON.stringify(responses),
    });

  const postTheme = (username: string, name: string, tags: string[]) =>
    fetch("/themes/" + username, {
      method: "POST",
      body: JSON.stringify(tags),
    });

  return {
    getPortfolio,
    getQuestions,
    postResponses,
    postTheme,
  };
};

export default useApi;
