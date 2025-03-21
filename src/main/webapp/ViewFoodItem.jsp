
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="JDBC.*" import="java.util.*" import="java.sql.*" import="java.io.*"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=request.getParameter("food_item") %></title>
</head>
<style>

/*this sets design attributes to the header*/
.header {
	padding: 30px;
	text-align: center;
	background: #D2042D;
	color: white;
	font-size: 20px;
	font-family: Times New Roman;
}

/*this sets design attributes to the table*/
.table {
	padding: 30px;
	background: #bfbfbf;
	table-layout: fixed;
}

/*this sets design attributes for the buttons*/
.button {
	transition-duration: 0.4s;
	padding: 40px 30px;
}

/*changes button to red while mouse hovers over button*/
.button:hover {
	background-color: #D2042D;
	color: white;
}

/*this sets design attributes to the logo*/
.logo {
	display: block;
	margin-left: auto;
	margin-right: auto;
	width: 50%;
}

/*this sets design attributes to the footer*/
.aboutThisSite {
	position: fixed;
	bottom: 0;
	padding: 10px;
}

/* Full-width input fields */
input[type=text], input[type=password] {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  display: inline-block;
  border: 1px solid #ccc;
  box-sizing: border-box;
}

/* Set a style for all buttons */
button {
  background-color: Black;
  color: white;
  padding: 14px 20px;
  margin: 8px 0;
  border: none;
  cursor: pointer;
  width: 100%;
}

button:hover {
  opacity: 0.8;
}

/* Extra styles for the cancel button */
.cancelbtn {
  width: auto;
  padding: 10px 18px;
  background-color: #f44336;
}

/* Center the image and position the close button */
.imgcontainer {
  text-align: center;
  margin: 24px 0 12px 0;
  position: relative;
}

img.avatar {
  width: 40%;
  border-radius: 50%;
}

.container {
  padding: 16px;
}

span.psw {
  float: right;
  padding-top: 16px;
}

/* The Modal (background) */
.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0,0,0); /* Fallback color */
  background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
  padding-top: 60px;
}

/* Modal Content/Box */
.modal-content {
  background-color: #fefefe;
  margin: 5% auto 15% auto; /* 5% from the top, 15% from the bottom and centered */
  border: 1px solid #888;
  width: 80%; /* Could be more or less, depending on screen size */
}

/* The Close Button (x) */
.close {
  position: absolute;
  right: 25px;
  top: 0;
  color: #000;
  font-size: 35px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: red;
  cursor: pointer;
}

/* Add Zoom Animation */
.animate {
  -webkit-animation: animatezoom 0.6s;
  animation: animatezoom 0.6s
}

@-webkit-keyframes animatezoom {
  from {-webkit-transform: scale(0)} 
  to {-webkit-transform: scale(1)}
}
  
@keyframes animatezoom {
  from {transform: scale(0)} 
  to {transform: scale(1)}
}

/* Change styles for span and cancel button on extra small screens */
@media screen and (max-width: 300px) {
  span.psw {
     display: block;
     float: none;
  }
  .cancelbtn {
     width: 100%;
  }
}

</style>
<body>
<h3>
<%
//below gets the food item and matching food review to print to the webpage
JDBCSelect js = new JDBCSelect();
JDBCInsert ji = new JDBCInsert();
String foodItem = request.getParameter("food_item");
out.println(foodItem);
if(js.getAverageRatingbyFoodItem(foodItem) != null)
{
	out.print("          ");
	out.print(String.format("%.2f",js.getAverageRatingbyFoodItem(foodItem)));
	out.print("/5");
}
%>
</h3>
<div id="id03" class="modal">
  
  <form class="modal-content animate" action="CreateReview_Action.jsp" method="post">
    <div class="imgcontainer">
      <span onclick="document.getElementById('id03').style.display='none'" class="close" title="Close Modal">&times;</span>
    </div>

	<!-- elements that allows user to submit a review for the selected food item -->
    <div class="container">
      <label for="food_item"><b>Food Item</b></label>
      <input type="text" placeholder="Food Item" name="food_item" value="<%=foodItem%>" readonly>
      
      <label for="title"><b>Title</b></label>
      <input type="text" placeholder="Enter Title" name="title" required>

      <label for="desc"><b>Description</b></label>
      <input type="text" placeholder="Enter Description" name="desc" required>
      
      <label for="rating"><b>Rating</b></label>
      <input type="number" placeholder="Enter Rating" min="1" max="5" name="rating" required>

      <button type="submit">Submit Review</button>
    </div>

    <div class="container" style="background-color:#f1f1f1">
      <button type="button" onclick="document.getElementById('id03').style.display='none'" class="cancelbtn">Cancel</button>
    </div>
  </form>
</div>
<%
ArrayList<String> foodList = js.getFoodItem(foodItem);
out.println("Nutrition Information");

if(session.getAttribute("loggedInUser") != null)
{
	String email = (String)session.getAttribute("loggedInUser");
	Integer reviewInt = ji.reviewAlreadyExists(email, foodItem);
	Integer favoriteInt = ji.favoriteAlreadyExists(email, foodItem);
	
	System.out.println(email);
	System.out.println(foodItem);
	System.out.println(ji.reviewAlreadyExists(email, foodItem));
	System.out.println(ji.favoriteAlreadyExists(email, foodItem));
	
	if(reviewInt != 1)
	{
		%>
		<button onclick="document.getElementById('id03').style.display='block'" style="width:auto;">Make Review</button>
		<%
	}
	
	if(favoriteInt != 1)
	{
		
		%>
		<a href="./CreateFavorite_Action.jsp?food_item=<%=foodItem%>"> 
		<button style="width:auto;">Add to Favorite</button>
		</a>
		<%
	}
}

%>
<br>
<!-- below prints nutrition information to webpage -->
<%
out.println("Calories: ");
out.println(foodList.get(2));
%>
<br>
<%
out.println("Fat: ");
out.println(foodList.get(3)); 
%>
<br>
<%
out.println("Cholesterol: ");
out.println(foodList.get(4)); 
%>
<br>
<%
out.println("Carbs: ");
out.println(foodList.get(5)); 
%>
<br>
<%
out.println("Protein: ");
out.println(foodList.get(6)); 
%>
<br>
<br>
<%
ArrayList<ArrayList<String>> reviewList = js.getFoodReviewsByFoodItem(foodItem);
out.println("Reviews");
%>
<br>
<% 
for(ArrayList<String> l : reviewList)
{
	//Title, Rating/5
	out.println(l.get(3) + ", " + l.get(2) + "/5");
	%>
	<br>
	<%
	//By: email@csbsju.edu
	out.println("By: " + l.get(1));
	%>
	<br>
	<%
	//Review Description
	out.println(l.get(4));
	%>
	<br>
	<br>
	<%
}
%>

</body>
</html>