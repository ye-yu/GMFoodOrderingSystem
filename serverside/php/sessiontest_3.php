<?php 
session_start();
?>
<!DOCTYPE HTML>
<?php 
session_destroy();
print_r ($_SESSION);
echo ("<br/><a href='sessiontest_1.php'>Recreate session</a>");
?>
