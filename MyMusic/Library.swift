//
//  Library.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 6/30/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import SwiftUI

struct Library: View {
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
                    LibraryCell()
                }
            }
            .navigationBarTitle("Library")
        }
    }
}

struct LibraryCell: View {
    var body: some View {
        HStack {
            Image("").resizable().frame(width: 60, height: 60).cornerRadius(2)
            VStack {
                Text("Track name")
                Text("Artist name")
            }
        }
    }
}


struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
