$(document).ready(function() {


/*==================================
Feature : Upload feedback linkon nva.
Page : http://localhost
Element : Button upload   click.
====================================*/
    function uploadSearchKeywords(){

        var bar = $('.bar');
        var percent = $('.percent');
        var status = $('#status');
        var progress = $('.progress');
        var uploadText = $('.upload_text');
        var uploadArea = $('#upload_area');
        var parsingArea = $('#parsing_area');
           
        $('#upload_form').ajaxForm({
            beforeSubmit: function(arr, $form, options) { 
                data = arr[0];
                if(data){
                    if (data.value.type != "text/csv"){
                        alert("Invalid file type. Only CSV allowed.")
                        return false 
                    }
                }
                             
            },
            beforeSend: function() {
                uploadArea.slideDown();
                status.empty();
                var percentVal = '0%';
                bar.width(percentVal)
                percent.html(percentVal);
            },
            uploadProgress: function(event, position, total, percentComplete) {
                progress.slideDown();
                var percentVal = percentComplete + '%';
                bar.width(percentVal)
                percent.html(percentVal);
                //console.log(percentVal, position, total);
            },
            success: function() {
                var percentVal = '100%';
                bar.width(percentVal)
                percent.html(percentVal);
            },
            complete: function(xhr) {
                $.notify(xhr.responseText, "success");
                $("#loader_icon").show();
                $("#uploadModal").modal("hide");
            }
        });        
    }


/*==================================
Feature : Realtime feedback on parsing.
Page : http://localhost
Element : Progres bar with parsing info.
====================================*/
    function realtimeParsingUpdate(){

        // Enable pusher logging - don't include this in production
        Pusher.log = function(message) {
          if (window.console && window.console.log) {
            window.console.log(message);
          }
        };

        var pusher = new Pusher('295955d8e06f90740986');
        var channel = pusher.subscribe('parsing_log');
        channel.bind('parse_operations', function(data) {
          id = data.id
          $("#success_rows" + id).text(data.success_rows);
          $("#failed_rows" + id).text(data.failed_rows);
          $("#total_rows" + id).text(data.total_rows);
          $("#status" + id).text(data.status);
        });       
    }

/*==================================
Feature : Reload data.
Page : http://localhost
Element : on demand ajax.
====================================*/
    function reloadData(){
            $.ajax({
                url: "/google_search_keywords/report",
                method: 'GET',
                success: function(response) {
                  $("#report_section").html(response);
                  deleteallResults();
                },
                error: function(response) {
                    console.log(response);
                }
            }); 

    }

/*==================================
Feature : Realtime feedback on browsing.
Page : http://localhost
Element : Browsing update.
====================================*/
    function realtimeBrowsing(){

        // Enable pusher logging - don't include this in production
        Pusher.log = function(message) {
          if (window.console && window.console.log) {
            window.console.log(message);
          }
        };

        var pusher = new Pusher('295955d8e06f90740986');
        var channel = pusher.subscribe('upload');
        channel.bind('browsing', function(data) {
            $("#loader_icon").hide();
            $.notify(data.info, "success");
            reloadData();
        });       
    }


/*==================================
Feature : Dleeting all reports.
Page : http://localhost
Element : Dlete button.
====================================*/
    function deleteallResults(){

        $("#delete_results").on('click', function(){
            url = $(this).attr('href');
            that = this;
            $(this).text('Deleting...');

            $.ajax({
                url: url,
                method: 'GET',
                success: function(response) {
                  $("#report_section").html(response)
                  $.notify('Successfully deleted all keywords', "success");
                },
                error: function(response) {
                    $(that).text('Delete All Results');
                    console.log(response);
                }
            }); 

            return false           
        })
             
    }

/*==================================
Feature : Query 1
Page : http://localhost
Element : Query 1
====================================*/
    function queryOne(){
        $("#query1_execute").on('click', function(){
            if($("#query1_text").val() == ""){
                alert("Please enter a value for query");
                $("#query1_text").focus();
                return false
            }

            $.ajax({
                url: "/google_search_keywords/queries",
                method: 'GET',
                data: {type: 1, input: $("#query1_text").val()},
                success: function(response) {
                  $("#query1_result").html(response.data)
                },
                error: function(response) {
                    console.log(response);
                }
            });

            return false            
        })
    }

/*==================================
Feature : Query 1
Page : http://localhost
Element : Query 1
====================================*/
    function queryTwo(){
        $("#query2_execute").on('click', function(){
            if($("#query2_text").val() == ""){
                alert("Please enter a value for query");
                $("#query2_text").focus();
                return false
            }

            $.ajax({
                url: "/google_search_keywords/queries",
                method: 'GET',
                data: {type: 2, input: $("#query2_text").val()},
                success: function(response) {
                  $("#query2_result").html(response.data)
                },
                error: function(response) {
                    console.log(response);
                }
            });

            return false            
        })
    }

/*==================================
Feature : Initializing all Javascript under this controller.
Page : http://localhost
Element : Program start here.
====================================*/

    uploadSearchKeywords();
    realtimeParsingUpdate();
    deleteallResults();
    realtimeBrowsing();
    queryOne();
    queryTwo();

});