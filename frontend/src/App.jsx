import React from "react";
import { Routes, Route, Link } from "react-router-dom";
import Home from "./Home";
import Page1 from "./Page1";

export default function App() {
  return (
    <div>
      <h1>React SPA with Build Step</h1>
      <nav>
        <Link to="/">Home</Link> | <Link to="/page1">Page 1</Link>
      </nav>
      <hr />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/page1" element={<Page1 />} />
      </Routes>
    </div>
  );
}
