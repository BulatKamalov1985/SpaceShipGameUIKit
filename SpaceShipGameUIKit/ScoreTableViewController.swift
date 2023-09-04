//
//  ScoreTableViewController.swift
//  SpaceShipGameUIKit
//
//  Created by Bulat Kamalov on 16.08.2023.
//
import UIKit

class ScoresTableViewController: UITableViewController {

    var scoresAndNames: [(playerName: String, score: Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ScoreTableViewCell.self, forCellReuseIdentifier: ScoreTableViewCell.reuseIdentifier)
        loadScores()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoresAndNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.reuseIdentifier, for: indexPath) as! ScoreTableViewCell
        let scoreAndName = scoresAndNames[indexPath.row]
        let score = Score(playerName: scoreAndName.playerName, score: scoreAndName.score)
        cell.configure(with: score)
        return cell
    }
    
    func loadScores() {
        guard let nameScoreDictionary = UserDefaults.standard.dictionary(forKey: "NameScoreDictionary") as? [String: Int] else {
            return
        }
        // Преобразование словаря в массив кортежей (имя, очки)
        let sortedScores = nameScoreDictionary.sorted { $0.value > $1.value }

        // Преобразование кортежей в массив очков и имен
        scoresAndNames = sortedScores.map { ($0.key, $0.value) }
        
        tableView.reloadData()
    }

}
