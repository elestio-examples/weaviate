# Weaviate CI/CD pipeline

<a href="https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/weaviate"><img src="deploy-on-elestio.png" alt="Deploy on Elest.io" width="180px" /></a>

Deploy Weaviate server with CI/CD on Elestio

<div style="text-align:center;">
<img src="Weaviate.png" style='width: 30%;'/>
</div>
<br/>
<br/>

# Once deployed ...

You can open Weaviate UI here:

    URL: https://[CI_CD_DOMAIN]
    login: root
    password: [APP_PASSWORD]

# How to connect to your instance with Node.js

First you need to install the package

    npm install weaviate-client

Then, you can connect to your instance with the following:

    const weaviate = require("weaviate-client");

    var username = "root";
    var password = "[APP_PASSWORD]";
    var auth = "Basic " + Buffer.from(username + ":" + password).toString("base64");

    const client = weaviate.client({
        scheme: "https",
        host: "[CI_CD_DOMAIN]",
        headers: { Authorization: auth },
    });

# Documentation

    https://weaviate.io/developers/weaviate/quickstart/installation
