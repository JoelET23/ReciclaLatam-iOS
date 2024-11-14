//
//  ViewController.swift
//  ReciclaLatam-iOS
//
//  Created by Joel Elmer Tello on 14/11/24.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        validateCredentials(email: "prueba@demo.com", password: "123456") { isValid, message in
            if isValid {
                print(message ?? "Inicio de sesión exitoso")
            } else {
                print(message ?? "Inicio de sesión fallido")
            }
        }
    }
    
    // URL de la API
    let apiUrl = URL(string: "https://4f6xpxszn6.execute-api.us-east-1.amazonaws.com/items")!

    func validateCredentials(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Manejo de errores
            guard error == nil else {
                completion(false, "Error: \(error!.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP: \(httpResponse.statusCode)")
            }
            
            if let data = data {
                do {
                    // Decodifica el JSON de la respuesta
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let items = jsonResponse["Items"] as? [[String: Any]] {
                        
                        // Busca el usuario en los datos obtenidos
                        for user in items {
                            if let userEmail = user["correo"] as? String,
                               let userPassword = user["password"] as? String,
                               userEmail == email,
                               userPassword == password {
                                
                                // Usuario encontrado
                                completion(true, "Inicio de sesión exitoso para \(user["nombres"] ?? "Usuario")")
                                return
                            }
                        }
                        // Si no se encontró ningún usuario con las credenciales dadas
                        completion(false, "Credenciales incorrectas")
                        
                    } else {
                        completion(false, "Error en el formato de datos")
                    }
                } catch {
                    completion(false, "Error al decodificar JSON: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    

}

