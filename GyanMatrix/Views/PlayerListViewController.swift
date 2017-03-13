//
//  PlayerListViewController.swift
//  GyanMatrix
//
//  Created by Sushant kumar on 12/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit
import CoreData

protocol PlayerListViewControllerDelegate{
    func handleFavorite(cell: PlayerListViewCell);
}

class PlayerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, PlayerListViewControllerDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortByRunsButton: UIButton!
    @IBOutlet weak var sortByMatchButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var totalPlayerList: UILabel!
    @IBOutlet weak var playerListView: UITableView!
    
    var playerList : [Player]!
    var playerListForView : [Player]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        self.searchBar.placeholder = "Search By name"
        self.searchBar.delegate = self as UISearchBarDelegate
        self.configButton()
        self.configTableview()
        playerList = []
        playerListForView = []
        self.fetchPlayers()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: tableView Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            print(indexPath)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerDetailViewController : PlayerDetailViewController = storyboard.instantiateViewController(withIdentifier: "PlayerDetailViewController") as! PlayerDetailViewController
        playerDetailViewController.player = playerListForView[indexPath.row]
        self.navigationController?.pushViewController(playerDetailViewController, animated: true);
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerListForView.count
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
        let player : Player = playerListForView[indexPath.row]
        
        cell.playerListViewControllerDelegate = self as PlayerListViewControllerDelegate
        cell.player = player
        cell.initCell()
        return cell
        
    }
    
//    MARK: SearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            playerListForView = playerList.filter(){ $0.name.range(of: searchText, options: .caseInsensitive) != nil }
            self.reLoadTable()
        } else {
            playerListForView = playerList
            self.reLoadTable()
            self.searchBar.endEditing(true)
        }
        
    }
    
//    MARK: Helper methods
    
    func configButton() {
        
        self.favouriteButton.titleLabel?.text = "           Favourites           "
        self.favouriteButton.tintColor = UIColor.darkGray
        self.favouriteButton.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.favouriteButton.layer.cornerRadius = 5.0
        self.favouriteButton.layer.borderWidth = 1
        
        self.sortByMatchButton.titleLabel?.text = " Match Played "
        self.sortByMatchButton.tintColor = UIColor.darkGray
        self.sortByMatchButton.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.sortByMatchButton.layer.cornerRadius = 5.0
        self.sortByMatchButton.layer.borderWidth = 1
        
        self.sortByRunsButton.titleLabel?.text = " Runs "
        self.sortByRunsButton.tintColor = UIColor.darkGray
        self.sortByRunsButton.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.sortByRunsButton.layer.cornerRadius = 5.0
        self.sortByRunsButton.layer.borderWidth = 1
        
    }
    
    func configTableview() {
        playerListView.tableFooterView = UIView(frame: CGRect.zero)
        playerListView.delegate = self as UITableViewDelegate
        playerListView.dataSource = self as UITableViewDataSource
        playerListView.register(UINib(nibName: "PlayerListViewCell", bundle: nil), forCellReuseIdentifier: "playerCell")
    }
    
    func reLoadTable() {
        DispatchQueue.main.async(execute: {
            self.totalPlayerList.text = "Total Player: \(self.playerListForView.count)"
            self.playerListView.reloadData()
        });
    }
    
    func fetchPlayers() {
        
//        let url = NSURL(string: "http://hackerearth.0x10.info/api/gyanmatrix?type=json&query=list_player")
//        
//        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
//            
//            //            print("Task completed")
//            if(error != nil) {
//                print(error?.localizedDescription ?? "Error Occured Fail")
//            }
//            do {
        
                if let path = Bundle.main.path(forResource: "list", ofType: "json") {
                    do {
                        let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                        do {
                            let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            //                print(jsonResult)
                            let jsonPlayerList : Array = jsonResult["records"] as! [[String:Any]];
                            
                            for jsonPlayer in jsonPlayerList {
                                let id : Double = (jsonPlayer["id"] as! NSString).doubleValue
                                let name : String = jsonPlayer["name"] as! String
                                let image : String = jsonPlayer["image"] as! String
                                let totalScore : Double = (jsonPlayer["total_score"] as! NSString).doubleValue
                                let descriptions : String = jsonPlayer["description"] as! String
                                let matchesPlayed : Double = (jsonPlayer["matches_played"] as! NSString).doubleValue
                                let country : String = jsonPlayer["country"] as! String
                                //                    print(name,id,image,totalScore,descriptions,matchesPlayed,country)
                                
                                let tempPlayer = Player.init(id: id, name: name, image: image, totalScore: totalScore, descriptions: descriptions, matchesPlayed: matchesPlayed, country: country);
                                self.playerList.append(tempPlayer)
                                
                                DBUtil.fetch()
                                for player in DBUtil.favoritePlayer {
                                    if tempPlayer.name == player.value(forKeyPath: "name") as! String {
                                        tempPlayer.favorite = true
                                    }
                                }
                                
                            }
                            
                            self.playerListForView = self.playerList
                            self.reLoadTable()
                        } catch {}
                    } catch {}
                }
                
//                let jsonResult = try JSONSerialization.jsonObject(with: data!, options:
//                    JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
        
//            } catch {
//                print("JSON Processing Failed")
//            }
//        }
//        
//        task.resume()
    }
    
    @IBAction func sortByMatchPlayed(_ sender: Any) {
        playerListForView = playerList.sorted { $0.matchesPlayed > $1.matchesPlayed }
        self.reLoadTable()
    }
    
    @IBAction func sortByRuns(_ sender: Any) {
        playerListForView = playerList.sorted { $0.totalScore > $1.totalScore }
        self.reLoadTable()
    }
    
    
    @IBAction func showFavouriteList(_ sender: Any) {
        
        let filteredPlayerList = playerList.filter() { $0.favorite == true }
        print(filteredPlayerList)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favoriteListViewController : FavoriteListViewController = storyboard.instantiateViewController(withIdentifier: "FavoriteListViewController") as! FavoriteListViewController
        favoriteListViewController.playerList = filteredPlayerList
        self.navigationController?.pushViewController(favoriteListViewController, animated: true);
    }
    
//    MARK: PlayerListViewControllerDelegate
    func handleFavorite(cell: PlayerListViewCell) {
        let indexPath = playerListView.indexPath(for: cell)
        playerListView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
        
        let player = playerListForView[(indexPath?.row)!] as Player
        
        if player.favorite {
            DBUtil.save(player: player)
        } else {
            DBUtil.delete(player: player)
        }
        
        
    }
    
    

}

