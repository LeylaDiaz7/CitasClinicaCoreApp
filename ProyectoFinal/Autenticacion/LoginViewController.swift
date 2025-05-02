import UIKit

class LoginViewController: UIViewController {

    private let backgroundImageView = UIImageView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton()
    private let registerLink = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupContainer()
        setupFields()
        setupLoginButton()
        setupRegisterLink()
    }

    private func setupBackground() {
        backgroundImageView.image = UIImage(named: "fondoLogin")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupContainer() {
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        containerView.layer.cornerRadius = 40 //25
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 180),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            containerView.heightAnchor.constraint(equalToConstant: 500)
        ])

        titleLabel.text = "¡Bienvenido de nuevo!"
        titleLabel.textColor = UIColor(hex: "#314975")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50), //
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    private func setupFields() {
        [emailField, passwordField].forEach {
            $0.backgroundColor = UIColor.systemGray6
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
            $0.applyNeumorphicEffect() // aplicando extension
        }


        emailField.placeholder = "Correo electrónico"
        emailField.keyboardType = .emailAddress

        passwordField.placeholder = "Contraseña"
        passwordField.isSecureTextEntry = true
        passwordField.enablePasswordToggle()
        
        emailField.setLeftPadding(12)
        passwordField.setLeftPadding(12)

        

        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            emailField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            emailField.heightAnchor.constraint(equalToConstant: 40),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupLoginButton() {
        loginButton.setTitle("Ingresar", for: .normal)
        
        loginButton.applyNeumorphicEffect()
        
        loginButton.backgroundColor = UIColor(hex: "#314975")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        containerView.addSubview(loginButton)

        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 25),
            loginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    private func setupRegisterLink() {
        registerLink.setTitle("¿No tienes cuenta? Regístrate", for: .normal)
        registerLink.setTitleColor(.systemBlue, for: .normal)
        registerLink.titleLabel?.font = .systemFont(ofSize: 14)
        registerLink.translatesAutoresizingMaskIntoConstraints = false
        registerLink.addTarget(self, action: #selector(irARegistro), for: .touchUpInside)
        containerView.addSubview(registerLink)

        NSLayoutConstraint.activate([
            registerLink.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            registerLink.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }

    @objc private func loginTapped() {
        guard let correo = emailField.text, !correo.isEmpty,
              let clave = passwordField.text, !clave.isEmpty else {
            AlertaManager.mostrarAlertaCamposVacios(en: self)
            return
        }

        if let usuario = CoreDataManager.shared.validarUsuario(usuario: correo, clave: clave) {
            let paciente = usuario.fk_paciente

            if let correoPaciente = paciente?.correo {
                UserDefaults.standard.set(correoPaciente, forKey: "correoActual")
            }

            let tabBarController = MainTabBarController()
            if let navController = tabBarController.viewControllers?.first as? UINavigationController,
               let homeVC = navController.viewControllers.first as? HomeViewController {
                homeVC.nombreUsuario = paciente?.nombres
                homeVC.correoUsuario = paciente?.correo
            }

            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = tabBarController
            }
        } else {
            AlertaManager.mostrarAlertaError(en: self)
        }
    }

    @objc private func irARegistro() {
        let registroVC = RegisterUserViewController()
        navigationController?.pushViewController(registroVC, animated: true)
    }
    
    
   
    

    
    
}
