"use strict";

(function (){

	function getAppointments(){
		$("#search").click(function(){
			var search_content = $("#textString").val();
				$.ajax({
						url:'perl/retriveData.pl',
						type: "post",
						dataType: 'json',
						data: {search_content:search_content},
						
						success: function(result){
								$("#body").empty();
								var append_data = '';
								var response = $.parseJSON(JSON.stringify(result));
								$(function(){
									$.each(response,function(i, item){
										//console.log(item);
										var arr=[];
										arr=item.split(" ");
										append_data = append_data+'<tr><td>'+arr[0]+'</td><td>'+arr[1]+'</td><td>'+arr[2]+'</td></tr>';
									});
									$("#displayTable").show();
									$(append_data).appendTo('#body'); 
								});
          				},
						error:function(){
					
						} 
				});               
		});
	}


	$(document).ready(function(){

		//retrives search data
		getAppointments();

         //shows hidden appointment form
		$("#newButton").click (function (){
			$("#newButton").hide();
			$("#formDiv").show();
			$("#displayTable").hide();
			$("#textString").val('');
		});

	     //hides appointment form
		$("#cancel").click (function(){
		 	$("#formDiv").hide();
		 	$("#appointmentForm").trigger("reset");
		 	$("#errorMessages").hide();
		  	$("#newButton").show();
		  });


         // performs form validation and submits data to backend
		$("#appointmentForm").validate({
			rules : {
				date : {
					required: true
				},

				time : {
					required: true
					
				},

				descField : {
					required: true
				}
			}, 

			messages : {
				date : {
					required : "Date is required",
				},

				time : {
					required : "Time is required"
					//time : "Enter hr:mm:ss"
				},

				descField : {
					required: "Appointment description is required"
				}
			},
			errorElement : 'div',
			errorLabelContainer: '#errorMessages',

			submitHandler: function(form){
				$.ajax({
					url: 'perl/insertData.pl',
					type: "POST",
					data: $(form).serialize(),
					success: function (result){
						$("#formSubmitMessage").show();
						$("#formSubmitMessage").fadeOut (5000);
						$("#formDiv").hide();
						$("#appointmentForm").trigger("reset");
						$("#displayTable").hide();
						$("#textString").val('');
						$("#newButton").show();
					},
					error: function(){
						console.log("Form submission error");
					}
				});
			}
		});

		//datepicker validation
		var currentDate = new Date().toISOString().slice(0,10);
		$("#date").attr("min", currentDate);	
	});

})();

