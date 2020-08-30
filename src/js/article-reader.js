class ArticleReader extends HTMLElement {
  constructor() {
    super();
    const shadow = this.attachShadow({ mode: "closed" });
    this.$article = document.createElement("article");
    shadow.appendChild(this.$article);
  }

  static get observedAttributes() {
    return ["value"];
  }

  attributeChangedCallback() {
    this._render();
  }

  connectedCallback() {
    this._render();
  }

  _render() {
    this.$article.innerHTML = this.getAttribute("value");
  }
}

customElements.define("article-reader", ArticleReader);
