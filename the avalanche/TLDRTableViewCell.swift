//
//  TLDRTableViewCell.swift
//  the avalanche
//
//  Created by Sofia Ongele on 9/5/20.
//  Copyright © 2020 Sofia Ongele. All rights reserved.
//

import UIKit

class TLDRTableViewCell: UITableViewCell {

    
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
