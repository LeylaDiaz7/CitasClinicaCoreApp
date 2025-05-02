import UIKit
import CoreData

class RegistrarCitaViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    private let especialidadTextField = UITextField()
    private let medicoTextField = UITextField()
    private let horarioTextField = UITextField()

    private let especialidadPicker = UIPickerView()
    private let medicoPicker = UIPickerView()
    private let horarioPicker = UIPickerView()

    private var especialidades: [Especialidad] = []
    private var medicosFiltrados: [Medico] = []
    private var horariosFiltrados: [HorarioMedico] = []

    var pacienteActual: Paciente!  // Asegúrate de asignar este valor al momento de crear esta vista

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Agendar"
        view.backgroundColor = .systemBackground

        configurarTextFields()
        configurarBotonRegistrar()
        configurarPickers()

        cargarEspecialidades()
    }

    private func configurarTextFields() {
        
        let especialidadLabel = UILabel()
        especialidadLabel.text = "Especialidad"
        especialidadLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(especialidadLabel)
        
        let medicoLabel = UILabel()
        medicoLabel.text = "Médico"
        medicoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(medicoLabel)
        
        let horarioLabel = UILabel()
        horarioLabel.text = "Horario"
        horarioLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horarioLabel)

        // Configurar los campos de texto
        especialidadTextField.inputView = especialidadPicker
        medicoTextField.inputView = medicoPicker
        horarioTextField.inputView = horarioPicker

        [especialidadTextField, medicoTextField, horarioTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        // Configurar las restricciones de las etiquetas y los campos de texto
        NSLayoutConstraint.activate([
            // Etiqueta Especialidad
            especialidadLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            especialidadLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Campo de texto Especialidad
            especialidadTextField.topAnchor.constraint(equalTo: especialidadLabel.bottomAnchor, constant: 8),
            especialidadTextField.leadingAnchor.constraint(equalTo: especialidadLabel.leadingAnchor),
            especialidadTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Etiqueta Médico
            medicoLabel.topAnchor.constraint(equalTo: especialidadTextField.bottomAnchor, constant: 20),
            medicoLabel.leadingAnchor.constraint(equalTo: especialidadLabel.leadingAnchor),
            
            // Campo de texto Médico
            medicoTextField.topAnchor.constraint(equalTo: medicoLabel.bottomAnchor, constant: 8),
            medicoTextField.leadingAnchor.constraint(equalTo: medicoLabel.leadingAnchor),
            medicoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Etiqueta Horario
            horarioLabel.topAnchor.constraint(equalTo: medicoTextField.bottomAnchor, constant: 20),
            horarioLabel.leadingAnchor.constraint(equalTo: medicoLabel.leadingAnchor),
            
            // Campo de texto Horario
            horarioTextField.topAnchor.constraint(equalTo: horarioLabel.bottomAnchor, constant: 8),
            horarioTextField.leadingAnchor.constraint(equalTo: horarioLabel.leadingAnchor),
            horarioTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configurarBotonRegistrar() {
        let botonRegistrar = UIButton(type: .system)
        botonRegistrar.setTitle("Registrar Cita", for: .normal)
        botonRegistrar.translatesAutoresizingMaskIntoConstraints = false
        botonRegistrar.addTarget(self, action: #selector(registrarCita), for: .touchUpInside)
        view.addSubview(botonRegistrar)

        botonRegistrar.topAnchor.constraint(equalTo: horarioTextField.bottomAnchor, constant: 30).isActive = true
        botonRegistrar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func configurarPickers() {
        especialidadPicker.dataSource = self
        especialidadPicker.delegate = self
        medicoPicker.dataSource = self
        medicoPicker.delegate = self
        horarioPicker.dataSource = self
        horarioPicker.delegate = self
    }

    private func cargarEspecialidades() {
        let request: NSFetchRequest<Especialidad> = Especialidad.fetchRequest()
        do {
            especialidades = try CoreDataManager.shared.context.fetch(request)
            especialidadPicker.reloadAllComponents()
            if let primera = especialidades.first {
                cargarMedicos(especialidad: primera)
            }
        } catch {
            print("Error al cargar especialidades: \(error)")
        }
    }

    private func cargarMedicos(especialidad: Especialidad) {
        if let medicos = especialidad.fk_medico?.allObjects as? [Medico] {
            medicosFiltrados = medicos
            medicoPicker.reloadAllComponents()
            if let primero = medicos.first {
                cargarHorarios(medico: primero)
            } else {
                horariosFiltrados = []
                horarioPicker.reloadAllComponents()
            }
        }
    }

    private func cargarHorarios(medico: Medico) {
        if let horarios = medico.fk_horarioMedico?.allObjects as? [HorarioMedico] {
            horariosFiltrados = horarios
        } else {
            horariosFiltrados = []
        }
        horarioPicker.reloadAllComponents()
    }

    // Función registrarCita para limpiar los campos y desactivar la selección.
    @objc func registrarCita() {
        guard !especialidades.isEmpty, !medicosFiltrados.isEmpty, !horariosFiltrados.isEmpty else {
            print("Faltan datos para registrar cita.")
            return
        }

        let medico = medicosFiltrados[medicoPicker.selectedRow(inComponent: 0)]
        let horario = horariosFiltrados[horarioPicker.selectedRow(inComponent: 0)]

        let context = CoreDataManager.shared.context
        let nuevaCita = CitaMedica(context: context)
        nuevaCita.id_Cita = UUID()
        nuevaCita.fecha_Cita = Date()
        nuevaCita.hora_cita = horario.hora_inicio
        nuevaCita.estado = "Programada"
        nuevaCita.fk_medico = medico
        nuevaCita.fk_paciente = pacienteActual

        do {
            try context.save()
            mostrarAlertaExito()
        } catch {
            print("❌ Error al guardar cita: \(error)")
        }
    }
    
    // Función para mostrar la alerta y limpiar los campos
    private func mostrarAlertaExito() {
        let alertaVC = UIViewController()
        alertaVC.modalPresentationStyle = .overCurrentContext
        alertaVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false

        let gifView = UIImageView()
        gifView.translatesAutoresizingMaskIntoConstraints = false
        gifView.loadGif(name: "success")
        container.addSubview(gifView)

        let tituloLabel = UILabel()
        tituloLabel.text = "Cita Registrada"
        tituloLabel.font = .boldSystemFont(ofSize: 16)
        tituloLabel.textAlignment = .center
        tituloLabel.translatesAutoresizingMaskIntoConstraints = false

        let mensajeLabel = UILabel()
        mensajeLabel.text = "Tu cita fue registrada con éxito."
        mensajeLabel.numberOfLines = 0
        mensajeLabel.font = .systemFont(ofSize: 14)
        mensajeLabel.textAlignment = .center
        mensajeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let mensajeLabel2 = UILabel()
        mensajeLabel2.text = "¡Te esperamos!"
        mensajeLabel2.numberOfLines = 0
        mensajeLabel2.font = .systemFont(ofSize: 14)
        mensajeLabel2.textAlignment = .center
        mensajeLabel2.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(tituloLabel)
        container.addSubview(mensajeLabel)
        container.addSubview(mensajeLabel2)

        alertaVC.view.addSubview(container)

        // Constraints
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: alertaVC.view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: alertaVC.view.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 250),
            container.heightAnchor.constraint(equalToConstant: 250),

            gifView.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
            gifView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            gifView.widthAnchor.constraint(equalToConstant: 150),
            gifView.heightAnchor.constraint(equalToConstant: 150),

            tituloLabel.topAnchor.constraint(equalTo: gifView.bottomAnchor, constant: 10),
            tituloLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            tituloLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),

            mensajeLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 4),
            mensajeLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            mensajeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            
            mensajeLabel2.topAnchor.constraint(equalTo: mensajeLabel.bottomAnchor, constant: 4),
            mensajeLabel2.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            mensajeLabel2.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            mensajeLabel2.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -15)
        ])

        present(alertaVC, animated: true)

        // Cierra después de 2 segundos y limpia los campos
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alertaVC.dismiss(animated: true) {
                // Limpiar campos
                self.limpiarCampos()
            }
        }
    }

    // Función para limpiar los campos
    private func limpiarCampos() {
        especialidadTextField.text = ""
        medicoTextField.text = ""
        horarioTextField.text = ""

        especialidadPicker.selectRow(0, inComponent: 0, animated: false)
        medicoPicker.selectRow(0, inComponent: 0, animated: false)
        horarioPicker.selectRow(0, inComponent: 0, animated: false)

        especialidadTextField.resignFirstResponder()
        medicoTextField.resignFirstResponder()
        horarioTextField.resignFirstResponder()
    }
    
    // MARK: PickerView delegates

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case especialidadPicker: return especialidades.count
        case medicoPicker: return medicosFiltrados.count
        case horarioPicker: return horariosFiltrados.count
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case especialidadPicker: return especialidades[row].nombre
        case medicoPicker: return medicosFiltrados[row].nombres
        case horarioPicker: return horariosFiltrados[row].dia_semana
        default: return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case especialidadPicker:
            let especialidadSeleccionada = especialidades[row]
            especialidadTextField.text = especialidadSeleccionada.nombre
            cargarMedicos(especialidad: especialidadSeleccionada)
        case medicoPicker:
            let medicoSeleccionado = medicosFiltrados[row]
            medicoTextField.text = medicoSeleccionado.nombres
            cargarHorarios(medico: medicoSeleccionado)
        case horarioPicker:
            let horarioSeleccionado = horariosFiltrados[row]
            horarioTextField.text = horarioSeleccionado.dia_semana
        default:
            break
        }
    }
}
