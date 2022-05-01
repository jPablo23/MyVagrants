<?php
$servername = "localhost"; // Nombre/IP del servidor
$database = "mysql"; // Nombre de la BBDD
$username = "root"; // Nombre del usuario
$password = "12345678"; // Contraseña del usuario
// Creamos la conexión
$con = mysqli_connect($servername, $username, $password, $database);
// Comprobamos la conexión
if (!$con) {
    die("La conexión ha fallado: " . mysqli_connect_error());
}
echo "Conexión satisfactoria Yea";
mysqli_close($con);
?>
