<?php
session_start();

// Gérer la déconnexion si demandée
/* if (isset($_GET['action']) && $_GET['action'] === 'logout') {
    session_destroy();
    header("Location: http://sso.demo.local");
    exit;
} */
if (isset($_GET['action']) && $_GET['action'] === 'logout') {
    // 1. Destruction complète de la session
    $_SESSION = array();
    if (ini_get("session.use_cookies")) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 4200,
            $params["path"], $params["domain"],
            $params["secure"], $params["httponly"]
        );
    }
    session_destroy();
    
    // 2. CORRECTION : Envoi du code 401 pour forcer Lynx à fermer l'interface
    header("HTTP/1.1 401 Unauthorized");
    echo "<h1>Déconnexion réussie.</h1><p>Session fermée de manière sécurisée.</p>";
    exit;
}


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';

    // Lecture directe de votre fichier users.txt existant
    $users = file('/var/www/monapp/users.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($users as $user) {
        if (strpos($user, ':') !== false) {
            list($u, $p) = explode(':', $user, 2);
            if ($u === $username && $p === $password) {
                $_SESSION['logged_in'] = true;
                $_SESSION['user'] = $username;
                
                // Redirection vers la racine après succès (Nginx affichera index.html)
                header("Location: http://sso.demo.local");
                exit;
            }
        }
    }
    $error = "Identifiants incorrects.";
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion Requise</title>
</head>
<body>
    <h2>Connexion Requise</h2>
    <?php if (isset($error)) echo "<p style='color:red;'>$error</p>"; ?>
    
    <form method="POST" action="/login.php">
        username :<input type="text" name="username" placeholder="Utilisateur" required><br><br>
        password :<input type="password" name="password" placeholder="Mot de passe" required><br><br>
        <button type="submit">Log in</button>
    </form>
</body>
</html>
