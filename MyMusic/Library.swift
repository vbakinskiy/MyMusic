//
//  Library.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 6/30/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.getSavedTracks()
    @State private var showAlert = false
    @State private var track: SearchViewModel.Cell!
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 10) {
                        Button(action: {
                            print("12345")
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(secondarySystemColor))
                                .background(Color.init(#colorLiteral(red: 0.949714467, green: 0.949714467, blue: 0.949714467, alpha: 1)))
                                .cornerRadius(10)
                        })
                        Button(action: {
                            print("54321")
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(secondarySystemColor))
                                .background(Color.init(#colorLiteral(red: 0.949714467, green: 0.949714467, blue: 0.949714467, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                
                List {
                    ForEach (tracks) { track in
                        LibraryCell(cell: track).gesture(LongPressGesture().onEnded({ (_tracks) in
                            self.track = track
                            self.showAlert = true
                        }))
                    }.onDelete(perform: delete)
                }
            }.actionSheet(isPresented: $showAlert, content: { () -> ActionSheet in
                ActionSheet(title: Text("Do you want to delete this track?"), buttons: [.destructive(Text("Delete"), action: {
                    self.delete(track: self.track)
                }),.cancel()] )
            })
                .navigationBarTitle("Library")
        }
    }
    
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.trackKey)
        }
    }
    
    func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return }
        tracks.remove(at: myIndex)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.trackKey)
        }
    }
    
    
    struct LibraryCell: View {
        
        var cell: SearchViewModel.Cell
        
        var body: some View {
            HStack {
                URLImage(URL(string: cell.iconUrlString ?? "")!) { proxy in
                    proxy.image
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(2)
                }
                VStack(alignment: .leading) {
                    Text("\(cell.trackName)")
                    Text("\(cell.artistName)")
                }
            }
        }
    }
    
    
    struct Library_Previews: PreviewProvider {
        
        static var previews: some View {
            Library()
        }
    }
}
