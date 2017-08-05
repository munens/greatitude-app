<?php

$host = 'boscustmysql04.eigbox.net';
$dbname = 'natalie_app_2017';
$db_user = 'natalie_2017';
$db_pass = 'natalie_2017';

$username = $_POST['email'];
$post_time = $_POST['post_time'];

$db = new PDO('mysql:host='. $host .';dbname=' . $dbname . ';charset=utf8', $db_user, $db_pass);

$stmt = $db->prepare("INSERT INTO shared_items(username, post_time) VALUES(?, ?)");
$result = $stmt->execute(array($username, $post_time));


if($result){
	echo json_encode(array("result"=>$result, "success"=>true));
} else {
	echo json_decode(array("success"=>true));
}

?>