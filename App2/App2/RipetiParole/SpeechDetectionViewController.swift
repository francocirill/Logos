//
//  SpeechDetectionViewController.swift
//  App2
//
//  Created by Franco Cirillo on 15/02/21.
//

import UIKit
import Speech
import AVFoundation

class SpeechDetectionViewController: UIViewController, SFSpeechRecognizerDelegate{

    @IBOutlet weak var saltaButton: UIButton!
    @IBAction func salta(_ sender: UIButton) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            self.newViewController = storyBoard.instantiateViewController(withIdentifier: "LivelloSuperatoViewController") as! LivelloSuperatoViewController
            //self.newViewController?.isModalInPresentation = true
            //PersistenceManager.fetchData()[0].lastLevel += 1
            self.livello+=1
            let cont = self.newViewController as! LivelloSuperatoViewController
            //passa la categoria
            cont.categoria=self.categoria
            cont.livello=self.livello
            cont.stelleTotali=self.stelleTotali
            self.navigationController?.pushViewController(self.newViewController!, animated: true)
//            })
    }
    
    let defaults = UserDefaults.standard
    let synthesizer = AVSpeechSynthesizer()
    var categoria:String!
    var stelleTotali=0
    @IBOutlet weak var rip: UILabel!
    
    var player: AVAudioPlayer?
    
    @IBAction func backHome(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "backHomeFromLevel", sender: self)
    }
    @IBOutlet weak var navigation: UINavigationItem!
    let audioEngine = AVAudioEngine()
    @IBOutlet weak var microphone: UIButton!
    //Riconoscimento vocale
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "it-IT"))
    var user : UserProfile! = nil
    var request = SFSpeechAudioBufferRecognitionRequest()
    var isRecording = false
    //Gestire il riconoscimento
    var recognitionTask: SFSpeechRecognitionTask?
    @IBOutlet weak var frase: UILabel!
    @IBOutlet weak var ripeti: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBAction func ripetiTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.speak(self.frase.text ?? "errore")
        }
    }
    var newViewController : UIViewController?
    
    var tentativi = 0
    var livello : Int=1
    //Indica se la funzione puo verificare che la parola pronunciata è giusta, si puo verificare una volta per volta che si preme il pulsante
    var puoVerificare:Int=0
    @IBAction func pronuncia(_ sender: Any) {
        if isRecording {
            //mostra salta
            saltaButton.isHidden=false
            
            request.endAudio() // Added line to mark end of recording
            audioEngine.stop()

            let node = audioEngine.inputNode
            node.removeTap(onBus: 0)
            recognitionTask?.cancel()
            
            microphone.setImage(UIImage(named: "mic_spento"), for: .normal)
            isRecording = false
            //startButton.backgroundColor = UIColor.gray

            } else {
                //nascondi salta
                saltaButton.isHidden=true
                
                puoVerificare=0
                
                self.pronunciata.textColor = UIColor.white
                let audioSession = AVAudioSession.sharedInstance();
                do {
                    try audioSession.setCategory (AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.mixWithOthers);
                    try  audioSession.setActive (true);
                }
                catch let error as NSError {
                    return print(error)
                }
                self.recordAndRecognizeSpeech()
                isRecording = true
                microphone.setImage(UIImage(named: "mic_acceso"), for: .normal)
               // startButton.backgroundColor = UIColor.red
            }
    }
    
    
    
    @IBOutlet weak var ripetiButton: UIButton!
    
    //text to speech
    @IBOutlet weak var pronunciata: UILabel!
    
    
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
    /*
     Imposta la pulsazione per la voce che ripete la parola
     */
    @objc func pulseRipetiButton() {
        if PersistenceManager.fetchData()[0].outLoud {
            let pulse = Pulsing(numberOfPulses: 2, radius: 50, position: ripetiButton.center)
            pulse.animationDuration = 0.8
            pulse.backgroundColor = UIColor(named: "Color2")?.cgColor
            
            self.view.layer.insertSublayer(pulse, below: ripetiButton.layer)
        }
    }
    /*
     Imposta la pulsazione per il microfono
     */
    @objc func addPulse(){
        let pulse = Pulsing(numberOfPulses: 1, radius: 110, position: microphone.center)
        pulse.animationDuration = 0.8
        pulse.backgroundColor = UIColor(named: "Color3")?.cgColor
        
        self.view.layer.insertSublayer(pulse, below: microphone.layer)
    }
    /*
     Riproduce la parola da pronunciare
     */
    func speak(_ msg : String) {
        let utterance = AVSpeechUtterance(string: msg)
       

        utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
        utterance.volume = 1.0
        //utterance.rate = 0.1 velocità di espressione
        
        
        synthesizer.speak(utterance)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //mostra la categoria
        rip.text="Categoria "+categoria
        //dovrei ricominciare da capo i livelli
        //livello = Int(PersistenceManager.fetchData()[0].lastLevel + 1)
        user = PersistenceManager.fetchData()[0]
        image.isHidden = !user.showPics
        ripetiButton.isHidden = !user.outLoud
        self.navigation!.title = "Livello \(livello)"
        //Prendo il livello localizzato in base alla stringa
        frase.text = NSLocalizedString("\(categoria ?? "")-level\(livello)", comment: "")
        self.image.image = UIImage(named: frase.text ?? "")
        
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.pulseRipetiButton), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Se è il primo livello spiega come funziona il gioco
        if livello==1 && defaults.bool(forKey: "Tutorial"){
            speak("Premi il microfono e ripeti la parola, se sbagli premi due volte il microfono e ripeti. "+frase.text!)
        } else {
            speak(frase.text!)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    /*
     Riconosce le parole pronunciate e le confronta con quelle da pronunciare
     */
    func recordAndRecognizeSpeech(){
        print("Sono entrato nella funzione")
        let node = audioEngine.inputNode //else { return }
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()

        request = SFSpeechAudioBufferRecognitionRequest()
        do{
            try audioEngine.start()
        }catch {
            return print(error)
        }
        print("prima di recognition task ")
        var trovata=0
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            print("Sono entrato in recognizer")
            if result != nil && trovata==0 && self.puoVerificare==0 { // check to see if result is empty (i.e. no speech found)
                    print("Sono entrato in res!=nil")
                    if let result = result {
                        print("Sono entrato in res=res")
                        self.addPulse()
//                        self.pronunciata.text = (result.transcriptions[0].segments[0].substring).lowercased()
                        self.pronunciata.text = (result.bestTranscription.segments[0].substring).lowercased()
                        
//                        if (result.transcriptions[0].segments.count) == 1 {
                        if (result.bestTranscription.segments.count) == 1 {
                            print("Sono entrato in trascrizione=1")
                            self.tentativi += 1
                           // print(String(result.transcriptions[0].segments[0].confidence * 100) + "%" )
                            
                            self.audioEngine.stop()
//                            DispatchQueue.main.async { [unowned self] in
//                            guard let task = self.recognitionTask else {
//                                        fatalError("Error")
//                                    }
//                                    task.cancel()
//                                    task.finish()
//                                }
                            //Non puo piu verificare finché non riavvia il microfono
                            self.puoVerificare=1
                            //Se chiami cancel troppe volte da problemi
                            if ((self.recognitionTask) != nil) {
                                    //[self.recognitionTask cancel];
                                self.recognitionTask?.finish()
                                print("Sono entrato in task cancellato")
                                }
                                self.recognitionTask = nil;
                            
                            if self.frase.text?.lowercased() == self.pronunciata.text {
                                
                                trovata=1
                                print("Sono entrato in parole uguali")
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                    print("Sono entrato in async per il segue")
                                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    self.newViewController = storyBoard.instantiateViewController(withIdentifier: "LivelloSuperatoViewController") as! LivelloSuperatoViewController
                                    //self.newViewController?.isModalInPresentation = true
                                    //PersistenceManager.fetchData()[0].lastLevel += 1
                                    self.livello+=1
                                    let cont = self.newViewController as! LivelloSuperatoViewController
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
                                    })
                            } else {
                                
                                self.pronunciata.textColor = UIColor.red
                                let animation = CABasicAnimation(keyPath: "position")
                                animation.duration = 0.1
                                animation.repeatCount = 5
                                animation.autoreverses = true
                                animation.fromValue = NSValue(cgPoint: CGPoint(x: self.pronunciata.center.x-10, y: self.pronunciata.center.y))
                                animation.toValue = NSValue(cgPoint: CGPoint(x: self.pronunciata.center.x+10, y: self.pronunciata.center.y))

                                self.pronunciata.layer.add(animation, forKey: "position")
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
                                
                    } else if let error = error {
                        print(error)
                    }
                }
                }
            })
        
    }
    

}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Tentativi \(tentativi)")
        if let controller = newViewController {
            let cont = controller as! LivelloSuperatoViewController
            switch tentativi {
            case 1:
                cont.numero = 3
            case 2, 3:
                cont.numero = 2
            default:
                cont.numero = 1
            }
        }/*
        switch segue.identifier {
        case "showAvatar" :
            let dstView = segue.destination as! CollectionViewController
            dstView.user = userProfile
        default: print(#function)
            
        }

    }
    

 }*/*/
