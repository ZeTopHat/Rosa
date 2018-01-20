// js script for sorting the stats table.

/*Setting global variable used to toggle sorting 
on columns between ascending/descending order*/
let pcolumn;
let toggleOn;

// Shimming some es6 functions
String.prototype.contains = String.prototype.contains || function(str) {
    return this.indexOf(str) >= 0;
}

String.prototype.startsWith = String.prototype.startsWith || function(prefix) {
    return this.indexOf(prefix) === 0;
}

String.prototype.endsWith = String.prototype.endsWith || function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) >= 0;
}

function parseBool(stringVal) {
    return !(stringVal === false || stringVal === "false");
}

function tableSort(column) {
    const rows = Array.from($("#tablesort").rows);
    const shortenedRows = rows.slice(1, rows.length - 2);
    
    const sortedText = shortenedRows.map(function(row) {
         return row.cells[column].textContent;
    }).sort();
    
    shortenedRows.map(function(row, index) {
        row.cells[column].textContent = sortedText[index];
    });

	/* if the same column was clicked twice use toggling
	to go back and forth between ascending and descending
	order instead of sorting over and over */
	if ((pcolumn == column) && !toggleOn) {
 		document.cookie = `pcolumn=${pcolumn}`;

        shortenedRows.map(function(row, index) {
            row.cells[column].textContent = sortedText.reverse()[index];
        });
	}
}

function readCookie(name) {
	const cookieArray = document.cookie.split(';');
    
    return cookieArray.reduce(function(retVal, cookie) {
        if (cookie.trim().startsWith(name)) retVal = cookie.trim().split("=")[1];
        return retVal;
    }, null);    
}

document.addEventListener("page:change", function() {
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

