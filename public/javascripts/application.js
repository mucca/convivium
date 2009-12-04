// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function tableSort(){
var sorting = [[0,0]];
$("#expense_list_table").tablesorter({headers: { 6: {sorter: false},7: {sorter: false},8: {sorter: false}},textExtraction: function(node) { if(node.id !=""){ return node.id;} else {return node.innerHTML;}}});
$("#expense_list_table").trigger("sorton",[sorting]);
}