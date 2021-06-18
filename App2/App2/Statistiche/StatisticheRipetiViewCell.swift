//
//  StatisticheViewCell.swift
//  App2
//
//  Created by Franco Cirillo on 14/03/21.
//

import UIKit

class StatisticheRipetiViewCell: UITableViewCell {

    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var percentuale: UILabel!
    @IBOutlet weak var stella: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
