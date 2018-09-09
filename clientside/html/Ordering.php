<!DOCTYPE html>
<html lang="en">
<head>
<title>Food Menu Management</title>
<meta charset="utf-8">
<?php
	if(isset($_POST['customer_number']))
	{
		$url = "http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/customer.php?request=FIND_ID&name=" . urlencode($_POST['customer_number']);
		$cid=file_get_contents($url);
		// $oid=file_get_contents("http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=FIND_ID&cid=" . $cid . "&tno=" . $_POST['table_number']);
		// echo($oid);
		//output, you can also save it locally on the server
		echo("<script>");
		echo("var customerNumber = '" . $_POST['customer_number'] . "';");
		echo("var tableNumber = '" . $_POST['table_number'] . "';");
		echo("var customerid = '" . $cid . "';");
		echo("var orderid = null;");
		echo("</script>");
	}
?>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/css/Ordering.css">
<script src="http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/others/lib/jQuery.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script>
function sendRequest(method,param,url,toSet){
	var ourRequest = new XMLHttpRequest();
	ourRequest.open(method,url);
	ourRequest.onload = function()
	{
		if(ourRequest.readyState== 4 && ourRequest.status == 200)
			{
				toSet(ourRequest.responseText);
				console.log(ourRequest.responseText);
			}
	}
	if (method == 'POST')
		ourRequest.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	ourRequest.send(param);
}
</script>
<script src="http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/javascript/bootstrap-number-input.js" ></script><!-- must include if have input number plus minus -->	
<!-- load customer script -->
<script src="http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/javascript/Customer.js"></script>
<!-- load order script -->
<script src="http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/javascript/Ordering.js"></script>
<!-- load food script -->
<script src="http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/javascript/Food.js"></script>
<!-- objects end -->
<script src="http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/javascript/Ordering(Module).js"></script>
<style>
/**********************************
Responsive navbar-brand image CSS
- Remove navbar-brand padding for firefox bug workaround
- add 100% height and width auto ... similar to how bootstrap img-responsive class works
***********************************/

.navbar-brand {
	padding: 0px;
}
.navbar-brand>img {
	height: 100%;
	padding: 15px;
	width: auto;
}
/* EXAMPLE 3

line height is 20px by default so add 30px top and bottom to equal the new .navbar-brand 80px height  */

.example3 .navbar-brand {
	height: 80px;/* same as image height */
}
.example3 .nav >li >a {
	padding-top: 30px;
	padding-bottom: 30px;
}
.example3 .navbar-toggle {
	padding: 10px;
	margin: 25px 15px 25px 0;
}

/* center restaurant name when not in mobile view */
@media only screen and (min-width : 768px) {
.navbar-text {
	position: absolute;
	width: 100%;
	left: 0;
	text-align: center;
	margin-top: 30px;
}
}

/* Set height of the grid so .sidenav can be 100% (adjust if needed) */
    .row.content {height: 1500px}
    
    /* Set gray background color and 100% height */
    .sidenav {
      background-color: #f1f1f1;
      height: 100%;
    }
      
    
    /* On small screens, set height to 'auto' for sidenav and grid */
    @media screen and (max-width: 767px) {
      .sidenav {
        height: auto;
        padding: 15px;
      }
      .row.content {height: auto;} 
    }	
</style>		
</head>
<body>
<div class="example3">
  <nav class="navbar navbar-default">
    <div class="container-fluid">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar1"> <span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> </button>
        <a class="navbar-brand" href="#"><img src="http://placehold.it/432x80&text=Logo" alt="logo"> </a>
        <h3 class="navbar-text">Restaurant Name</h3>
      </div>
      <div id="navbar1" class="navbar-collapse collapse">
        <ul class="nav navbar-nav navbar-right">
          <li class="active"><a href="1.html">Home</a></li>
          <li><a href="#">Contact Us</a></li>
          <li><a href="#">Locate Us</a></li>
        </ul>
      </div>
      <!--/.nav-collapse --> 
    </div>
    <!--/.container-fluid --> 
  </nav>
</div>
	
