// Function to allow for collapsible content
function collapsible(idHash) {
    $.each(idHash, function(key, value) {
        let elements = $(`#${key}`).next().children();

        // Use 'map' to iterate over elements instead of for-loop and use ternaries to assign conditional values
        elements.map(function(element) {
            value ? element.style.display = '' : element.style.display = 'none'
        });

        value ? $(`#${key}`).find('sup').replaceWith('') : $(`#${key}`).append($('<sup class="supersup">collapses</sup>'));
    });
}

// Parses some value; if its "false" (string) or false (boolean) returns false
function parseBool(stringVal) {
    return !(stringVal === false || stringVal === "false")
}

// Jquery to impliment collapse on proper click and with cookie
document.addEventListener("page:change", function() {
    if($('#collapsible').length){
        let idHash = {};
        let ids = [];
        let id;

        $(".collapsible").each(function() {
            id = $(this).attr('id');
            ids.push(id);
        });

        ids.map(function(singleId) {
            let collapsibleIdCookie;
            let expansion = parseBool(readCookie(`expansion${singleId}`));
            if (collapsibleIdCookie = readCookie(`collapsibleId${singleId}`))  idHash[collapsibleIdCookie] = expansion; 
        });
        
        if (idHash) collapsible(idHash);

        $(".collapsible").click( function(){
            idHash = {};
            ids = [];
            id = $(this).attr('id');
            ids.push(id);

            // setting cookies and toggling expansion
            document.cookie = `collapsibleId${id}=${id};`;
            expansion != parseBool(readCookie(`expansion${id}`));

            document.cookie = `expansion${id}=${expansion};`;
            idHash[id] = expansion;
            collapsible(idHash);
        });
    }
});

