//
//  TodoCell.swift
//  To Do App
//
//  Created by Mohanned Alsahaf on 15/01/1444 AH.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var todoDate: UILabel!
    @IBOutlet weak var todoTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
