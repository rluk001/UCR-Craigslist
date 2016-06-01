<?php
	session_start();
	if($_SESSION['user']){
	}
	else{
		header("location:index.php");
		Print "Please log in";
		exit();
	}
	if($_SERVER['REQUEST_METHOD'] == "GET"){
		$category = $_GET['category'];
		include 'navbar.php';
	}
	else{
		header("location: home.php"); //redirects back to home
		exit();
	}
?>
<html>
	<head>
		<title>UCR Craigslist</title>
		<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
		<link href="/home.css" rel="stylesheet">
	</head>
	<body>
		<h2 align="center"><?php echo ucfirst($category) ?></h2>
		<div class="wrapperHome">
		<table class ="table table-hover table-sm">
			<thead>
				<tr>
					<th>Title</th>
					<th>Seller</th>
					<th>Price</th>
					<th>Category</th>
					<th>Date / Time</th>
					<th>Pictures</th>
				</tr>
			</thead>
			<tbody>
		<?php
			if($_SERVER['REQUEST_METHOD'] == "GET")
			{
				include 'serverconnect.php'; //server connection code
					    
				$query = mysqli_query($conn, "SELECT * from posts WHERE post_category='$category'"); // SQL Query
				while($row = mysqli_fetch_array($query,MYSQLI_ASSOC))
				{
					Print "<tr>";
						$id = $row['post_id'];
						Print '<td align="center"><a href="specificpost.php?post_id='.$id.'">'. $row['post_title'] . "</a></td>";
						Print '<td align="center"><a href="profile.php?user_profile='. $row['post_username'] .'">'. $row['post_username'] . "</a></td>";
						Print '<td align="center">$'. $row['post_price'] . "</td>";
						Print '<td align="center">'. $row['post_category'] . "</td>";
						Print '<td align="center">'. $row['post_date']. " - ". $row['post_time']."</td>";
						if($numpics = $row['post_photos']){
							Print '<td align="center">'.$numpics.' available</td>';
						}
						else
							Print '<td align="center"> none </td>';
					Print "</tr>";
				}
			}
			else{
				header("location: home.php"); //redirects back to home
				exit();
			}
		?>
		</tbody>
		</table>
		</div>
	</body>
</html>