// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var textExtractionFunction = function(node){ 
    if(node.id !=""){
        return node.id;
    } else { 
        return node.innerHTML;
    }
}

function tableSort(){
    var sorting = [[0,1]];
    $("#expense_list_table").tablesorter({
        headers: { 6: {sorter: false},
                   7: {sorter: false},
                   8: {sorter: false}
                 },
        textExtraction:textExtractionFunction
    });
    $("#expense_list_table").trigger("sorton",[sorting]);
}