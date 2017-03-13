//
//  FavoriteListViewController.swift
//  GyanMatrix
//
//  Created by Sushant kumar on 12/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var playerListView: UITableView!
    public var playerList : [Player]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.configTableview()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: Helper method
    
    func configTableview() {
        playerListView.tableFooterView = UIView(frame: CGRect.zero)
        playerListView.delegate = self as UITableViewDelegate
        playerListView.dataSource = self as UITableViewDataSource
        playerListView.register(UINib(nibName: "PlayerListViewCell", bundle: nil), forCellReuseIdentifier: "playerCell")
    }
    
    
    //    MARK: tableView Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //            print(indexPath)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerDetailViewController : PlayerDetailViewController = storyboard.instantiateViewController(withIdentifier: "PlayerDetailViewController") as! PlayerDetailViewController
        playerDetailViewController.player = playerList[indexPath.row]
        self.navigationController?.pushViewController(playerDetailViewController, animated: true);
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerListViewCell
        let player : Player = playerList[indexPath.row]
        
//        cell.playerListViewControllerDelegate = self as PlayerListViewControllerDelegate
        cell.player = player
        cell.initCell()
        cell.favoriteImage.isUserInteractionEnabled = false
        return cell
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
