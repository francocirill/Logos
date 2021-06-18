//
//  StatisticheViewController.swift
//  App2
//
//  Created by Franco Cirillo on 14/03/21.
//

import UIKit

class StatisticheRipetiViewController: UITableViewController {

    //Array di tutte le categorie di fonemi
    var listaCategoria = [String]()
    var n:Int=0
    let defaults = UserDefaults.standard
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "statisticheRipetiCell", for: indexPath) as! StatisticheRipetiViewCell

        let categoria=listaCategoria[indexPath.row]
        cell.categoria.text=categoria
        let perc = (defaults.double(forKey: "\(categoria)-percentuale")*100).rounded()/100
        cell.percentuale.text=perc.description+"/3"
        
        if perc>=2 {
            cell.stella.image=UIImage(named: "stella verde")
        } else if perc>=1 {
            cell.stella.image=UIImage(named: "stella piena")
        } else {
            cell.stella.image=UIImage(named: "stella rossa")
        }
        

        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData() 
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
