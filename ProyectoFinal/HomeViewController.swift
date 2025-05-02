
import UIKit

class HomeViewController: UIViewController {

    var nombreUsuario: String?
    var correoUsuario: String?

    private let saludoLabel = UILabel()
    private let logoImageView = UIImageView()
    private let gridButton = UIButton()
    private let proximaCitaLabel = UILabel()
    private let citaContainerView = UIView()
    
    private let logoutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        gridButton.addTarget(self, action: #selector(irAMiPerfil), for: .touchUpInside)
        logoutButton.setImage(UIImage(systemName: "arrow.backward.circle"), for: .normal)
        logoutButton.tintColor = .black
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(confirmarLogout), for: .touchUpInside)
        view.addSubview(logoutButton)
        
        setupLayout()
    }

    private func setupLayout() {
        // Grid (menú) button
        gridButton.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        gridButton.tintColor = .black
        gridButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridButton)

        // Logo
        logoImageView.image = UIImage(named: "logoVitaNova-sinfondo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)


        // Mensaje de bienvenida
        saludoLabel.text = "Bienvenid@ \(nombreUsuario ?? "{Nombre de usuario}")\na tu clínica de confianza"
                saludoLabel.numberOfLines = 2
        saludoLabel.textAlignment = .center
        saludoLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        saludoLabel.backgroundColor = UIColor.systemGray6
        saludoLabel.layer.cornerRadius = 15
        
        //saludoLabel.layer.masksToBounds = true
        saludoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Después de configurar saludoLabel
        saludoLabel.applyNeumorphicEffect()
        view.addSubview(saludoLabel)

        // Texto "Tus próximas citas..."
        proximaCitaLabel.text = "Tus próximas citas..."
        proximaCitaLabel.font = UIFont.boldSystemFont(ofSize: 16)
        proximaCitaLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(proximaCitaLabel)

        // Contenedor para mostrar que no hay citas
        citaContainerView.backgroundColor = UIColor.systemGray6
        citaContainerView.layer.cornerRadius = 15
        citaContainerView.translatesAutoresizingMaskIntoConstraints = false

        let noCitasLabel = UILabel()
        noCitasLabel.text = "No tienes citas registradas hasta el momento"
        noCitasLabel.textColor = .gray
        noCitasLabel.font = UIFont.systemFont(ofSize: 14)
        noCitasLabel.textAlignment = .center
        noCitasLabel.translatesAutoresizingMaskIntoConstraints = false

        citaContainerView.addSubview(noCitasLabel)
        
        citaContainerView.applyNeumorphicEffect()

        view.addSubview(citaContainerView)

        // Constraints
        NSLayoutConstraint.activate([
            gridButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gridButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            gridButton.widthAnchor.constraint(equalToConstant: 30),
            gridButton.heightAnchor.constraint(equalToConstant: 30),

            // ...
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: gridButton.centerYAnchor),

            logoImageView.widthAnchor.constraint(equalToConstant: 240),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),

            //... constrains para log-out
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: gridButton.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 30),
            logoutButton.heightAnchor.constraint(equalToConstant: 30),
            
            //...

            saludoLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            saludoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saludoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saludoLabel.heightAnchor.constraint(equalToConstant: 60),

            proximaCitaLabel.topAnchor.constraint(equalTo: saludoLabel.bottomAnchor, constant: 30),
            proximaCitaLabel.leadingAnchor.constraint(equalTo: saludoLabel.leadingAnchor),

            citaContainerView.topAnchor.constraint(equalTo: proximaCitaLabel.bottomAnchor, constant: 10),
            citaContainerView.leadingAnchor.constraint(equalTo: saludoLabel.leadingAnchor),
            citaContainerView.trailingAnchor.constraint(equalTo: saludoLabel.trailingAnchor),
            citaContainerView.heightAnchor.constraint(equalToConstant: 100),

            noCitasLabel.centerXAnchor.constraint(equalTo: citaContainerView.centerXAnchor),
            noCitasLabel.centerYAnchor.constraint(equalTo: citaContainerView.centerYAnchor)
        ])
    }
    
    @objc private func irAMiPerfil() {
        let perfilVC = ActualizarInfoViewController()
        perfilVC.correoUsuario = correoUsuario
        navigationController?.pushViewController(perfilVC, animated: true)
    }
    
    @objc private func confirmarLogout() {
        let alert = UIAlertController(title: "¿Cerrar sesión?", message: "¿Estás seguro de que deseas cerrar sesión?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Salir", style: .destructive, handler: { _ in
            self.logout()
        }))
        
        alert.addAction(UIAlertAction(title: "No, me quedaré", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func logout() {
        print("Logout exitoso")
        
        // Obtener la escena actual y la ventana asociada
        if let scene = view.window?.windowScene,
           let delegate = scene.delegate as? SceneDelegate {
            
            // Crear una nueva instancia del LoginViewController
            let loginVC = LoginViewController()
            
            // Crear el UINavigationController con LoginViewController como el controlador raíz
            let navigationController = UINavigationController(rootViewController: loginVC)
            
            // Establecer el UINavigationController como rootViewController de la ventana
            delegate.window?.rootViewController = navigationController
            delegate.window?.makeKeyAndVisible()
        }
    }




}
