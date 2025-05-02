import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupTabBar()
    }

    private func setupTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: "house.fill"), tag: 0)

        let misCitasVC = UINavigationController(rootViewController: MisCitasViewController())
        misCitasVC.tabBarItem = UITabBarItem(title: "Mis Citas", image: UIImage(systemName: "person.3.fill"), tag: 1)

        let agendarVC = UINavigationController(rootViewController: RegistrarCitaViewController())
        agendarVC.tabBarItem = UITabBarItem(title: "Agendar", image: UIImage(systemName: "calendar.badge.plus"), tag: 2)

        
        
        let perfilVC = ActualizarInfoViewController()
        perfilVC.correoUsuario = UserDefaults.standard.string(forKey: "correoActual")
        let navPerfilVC = UINavigationController(rootViewController: perfilVC)
        navPerfilVC.tabBarItem = UITabBarItem(title: "Mi Perfil", image: UIImage(systemName: "person.fill"), tag: 3)


        //--------------------
        let contactarVC = UIViewController()
        contactarVC.view.backgroundColor = .white
        contactarVC.tabBarItem = UITabBarItem(title: "Contactar", image: UIImage(systemName: "phone.fill"), tag: 4)

        viewControllers = [homeVC, misCitasVC, agendarVC, navPerfilVC, contactarVC]
        tabBar.tintColor = .black
        tabBar.backgroundColor = .systemGray5
    }
}
