//
//  NuovoUtenteController.swift
//  App2
//
//  Created by Franco Cirillo on 12/02/21.
//

import UIKit

class NuovoUtenteController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var pictureSwitch: UISwitch!
    @IBOutlet weak var speechSwitch: UISwitch!
    @IBOutlet weak var tutorial: UISwitch!
    
    
    
    @IBOutlet weak var creaButton: UIButton!
    
    let defaults = UserDefaults.standard
    var avatar: MyString?
    var textChanged = false
    var avatarChanged = false
    @IBOutlet weak var avatarbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
        avatar = MyString()
        avatar!.str = ""
        //userProfile!.setValue("default", forKey: "avatar")
        //userProfile.avatar = "default"
        creaButton.isEnabled = false
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        textChanged = sender.text != ""
        creaButton.isEnabled = textChanged && avatarChanged
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if avatar!.str != "" {
            avatarbutton.setImage(UIImage(named: avatar!.str) , for: .normal)
            avatarChanged = true
            creaButton.isEnabled = textChanged && avatarChanged
        } else {
            avatarChanged = false
            creaButton.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "showAvatar" :
            let dstView = segue.destination as! CollectionViewController
            dstView.avatar = avatar
        case "create":
            PersistenceManager.newProfile(name: userNameTextField.text!, outLoud: speechSwitch.isOn, showPics: pictureSwitch.isOn, avatar: (avatar!.str))
            PersistenceManager.saveContext()
            defaults.set(tutorial.isOn, forKey: "Tutorial")
        default: print(#function)
            
        }
        
        
    }
    
    
}

