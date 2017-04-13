// js script for sorting the stats table.

/*Setting global variable used to toggle sorting 
on columns between ascending/descending order*/
var pcolumn;
var toggleOn;

function tableSort(column) {
  var table, rows, switching, i, x, y, shouldSwitch;
  
  table = document.getElementById("tablesort");
  
  
  switching = true;
  while (switching) {
    /*exit the while loop if later 
    logic doesn't set it to continue*/
    switching = false;
    

    rows = table.getElementsByTagName("TR");
    /*Loop through each row for sorting (except 
    for the footer and header rows)*/
    for (i = 1; i < (rows.length - 2); i++) {
      //Don't switch rows unless later logic sets it
      shouldSwitch = false;
      /*Get the two elements you want to compare,
      one from current row and one from the next*/
      x = rows[i].getElementsByTagName("TD")[column];
      if (x == null){
        x = document.createTextNode("0");
      }
      y = rows[i + 1].getElementsByTagName("TD")[column];
      if (y == null){
        y = document.createTextNode("0");
      }
      // If column content starts with digits sort numerically
			if (/^\d/.test(parseFloat(x.textContent))){
        //check if the two rows should switch places
      	if (parseFloat(x.textContent) > parseFloat(y.textContent)) {
					//if so, mark to switch and break the for loop
      		shouldSwitch = true;
					break;
        }
			// otherwise sort alphabetically	
      } else {
      	//check if the two rows should switch places
      	if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
        	//if so, mark to switch and break the for loop
        	shouldSwitch= true;
					break;
      	}
			}
    }
    if (shouldSwitch) {
      //make the switch and mark the while loop for another go
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      switching = true;
    }
  }
  /* if the same column was clicked twice use toggling
  to go back and forth between ascending and descending
  order instead of sorting over and over */
  if (pcolumn == column){
    if (!toggleOn) {
		  // Set the pcolumn cookie
   	  document.cookie = "pcolumn=" + pcolumn;
   	  // reverse the order of the sorting
   	  listrows = table.getElementsByTagName("TR");
		  pnode = listrows[1].parentNode;
			rows = $.makeArray(listrows).reverse();
   		for (i = 1; i < (listrows.length - 1); i++) {
  			pnode.removeChild(listrows[i]);
   		}
   		for (i = 1; i < (rows.length - 1); i++) {
   	  	pnode.appendChild(rows[i]);
   		}
		}
	}
}

function readCookie(name){
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for(var i=0;i < ca.length;i++) {
    var c = ca[i];
    while (c.charAt(0)==' ') c = c.substring(1,c.length);
    if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
  }
  return null;
}

document.addEventListener("page:change", function(){
	if($('#index').length){
  	// Use cookies to initially sort table
  	var columnCookie = readCookie("column");
  	var pcolumnCookie = readCookie("pcolumn");
  	pcolumn = pcolumnCookie;
  	// change the cookie string back into a boolean
		var toggleCookie = readCookie("toggleOn");
  	if (toggleCookie == "false"){ 
    	toggleOn = false;
  	} else {
    	toggleOn = true;
		}
  	tableSort(columnCookie);

  	$(".thsortable").click( function(){
    	column = $(this).index();
			// set cookie for column
			document.cookie = "column=" + column;
			// toggle sorting on click
    	toggleOn = !toggleOn;
			// set toggle cookie
	  	document.cookie = "toggleOn=" + toggleOn;
    	tableSort(column);
			// After sorting set previous column
    	pcolumn = column;
  	});
	}
});

