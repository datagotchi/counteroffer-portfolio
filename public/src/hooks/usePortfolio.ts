import { useEffect, useState } from "react";
import { Portfolio } from "../types";
import useApi from "./useApi";

const usePortfolio = (username?: string) => {
  const [portfolio, setPortfolio] = useState<Portfolio | undefined>();
  const [loading, setLoading] = useState(false);

  const api = useApi();

  useEffect(() => {
    if (username && !portfolio && !loading) {
      setLoading(true);
      api
        .getPortfolio(username)
        .then((response) => response.json())
        .then((data) => {
          setPortfolio(data);
        })
        .finally(() => setLoading(false));
    }
  }, [api, username, portfolio, loading]);

  return portfolio;
};

export default usePortfolio;
