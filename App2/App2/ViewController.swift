//
//  ViewController.swift
//  App2
//
//  Created by Franco Cirillo on 12/02/21.
//

import UIKit

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var stars: UILabel!
    @IBOutlet weak var categorieCompletate: UILabel!
    @IBOutlet weak var continuaButton: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false;
        if PersistenceManager.fetchData().count == 0 {let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "TutorialViewController")
            //self.newViewController?.isModalInPresentation = true
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if PersistenceManager.fetchData().count != 0 {
            let user = PersistenceManager.fetchData()[0]
            userName.text = user.name!
            stars.text = String(user.points)
            //level.text = String(user.lastLevel + 1)
            let cc = defaults.integer(forKey: "CategorieCompletate")
            categorieCompletate.text=cc.description
            avatar.image = UIImage(named: user.avatar!)
        }
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
}

