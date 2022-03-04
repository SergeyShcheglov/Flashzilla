//
//  ViewModel.swift
//  Flashzilla
//
//  Created by Sergey Shcheglov on 04.03.2022.
//

import Foundation


class ViewModel: ObservableObject {
    @Published private(set) var cards = [Card]()
    @Published var promptPlaceholder = "Prompt"
    @Published var answerPlaceholder = "Answer"
    @Published var newPrompt = ""
    @Published var newAnswer = ""
    
    @Published var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Published var showingEditScreen = false
    @Published var isActive = true
    
    let savePaths = FileManager.getDocumentDirectory.appendingPathComponent("Saved Cards")
    
    
    func loadData() {
        do {
            let data = try Data(contentsOf: savePaths)
            cards = try JSONDecoder().decode([Card].self, from: data)
        } catch {
            cards = []
        }
    }
    
    func removeCard(at index: Int, reinsert: Bool) {
        guard index >= 0 else { return }
        
        if reinsert {
            cards.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
        } else {
            cards.remove(at: index)
        }
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    func deleteCard(at offset: IndexSet) {
        cards.remove(atOffsets: offset)
        save()
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
    
    func save() {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: savePaths, options: [.atomic, .completeFileProtection])
        } catch {
            print("Couldn't save to documentsDirectory")
        }
        
        if let encoded = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(encoded, forKey: "SavedCards")
        }
    }
}
