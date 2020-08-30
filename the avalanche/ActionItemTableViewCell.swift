//
//  ActionItemTableViewCell.swift
//  the avalanche
//
//  Created by Sofia Ongele on 8/28/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit

class ActionItemTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
