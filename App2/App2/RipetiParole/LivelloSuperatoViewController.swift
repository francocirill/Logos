//
//  LivelloSuperatoViewController.swift
//  App2
//
//  Created by Marco Venere on 16/02/21.
//

import UIKit
import AVFoundation

class LivelloSuperatoViewController: UIViewController {
    var categoria:String!
    var livello:Int=1
    let defaults = UserDefaults.standard
    var stelleTotali=0
    @IBOutlet weak var congratulazioni: UILabel!
    @IBOutlet weak var finito: UILabel!
    @IBOutlet weak var stella1: UIImageView!
    @IBOutlet weak var stella2: UIImageView!
    @IBOutlet weak var stella3: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var avatarImage: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var player: AVAudioPlayer?
    var numero : Int = 0
    var user : UserProfile!
    @IBOutlet weak var avantiButton: UIButton!
    @IBAction func avanti(_ sender: Any) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController:UIViewController
            let nlivelli=Int(NSLocalizedString("\(self.categoria ?? "")-numero", comment: ""))
            if self.livello==(nlivelli!+1) {
                
                 newViewController = storyBoard.instantiateViewController(withIdentifier: "CategorieViewController") as! CategorieViewController
                //newViewController.isModalInPresentation = true
                self.navigationController?.pushViewController(newViewController, animated: true)
                
            } else{
                 newViewController = storyBoard.instantiateViewController(withIdentifier: "SpeechDetectionViewController") as! SpeechDetectionViewController
                let c=newViewController as! SpeechDetectionViewController
                c.categoria=self.categoria
                c.livello=self.livello
                c.stelleTotali=self.stelleTotali
                //self.newViewController?.isModalInPresentation = true
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
//        })
    }
    @IBOutlet weak var starsConstraint: NSLayoutConstraint!
    @IBAction func backHome(_ sender: Any) {
            performSegue(withIdentifier: "backHomeFromLevel", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false;
        user = PersistenceManager.fetchData()[0]
        avatarImage.setImage(UIImage(named: user.avatar!), for: .normal)
        nameLabel.text = "\(user.name!)!"
        let audioSession = AVAudioSession.sharedInstance();
        do {
            try audioSession.setCategory (AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.mixWithOthers);
            try  audioSession.setActive (true);
        
        }
        catch let error as NSError {
            return print(error)
        }
    }
    
    @IBOutlet weak var starsStack: UIStackView!
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        finito.isHidden=true
        starsConstraint.constant += 100
        starsStack.alpha = 0.0
        tipLabel.alpha = 0.0
//        if PersistenceManager.fetchData()[0].lastLevel == 7 {
//            //avantiButton.isHidden = true
//            finito.isHidden=false
//            PersistenceManager.fetchData()[0].lastLevel = 0
//            PersistenceManager.saveContext()
//        }
        let nlivelli=Int(NSLocalizedString("\(self.categoria ?? "")-numero", comment: ""))
        if self.livello==(nlivelli!+1) {
            finito.isHidden=false
            let cc = defaults.integer(forKey: "CategorieCompletate")
            defaults.set(cc+1, forKey: "CategorieCompletate")
            
            defaults.set(Double(stelleTotali)/Double(nlivelli ?? 0 + 1), forKey: "\(categoria ?? "")-percentuale")

            
            
        }


        
        switch numero {
        case 3:
            stella3.image! = UIImage(named: "stella piena")!
            stella2.image! = UIImage(named: "stella piena")!
            tipLabel.text = "Ottimo lavoro!"
            self.navigationController?.title = "Livello superato!"
        case 2:
            stella2.image! = UIImage(named: "stella piena")!
            tipLabel.text = "Ci sei quasi!"
            self.navigationController?.title = "Livello superato!"
            
        case 0:
            stella1.image! = UIImage(named: "stella_vuota")!
            stella2.image! = UIImage(named: "stella_vuota")!
            stella3.image! = UIImage(named: "stella_vuota")!
            tipLabel.text = "Riprovalo piu tardi"
            nameLabel.isHidden=true
            congratulazioni.isHidden=true
        default:
            stella2.image! = UIImage(named: "stella_vuota")!
            stella3.image! = UIImage(named: "stella_vuota")!
            tipLabel.text = "Metticela tutta!"
            self.navigationController?.title = "Livello superato!"
        }
        
        if numero != 0{
            guard let url = Bundle.main.url(forResource: "mixkit-game-level-completed-2059", withExtension: "wav") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

                /* iOS 10 and earlier require the following line:
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

                guard let player = self.player else { return }

                player.play()

            } catch let error {
                print(error.localizedDescription)
            }
        }
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        player?.stop()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
     override func viewDidAppear(_ animated: Bool) {
       starsConstraint.constant = 0
        UIView.animate(withDuration: 2, animations: {
            [weak self] in self?.view.layoutIfNeeded()
        }, completion: {_ in
            UIView.animate(withDuration: 2, animations: {
                self.tipLabel.alpha = 1.0
            })
        })
        UIView.animate(withDuration: 2, animations: {
            self.starsStack.alpha = 1.0
        })
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
