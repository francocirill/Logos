//
//  MemoriaViewController.swift
//  App2
//
//  Created by Franco Cirillo on 05/04/21.
//

import UIKit
import AVFoundation

class MemoriaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
//    var immaginiProdotti = [UIImage(named: "Ape"), UIImage(named: "Ape"), UIImage(named: "Ape"), UIImage(named: "Ape"),UIImage(named: "Ape"), UIImage(named: "Ape"), UIImage(named: "Ape"), UIImage(named: "Ape"),UIImage(named: "Ape"), UIImage(named: "Ape"), UIImage(named: "Ape"), UIImage(named: "Ape"),UIImage(named: "Ape"), UIImage(named: "Ape"), UIImage(named: "Ape"), UIImage(named: "Ape")]
//    var immagini = ["Ape","Babbo","Ape","Ape","Ape","Ape","Ape","Ape","Ape","Ape","Ape","Ape"]
    var tentativi=0
    var trovate=0
    //Array nomi immagini
    var immagini=[String]()
    var scoperte:Int=0
    var index1:IndexPath?=nil
    var index2:IndexPath?=nil
    let maxCarte=12
    var newViewController : UIViewController?
    let synthesizer = AVSpeechSynthesizer()
    var player: AVAudioPlayer?
    let audioEngine = AVAudioEngine()
    let defaults = UserDefaults.standard
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        
        }
        catch let error as NSError {
            return print(error)
        }
        // Carica array immagini
        caricaImmagini()
    }
    override func viewDidAppear(_ animated: Bool) {
        speak("Trova le immagini uguali")
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        synthesizer.stopSpeaking(at: .immediate)
    }

    func speak(_ msg : String) {
        //per non mettere in fila troppe parole
        synthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: msg)

        utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
        utterance.volume = 1.0
        //utterance.rate = 0.1 velocità di espressione
        
        
        synthesizer.speak(utterance)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            //questo valore serve per far capire alla Collection View quante celle devono essere visualizzate
            return maxCarte
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cella", for: indexPath as IndexPath) as! MemoriaCell
        
        //impostiamo l'immagine e il testo della label con quelli precedentemente dichiarati nelle due variabili
//        cell.image?.image = self.immaginiProdotti[indexPath.row]
        //cell.labelNome?.text = prodottiApple[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MemoriaCell
        
        //Ripeti parola
        speak(immagini[indexPath.row])
        
        //impostiamo l'immagine
        switch scoperte {
        case 0:
            index1=indexPath
            UIView.transition(with: cell.image, duration: 1, options: .transitionFlipFromRight, animations: {cell.image?.image = UIImage(named: self.immagini[indexPath.row])}, completion: nil)
        case 1:
            //la seconda carta non puo essere uguale alla prima
            if indexPath != index1 {
                tentativi+=1
                tent.text=tentativi.description
                index2=indexPath
                //salvo perché la funzione è asincrona
                let i1=index1
                let i2=index2
                UIView.transition(with: cell.image, duration: 1, options: .transitionFlipFromRight, animations: {cell.image?.image = UIImage(named: self.immagini[indexPath.row])}, completion: {_ in self.verificaVittoria(i1!,i2!)})
            } else{scoperte-=1}
        default:
            scoperte=0
            let cella1 = collectionView.cellForItem(at: index1!) as! MemoriaCell
            let cella2 = collectionView.cellForItem(at: index2!) as! MemoriaCell
            UIView.transition(with: cella1.image, duration: 1, options: .transitionFlipFromRight, animations: {cella1.image?.image = UIImage(systemName: "questionmark.square.dashed")}, completion: nil)
            UIView.transition(with: cella2.image, duration: 1, options: .transitionFlipFromRight, animations: {cella2.image?.image = UIImage(systemName: "questionmark.square.dashed")}, completion: nil)
            /*
            for i in 0..<maxCarte {
                let cella = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! MemoriaCell
                
                UIView.transition(with: cella.image, duration: 1, options: .transitionFlipFromRight, animations: { if cella.image.image?.pngData() != UIImage(systemName: "questionmark.square.dashed")?.pngData() {                                   cella.image?.image = UIImage(systemName: "questionmark.square.dashed")}}, completion: nil)
            }*/
            
            UIView.transition(with: cell.image, duration: 1, options: .transitionFlipFromRight, animations: {cell.image?.image = UIImage(named: self.immagini[indexPath.row])}, completion: nil)
            index1=indexPath
            
        }
        scoperte+=1
        
        
//        self.performSegue(withIdentifier: "mostraImmagine", sender: self)
        }

    func caricaImmagini(){
        //scegli una categoria
        let max = Int(NSLocalizedString("numeroCategorie", comment: "")) ?? 0
        var n = Int.random(in: 1...max)
        var categoria=NSLocalizedString("categoria\(n)", comment: "")
        //prendi solo le categorie con piu di 6 parole
        var num=Int(NSLocalizedString("\(categoria)-numero", comment: ""))!
        while num<6 {
            n = Int.random(in: 1...max)
            categoria=NSLocalizedString("categoria\(n)", comment: "")
            num=Int(NSLocalizedString("\(categoria)-numero", comment: ""))!
        }
        //prendi i primi 6 livelli e inseriscili nell array 2 volte
        for i in 1...6{
            immagini.append(NSLocalizedString("\(categoria)-level\(i)", comment: ""))
            immagini.append(NSLocalizedString("\(categoria)-level\(i)", comment: ""))
        }
        //mescola l'array
        immagini.shuffle()
        
    }
    func verificaVittoria(_ i1:IndexPath,_ i2:IndexPath){
        //se gli elementi nell'array con indice index1 e index2 sono uguali toglili dalla collection
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
        if immagini[i1.row] == immagini[i2.row] {
            print(i1.row)
            print(i2.row)
            let cell1 = self.collectionView.cellForItem(at: i1) as! MemoriaCell
            cell1.isHidden=true
            let cell2 = self.collectionView.cellForItem(at: i2) as! MemoriaCell
            cell2.isHidden=true
            trovate+=2
        }
        if trovate == maxCarte {
            //vittoria
            print("Hai vinto")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            self.newViewController = storyBoard.instantiateViewController(withIdentifier: "MemoriaSuperatoViewController") as! MemoriaSuperatoViewController
            let cont = self.newViewController as! MemoriaSuperatoViewController
            
            switch self.tentativi {
            case 0...15:
                cont.numero = 3
                PersistenceManager.fetchData()[0].points +=  3
            case 16...25:
                cont.numero = 2
                PersistenceManager.fetchData()[0].points +=  2
            default:
                cont.numero = 1
                PersistenceManager.fetchData()[0].points +=  1
            }
            var mem = defaults.array(forKey: "Memoria") ?? Array()
            mem.append(tentativi)
            defaults.set(mem, forKey: "Memoria")
            //print(mem[0])
            //print(mem[1])
            PersistenceManager.saveContext()
            self.navigationController?.pushViewController(self.newViewController!, animated: true)
        }
        
        
//        })
        //se finiscono le carte termina il gioco

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
