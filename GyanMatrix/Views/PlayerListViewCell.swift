//
//  PlayerListViewCell.swift
//  GyanMatrix
//
//  Created by Sushant kumar on 12/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit

class PlayerListViewCell: UITableViewCell {

    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    public var player: Player!
    
    public var playerListViewControllerDelegate : PlayerListViewControllerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleFavorite(_:)))
        tap.delegate = self
        favoriteImage.addGestureRecognizer(tap)
        favoriteImage.isUserInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func initCell() {
        playerName.text = player.name
        if player.favorite {
            self.favoriteImage.image = UIImage(named:"fillStar")
        } else {
            self.favoriteImage.image = UIImage(named:"star")
        }
    }
    
    func handleFavorite(_ sender: UITapGestureRecognizer) {
        player.favorite = !player.favorite
        playerListViewControllerDelegate.handleFavorite(cell: self)
    }
    
}
