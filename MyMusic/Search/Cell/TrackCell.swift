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
        
        let savedTracks = UserDefaults.standard.getSavedTracks()
        let hasfavorite = savedTracks.firstIndex(where: {
            $0.trackName == self.cell?.trackName &&
                $0.artistName == self.cell?.artistName
        }) != nil
        if hasfavorite {
            addTrackButton.isHidden = true
        } else {
            addTrackButton.isHidden = false
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    @IBAction func addTrackButtonPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        guard let cell = cell else { return }
        var listOfTracks = defaults.getSavedTracks()
        
        listOfTracks.append(cell)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks.self, requiringSecureCoding: false) {
            defaults.set(savedData, forKey: UserDefaults.trackKey)
        }
        
        addTrackButton.isHidden = true
    }
}
