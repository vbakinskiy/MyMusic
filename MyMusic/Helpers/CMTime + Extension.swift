//
//  CMTime + Extension.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 6/25/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeForString = String(format: "%02d:%02d", minutes, seconds)
        return timeForString
    }
}
