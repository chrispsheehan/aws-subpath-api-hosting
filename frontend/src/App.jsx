import React from "react";
import { Routes, Route, Link, useLocation } from "react-router-dom";
import Home from "./Home";
import Page1 from "./Page1";

function QueryDebug() {
  const location = useLocation();
  const queryParams = new URLSearchParams(location.search);
  const entries = Array.from(queryParams.entries());

  if (entries.length === 0) return null;

  return (
    <div style={{ padding: "1rem", background: "#eee", fontSize: "0.9rem" }}>
      <strong>Query Params:</strong>
      <ul>
        {entries.map(([key, value]) => (
          <li key={key}>
            <strong>{key}</strong>: {value}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default function App() {
  return (
    <div>
      <h1>React SPA App</h1>
      <nav>
        <Link to="/">Home</Link> | <Link to="/page1">Page 1</Link>
      </nav>
      <QueryDebug />
      <hr />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/page1" element={<Page1 />} />
      </Routes>
    </div>
  );
}
