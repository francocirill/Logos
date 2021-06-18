//
//  IndovinaViewCell.swift
//  App2
//
//  Created by Franco Cirillo on 04/04/21.
//

import UIKit

class IndovinaViewCell: UITableViewCell {

    @IBOutlet weak var sfondo: UIView!
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var numero: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
