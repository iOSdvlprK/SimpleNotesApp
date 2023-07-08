//
//  UpdateNoteView.swift
//  SimpleNotesApp
//
//  Created by joe on 2023/07/08.
//

import SwiftUI

struct UpdateNoteView: View {
    @Binding var note: String
    @Binding var noteId: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            TextField("Update a note...", text: $note)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .clipped()
            
            Button(action: updateNote) {
                Text("Update")
            }
            .padding(8)
        }
    }
    
    private func updateNote() {
        print("UPDATE")
        let url = URL(string: "http://localhost:3000/notes/\(noteId)")!
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        let params = ["note": note] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, res, err in
                guard err == nil else { return }
                guard let data = data else { return }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                    }
                }
                catch {
                    print(error)
                }
            }
            
            task.resume()
            
            self.note = ""
            presentationMode.wrappedValue.dismiss()
        }
        catch let err {
            print(err)
        }
    }
}

/*
struct UpdateNoteView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateNoteView()
    }
}
*/
