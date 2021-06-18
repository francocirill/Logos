//
//  Impostazioni.swift
//  App2
//
//  Created by Marco Venere on 20/02/21.
//

import UIKit

class Impostazioni: UIViewController {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var avatar: UIButton!
    @IBOutlet weak var showPics: UISwitch!
    @IBOutlet weak var outLoud: UISwitch!
    @IBOutlet weak var tutorial: UISwitch!
    @IBOutlet weak var salvabutton: UIButton!
    var avatarString : MyString?
    override func viewDidLoad() {
        
        avatarString = MyString()
        avatarString!.str = PersistenceManager.fetchData()[0].avatar!
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let user = PersistenceManager.fetchData()[0]
        nome.text = user.name
        showPics.isOn = user.showPics
        outLoud.isOn = user.outLoud
        tutorial.isOn = defaults.bool(forKey: "Tutorial")
        avatar.setImage(UIImage(named: avatarString!.str) , for: .normal)
    }
    @IBAction func textchanged(_ sender: Any) {
        salvabutton.isEnabled = nome.text != ""
    }
    
    @IBAction func salvaButton(_ sender: Any) {
        let user = PersistenceManager.fetchData()[0]
        user.name = nome.text
        user.avatar = avatarString?.str
        user.showPics = showPics.isOn
        user.outLoud = outLoud.isOn
        PersistenceManager.saveContext()
        
        defaults.set(tutorial.isOn, forKey: "Tutorial")
        //performSegue(withIdentifier: "backHomeFromLevel", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "showAvatar" :
            let dstView = segue.destination as! CollectionViewController
            dstView.avatar = avatarString
        default:
            print(#function)
        }
    }
}
