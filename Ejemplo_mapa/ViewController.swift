//
//  ViewController.swift
//  Ejemplo_mapa
//
//  Created by Hansel on 28/10/21.
//

import UIKit
import CoreData
import GooglePlaces

class ViewController: UIViewController, GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet weak var textBuscar: UITextField!
    @IBOutlet weak var textLatitud: UITextField!
    @IBOutlet weak var textLongitud: UITextField!
    
    var contexto: NSManagedObjectContext?
    var dir = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contexto = obtener_contexto_core_data()
    }

    @IBAction func btnGuardarPress(_ sender: Any) {
        if textLatitud.text == "" || textLongitud.text == "" {
            Alerta_Mensaje(title: "Atencion", Mensaje: "Se requiere llenar mas datos")
        } else {
            let latitud = Double(textLatitud.text!)
            let longitud = Double(textLongitud.text!)
            
            do {
                let nuevo_objeto = NSEntityDescription.insertNewObject(forEntityName: "Coordenadas", into: contexto!)
                nuevo_objeto.setValue(latitud, forKey: "latitud")
                nuevo_objeto.setValue(longitud, forKey: "longitud")
                nuevo_objeto.setValue(dir, forKey: "direccion")
                nuevo_objeto.setValue("", forKey: "otro")
                
                try contexto!.save()
                
            } catch {
                print("Error")
            }
            
            textLatitud.text = String()
            textLongitud.text = String()
            textBuscar.text = String()
            dir = String()
        }
    }
    
    @IBAction func btnVerMapaPress(_ sender: Any) {
        performSegue(withIdentifier: "conexion_mapa", sender: contexto)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nueva_pantalla: Mapa_controllers = segue.destination as! Mapa_controllers
        
        nueva_pantalla.contexto = sender as? NSManagedObjectContext
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        textLatitud.text = "\(place.coordinate.latitude)"
        textLongitud.text = "\(place.coordinate.longitude)"
        dir = place.formattedAddress!
        textBuscar.text = dir
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func autocompletado(_ sender: UITextField) {
        sender.resignFirstResponder()
        
        let controlador_autocompletador = GMSAutocompleteViewController()
        controlador_autocompletador.delegate = self
        
        present(controlador_autocompletador, animated: true, completion: nil)
    }
    
}

