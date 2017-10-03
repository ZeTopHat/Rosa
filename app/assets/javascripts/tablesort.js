// js script for sorting the stats table.

/*Setting global variable used to toggle sorting 
on columns between ascending/descending order*/
let pcolumn;
let toggleOn;

function compare(a, b) {
    if (a.text < b.text)  return -1;
    if (a.text > b.text) {
        a.node.parentNode.insertBefore(b.node, a.node);
        return 1;
    }
    return 0;
}


function parseBool(stringVal) {
    return !(stringVal === false || stringVal === "false")
}

function tableSort(column) {
    const rows = Array.from($("#tablesort").rows);
    const shortenedRows = rows.slice(1, rows.length - 1);

    shortenedRows.map((row) => {
        return {
         "node": row.cells[column],
         "text": row.cells[column].textContent
        }   
    }).sort(compare)

	/* if the same column was clicked twice use toggling
	to go back and forth between ascending and descending
	order instead of sorting over and over */
	if (pcolumn == column && !toggleOn){
		// Set the pcolumn cookie
 		document.cookie = `pcolumn=${pcolumn}`;
        $("#tablesort")
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

function readCookie(name){;
	const cookieArray = document.cookie.split(';');
    
    return cookieArray.reduce((retVal, cookie) => {
        if (cookie.trim().startsWith(name)) retVal = cookie.trim().split("=")[1];
        return retVal;
    }, null);    
}

document.addEventListener("page:change", function(){
	if ($('#index')) {
		// Use cookies to initially sort table
		pcolumn = readCookie("pcolumn");

		// change the cookie string back into a boolean
        toggleOn = parseBool(readCookie("toggleOn"));
		tableSort(readCookie("column"));

 		$(".thsortable").click( function(){
			column = $(this).index();
			// set cookie for column
			document.cookie = `column=${column}`;
			// toggle sorting on click
			toggleOn = !toggleOn;
			// set toggle cookie
			document.cookie = `toggleOn=${toggleOn}`;
			tableSort(column);
			// After sorting set previous column
			pcolumn = column;
		});
	}
});

