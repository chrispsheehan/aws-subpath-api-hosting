import React, { useEffect, useState } from "react";

export default function Home() {
  const [data, setData] = useState("Loading...");

  useEffect(() => {
    fetch("/api/hello")
      .then((res) => res.json())
      .then((json) => setData(JSON.stringify(json, null, 2)))
      .catch((err) => setData("❌ " + err.message));
  }, []);

  return (
    <div>
      <h2>🏠 Home</h2>
      <pre>{data}</pre>
    </div>
  );
}
