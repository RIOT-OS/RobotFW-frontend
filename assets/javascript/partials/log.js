document.addEventListener("DOMContentLoaded", function() {
  if (isPageLog()) {

    // Open collapsed elements if anchor link used
    if (window.location.hash) {
      var anchor = window.location.hash;
      var idArray = anchor.replace('#','').split("-");
      var firstElement = null;
      while (idArray.length) {
        var container = document.getElementById(idArray.join('-'));
        var trigger = container.querySelector('.c-log-header');
        var collapse = new BSN.Collapse(trigger)
        collapse.show();
        if ( firstElement == null ) firstElement = container;
        idArray.pop();
      }
      firstElement.classList.add("c-log-anchored");
      location.hash = anchor;
    }

    // Don't trigger collapse if an element has the .no-trigger-collapse class
    var blockedTriggers = document.querySelectorAll('#c-log-wrapper .no-trigger-collapse');
    blockedTriggers.forEach(function(trigger) {
      trigger.addEventListener('click', function(event) {
        event.stopPropagation();
      }, false);
    });

    // Open / Collapse all children
    var collapsibleTriggers = document.querySelectorAll('#c-log-wrapper .c-log-toggle-children');
    collapsibleTriggers.forEach(function(trigger) {
      trigger.addEventListener('click', function(event) {
        if (trigger.classList.contains('c-log-open-children')) {
          expandChildrenRecursively(trigger.closest('.c-log'));
        }
        else if (trigger.classList.contains('c-log-close-children')) {
          closeChildren(trigger.closest('.c-log'));
        }
      });
    });
  }
});

function expandChildrenRecursively(element) {
  element.querySelector('.c-log-header').classList.remove('collapsed');
  element.querySelector('.c-log-body').classList.add('show');
  var children = element.querySelectorAll(':scope > .c-log-body > .c-log');
  children.forEach(function(child) {
    expandChildrenRecursively(child)
  });
}

function closeChildren(element) {
  var childrenHeader = element.querySelectorAll('.c-log-header');
  childrenHeader.forEach(function(collapsible) {
    collapsible.classList.add('collapsed');
  });
  var childrenBody = element.querySelectorAll('.c-log-body');
  childrenBody.forEach(function(collapsible) {
    collapsible.classList.remove('show');
  });
}

function isPageLog() {
  return document.getElementById('content').classList.contains('c-page-log');
}