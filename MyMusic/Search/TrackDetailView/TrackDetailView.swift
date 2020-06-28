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

protocol TrackMovingDelegate: class {
    func moveBackToPreviousTrack() -> SearchViewModel.Cell?
    func moveForwardToNextTrack() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
    
    @IBOutlet var maximizedStackView: UIStackView!
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
    
    @IBOutlet var miniTrackView: UIView!
    @IBOutlet var miniNextTrackButton: UIButton!
    @IBOutlet var miniTrackImageView: UIImageView!
    @IBOutlet var miniTrackNameLabel: UILabel!
    @IBOutlet var miniPlayPauseButton: UIButton!
    
    
    let player:AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    //MARK: - AwakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestureRecognizer()
        
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        currentTimeSlider.tintColor = secondarySystemColor
        volumeSlider.tintColor = secondarySystemColor
        previousTrackButton.tintColor = secondarySystemColor
        playPauseButton.tintColor = secondarySystemColor
        nextTrackButton.tintColor = secondarySystemColor
        artistNameLabel.textColor = secondarySystemColor
        
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5
        
        miniPlayPauseButton.imageEdgeInsets = .init(top: 11, left: 11, bottom: 11, right: 11)
    }
    
    //MARK: - Setup
    
    func set(viewModel: SearchViewModel.Cell) {
        miniTrackNameLabel.text = viewModel.trackName
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        playTrack(fromUrl: viewModel.previewUrl)
        monitorStartTime()
        observePlayerCurrentTime()
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let urlString600x600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: urlString600x600 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
        miniTrackImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func playTrack(fromUrl: String?) {
        guard let url = URL(string: fromUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    //MARK: - Gestures
    
    private func setupGestureRecognizer() {
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlpha = 1 + translation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizedStackView.alpha = -translation.y / 200
    }
    
    private func handlePanEndid(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = .identity
                        if translation.y < -200 || velocity.y < -500 {
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
                        } else {
                            self.miniTrackView.alpha = 1
                            self.maximizedStackView.alpha = 0
                        }
        }, completion: nil)
    }
    
    @objc private func handleTapMaximized() {
        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
    }
    
    @objc private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: self.superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            self.maximizedStackView.transform = .identity
                            self.transform = .identity
                            if translation.y > 50 {
                                self.tabBarDelegate?.minimizeTrackDetailController()
                            }
            }, completion: nil)
        default:
            break
        }
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .changed:
            handlePanChanged(gesture: gesture)
        case .ended:
            handlePanEndid(gesture: gesture)
        default:
            break
        }
    }
    
    //MARK: - Time observers
    
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        }
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (time) in
            self.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self.player.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self.durationLabel.text = "-\(currentDurationText)"
            self.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds/durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    //MARK: - Animations
    
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func reduceTrackImageView() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        let scale: CGFloat = 0.8
                        self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    //MARK: - @IBActions
    
    @IBAction func dragDownButtonPressed(_ sender: Any) {
        self.tabBarDelegate?.minimizeTrackDetailController()
        //        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImageView()
        }
    }
    
    @IBAction func previousTrackButtonPressed(_ sender: Any) {
        let cellViewModel = delegate?.moveBackToPreviousTrack()
        guard let cellInfo = cellViewModel else { return }
        self.set(viewModel: cellInfo)
    }
    
    @IBAction func nextTrackButtonPressed(_ sender: Any) {
        let cellViewModel = delegate?.moveForwardToNextTrack()
        guard let cellInfo = cellViewModel else { return }
        self.set(viewModel: cellInfo)
    }
    
}
