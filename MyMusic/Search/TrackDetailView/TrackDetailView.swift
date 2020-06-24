//
//  TrackDetailView.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 6/24/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import UIKit

class TrackDetailView: UIView {
    
    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var currentTimeSlider: UISlider!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var previousTrackButton: UIButton!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var nextTrackButton: UIButton!
    @IBOutlet var volumeSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currentTimeSlider.tintColor = secondarySystemColor
        volumeSlider.tintColor = secondarySystemColor
        previousTrackButton.tintColor = secondarySystemColor
        playPauseButton.tintColor = secondarySystemColor
        nextTrackButton.tintColor = secondarySystemColor
        artistNameLabel.textColor = secondarySystemColor
    }
    
    @IBAction func dragDownButtonPressed(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
    }
    
    @IBAction func previousTrackButtonPressed(_ sender: Any) {
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
    }
    
    @IBAction func nextTrackButtonPressed(_ sender: Any) {
    }
    
}
