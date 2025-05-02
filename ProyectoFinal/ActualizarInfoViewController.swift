import UIKit

class ActualizarInfoViewController: UIViewController {

    var correoUsuario: String?

    // Ahora son UITextFields
    private let nombreField = UITextField()
    private let dniField = UITextField()
    private let correoField = UITextField()

    private let telefonoField = UITextField()
    private let direccionField = UITextField()
    private let fechaField = UITextField()

    private let guardarButton = UIButton()

    private var paciente: Paciente?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mi Perfil"
        view.backgroundColor = .systemBackground

        setupViews()
        cargarDatos()
    }

    private func setupViews() {
        let labels = ["Nombre", "DNI", "Correo", "Teléfono", "Dirección", "Fecha Nacimiento"]
        let campos = [nombreField, dniField, correoField, telefonoField, direccionField, fechaField]

        for campo in campos {
            campo.borderStyle = .roundedRect
            campo.translatesAutoresizingMaskIntoConstraints = false
            campo.heightAnchor.constraint(equalToConstant: 40).isActive = true
            campo.applyNeumorphicEffect() // aplicando extension
            campo.backgroundColor = .systemBackground
        }

        // Desactivar edición en campos no editables
        [nombreField, dniField, correoField, fechaField].forEach {
            $0.isEnabled = false
            $0.textColor = .gray
            $0.applyNeumorphicEffect() // aplicando extension

        }

        guardarButton.setTitle("Guardar Cambios", for: .normal)
        guardarButton.backgroundColor = UIColor(hex:  "#314975")
        guardarButton.layer.cornerRadius = 8
        guardarButton.translatesAutoresizingMaskIntoConstraints = false
        guardarButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        guardarButton.addTarget(self, action: #selector(guardarCambios), for: .touchUpInside)

        // Stack vertical con etiquetas y campos
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        for (i, labelText) in labels.enumerated() {
            let label = UILabel()
            label.text = labelText
            label.font = .systemFont(ofSize: 14, weight: .semibold)

            stack.addArrangedSubview(label)
            stack.addArrangedSubview(campos[i])
        }

        stack.addArrangedSubview(guardarButton)

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
    }

    private func cargarDatos() {
        guard let correo = correoUsuario else {
            print("Correo no disponible")
            return
        }

        guard let paciente = CoreDataManager.shared.obtenerPacientePorCorreo(correo: correo) else {
            print("Paciente no encontrado")
            return
        }

        self.paciente = paciente

        nombreField.text = paciente.nombres
        dniField.text = paciente.dni
        correoField.text = paciente.correo
        telefonoField.text = paciente.telefono
        direccionField.text = paciente.direccion

        if let fecha = paciente.fechaNacimiento {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            fechaField.text = formatter.string(from: fecha)
        }
    }

    @objc private func guardarCambios() {
        guard let paciente = paciente else { return }

        paciente.telefono = telefonoField.text
        paciente.direccion = direccionField.text

        CoreDataManager.shared.guardarCambios()

        AlertaManager.mostrarAlertaActualizacionPerfilExitosa(en: self)
    }
    
}
