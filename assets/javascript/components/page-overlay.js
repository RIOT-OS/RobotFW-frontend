document.addEventListener('readystatechange', event => {
  if (event.target.readyState === "complete") {
    element = document.getElementById('page-overlay');
    if (element && element.classList.contains('remove-when-loaded')) {
      element.remove();
    }
  }
});