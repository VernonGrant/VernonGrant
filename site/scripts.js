function createButton(title, link, target = "_blank") {
    const button = document.createElement("a");
    button.innerText = title;
    button.href = link;
    button.classList.add("btn");
    button.setAttribute("target", target);
    return button;
}

window.onload = function () {
    // Create and add header buttons.
    const headerButtons = document.createElement("div");
    headerButtons.classList.add("header-buttons");
    headerButtons.appendChild(createButton("GitHub", "#"));
    headerButtons.appendChild(createButton("Support", "#"));

    // Create and add home button.
    const homeButton = createButton(
        "Home",
        "https://vernongrant.github.io/Vernon Grant/",
        "_self"
    );
    homeButton.classList.add("btn-home");

    // Append header buttons.
    headerButtons.appendChild(homeButton);
    document.body.appendChild(headerButtons);
};
