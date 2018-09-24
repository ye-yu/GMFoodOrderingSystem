<?php
	session_start();
?>
<html>
	<head>
	<?php
		$has_session = isset($_SESSION['username']);
		echo("<script>");
		if($has_session)
			echo("var has_session = true;");
		else
			echo("var has_session = false;");
		echo("</script>");
		if($has_session)
		{
			$connection = new mysqli("localhost", $_SESSION['username'], $_SESSION['password'], "foodorder");
			if($connection -> connect_error)
				session_destroy();
			if(isset($_POST["submit"]) && $_POST["submit"] == "Add Food") {
				if($_POST['foodtype'] == "Others")
					$_POST['foodtype'] = $_POST['other'];
				if(isset($_FILES["upload"]["tmp_name"]))
					$check = getimagesize($_FILES["upload"]["tmp_name"]);
				else 
					$check = false;
				if($check !== false) {
					$date = new DateTime();
					$filename = $date->getTimestamp();
					if (move_uploaded_file($_FILES["upload"]["tmp_name"], "assets/foods/" . $filename)) {
						if($connection -> query("select add_food('" . $_POST['foodname'] . "', " . $_POST['price'] . ", '" . $_POST['foodtype'] . "', '" . $_POST['foodDesription'] . "', '" . $filename . "')"))
						{
							echo('<div class="alert alert-success" onclick="setSlideUp(this);">');
							echo('<strong>Success!</strong> Your food has been added.');
							echo('</div>');
						} else {
						echo('<div class="alert alert-warning" onclick="setSlideUp(this);">');
						echo('<strong>Error.</strong> Please resubmit the food information.');
						echo('</div>');
						}
					} else {
						echo('<div class="alert alert-warning" onclick="setSlideUp(this);">');
						echo('<strong>Error.</strong> Please resubmit the food information.');
						echo('</div>');
					}
				} else {
					echo('<div class="alert alert-warning" onclick="setSlideUp(this);">');
					echo('<strong>Error.</strong> Please resubmit the food information.');
					echo('</div>');
				}
			}
			else if (isset($_POST['submittype']) && $_POST['submittype'] == "Make Changes")
			{
				// print_r($_POST);
				// print_r($_FILES["upload"]);
				if($_POST['foodtype'] === "Others")
					$_POST['foodtype'] = $_POST['other'];
				//update image
				$has_image = true;
				if ($_FILES["upload"]["error"] == 1)
				{
					$has_image = false;
					echo('<div class="alert alert-warning" onclick="setSlideUp(this);">');
					echo('<strong>Filename Error.</strong> Please rename the file of the image. Other information will be updated.');
					echo('</div>');
				}
				else if ($_FILES["upload"]["error"] == 4)
				{
					$has_image = false;
				}

				if($has_image)
				{
					$check = getimagesize($_FILES["upload"]["tmp_name"]);
					if($check !== false) {
						$date = new DateTime();
						$filename = $date->getTimestamp();
						if (move_uploaded_file($_FILES["upload"]["tmp_name"], "assets/foods/" . $filename)) {
							if($connection -> query("update food set foodname='" . $_POST['foodname'] . "', foodtype='" . $_POST['foodtype'] . "', foodprice=" . $_POST['foodprice'] . ", fooddescription='" . $_POST['foodDesription'] . "', foodimagelink = '" . $filename . "' where foodid ='" . $_POST['id'] . "'"))
							{
								echo('<div class="alert alert-success" onclick="setSlideUp(this);">');
								echo('<strong>Success!</strong> Your food image has been updated.');
								echo('</div>');
							} else {
							echo('<div class="alert alert-warning" onclick="setSlideUp(this);">');
							echo('<strong>Error.</strong> Please resubmit the food information.');
							echo('</div>');
							}
						} else {
							echo('<div class="alert alert-warning" onclick="setSlideUp(this);">');
							echo('<strong>Error.</strong> Please resubmit the food information.');
							echo('</div>');
						}
					}
				}
				else if($connection -> query("update food set foodname='" . $_POST['foodname'] . "', foodtype='" . $_POST['foodtype'] . "', foodprice=" . $_POST['foodprice'] . ", fooddescription='" . $_POST['foodDesription'] . "' where foodid ='" . $_POST['id'] . "'"))
				{
					echo('<div class="alert alert-success" onclick="setSlideUp(this);">');
					echo('<strong>Success!</strong> Your food has been updated.');
					echo('</div>');
				}
				else
				{
					echo('<div class="alert alert-warning" onclick="setSlideUp(this);">');
					echo('<strong>Error.</strong> Please resubmit the food information.');
					echo('</div>');
				}
				//
			}
			else if (isset($_POST['submittype']) && $_POST['submittype'] == "Remove")
			{
				if($connection -> query("update food set showfood = false where foodid ='" . $_POST['id'] . "';"))
				{
					echo('<div class="alert alert-success" onclick="setSlideUp(this);">');
					echo('<strong>Success!</strong> Your food has been updated.');
					echo('</div>');
				}
				else
				{
					echo('<div class="alert alert-warning" onclick="setSlideUp(this);">');
					echo('<strong>Error.</strong> Please resubmit the action.');
					echo("delete from food where foodid ='" . $_POST['id'] . "';");
					echo('</div>');
				}
			}

		}
	?>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.7.0/animate.css" />
	<script>
		document.write("<base href='http://" + document.location.host + "' />");
	</script>
	<link rel="stylesheet" href="dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/css/MenuManagement.css">
	<style>
			#login-page{
				border:2px solid black;
				padding:10px;
				height:300px;
				width:700px;
				 position: absolute;
				  margin: auto;
				  top: 0;
				  right: 0;
				  bottom: 0;
				  left: 0;
			}
			#login-page input{
				display:block
			
			}
			#login-page button{
				display:block;
			}

			#login-page-content p{
				left:0;
				top:0;
			}
			#task form > *{
				display:block;
			}
			.datepickerdropdown {
  background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAD6CAIAAADvIroEAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwQAADsEBuJFr7QAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIHYzLjM2qefiJQAAAIhJREFUOE99w4cRgDAQBLHtvzKyyWByhjKo4E8z4vs+3vc1P8+Det836nVdqOd5oh7HgXXfd9Rt21DXdUVdlgV1nmes0zShjuOIOgwDqvcete97rF3XobZti9o0DWpd16hVVaGWZYm1KArUPM9RnXOoWZahpmmKNUkS1DiOUaMoQg3DEDUIAow/RjJ3qB92TU4AAAAASUVORK5CYII=);
  border:1px solid #888;
  border-radius:5px;
  padding:10px;
  position:absolute;
  text-align:center;
}
.datepickerdropdown table {
  border-collapse:collapse;
  margin:auto;
}
.datepickerdropdown input {
  font-family:monospace;
  border:1px solid #888;
  border-radius:3px;
  margin:1px;
  padding:2px 5px;
  text-align:center;
}
.datepickerdropdown table input[type=button] {
  width:2em;
}
.datepickerdropdown input[type=button] {
  background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAAeCAIAAABi9+OQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAAOwwAADsMBx2+oZAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIHYzLjM2qefiJQAAAElJREFUGFeNwwEGACEQQNF//6MlSRSRSMMkY86wdk+wj4e78zaz772Xcw6qioiw92atxZyTMQa9d1pr1FoppZBzJqVEjJEQwt8PXeRLuM/peRgAAAAASUVORK5CYII=);
}
.datepickerdropdown input[type=button]:hover {
  background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAAeCAIAAABi9+OQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAAOwwAADsMBx2+oZAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIHYzLjM2qefiJQAAAFpJREFUGFdjePfuAgMIv3lzCoxfvTrK8OLFAYbnz/cyPHmyleHx480MDx+uY7h3bxnDnTsLGW7enMVw7dpkhqtXJzJcutTFcOFCG8O5c00MZ87UMZw6VUksBgDwaURPl4Jv2AAAAABJRU5ErkJggg==);
}
.datepickerdropdown input[type=button]:active {
  background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAAeCAIAAABi9+OQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAAOwwAADsMBx2+oZAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIHYzLjM2qefiJQAAAFhJREFUGFdjOHWqkuHMmTqGc+eaGC5caGO4dKmL4erViQzXrk1muHlzFsOdOwsZ7t1bxvDw4TqGx483Mzx5spXh+fO9DC9eHGB49eoow5s3p8D43bsLpGAAr0NKhZpZNgcAAAAASUVORK5CYII=);
  padding:2px 4px 2px 6px;
}      
.datepickerdropdown input.selected {
  background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAAeCAIAAABi9+OQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAAOwwAADsMBx2+oZAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIHYzLjM2qefiJQAAAEBJREFUGFdj+P//P8P//5+A+CkQXwfiU0C8B4jXA/EiIJ4CxO1AXAnEOUAcB8SBQOwCxGZArAnE0kDMB8QMxGIAwnRFxCnPkL8AAAAASUVORK5CYII=);
}
.datepickerdropdown input[type=text] {
  background:#fff;
  color:#000;
}
.datepickerdropdown input.today {
  border:1px solid red;
}
.datepickerdropdown input.othermonth {
  color:#aaa;
  border:1px solid #bbb;
}
.datepickershow img {
  border:0;
}
.monthDsp
{
width:80px;
font-size:9px;
}
.daysRow
{
font-family:sans-serif;
font-size:11px;
}
		</style>
	</head>
	<body>
		<div class="container-fluid" id="main-content">
		<div class="container-fluid" id="login-page">
			<div class="login-section">
				<div id="login-page-content">
				<p class="login-header">Login to Menu Management<p>
				<div class="login-form">
					Username: <input type="text" id="uname">
					Password: <input type="password" id="pword">
				<input type="submit" id="login-btn" class="button" value="Login"/>
				<a onclick="this.innerHTML = 'You may contact us at our hotline: 1300300300';"><p id="haha">Contact support</p></a>
				</div>
				<div class="" id="login-error"></div>
				</div>
			</div>
		</div>
		<div class="container-fluid" style="display:none" id="menu-mgmt-page">
				<div id="pg-title">
				<h2> Menu Management Page</h2>
				</div>
				<div class="row">
				<div class="col-md-3 btn-list">
				<p class="button-actions">
					Action:
				</p>
					<button id="add-food">Add Food</button>
					<button id="view-food">View/Remove Food</button>
					<button id="view-fdbck">View Feedback</button>
					<button id="logout" onclick="logOut();">Log Out</button>
				</div>
				<div id="list-of-food" class="col-md-9">
					<div id="task">
						<p class="add-header"> Add Food </p>
						<p class="add-caption">You may add new food here. All fields are compulsory.</p>
						<form id="menu-upload" action="dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/html/MenuManagement.php" method="POST" enctype="multipart/form-data">
								Name: <span class="form-caption">(Max length: 100 chars)</span> <input type="text" style="display: inline-block;" maxlength="100" name="foodname" required />
							<div id="categories">
								Category: <select name="foodtype" required>
								<script>
								var categories = "";
