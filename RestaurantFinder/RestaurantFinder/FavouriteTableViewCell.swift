//
//  FavouriteTableViewCell.swift
//  YelpAssignment
//
//  Created by Vijay reddy Muniswamy on 5/23/16.
//  
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgvw :UIImageView!
    @IBOutlet weak var ratingimage : UIImageView!
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var address : UILabel!
    
    @IBOutlet weak var keywords:UILabel!
    
    @IBOutlet weak var review : UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
