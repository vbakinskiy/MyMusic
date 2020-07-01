//
//  TrackCell.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 6/23/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var collectionName: String { get }
    var artistName: String { get }
}

class TrackCell: UITableViewCell {
    
    static let reuseIdentifier = "TrackCell"
    
    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var collectionNameLabel: UILabel!
    @IBOutlet var addTrackButton: UIButton!
    
    var cell:SearchViewModel.Cell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTrackButton.tintColor = secondarySystemColor
    }
    
    override func prepareForReuse() {
        super .prepareForReuse()
        trackImageView.image = nil
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    @IBAction func addTrackButtonPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: cell.self, requiringSecureCoding: false) {
            print("Успешно!")
            defaults.set(savedData, forKey: "tracks")
        }
    }
    
    @IBAction func showInfo(_ sender: Any) {
        let defaults = UserDefaults.standard
        if let savedTracks = defaults.object(forKey: "tracks") as? Data {
            if let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? SearchViewModel.Cell {
                print("Decoded Track name: \(decodedTracks.trackName)")
            }
        }
    }
}
