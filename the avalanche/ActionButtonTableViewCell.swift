//
//  ActionButtonTableViewCell.swift
//  the avalanche
//
//  Created by Sofia Ongele on 9/17/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit

class ActionButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var actionTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
