//
//  EsercizioController.swift
//  App2
//
//  Created by Franco Cirillo on 20/03/21.
//

import UIKit
import AVFoundation

class EsercizioController: UIViewController {
    
    var esercizio:String=""
    var secondsRemaining:Int=6
    let defaults = UserDefaults.standard
    var tim:Timer?=nil
    let synthesizer = AVSpeechSynthesizer()

    @IBOutlet var nomeEsercizio: UILabel!
    @IBOutlet weak var descrizione: UILabel!
    @IBOutlet weak var immagine: UIImageView!
    @IBOutlet weak var tempo: UILabel!
    @IBOutlet weak var timer: UIButton!
    @IBAction func avviaTimer(_ sender: UIButton) {
        timer.isHidden=true
        self.tempo.text=("\(self.secondsRemaining) secondi")
        secondsRemaining-=1
        tim=Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                if self.secondsRemaining > 0 {
                    self.tempo.text=("\(self.secondsRemaining) secondi")
                    self.secondsRemaining -= 1
                } else {
                    Timer.invalidate()
                    self.tempo.text=("Hai terminato")
                    //aggiorna statistiche
                    print("aggiorna volte")
                    let volte = self.defaults.integer(forKey: "\(self.esercizio)-volte")
                    self.defaults.set(volte+1, forKey: "\(self.esercizio)-volte")
                    
                }
            }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        nomeEsercizio.text=esercizio
//        descrizione.text="L’esercizio prevede di toccare il naso con la punta della lingua. È una cosa che non tutti riescono a fare, ma l’importante è che comunque la lingua sia tesa il più possibile verso il naso."
        descrizione.text = NSLocalizedString("\(esercizio)", comment: "")
        descrizione.sizeToFit()
        immagine.image=UIImage(named: esercizio)
        
        speak(NSLocalizedString("\(esercizio)", comment: ""))
        
        
    }
    /*
     Riproduce la parola da pronunciare
     */
    func speak(_ msg : String) {
        let utterance = AVSpeechUtterance(string: msg)
       

        utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
        utterance.volume = 1.0
        utterance.rate = 0.4
        
        
        synthesizer.speak(utterance)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        tim?.invalidate()
        synthesizer.stopSpeaking(at: .immediate)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
