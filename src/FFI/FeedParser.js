const TauriHttp = require("tauri/api/http").default;
const { Parser } = require("pulse-feed-parser");

exports.parse_ = xml =>
  async function() {
    const doc = new DOMParser().parseFromString(xml, "text/xml");
    const feed = await new Parser().parseDocument(doc);
    console.log(feed);
    return feed;
  };

exports.fetch_ = url =>
  async function() {
    const xml = await TauriHttp.get(url, {
      responseType: TauriHttp.ResponseType.Text
    });
    const doc = new DOMParser().parseFromString(xml, "text/xml");
    const feed = await new Parser().parseDocument(doc);
    console.log(feed);
    return feed;
  };
