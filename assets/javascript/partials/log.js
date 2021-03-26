if (isPageLog()) {
  window.addEventListener('hashchange', function() {
    openParentLogElements(window.location.hash)
  }, false);

  document.addEventListener("DOMContentLoaded", function() {
    if (window.location.hash) {
      openParentLogElements(window.location.hash)
    }

    // Don't trigger collapse if an element has the .no-trigger-collapse class
    var blockedTriggers = document.querySelectorAll('#c-log-wrapper .no-trigger-collapse');
    blockedTriggers.forEach(function(trigger) {
      trigger.addEventListener('click', function(event) {
        event.stopPropagation();
      }, false);
    });

    // Toggle all children
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
  }, false);
}

function openParentLogElements(id, highlight=true) {
  var idArray = id.replace('#','').split("-");
  var topParent = null;

  while (idArray.length) {
    var container = document.getElementById(idArray.join('-'));
    var trigger = container.querySelector('.c-log-header');
    var collapse = new BSN.Collapse(trigger)
    collapse.show();
    if ( topParent == null ) topParent = container;
    idArray.pop();
  }
  var highlighted = document.querySelectorAll('#c-log-wrapper .c-log-anchored');
  highlighted.forEach(function(element) {
    element.classList.remove("c-log-anchored");
  });
  if ( highlight ) topParent.classList.add("c-log-anchored");
}

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
