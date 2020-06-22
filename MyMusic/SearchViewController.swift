//
//  SearchViewController.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 6/22/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import UIKit
import Alamofire

struct TrackModel {
    
    var trackName: String
    var artistName: String
}

class SearchViewController: UITableViewController {
    
    private var timer: Timer?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupSearchBar()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        //        cell.imageView?.image =
        return cell
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            let url = "https://itunes.apple.com/search"
            let parameters = ["term": "\(searchText)", "limit": "10"]
            AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { (response) in
                if let error = response.error {
                    print("Response error: \(error.localizedDescription)")
                    return
                }
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(SearchResponse.self, from: data)
                    self.tracks = objects.results
                    self.tableView.reloadData()
                } catch let error {
                    print("Data error: \(error.localizedDescription)")
                }
            }
        })
    }
}
