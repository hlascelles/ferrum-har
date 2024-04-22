const createHarResponse = function() {
  // Ask the network panel for the HAR data. Note, we must wrap this in a "log" key to make it
  // a valid HAR.
  chrome.devtools.network.getHAR(
    function(harLog) {
      // Pass the HAR back to the inspected window. We need to base64 encode it to avoid any quoting
      // and parsing issues.
      const base64EncodedHar = btoa('{"log":' + JSON.stringify(harLog) + '}');
      const comms = 'document.ferrumHar = "' + base64EncodedHar + '";';
      chrome.devtools.inspectedWindow.eval(comms);
    });
};

/**
 * If the HAR is requested, create it and send it back to the inspected window.
 */
const checkForHarInstruction = function() {
  chrome.devtools.inspectedWindow.eval(
    "document.ferrumHarRequested === true;",
    function() {
      // Prepare to receive another request.
      chrome.devtools.inspectedWindow.eval("document.ferrumHarRequested = null;");
      createHarResponse();
    }
  );
};

/**
 * Start a continuous loop to check for the "create HAR" instruction from Ferrum. This is passed in
 * by setting a JS variable in the inspected window. When this is detected, the HAR is created.
 */
const loop_speed = 100;
const loop = function() {
  checkForHarInstruction();
  setTimeout(loop, loop_speed);
};
setTimeout(loop, loop_speed);

// Add the new chrome devtools panel. We need to do this or the extension cannot access the HAR.
// null is the image path (not needed).
chrome.devtools.panels.create("ferrum-har", null, "panel.html");
