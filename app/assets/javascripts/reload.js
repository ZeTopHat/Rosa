// Function to be used for timed refreshes on the index page
function timedRefresh(timeoutPeriod) {
  setTimeout('location.reload(true);',timeoutPeriod);
}
// Jquery to impliment refresh on initial load of page. Has the qualification of being the index page
$(document).ready(function(){
    if($('#index').length){
        timedRefresh(12000);
    }
});
// Jquery to impliment refresh on page changes to the index page. This is necessary because of the way turbolinks works
document.addEventListener("page:change", function() {
    if($('#index').length){
        timedRefresh(12000);
    }
})

