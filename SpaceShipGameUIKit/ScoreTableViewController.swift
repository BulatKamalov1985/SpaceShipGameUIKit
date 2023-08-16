//
//  ScoreTableViewController.swift
//  SpaceShipGameUIKit
//
//  Created by Bulat Kamalov on 16.08.2023.
//

import UIKit

class ScoresTableViewController: UITableViewController {

    var scores: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ScoreTableViewCell.self, forCellReuseIdentifier: ScoreTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        loadScores()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.reuseIdentifier, for: indexPath) as! ScoreTableViewCell
        let scoreValue = scores[indexPath.row]
        let score = Score(playerName: "Player \(indexPath.row + 1)", score: scoreValue)
        cell.configure(with: score)
        return cell
    }
    
    func loadScores() {
        scores = UserDefaults.standard.array(forKey: "HighScores") as? [Int] ?? []
        scores.sort(by: > )
        tableView.reloadData()
    }
    
}
