import UIKit
import CoreData
import GoogleMaps

class Mapa_controllers: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapa_vista: GMSMapView!
    
    var contexto: NSManagedObjectContext?
    var coordenadas = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configura_mapa_inicial()
        recupera_lugar()
    }
    
    func configura_mapa_inicial(){
        mapa_vista.delegate = self
        //mapa.mapType = .satellite
    }
    
    func recupera_lugar() {
        let solicitud_busqueda = NSFetchRequest<NSFetchRequestResult>(entityName: "Coordenadas")
        do {
            coordenadas = try contexto!.fetch(solicitud_busqueda)
            mapa_vista.clear()
            if coordenadas.count == 0 {
                Alerta_Mensaje(title: "Disculpa", Mensaje: "No se han guardado lugares aun.")
            } else {
                for item in coordenadas {
                    let coord = item as! NSManagedObject
                    
                    let lat = coord.value(forKey: "latitud") as! Double
                    let long = coord.value(forKey: "longitud") as! Double
                    let dir = coord.value(forKey: "direccion") as! String
                    let otro = coord.value(forKey: "otro") as! String
                    
                    
                    mapa_vista.camera = GMSCameraPosition(latitude: lat, longitude: long, zoom: 16, bearing: 0, viewingAngle: 0)
                   
                    let marcador_mapa = GMSMarker()
                    marcador_mapa.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    marcador_mapa.title = dir
                    
                    marcador_mapa.map = mapa_vista
                }
            }
        } catch {
            Alerta_Mensaje(title: "Error", Mensaje: "Disculpe las molestias, estamos teniendo problemas para recueperar ubicaciones")
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let titulo_market = marker.title!
        
        var indice_encontrado = -1
        var contador = 0
        
        for item in coordenadas {
            let coord = item as! NSManagedObject
            
            let dir = coord.value(forKey: "direccion") as! String
            
            if dir == titulo_market {
                indice_encontrado = contador
            }
            contador += 1
        }
        let alerta_terminos = UIAlertController(title: "Eliminar", message: "Desea eliminar el pin", preferredStyle: UIAlertController.Style.alert)
        
        let boton_alertaOk = UIAlertAction(title: "Simon", style: UIAlertAction.Style.default, handler: {
            _ in
            print("Si")
            do {
                self.contexto?.delete(self.coordenadas[indice_encontrado] as! NSManagedObject)
                try self.contexto?.save()
            } catch {
                print("Error")
            }
            self.recupera_lugar()
        })
        
        let boton_alertaNo = UIAlertAction(title: "Nel", style: UIAlertAction.Style.default, handler: nil)
        
        alerta_terminos.addAction(boton_alertaOk)
        alerta_terminos.addAction(boton_alertaNo)
        
        self.present(alerta_terminos, animated: true, completion: nil)
        
        print(coordenadas[indice_encontrado])
        return false
    }
}
