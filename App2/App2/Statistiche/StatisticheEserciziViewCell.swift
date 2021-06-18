//
//  StatisticheEserciziViewCell.swift
//  App2
//
//  Created by Franco Cirillo on 20/03/21.
//

import UIKit

class StatisticheEserciziViewCell: UITableViewCell {
    @IBOutlet weak var esercizio: UILabel!
    @IBOutlet weak var volte: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
