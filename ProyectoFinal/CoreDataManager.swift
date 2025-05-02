import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func save() {
        do {
            try context.save()
        } catch {
            print("❌ Error al guardar: \(error.localizedDescription)")
        }
    }

    // MARK: - Crear Usuario con su Paciente
    func crearUsuarioConPaciente(usuario: String, clave: String, paciente: Paciente) {
        let nuevoUsuario = Usuario(context: context)
        nuevoUsuario.id_usuario = UUID()
        nuevoUsuario.usuario = usuario
        nuevoUsuario.clave = clave
        nuevoUsuario.fecha_registro = Date()
        nuevoUsuario.fk_paciente = paciente
        save()
    }

    // MARK: - Validar Usuario
    func validarUsuario(usuario: String, clave: String) -> Usuario? {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "usuario == %@ AND clave == %@", usuario, clave)
        return (try? context.fetch(request).first)
    }

    // MARK: - Crear Paciente
    func crearPaciente(nombreCompleto: String, dni: String, telefono: String, correo: String, fechaNacimiento: Date, genero: String, direccion: String) -> Paciente {
        let paciente = Paciente(context: context)
        paciente.id_paciente = UUID()
        paciente.nombres = nombreCompleto
        paciente.dni = dni
        paciente.telefono = telefono
        paciente.correo = correo
        paciente.fechaNacimiento = fechaNacimiento
        paciente.genero = genero
        paciente.direccion = direccion
        save()
        return paciente
    }
    
    func obtenerPacienteActual() -> Paciente? {
        // Aquí puedes usar el usuario logueado para obtener su paciente
        // Por ejemplo, usando UserDefaults o sesión actual
        let request: NSFetchRequest<Paciente> = Paciente.fetchRequest()
        // Aplica un filtro si tienes lógica de sesión
        return try? context.fetch(request).first
    }

    func guardarCambios() {
        do {
            try context.save()
        } catch {
            print("Error al guardar cambios en CoreData: \(error.localizedDescription)")
        }
    }
    
    func obtenerPacientePorCorreo(correo: String) -> Paciente? {
        let fetchRequest: NSFetchRequest<Paciente> = Paciente.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "correo == %@", correo)
        
        do {
            let resultados = try context.fetch(fetchRequest)
            return resultados.first
        } catch {
            print("Error al obtener paciente por correo: \(error)")
            return nil
        }
    }



}

// MARK: - Datos Iniciales: Especialidades y Médicos
extension CoreDataManager {
    func cargarDatosIniciales() {
        let fetch: NSFetchRequest<Especialidad> = Especialidad.fetchRequest()
        let count = (try? context.count(for: fetch)) ?? 0
        if count > 0 { return }

        let especialidades = ["Cardiología", "Dermatología", "Neurología"]
        for nombre in especialidades {
            let esp = Especialidad(context: context)
            esp.id_especialidad = UUID()
            esp.nombre = nombre
            esp.descripcion = "Área médica de \(nombre)"
        }
        save()
        cargarMedicos()
    }

    func cargarMedicos() {
        guard let especialidades = try? context.fetch(Especialidad.fetchRequest()) as? [Especialidad] else { return }

        for especialidad in especialidades {
            for i in 1...2 {
                let medico = Medico(context: context)
                medico.id_medico = UUID()
                medico.nombres = "Dr. \(especialidad.nombre!) \(i)"
                medico.cmp = "CMP-\(Int.random(in: 1000...9999))"
                medico.telefono = "999999\(i)"
                medico.correo = "dr\(i)@medico.com"
                medico.fk_especialidad = especialidad
            }
        }
        save()
    }

    func obtenerEspecialidades() -> [Especialidad] {
        (try? context.fetch(Especialidad.fetchRequest())) ?? []
    }

    func obtenerMedicosPorEspecialidad(especialidad: Especialidad) -> [Medico] {
        let request: NSFetchRequest<Medico> = Medico.fetchRequest()
        request.predicate = NSPredicate(format: "especialidad == %@", especialidad)
        return (try? context.fetch(request)) ?? []
    }

    func obtenerHorariosDeMedico(medico: Medico) -> [HorarioMedico] {
        let request: NSFetchRequest<HorarioMedico> = HorarioMedico.fetchRequest()
        request.predicate = NSPredicate(format: "medico == %@", medico)
        return (try? context.fetch(request)) ?? []
    }
    
    func existeUsuario(correo: String) -> Bool {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "usuario == %@", correo)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error verificando usuario existente: \(error.localizedDescription)")
            return false
        }
    }

}

func insertarDatosDePrueba() {
    let context = CoreDataManager.shared.context

    // Verificamos si ya existen especialidades para evitar duplicados
    let fetchRequest: NSFetchRequest<Especialidad> = Especialidad.fetchRequest()
    if let count = try? context.count(for: fetchRequest), count > 0 {
        print("Ya existen datos, no se insertarán duplicados.")
        return
    }

    // Crear Especialidades
    let esp1 = Especialidad(context: context)
    esp1.id_especialidad = UUID()
    esp1.nombre = "Cardiología"
    esp1.descripcion = "Problemas del corazón"

    let esp2 = Especialidad(context: context)
    esp2.id_especialidad = UUID()
    esp2.nombre = "Pediatría"
    esp2.descripcion = "Salud infantil"

    let esp3 = Especialidad(context: context)
    esp3.id_especialidad = UUID()
    esp3.nombre = "Dermatología"
    esp3.descripcion = "Cuidado de la piel"

    // Crear Médicos
    let nombresMedicos = [
        ("Dr. Juan Pérez", esp1),
        ("Dra. Luisa Ramos", esp2),
        ("Dr. Mario Gómez", esp3),
        ("Dra. Carla Silva", esp1),
        ("Dr. José Chávez", esp2)
    ]

    var medicos: [Medico] = []

    for (nombre, especialidad) in nombresMedicos {
        let medico = Medico(context: context)
        medico.id_medico = UUID()
        medico.nombres = nombre
        medico.cmp = "CMP\(Int.random(in: 1000...9999))"
        medico.telefono = "999-888-777"
        medico.correo = "\(nombre.replacingOccurrences(of: " ", with: "").lowercased())@clinica.com"
        medico.fk_especialidad = especialidad
        medicos.append(medico)
    }

    // Crear Horarios (1 por médico)
    let dias = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"]
    let formatoHora = DateFormatter()
    formatoHora.dateFormat = "HH:mm"

    for (i, medico) in medicos.enumerated() {
        let horario = HorarioMedico(context: context)
        horario.id_horario = UUID()
        horario.dia_semana = dias[i % dias.count]
        horario.hora_inicio = formatoHora.date(from: "09:00")!
        horario.hora_fin = formatoHora.date(from: "13:00")!
        horario.fk_medico = medico
    }

    do {
        try context.save()
        print("Datos de prueba insertados correctamente.")
    } catch {
        print("Error al guardar datos de prueba: \(error)")
    }
}
