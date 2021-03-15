document.addEventListener("DOMContentLoaded", function() {
  const closeTriggers = document.querySelectorAll(".c-label-close");
  closeTriggers.forEach(
    function(trigger) {
      trigger.addEventListener("click", closeLabel);
    }
  );
});

function closeLabel(event) {
  var closeable = event.target.closest(".c-label");
  if (closeable.parentElement.classList.contains('c-label-wrapper')) {
    closeable = closeable.parentElement;
  }
  closeable.classList.add("c-label-closing");
  setTimeout(function() {
    closeable.remove();
  }, 700);
}