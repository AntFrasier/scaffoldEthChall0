// import { PageHeader } from "antd";
import React from "react";
import Logo from "./Logo";
// import "./css/header.less";

// displays a page header

export default function Header() {
  return (

    <div className="header">

      <Logo />

    <a href="https://cyril-maranber.com" target="_blank" rel="noopener noreferrer" style={{textAlign:"left"}}>
      <h1>
        {/* <img src={logo} /> */}
        Forked from ScaffolgEth Challenges.
      </h1>
      {/* <PageHeader
        title="🏗 scaffold-eth"
        subTitle="forkable Ethereum dev stack focused on fast product iteration"
        style={{ cursor: "pointer" }}
      /> */}
    </a>
    </div>
  );
}
