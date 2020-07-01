//
//  UserDefaults.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 7/1/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let trackKey = "trackKey"
    
    func getSavedTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        guard let savedTracks = defaults.object(forKey: "tracks") as? Data else { return [] }
        guard let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else { return [] }
        
        return decodedTracks
    }
    
    
}
