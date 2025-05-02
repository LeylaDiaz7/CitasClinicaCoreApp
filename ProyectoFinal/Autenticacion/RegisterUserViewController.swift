import UIKit

class RegisterUserViewController: UIViewController {

    private let backgroundImageView = UIImageView()
    private let containerView = UIView()

    private let titleLabel = UILabel()
    
    private let nameField = UITextField()
    private let dniField = UITextField()
    private let userField = UITextField()
    private let passField = UITextField()
    private let phoneField = UITextField()
    private let addressField = UITextField()
    private let birthDatePicker = UIDatePicker()
    private let genderSegment = UISegmentedControl(items: ["Masculino", "Femenino", "Otro"])
    private let registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupContainer()
        setupFields()
        setupRegisterButton()
    }

    private func setupBackground() {
        backgroundImageView.image = UIImage(named: "fondoLogin") // misma imagen
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
        containerView.layer.cornerRadius = 40
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 180),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 800)
        ])
        
        titleLabel.text = "¡Registrate aquí y ahora!"
        titleLabel.textColor = UIColor(hex: "#314975")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
    }

    private func setupFields() {
        let fields: [UIView] = [nameField, dniField, userField, passField, phoneField, addressField, genderSegment, birthDatePicker]
        fields.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
            $0.applyNeumorphicEffect()
        }

        nameField.placeholder = "Nombre completo"
        dniField.placeholder = "DNI"
        userField.placeholder = "Correo electrónico"
        userField.keyboardType = .emailAddress
        passField.placeholder = "Contraseña"
        passField.isSecureTextEntry = true
        phoneField.placeholder = "Teléfono"
        phoneField.keyboardType = .phonePad
        addressField.placeholder = "Dirección"
        genderSegment.selectedSegmentIndex = 2
        birthDatePicker.datePickerMode = .date
        birthDatePicker.maximumDate = Date()
        
        nameField.setLeftPadding(12)
        dniField.setLeftPadding(12)
        userField.setLeftPadding(12)
        passField.setLeftPadding(12)
        phoneField.setLeftPadding(12)
        addressField.setLeftPadding(12)

        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 40),
            nameField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            nameField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            nameField.heightAnchor.constraint(equalToConstant: 40),

            dniField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 10),
            dniField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            dniField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            dniField.heightAnchor.constraint(equalToConstant: 40),

            userField.topAnchor.constraint(equalTo: dniField.bottomAnchor, constant: 10),
            userField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            userField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            userField.heightAnchor.constraint(equalToConstant: 40),

            passField.topAnchor.constraint(equalTo: userField.bottomAnchor, constant: 10),
            passField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            passField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            passField.heightAnchor.constraint(equalToConstant: 40),

            phoneField.topAnchor.constraint(equalTo: passField.bottomAnchor, constant: 10),
            phoneField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            phoneField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            phoneField.heightAnchor.constraint(equalToConstant: 40),

            addressField.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 10),
            addressField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            addressField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            addressField.heightAnchor.constraint(equalToConstant: 40),

            genderSegment.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 10),
            genderSegment.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            genderSegment.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            genderSegment.heightAnchor.constraint(equalToConstant: 30),

            birthDatePicker.topAnchor.constraint(equalTo: genderSegment.bottomAnchor, constant: 10),
            birthDatePicker.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }

    private func setupRegisterButton() {
        registerButton.setTitle("Registrarse", for: .normal)
        
        registerButton.applyNeumorphicEffect()
        registerButton.backgroundColor = UIColor(hex: "#314975")
        
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 10
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        containerView.addSubview(registerButton)

        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: birthDatePicker.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 200),
            registerButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    @objc private func registerTapped() {
        guard let correo = userField.text, !correo.isEmpty,
              let password = passField.text, !password.isEmpty,
              let nombre = nameField.text, !nombre.isEmpty,
              let dni = dniField.text, !dni.isEmpty,
              let telefono = phoneField.text, !telefono.isEmpty,
              let direccion = addressField.text, !direccion.isEmpty else {
            
            AlertaManager.mostrarAlertaCamposVacios(en: self)
            
            return
        }

        guard correo.contains("@"), correo.contains(".") else {
            AlertaManager.mostrarAlertaCorreoNoValido(en: self)
            return
        }

        let generoSeleccionado = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex) ?? "Otro"
        let fechaNacimiento = birthDatePicker.date

        if CoreDataManager.shared.existeUsuario(correo: correo) {
            
            AlertaManager.mostrarAlertaCorreoOcupado(en: self)
            
            return
        }

        let paciente = CoreDataManager.shared.crearPaciente(
            nombreCompleto: nombre,
            dni: dni,
            telefono: telefono,
            correo: correo,
            fechaNacimiento: fechaNacimiento,
            genero: generoSeleccionado,
            direccion: direccion
        )

        CoreDataManager.shared.crearUsuarioConPaciente(
            usuario: correo,
            clave: password,
            paciente: paciente
        )

        AlertaManager.mostrarAlertaRegistroUsuExitoso(en: self)
        
        limpiarCampos()
    }
    
    private func limpiarCampos() {
        nameField.text = ""
        dniField.text = ""
        userField.text = ""
        passField.text = ""
        phoneField.text = ""
        addressField.text = ""
        birthDatePicker.date = Date()
        genderSegment.selectedSegmentIndex = 2 // índice "Otro"
        
        nameField.becomeFirstResponder()
    }

}
