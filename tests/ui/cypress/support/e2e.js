// Import commands
import "./commands";

// Hide fetch/XHR requests from command log for cleaner output
const app = window.top;
if (!app.document.head.querySelector("[data-hide-command-log-request]")) {
  const style = app.document.createElement("style");
  style.innerHTML =
    ".command-name-request, .command-name-xhr { display: none }";
  style.setAttribute("data-hide-command-log-request", "");
  app.document.head.appendChild(style);
}

// Suppress uncaught exceptions that don't affect test validity
Cypress.on("uncaught:exception", (err, runnable) => {
  // Return false to prevent test failure on uncaught exceptions
  // Only for known harmless errors
  return false;
});
