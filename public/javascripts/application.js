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

function sync_group_users(item) { 
  if (typeof(item) == "string") {         
    var item = eval("item=" + item);  
  }
  if (typeof(item) != "object") {
    return true;
  }       
  type = item._value.split(":")[0];
  id = item._value.split(":")[1];     
  if (type == "user") {
    $("#expense_user_ids option[value="+id+"]").attr("selected","selected");
  } 
  if (type == "expensegroup") {
    $("#expense_expensegroup_ids option[value="+id+"]").attr("selected","selected");  
    $("li[rel="+item._value+"]").addClass('group-box');
    push_group_users(id, "#dummy_user_group");
  }
} 

function deselect_removed(item){
  if (typeof(item) == "string") {         
    var item = eval("item=" + item);  
  }
  if (type == "user") {
    $("#expense_user_ids option[value="+id+"]").attr("selected","");
  } 
  if (type == "expensegroup") {
    $("#expense_expensegroup_ids option[value="+id+"]").attr("selected","");  
  }
}

$(document).ready(function(){
	$("#column-right ul li a").button({ icons: {primary:'ui-icon-folder-collapsed'} });
	$("#column-right ul li.users_link a").button({ icons: {primary:'ui-icon-person'} });
	$("input[type=submit]").button({ icons: {primary:'ui-icon-folder-collapsed'} });
	$("ul.expense-year-list li a").button({ icons: {primary:'ui-icon-calculator'} });
	$("ul.expense-year-list li a").button({ icons: {primary:'ui-icon-calculator'} });

	$(".jquery-date-picker").each(function(){
	    $(this).datepicker({ dateFormat: 'yy-mm-dd',constrainInput: false, firstDay:1 });
	});
	$(".skip-import-submit").click(function(){
	    $(this).parent('form').remove();
	    return false;
	});
});