//
//  Indovina.swift
//  App2
//
//  Created by Franco Cirillo on 04/04/21.
//

import UIKit
import AVFoundation

class Indovina: UIViewController {
    
    let defaults = UserDefaults.standard
    var categoria:String!
    var stelleTotali=0
    var tentativi = 0
    var livello : Int=1
    //viene aggiornata in willAppear
    var rispostaGiusta:Int=0
    var newViewController : UIViewController?
    let synthesizer = AVSpeechSynthesizer()
    var player: AVAudioPlayer?
    let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var parola: UILabel!
    @IBOutlet weak var img1: UIButton!
    @IBOutlet weak var img2: UIButton!
    @IBOutlet weak var img3: UIButton!
    @IBOutlet weak var img4: UIButton!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBAction func premi(_ sender: UIButton) {
        //Se non è stato mai premuto aumenta i tentativi
        if sender.layer.borderWidth == 0 {
            tentativi+=1
        }
        
        if sender.tag == rispostaGiusta {
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                self.newViewController = storyBoard.instantiateViewController(withIdentifier: "IndovinaSuperatoViewController") as! IndovinaSuperatoViewController
                //self.newViewController?.isModalInPresentation = true
                //PersistenceManager.fetchData()[0].lastLevel += 1
                self.livello+=1
                let cont = self.newViewController as! IndovinaSuperatoViewController
                //passa la categoria
                cont.categoria=self.categoria
                cont.livello=self.livello
                
                switch self.tentativi {
                case 1:
                    cont.numero = 3
                    cont.stelleTotali=self.stelleTotali+3
                    PersistenceManager.fetchData()[0].points +=  3
                case 2, 3:
                    cont.numero = 2
                    cont.stelleTotali=self.stelleTotali+2
                    PersistenceManager.fetchData()[0].points +=  2
                default:
                    cont.numero = 1
                    cont.stelleTotali=self.stelleTotali+1
                    PersistenceManager.fetchData()[0].points +=  1
                }
                PersistenceManager.saveContext()
                self.navigationController?.pushViewController(self.newViewController!, animated: true)
//                })
        } else {
            //sender.alpha=0.25
            sender.layer.borderWidth = 8
            sender.layer.borderColor = UIColor.red.cgColor
            
            guard let url = Bundle.main.url(forResource: "zapsplat_multimedia_game_sound_wooden_bright_mallet_style_negative_tone_001_62381", withExtension: "mp3") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                /* iOS 10 and earlier require the following line:
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

                guard let player = self.player else { return }

                player.play()

            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        
        }
        catch let error as NSError {
            return print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigation!.title = "Livello \(livello)"
        //Prendo il livello localizzato in base alla stringa
        parola.text = NSLocalizedString("\(categoria ?? "")-level\(livello)", comment: "")
        
        caricaImg()
        //self.image.image = UIImage(named: parola.text ?? "")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Se è il primo livello spiega come funziona il gioco
        if livello==1 && defaults.bool(forKey: "Tutorial"){
            speak("Premi sull'immagine giusta. "+parola.text!)
        } else {
            speak(parola.text!)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        synthesizer.stopSpeaking(at: .immediate)
    }

    func speak(_ msg : String) {
        let utterance = AVSpeechUtterance(string: msg)
       

        utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
        utterance.volume = 1.0
        //utterance.rate = 0.1 velocità di espressione
        
        
        synthesizer.speak(utterance)
    }
    
    func caricaImg(){
        //Contenitori di immagini
        var v:[Int]=[0,0,0,0]
        //Immagini gia usate
        var x=Dictionary<Int, Int>()
        
        var n1 = Int.random(in: 1..<5)
        rispostaGiusta=n1
        switch n1 {
        case 1:
            img1.setBackgroundImage(UIImage(named: parola.text ?? ""), for: UIControl.State.normal)
            v[0]=1
        case 2:
            img2.setBackgroundImage(UIImage(named: parola.text ?? ""), for: UIControl.State.normal)
            v[1]=1
        case 3:
            img3.setBackgroundImage(UIImage(named: parola.text ?? ""), for: UIControl.State.normal)
            v[2]=1
        case 4:
            img4.setBackgroundImage(UIImage(named: parola.text ?? ""), for: UIControl.State.normal)
            v[3]=1
        default:
            print("Errore")
        }
        x[livello]=1
        
        
        
        
        
        for _ in 0...2 {
            n1 = Int.random(in: 1..<5)
            while  v[n1-1] == 1 {
                n1 = Int.random(in: 1..<5)
            }
            var liv=Int.random(in: 1..<Int(NSLocalizedString("\(self.categoria ?? "")-numero", comment: ""))!)
            while  x[liv, default: 0] != 0 {
                liv = Int.random(in: 1..<Int(NSLocalizedString("\(self.categoria ?? "")-numero", comment: ""))!)
            }
            x[liv]=1
            let img=NSLocalizedString("\(categoria ?? "")-level\(liv)", comment: "")
            switch n1 {
            case 1:
                img1.setBackgroundImage(UIImage(named: img), for: UIControl.State.normal)
                v[0]=1
            case 2:
                img2.setBackgroundImage(UIImage(named: img), for: UIControl.State.normal)
                v[1]=1
            case 3:
                img3.setBackgroundImage(UIImage(named: img), for: UIControl.State.normal)
                v[2]=1
            case 4:
                img4.setBackgroundImage(UIImage(named: img), for: UIControl.State.normal)
                v[3]=1
            default:
                print("Errore")
            }
        }
        
        
        
        
        
        
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
