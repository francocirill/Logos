//
//  AvatarViewController.swift
//  App2
//
//  Created by Marco Venere on 15/02/21.
//

import UIKit

class AvatarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var avatars = [UIImage(named:"icons8-captain-america-100"),
                   UIImage(named: "icons8-hulk-100"),
                   UIImage(named: "icons8-spider-man-head-100"),
                   UIImage(named: "icons8-thanos-100"),
                   UIImage(named: "icons8-wolverine-100")]
    var avatarsNames = ["Captain America", "Hulk", "Spiderman", "Thanos", "Wolverine"]
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            //questo valore serve per far capire alla Collection View quante celle devono essere visualizzate
            return avatarsNames.count
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! CollectionViewCell
            
            //impostiamo l'immagine e il testo della label con quelli precedentemente dichiarati nelle due variabili
            cell.avatar?.image = self.avatars[indexPath.row]
            
            return cell
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
