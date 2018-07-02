//
//  Custometablecell.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 19/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit

class Custometablecell: UITableViewCell {
    @IBOutlet weak var imageview: UIImageView!
     @IBOutlet weak var titlelabel: UILabel!
     @IBOutlet weak var titletypwlabel: UILabel!
     @IBOutlet weak var desciptionlabel: UILabel!
    
    @IBOutlet var timerview: UIView!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var cellouterview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
