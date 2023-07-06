//
//  ContentView.swift
//  SimpleNotesApp
//
//  Created by joe on 2023/07/06.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            List(0..<9) { i in
                Text("We are at \(i)")
                    .padding()
            }
            .onAppear(perform: {
                fetchNotes()
            })
            .navigationTitle("Notes")
            .navigationBarItems(trailing: Button(action: {
                print("Add a note")
            }, label: {
                Text("Add")
            }))
        }
    }
    
    func fetchNotes() {
        let url = URL(string: "http://localhost:3000/notes")!
        
        let task = URLSession.shared.dataTask(with: url) { data, res, err in
            guard let data = data else { return }
            
            print(String(data: data, encoding: .utf8) ?? "")
        }
        
        task.resume()
    }
}

struct Note: Identifiable, Codable {
    var id: String { _id }
    var _id: String
    var note: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
