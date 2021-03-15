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