<?php
	if($has_session)
	{
		$connection = new mysqli("localhost", $_SESSION['username'], $_SESSION['password'], "foodorder");
		$req = $connection -> query("select foodtype from food group by foodtype;");
		while($row = $req -> fetch_assoc())
			echo("categories += \"<option value='" . $row['foodtype'] . "' onclick='disableOthers();'>" . $row['foodtype'] . "</option>\";");
	}
?>
document.write(categories);
</script>
										  <option value="Others" onclick="enableOthers();">Add Others:</option>
										  </select>
										  <span class="form-caption">(Max length: 50 chars)</span> 
										  <input type="text" maxlength="50" id="other-name" class="other-name" name="other" disabled />
							</div>
							Price (RM):<input type="number" min=0 style="display: inline-block;" name="price" step=".01" required /> <br/>
							Description: <span class="form-caption">(Max length: 500 chars)</span> <textarea name="foodDesription" rows="8"  maxlength="50" required /></textarea>
							Upload Image: <input type="file" onchange="previewFile()" style="display: inline-block;" name="upload"><br>
							<img src="" height="200" alt="Image preview...">
							<input type="submit" value="Add Food" name="submit">
						</form>
					</div>
					<div id="task-2">
					
					</div>
					<div id="fdbck-page">
						<h4>View Feedbacks</h4>
						<span>From date:</span><input id="start_dt" type="date" value="dateChosen"></input><input type="submit" value="Go"></input>
						<div id="fdbck">
						</div>
					</div>
				</div>
				</div>
		</div>
	</div>
	<div class="modal  bd-example-modal-lg" id="pop-up" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" >
  <div class="modal-dialog modal-lg">
    <div class="modal-content text-center">
      
    </div>
  </div>
</div>
	<script src="dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/javascript/MenuMangement.js"></script>
  </p> 
  
	</body>
</html>