//
//  extension_mapa_core.swift
//  Ejemplo_mapa
//
//  Created by Hansel on 28/10/21.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    
    func obtener_contexto_core_data() -> NSManagedObjectContext {
        let contexto = UIApplication.shared.delegate as! AppDelegate
        return contexto.persistentContainer.viewContext
    }
    
}
