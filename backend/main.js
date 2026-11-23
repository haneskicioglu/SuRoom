const path = require('path');
const http = require('http');
const fs = require('fs');
const fetch = require('node-fetch');
const config = JSON.parse(fs.readFileSync("./config.json", "utf-8"));
const crypto = require('crypto');
const uploadEndpoints = [];

const server = http.createServer(async function (req, res) {
    const directory = req.url.substring(1).split("/");
    let query = directory.pop().split("?");
    directory.push(query.shift());
    if (query.length) query = query[0];
    if (query.includes("&")) {
        query = query.split("&").reduce((acc, curr) => {
            const [key, value] = curr.split("=");
            acc[key] = value;
            return acc;
        }, {});
    }
    else {
        query = query.length > 0 ? { [query.split("=")[0]]: query.split("=")[1] } : {};
    }
    const isUpload = uploadEndpoints[directory.join("/")] && uploadEndpoints[directory.join("/")].includes(req.method);
    if (!isUpload) {
        const sizeHeader = req.headers["content-length"];
        if (sizeHeader && sizeHeader > 1 * 1024 * 1024) {
            res.writeHead(413, { "Content-Type": "application/json" });
            res.end(JSON.stringify({ e: "Request body is too large. Please shorten the JSON or text payload for this request." }));
            return;
        }
    }
    const body = isUpload ? { exists: true, json: false, data: null, err: null, upload: true, raw: req } : await new Promise((resolve, reject) => {
        let t = 0;
        let b = "";
        req.on("data", function (c) {
            b += c;
        });
        req.on("end", function () {
            if (b == "") {
                t = 0;
                b = null;
            }
            else {
                try {
                    b = JSON.parse(b);
                    t = 2;
                } catch (error) {
                    t = 1;
                }
            }
            resolve({ exists: t !== 0, json: t === 2, data: b, err: null });
        });
        req.on("error", function (err) {
            reject(err);
        });
    }).catch(err => ({ exists: false, json: false, data: null, err: err }));
    function returnResponse(statusCode = 200, headers = {}, data) {
        headers["Content-Type"] = "application/json";
        res.writeHead(statusCode, headers);
        res.end(JSON.stringify(data));
    }
    if (directory[0] === "login") {
        returnResponse(200, {}, { e: "Login endpoint" });
    }
    else {
        returnResponse(404, {}, { e: "Endpoint not found" });
    }
})
function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
server.listen(config.port, function (error) {
    if (error) {
        console.log("SUROOM-BACKEND > Something went wrong", error);
    }
    else {
        console.log("SUROOM-BACKEND > Listening on " + config.port);
    }
})