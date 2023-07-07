//
//  ContentView.swift
//  SimpleNotesApp
//
//  Created by joe on 2023/07/06.
//

import SwiftUI

struct Home: View {
    @State var notes = [Note]()
    @State var showAdd = false
    @State var showAlert = false
    @State var deleteItem: Note?
    
    var alert: Alert {
        Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this note?"), primaryButton: .destructive(Text("Delete"), action: deleteNote), secondaryButton: .cancel())
    }
    
    var body: some View {
        NavigationView {
            List(self.notes) { note in
                Text(note.note)
                    .padding()
                    .onLongPressGesture {
                        self.showAlert.toggle()
                        deleteItem = note
                    }
            }
            .alert(isPresented: $showAlert, content: {
                alert
            })
            .sheet(isPresented: $showAdd, onDismiss: fetchNotes, content: {
                AddNoteView()
            })
            .onAppear(perform: {
                fetchNotes()
            })
            .navigationTitle("Notes")
            .navigationBarItems(trailing: Button(action: {
                self.showAdd.toggle()
            }, label: {
                Text("Add")
            }))
        }
    }
    
    func fetchNotes() {
        let url = URL(string: "http://localhost:3000/notes")!
        
        let task = URLSession.shared.dataTask(with: url) { data, res, err in
            guard let data = data else { return }
            
//            print(String(data: data, encoding: .utf8) ?? "")
            do {
                let notes = try JSONDecoder().decode([Note].self, from: data)
//                print(notes)
                self.notes = notes
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func deleteNote() {
        guard let id = deleteItem?._id else { return }
        guard let url = URL(string: "http://localhost:3000/notes/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to delete the note:", err)
                    return
                }
                
                if let res = res as? HTTPURLResponse, res.statusCode != 200 {
                    let errorString = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    print(NSError(domain: "", code: res.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString]))
                    return
                }
                
                print("Deleted successfully.")
                fetchNotes()
            }
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