<div class="container-fluid">
	<div class="row leftnav">
	<!-- <div class=""> -->
		<div class="col-sm-3 sidenav">   
			<br>
			<form>		
				<h2>Select by:</h2>
				<div class="radio">
					<label><input type="radio" name="sel_by" checked>Category</label>
				</div>
				<div class="radio">
					<label><input type="radio" name="sel_by">Combo by price range</label>
				</div>
				<div class="form-inline">
					<div class="form-group">
						<label for="price">RM:</label>
						<input type="text" class="form-control" id="price">
					</div>  
				</div>
				<p><b>Include:</b></p>
				<span id="food-category">
					<div class="checkbox">
						<label><input type="checkbox" value="">Western Food</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" value="">Eastern Food</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" value="">Canned Drink</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" value="">Beverages</label>
					</div>
					<div class="checkbox">
						<label><input type="checkbox" value="">Add-ons</label>
					</div>
				</span>
			</form>		
		</div>

		<div class="col-sm-9">            
		<div class="container-fluid">
		  <div class="row">
				<div class="col-md-6" style="padding: 10px;">
				   <a href="#" style="font-size: 30pt;" onclick="showFoodCategory();">Categories</a>
				   <span id="selected-category" style="font-size: 20pt;">
				   </span>
				</div>
				<!-- <div class="col-md-6 text-right" style="padding-top: 30px;">    		    -->
					<!-- <button type="button" class="btn btn-lg">My Cart <span class="badge">0</span></button> -->
				<!-- </div> -->
        <div class="col-md-6 text-right" style="padding-top: 30px;">    		   
			<button type="button" class="btn btn-lg" data-toggle="modal" data-target="#mycartModal" onclick="updateCartFoodList();">My Cart <span class="badge" id="cart-count">0</span></button>
			 <!-- Modal -->
				  <div class="modal fade" id="mycartModal" role="dialog">
					<div class="modal-dialog">

					  <!-- Modal content-->
					  <div class="modal-content">
						<div class="modal-header">
						  <button type="button" class="close" data-dismiss="modal">&times;</button>
						  <h1 class="modal-title text-left">My Cart</h1>
						</div>
						<div class="modal-body">
						  <div class="text-left cartFoodList" id="cartFoodList">
						  <p><span class="cart-food-name"></span><span class="price-per-item">(RM<span class="price-per-item-number"></span></span>) &times; <button type="button" class="btn btn-default cart-btn" onclick="removeFromCart();">Remove</button></p>
							  <hr style="background-color: lightgray; height: 1px; border: 0;">
						  <p>-Food #2 &nbsp; x1 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Price per item: RM5 &nbsp;&nbsp;&nbsp;<button type="button" class="btn btn-default">Remove</button></p>
							  <hr style="background-color: lightgray; height: 1px; border: 0;">
						  <p>-Drink #4 &nbsp; x1 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Price per item: RM5 &nbsp;&nbsp;&nbsp;<button type="button" class="btn btn-default">Remove</button></p>
							  <hr style="background-color: lightgray; height: 1px; border: 0;">
							
						  </div>
							<br>
							<br>
								<h1 class="modal-title text-right">Total Price: RM<span id="cart-total">123</span></h1>
						</div>
						<div class="modal-footer">
						  <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
						  <button type="button" class="btn btn-default" onclick="placeOrder();">Place Order</button>						  
						</div>
					  </div>

					</div>
				  </div>
    	</div>
		  </div>
		</div>
		<div id="ordering-content" style="overflow-y: scroll;">
		<!-- dynamic listing starts here -->
			<div class="container-fluid bg-3 text-center">
			  <div class="row">
				<a href="https://i.hungrygowhere.com/cms/f3/01/83/e8/163650/western-subang-default2.jpg">
					<div class="col-sm-4">
					  <div class="thumbnail">        
						  <img src="https://i.hungrygowhere.com/cms/f3/01/83/e8/163650/western-subang-default2.jpg" alt="" style="width:100%;height: 200px;">
						  <div class="caption" style="background-color: lightgrey">
							<p>Chicken Chop -- RM3</p>
						  </div>        
					  </div>
					</div>
				</a>

				<div class="col-sm-4"> 
				  <div class="thumbnail">        
					  <img src="https://farm5.staticflickr.com/4394/36497890770_dcd561c818_o.jpg" alt="Nature" style="width:100%;height: 200px;">
					  <div class="caption" style="background-color: lightgrey">
						<p>Chicken Chop</p>
						  <div class="form-inline">
							  <div class="form-group">
								<label class="control-label">Qty:</label>
								<input id="inp_num2" class="form-control" style="width: 100px;" type="number" value="1" min="1" max="10" />
							  </div>
							  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#food2Modal">Add</button>
							<script>
							$('#inp_num2').bootstrapNumber();
							</script>
							  <!-- Modal -->
							  <div class="modal fade" id="food2Modal" role="dialog">
								<div class="modal-dialog">

								  <!-- Modal content-->
								  <div class="modal-content">
									<div class="modal-header">
									  <button type="button" class="close" data-dismiss="modal">&times;</button>
									  <h2 class="modal-title">Add this to cart?</h2>
									</div>
									<div class="modal-body">
									  <div class="row">
										<div class="col-sm-4">
										<img src="https://farm5.staticflickr.com/4394/36497890770_dcd561c818_o.jpg" style="width:100%;" class="img-rounded" alt="">
										</div>
										<div class="col-sm-8 text-left">
										<p>Chicken Chop</p>
										<p>.................</p>
										<p>.................</p>
										<p>.................</p>
										</div>
									  </div>
									</div>
									<div class="modal-footer">
									  <button type="button" class="btn btn-default">Add x quantity</button>
									  <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
									</div>
								  </div>

								</div>
							  </div>
						  </div>
					  </div>        
				  </div>
				</div>
				<div class="col-sm-4"> 
				  <div class="thumbnail">        
					  <img src="https://1.bp.blogspot.com/-DSFD2AhX4oE/WTbHFo7uPpI/AAAAAAAA_-E/c2zBDzH3dnYvys_cJ26RLM8eQL1qtrOgwCKgB/s1600/IMG_2581.JPG" alt="Nature" style="width:100%;height: 200px;">
					  <div class="caption" style="background-color: lightgrey">
						<p>Grilled Salmon Steak </p>
						  <div class="form-inline">
							  <div class="form-group">
								<label class="control-label">Qty:</label>
								<input id="inp_num3" class="form-control" style="width: 100px;" type="number" value="1" min="1" max="10" />
							  </div>
							  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#food3Modal">Add</button>
							<script>
							$('#inp_num3').bootstrapNumber();
							</script>
							  <!-- Modal -->
							  <div class="modal fade" id="food3Modal" role="dialog">
								<div class="modal-dialog">

								  <!-- Modal content-->
								  <div class="modal-content">
									<div class="modal-header">
									  <button type="button" class="close" data-dismiss="modal">&times;</button>
									  <h2 class="modal-title">Add this to cart?</h2>
									</div>
									<div class="modal-body">
									  <div class="row">
										<div class="col-sm-4">
										<img src="https://1.bp.blogspot.com/-DSFD2AhX4oE/WTbHFo7uPpI/AAAAAAAA_-E/c2zBDzH3dnYvys_cJ26RLM8eQL1qtrOgwCKgB/s1600/IMG_2581.JPG" style="width:100%;" class="img-rounded" alt="">
										</div>
										<div class="col-sm-8 text-left">
										<p>Grilled Salmon Steak </p>
										<p>.................</p>
										<p>.................</p>
										<p>.................</p>
										</div>
									  </div>
									</div>
									<div class="modal-footer">
									  <button type="button" class="btn btn-default">Add x quantity</button>
									  <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
									</div>
								  </div>

								</div>
							  </div>
						  </div>
					  </div>        
				  </div>
				</div>
			  </div>
			</div>
			<div class="container-fluid bg-3 text-center">    
			  <div class="row">
				<div class="col-sm-4">
				  <div class="thumbnail">        
					  <img src="http://www.noahfoods.com/v2/wp-content/uploads/2013/10/lamb-ribs-2-001.jpg" alt="" style="width:100%;height: 200px;">
					  <div class="caption" style="background-color: lightgrey">
						<p>Lamb Ribs</p>
						  <div class="form-inline">
							  <div class="form-group">
								<label class="control-label">Qty:</label>
								<input id="inp_num4" class="form-control" style="width: 100px;" type="number" value="1" min="1" max="10" />
							  </div>
							  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#food4Modal">Add</button>
							<script>
							$('#inp_num4').bootstrapNumber();
							</script>
							  <!-- Modal -->
							  <div class="modal fade" id="food4Modal" role="dialog">
								<div class="modal-dialog">

								  <!-- Modal content-->
								  <div class="modal-content">
									<div class="modal-header">
									  <button type="button" class="close" data-dismiss="modal">&times;</button>
									  <h2 class="modal-title">Add this to cart?</h2>
									</div>
									<div class="modal-body">
									  <div class="row">
										<div class="col-sm-4">
										<img src="http://www.noahfoods.com/v2/wp-content/uploads/2013/10/lamb-ribs-2-001.jpg" style="width:100%;" class="img-rounded" alt="">
										</div>
										<div class="col-sm-8 text-left">
										<p>Lamb Ribs</p>
										<p>.................</p>
										<p>.................</p>
										<p>.................</p>
										</div>
									  </div>
									</div>
									<div class="modal-footer">
									  <button type="button" class="btn btn-default">Add x quantity</button>
									  <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
									</div>
								  </div>

								</div>
							  </div>
						  </div>
					  </div>
				  </div>
				</div>
				<div class="col-sm-4"> 
				  <div class="thumbnail">
					  <img src="http://2.bp.blogspot.com/-Eynl06cI4CY/UgO5HJnYWGI/AAAAAAAAJtE/yT_p4nPU7B4/s1600/DSC03585.JPG" alt="Nature" style="width:100%;height: 200px;">
					  <div class="caption" style="background-color: lightgrey">
						<p>Chicken Kiev</p>
						  <div class="form-inline">
							  <div class="form-group">
								<label class="control-label">Qty:</label>
								<input id="inp_num5" class="form-control" style="width: 100px;" type="number" value="1" min="1" max="10" />
							  </div>
							  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#food5Modal">Add</button>
							<script>
							$('#inp_num5').bootstrapNumber();
							</script>
							  <!-- Modal -->
							  <div class="modal fade" id="food5Modal" role="dialog">
								<div class="modal-dialog">

								  <!-- Modal content-->
								  <div class="modal-content">
									<div class="modal-header">
									  <button type="button" class="close" data-dismiss="modal">&times;</button>
									  <h2 class="modal-title">Add this to cart?</h2>
									</div>
									<div class="modal-body">
									  <div class="row">
										<div class="col-sm-4">
										<img src="http://2.bp.blogspot.com/-Eynl06cI4CY/UgO5HJnYWGI/AAAAAAAAJtE/yT_p4nPU7B4/s1600/DSC03585.JPG" style="width:100%;" class="img-rounded" alt="">
										</div>
										<div class="col-sm-8 text-left">
										<p>Chicken Kiev</p>
										<p>.................</p>
										<p>.................</p>
										<p>.................</p>
										</div>
									  </div>
									</div>
									<div class="modal-footer">
									  <button type="button" class="btn btn-default">Add x quantity</button>
									  <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
									</div>
								  </div>
								</div>
							  </div>
						  </div>
					  </div>
				  </div>
				</div>
				<div class="col-sm-4"> 
				  <div class="thumbnail">
					  <img src="https://my.openrice.com/userphoto/Article/0/P/00053E150DCAAE86DFC0FCj.jpg" alt="Nature" style="width:100%;height: 200px;">
					  <div class="caption" style="background-color: lightgrey">
						<p>Steak</p>
						  <div class="form-inline">
							  <div class="form-group">
								<label class="control-label">Qty:</label>
								<input id="inp_num6" class="form-control" style="width: 100px;" type="number" value="1" min="1" max="10" />
							  </div>
							  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#food6Modal">Add</button>
							<script>
							$('#inp_num6').bootstrapNumber();
							</script>
							  <!-- Modal -->
							  <div class="modal fade" id="food6Modal" role="dialog">
								<div class="modal-dialog">

								  <!-- Modal content-->
								  <div class="modal-content">
									<div class="modal-header">
									  <button type="button" class="close" data-dismiss="modal">&times;</button>
									  <h2 class="modal-title">Add this to cart?</h2>
									</div>
									<div class="modal-body">
									  <div class="row">
										<div class="col-sm-4">
										<img src="https://my.openrice.com/userphoto/Article/0/P/00053E150DCAAE86DFC0FCj.jpg" style="width:100%;" class="img-rounded" alt="">
										</div>
										<div class="col-sm-8 text-left">
										<p>Steak</p>
										<p>.................</p>
										<p>.................</p>
										<p>.................</p>
										</div>
									  </div>
									</div>
									<div class="modal-footer">
									  <button type="button" class="btn btn-default">Add x quantity</button>
									  <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
									</div>
								  </div>

								</div>
							  </div>
						  </div>
					  </div>
				  </div>
				</div>
				
			  </div>
			</div>
		<!-- dynamic listing ends here -->
		</div>

				
			  
			  
		</div>
	</div>
</div>	
</body>
</html>
