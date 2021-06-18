//
//  CollectionViewController.swift
//  App2
//
//  Created by Marco Venere on 15/02/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController{

    var avatars = [UIImage(named: "Captain America"),
                   UIImage(named: "Hulk"),
                   UIImage(named: "Batman"),
                   UIImage(named: "Catwoman"),
                   UIImage(named: "Groot"),
                   UIImage(named: "Harley Quinn"),
                   UIImage(named: "Iron Man"),
                   UIImage(named: "Joker"),
                   UIImage(named: "Magneto"),
                   UIImage(named: "Professor X"),
                   UIImage(named: "Thor"),
                   UIImage(named: "Spiderman"),
                   UIImage(named: "Thanos"),
                   UIImage(named: "Wolverine")]
    var avatarsNames = ["Captain America", "Hulk", "Batman", "Catwoman", "Groot", "Harley Quinn", "Iron Man", "Joker", "Magneto", "Professor X", "Thor", "Spiderman", "Thanos", "Wolverine"]
    
    var  avatar:  MyString?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return avatarsNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! CollectionViewCell
        
        //impostiamo l'immagine e il testo della label con quelli precedentemente dichiarati nelle due variabili
        cell.avatar?.image = self.avatars[indexPath.row]
        cell.avatarName?.text = self.avatarsNames[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            //salvare in memoria
            avatar!.str = cell.avatarName.text!
            _ = navigationController?.popViewController(animated: true)
        }
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


