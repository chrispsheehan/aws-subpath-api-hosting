import React, { useEffect, useState } from "react";

export default function Home() {
  const [apiData, setApiData] = useState("Loading /api/hello...");
  const [searchData, setSearchData] = useState("Loading /search?this=that...");

  useEffect(() => {
    // Test /api/hello
    fetch("/api/hello")
      .then((res) => res.json())
      .then((json) => setApiData(JSON.stringify(json, null, 2)))
      .catch((err) => setApiData("❌ " + err.message));

    // Test /search?this=that
    fetch("/search?this=that")
      .then((res) => res.text())
      .then((text) => setSearchData(text))
      .catch((err) => setSearchData("❌ " + err.message));
  }, []);

  return (
    <div>
      <h2>🏠 Home</h2>

      <h3>✅ /api/hello</h3>
      <pre>{apiData}</pre>

      <h3>🧪 /search?this=that</h3>
      <pre>{searchData}</pre>
    </div>
  );
}
