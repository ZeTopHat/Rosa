// Function to allow for collapsible content
function collapsible(idHash) {
	$.each(idHash, function(key, value) {
		var elements = $(document.getElementById(key)).next().children();
		for (var i = 0; i < elements.length; i++) {
			var child = elements[i];
			if(value){
				child.style.display = 'inherit';
			} else {
				child.style.display = 'none';
			}
		}
		if (!value){
			$(document.getElementById(key)).append($('<sup class="supersup">collapsed</sup>'));
		} else {
			$(document.getElementById(key)).find('sup').replaceWith('');
		}
	});
}

// Jquery to impliment collapse on proper click and with cookie
document.addEventListener("page:change", function() {
	if($('#collapsible').length){
		idHash = {};
		ids = [];
		$(".collapsible").each(function() {
			id = $(this).attr('id');
			ids.push(id);
		});
		for (var i = 0; i < ids.length; i++) {
			var collapsibleIdCookie = readCookie("collapsibleId" + ids[i]);
			var expansionCookie = readCookie("expansion" + ids[i]);
			// convert cookie text back to boolean
			if (expansionCookie == "false"){
				expansion = false;
			} else {
				expansion = true;
			}
			if (collapsibleIdCookie){
				idHash[collapsibleIdCookie] = expansion;
			}
		}
		// make sure cookie exists then run through function with cookies
		if (idHash){
			collapsible(idHash);
		}

		$(".collapsible").click( function(){
			idHash = {};
			ids = [];
			id = $(this).attr('id');
			ids.push(id);
			// setting cookies and toggling expansion
			document.cookie = "collapsibleId" + id + "=" + id + ";";
			var expansionCookie = readCookie("expansion" + id);
			if (expansionCookie == "false"){
				expansion = false;
			} else {
				expansion = true;
			}
				expansion = !expansion;
				document.cookie = "expansion" + id + "=" + expansion + ";";
				idHash[id] = expansion;
				collapsible(idHash);
		});
	}
});

