//
//  EditView.swift
//  Flashzilla
//
//  Created by Sergey Shcheglov on 01.03.2022.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var cards = [Card]()
    @State private var promptPlaceholder = "Prompt"
    @State private var answerPlaceholder = "Answer"
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    let savePaths = FileManager.getDocumentDirectory.appendingPathComponent("Saved Cards")

    
    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField(promptPlaceholder, text: $newPrompt)
                    TextField(answerPlaceholder, text: $newAnswer)
                    Button("Add card", action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: deleteCard)
                }
                
            }
            .navigationTitle("Edit Cards")
            
            .toolbar {
                Button("Done", action: done)
            }
            .listStyle(.grouped)
            .onAppear(perform: loadData)
            
        }
    }
    func done() {
        dismiss()
    }
    func loadData() {
        do {
            let data = try Data(contentsOf: savePaths)
            cards = try JSONDecoder().decode([Card].self, from: data)
        } catch {
            cards = []
        }
        
//        if let data = UserDefaults.standard.data(forKey: "SavedCards") {
//            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
//                cards = decoded
//            }
//        }
    }
    func save() {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: savePaths, options: [.atomic, .completeFileProtection])
        } catch {
            print("Couldn't save to documentsDirectory")
        }
        
//        if let encoded = try? JSONEncoder().encode(cards) {
//            UserDefaults.standard.set(encoded, forKey: "SavedCards")
//        }
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswers = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswers.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswers)
        cards.insert(card, at: 0)
        save()
        
        newPrompt = ""
        newAnswer = ""
    }
    
    func deleteCard(at offset: IndexSet) {
        cards.remove(atOffsets: offset)
        save()
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
