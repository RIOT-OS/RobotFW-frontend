document.addEventListener("DOMContentLoaded", function() {

  /*
   * Navbar
   */
  if (document.getElementById('navbar-dropdown-boards') != null) {
    var navDropdownBoardsInit = new BSN.Dropdown('#navbar-dropdown-boards');
  }
  if (document.getElementById('navbar-dropdown-boards') != null) {
    var navDropdownApplicationsInit = new BSN.Dropdown('#navbar-dropdown-applications');
  }
});
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
document.addEventListener('readystatechange', event => {
  if (event.target.readyState === "complete") {
    element = document.getElementById('page-overlay');
    if (element && element.classList.contains('remove-when-loaded')) {
      element.remove();
    }
  }
});
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

document.addEventListener("DOMContentLoaded", function() {
  if (isPageOverview()) {

    var collapseTriggers = document.querySelectorAll('#content.c-page-overview a[data-toggle="details-sidebar"]');
    var collapseSidebar = document.getElementById('content-sidebar');

    collapseTriggers.forEach(function (item) {
      var board = item.dataset.board;
      var suite = item.dataset.suite;
      var sidebarTitle = board + '/' + suite;
      var sidebarContentID = 'sidebar-panel-' + board + '-' + suite;

      item.addEventListener('click', function(event) {
        if (item.classList.contains('active')) {
          clearTriggers(collapseTriggers);
          closeCollapsible(collapseSidebar);
        }
        else {
          clearTriggers(collapseTriggers);
          openCollapsible(collapseSidebar);

          // Set sidebar title
          collapseSidebar.querySelector('#content-sidebar-title').innerHTML = sidebarTitle;

          // Add classes to selected trigger
          setCellStatus(item, true);

          // Content panel
          var sidebarPanels = collapseSidebar.querySelectorAll('div.c-sidebar-panel.show');
          if (sidebarPanels != null) {
            sidebarPanels.forEach(function (item) {
              item.classList.remove('show');
            });
          }
          var sidebarContent = document.getElementById(sidebarContentID);
          sidebarContent.classList.add('show');
        }
      })
    });

    collapseSidebar.addEventListener('hide.bs.collapse', function(event){
      clearTriggers(collapseTriggers);
    }, false);
  }
});

function clearTriggers(collapseTriggers) {
  collapseTriggers.forEach(function (item) {
    setCellStatus(item, false);
  });
}

function setCellStatus(item, status) {
  var cell = item.closest('.c-cell');

  if ((item !== null) && (cell !== null)) {
    if (status) {
      item.classList.add('active');
      cell.classList.add('selected');
    }
    else {
      item.classList.remove('active');
      cell.classList.remove('selected');
    }
    showActiveIcon(item, status);
  }
}

function showActiveIcon(parent, status) {
  var icon_close = parent.querySelector('.c-icon-close');
  var icon_open = parent.querySelector('.c-icon-open');

  if ((icon_close !== null) && (icon_open !== null)) {
    if (status) {
      icon_close.classList.remove('hidden');
      icon_open.classList.add('hidden');
    }
    else {
      icon_close.classList.add('hidden');
      icon_open.classList.remove('hidden');
    }
  }
}

function openCollapsible(element) {
  element.classList.add('show');
  element.setAttribute("aria-expanded", 'true');
}

function closeCollapsible(element) {
  element.classList.remove('show');
  element.setAttribute("aria-expanded", 'false');
}

function isPageOverview() {
  return document.getElementById('content').classList.contains('c-page-overview');
}
