//
//  TrackDetailView.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 6/24/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

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
    
    let player:AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        currentTimeSlider.tintColor = secondarySystemColor
        volumeSlider.tintColor = secondarySystemColor
        previousTrackButton.tintColor = secondarySystemColor
        playPauseButton.tintColor = secondarySystemColor
        nextTrackButton.tintColor = secondarySystemColor
        artistNameLabel.textColor = secondarySystemColor
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        playTrack(fromUrl: viewModel.previewUrl)
        let urlString600x600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: urlString600x600 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func playTrack(fromUrl: String?) {
        guard let url = URL(string: fromUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
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
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    
    @IBAction func nextTrackButtonPressed(_ sender: Any) {
    }
    
}
