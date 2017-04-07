var timeout
// Function to be used for timed refreshes on the index page
function timedRefresh(timeoutPeriod) {
  timeout = setTimeout('location.reload(true);',timeoutPeriod);
}

// Function to be used for cancelling timed refreshes when leaving the index page
function stopRefresh() {
  clearTimeout(timeout)
  timeout = null;
}

// Jquery to impliment refresh on page changes to the index page. This is necessary because of the way turbolinks works
document.addEventListener("page:change", function() {
    if($('#index').length){
        timedRefresh(12000);
    } else{
        stopRefresh();
    }
});

