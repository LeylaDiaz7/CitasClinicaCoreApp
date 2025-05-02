import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Asegúrate de que scene sea una UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Crear la ventana con la escena proporcionada
        window = UIWindow(windowScene: windowScene)
        
        // Crear la instancia de LoginViewController
        let loginViewController = LoginViewController()

        // Crear el UINavigationController con LoginViewController como el controlador raíz
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        // Establecer el UINavigationController como rootViewController de la ventana
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        CoreDataManager.shared.cargarDatosIniciales()
        

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Llamado cuando la escena está siendo liberada por el sistema.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Llamado cuando la escena ha pasado de un estado inactivo a un estado activo.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Llamado cuando la escena pasará de un estado activo a un estado inactivo.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Llamado cuando la escena transita del fondo al primer plano.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Llamado cuando la escena transita del primer plano al fondo.
        // Puedes guardar datos aquí si es necesario.
    }
}
