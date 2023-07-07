//
//  AddNoteView.swift
//  SimpleNotesApp
//
//  Created by joe on 2023/07/07.
//

import SwiftUI

struct AddNoteView: View {
    @State var text = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            TextField("Write a note...", text: $text)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .clipped()
            
            Button(action: postNote) {
                Text("Add")
            }
            .padding(8)
        }
    }
    
    func postNote() {
        let url = URL(string: "http://localhost:3000/notes")!
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let params = ["note": text] as [String: Any]
        
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
            
            self.text = ""
            presentationMode.wrappedValue.dismiss()
        }
        catch let err {
            print(err)
        }
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
