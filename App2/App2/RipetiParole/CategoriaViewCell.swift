//
//  CategoriaViewCell.swift
//  App2
//
//  Created by Franco Cirillo on 10/03/21.
//

import UIKit

class CategoriaViewCell: UITableViewCell {

    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var sfondo: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
