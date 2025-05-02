import UIKit
import CoreData

class MisCitasViewController: UIViewController, UITableViewDataSource {

    var paciente: Paciente!
    private var citas: [CitaMedica] = []
    private let tablaCitas = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis Citas"
        view.backgroundColor = .systemBackground
        
        tablaCitas.translatesAutoresizingMaskIntoConstraints = false
        tablaCitas.dataSource = self
        tablaCitas.register(UITableViewCell.self, forCellReuseIdentifier: "CitaCell")
        view.addSubview(tablaCitas)
        
        NSLayoutConstraint.activate([
            tablaCitas.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tablaCitas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tablaCitas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tablaCitas.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        cargarCitasDelPaciente()
    }
    
    func cargarCitasDelPaciente() {
        guard let pacienteActual = paciente else { return }

        let request: NSFetchRequest<CitaMedica> = CitaMedica.fetchRequest()
        let predicate = NSPredicate(format: "fk_paciente == %@", pacienteActual)
        request.predicate = predicate
        
        do {
            citas = try CoreDataManager.shared.context.fetch(request)
            tablaCitas.reloadData()
        } catch {
            print("Error al cargar las citas: \(error)")
        }
    }

    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cita = citas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitaCell", for: indexPath)
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm"
        cell.textLabel?.text = "\(cita.hora_cita ?? Date()) - \(df.string(from: cita.fecha_Cita ?? Date()))"
        return cell
    }
}
