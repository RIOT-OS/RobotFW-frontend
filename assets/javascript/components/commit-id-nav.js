document.addEventListener("DOMContentLoaded", function() {
  const closeTriggers = document.querySelectorAll(".c-commit-id-nav .c-copy-to-clipboard");
  closeTriggers.forEach(
    function(trigger) {
      trigger.addEventListener("click", copyToClipboard);
    }
  );
});

function copyToClipboard(event) {
  var container = event.target.closest(".c-commit-id-nav").querySelector(".c-copy-content .c-copy-content-inner");

  if (container.classList.contains("c-copy-inner-value")) {
    var textToCopy = container.innerHTML;
  }
  else if (container.querySelector(".c-copy-inner-value")) {
    var textToCopy = container.querySelector(".c-copy-inner-value").innerHTML;
  }
  if (navigator.clipboard && textToCopy != null) {
    navigator.clipboard.writeText(textToCopy).then(
      function(){
        updateTooltip("Copied " + textToCopy)
      })
    .catch(
      function() {
        updateTooltip("Ooops, an error occured!")
    });
  }
}

function updateTooltip(content) {
  var tooltipInner = document.querySelector("body .tooltip .tooltip-inner");
  tooltipInner.textContent = content;
}