//
//  Funciones_Generales.swift
//  Viajes
//
//  Created by user205705 on 9/24/21.
//

import Foundation
import UIKit

extension UIViewController
{
    func quitar_barra_navegacion(){
        self.navigationController?.navigationBar.isHidden = true
    }
    func agregar_barra_navegacion(){
        self.navigationController?.navigationBar.isHidden = false
    }
    func Alerta_Mensaje(title: String, Mensaje: String)
    {
        let Mensaje_alerta = UIAlertController(title: title, message: Mensaje, preferredStyle: UIAlertController.Style.alert)
        
        let BotonAlertaOk = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        Mensaje_alerta.addAction(BotonAlertaOk)
        
        self.present(Mensaje_alerta, animated: true, completion:nil)
    }
    
}
