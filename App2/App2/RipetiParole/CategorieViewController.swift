//
//  CategorieViewController.swift
//  App2
//
//  Created by Franco Cirillo on 10/03/21.
//

import UIKit

class CategorieViewController: UITableViewController {

    //Array di tutte le categorie di fonemi
    var listaCategoria = [String]()
    var n:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        caricamento()
        
    }
    /*
     Carica il contenuto della lista delle categorie da Localizable.strings
     */
    func caricamento()
    {
        //carica tutte le categorie in un array
        n = Int(NSLocalizedString("numeroCategorie", comment: "")) ?? 0
        
        for i in 0...(n-1){
            listaCategoria.append(NSLocalizedString("categoria\(i+1)", comment: ""))
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaCategoria.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriaCell", for: indexPath) as! CategoriaViewCell

        let categoria=listaCategoria[indexPath.row]
        cell.categoria.text=categoria
        //cell.numero.text=String(indexPath.row+1)
        cell.numero.text=listaCategoria[indexPath.row].prefix(1).description
        
        cell.sfondo.layer.shadowColor = UIColor.black.cgColor
        cell.sfondo.layer.shadowOpacity = 1
        cell.sfondo.layer.shadowOffset = .zero
        cell.sfondo.layer.shadowRadius = 20
        //cell.categoria.setTitle("Categoria "+categoria, for: .normal)
        //cell.sfondo.backgroundColor = cellColorForIndex(indexPath: indexPath)
        //cell.backgroundColor=UIColor(named: "black")
        
        return cell
    }
    /*
    //MARK: Instance Methods
    func cellColorForIndex(indexPath:IndexPath) -> UIColor{
        //cast row and section to CGFloat
        let row = CGFloat(indexPath.row)
        //let section = CGFloat(indexPath.section)
        //compute row as hue and section as saturation
        let alpha  = 1.0 - row / CGFloat(listaCategoria.count)
        var hue=UIColor(named: "Color5")
        //UIColor(named: "Color5")?.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return UIColor(hue: hue!.cgColor as! CGFloat, saturation: 1.0, brightness: 1.0, alpha: alpha)
    }
*/

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
     switch segue.identifier {
     case "livelli":
         if let currentIndex=tableView.indexPathForSelectedRow?.row{
             
            
            //impostare i livelli in base alle categorie
            
            let dstview=segue.destination as! SpeechDetectionViewController
            let categoria=listaCategoria[currentIndex]
            dstview.categoria=categoria
         }
        
     default:
         print(#function)
     }
     
     
     
    }
    

}
