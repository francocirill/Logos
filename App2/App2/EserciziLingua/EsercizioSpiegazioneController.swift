//
//  EsercizioSpiegazioneController.swift
//  App2
//
//  Created by Franco Cirillo on 24/04/21.
//

import UIKit
import AVFoundation

class EsercizioSpiegazioneController: UIViewController {

    var esercizio:String=""
    var secondsRemaining:Int=6
    let defaults = UserDefaults.standard
//    let synthesizer = AVSpeechSynthesizer()

    @IBOutlet var nomeEsercizio: UILabel!
    @IBOutlet weak var descrizione: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        nomeEsercizio.text=esercizio
//        descrizione.text="L’esercizio prevede di toccare il naso con la punta della lingua. È una cosa che non tutti riescono a fare, ma l’importante è che comunque la lingua sia tesa il più possibile verso il naso."
        descrizione.text = NSLocalizedString("\(esercizio)", comment: "")
        descrizione.sizeToFit()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "esercizioLingua":
               
               let dstview=segue.destination as! EsercizioMLController
               let esercizio=self.esercizio
               dstview.esercizio=esercizio
           
        default:
            print(#function)
        }
    }
    

}
