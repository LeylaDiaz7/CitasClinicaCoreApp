import UIKit

class AlertaManager {
    
    static func mostrarAlertaError(en controlador: UIViewController) {
        mostrarAlerta(
            en: controlador,
            gifName: "alert",
            titulo: "Error",
            mensaje: "Correo o contraseña incorrectos"
        )
    }
    
    static func mostrarAlertaCamposVacios(en controlador: UIViewController) {
        mostrarAlerta(
            en: controlador,
            gifName: "ghost",
            titulo: "Campos vacíos",
            mensaje: "Completar todos los campos."
        )
    }
    
    static func mostrarAlertaCorreoNoValido(en controlador: UIViewController) {
        mostrarAlerta(
            en: controlador,
            gifName: "alert",
            titulo: "Formato de correo inválido.",
            mensaje: "Ingresa un correo electrónico válido (ej. usuario@dominio.com)."
        )
    }
    
    static func mostrarAlertaCorreoOcupado(en controlador: UIViewController) {
        mostrarAlerta(
            en: controlador,
            gifName: "alert",
            titulo: "Error",
            mensaje: "El correo ya está registrado."
        )
    }
    
    static func mostrarAlertaRegistroUsuExitoso(en controlador: UIViewController) {
        mostrarAlerta(
            en: controlador,
            gifName: "success",
            titulo: "Éxito",
            mensaje: "Usuario registrado correctamente."
        )
    }
    
    static func mostrarAlertaRegistroCitaExitoso(en controlador: UIViewController) {
        mostrarAlerta(
            en: controlador,
            gifName: "success",
            titulo: "Éxito",
            mensaje: "Tu cita fue registrada con éxito. \n ¡Te esperamos!"
        )
    }
    
    static func mostrarAlertaActualizacionPerfilExitosa(en controlador: UIViewController) {
        mostrarAlerta(
            en: controlador,
            gifName: "success",
            titulo: "Éxito",
            mensaje: "¡Informaciòn actualizada con éxito!"
        )
    }
    
    private static func mostrarAlerta(en controlador: UIViewController, gifName: String, titulo: String, mensaje: String) {
        let alertaVC = UIViewController()
        alertaVC.modalPresentationStyle = .overCurrentContext
        alertaVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 15
        container.translatesAutoresizingMaskIntoConstraints = false

        let gifView = UIImageView()
        gifView.translatesAutoresizingMaskIntoConstraints = false
        gifView.loadGif(name: gifName)
        container.addSubview(gifView)

        let tituloLabel = UILabel()
        tituloLabel.text = titulo
        tituloLabel.font = .boldSystemFont(ofSize: 16)
        tituloLabel.textAlignment = .center
        tituloLabel.translatesAutoresizingMaskIntoConstraints = false

        let mensajeLabel = UILabel()
        mensajeLabel.text = mensaje
        mensajeLabel.numberOfLines = 0
        mensajeLabel.font = .systemFont(ofSize: 14)
        mensajeLabel.textAlignment = .center
        mensajeLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(tituloLabel)
        container.addSubview(mensajeLabel)
        alertaVC.view.addSubview(container)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: alertaVC.view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: alertaVC.view.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 250),
            container.heightAnchor.constraint(equalToConstant: 230),

            gifView.topAnchor.constraint(equalTo: container.topAnchor, constant: 50),
            gifView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            gifView.widthAnchor.constraint(equalToConstant: 70),
            gifView.heightAnchor.constraint(equalToConstant: 70),

            tituloLabel.topAnchor.constraint(equalTo: gifView.bottomAnchor, constant: 15),
            tituloLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            tituloLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),

            mensajeLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 4),
            mensajeLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            mensajeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
        ])

        controlador.present(alertaVC, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alertaVC.dismiss(animated: true)
        }
    }
}
