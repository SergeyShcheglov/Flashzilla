//
//  EditView.swift
//  Flashzilla
//
//  Created by Sergey Shcheglov on 01.03.2022.
//

import SwiftUI

struct EditView: View {
    @StateObject private var vm = ViewModel()
    @Environment(\.dismiss) var dismiss
   
    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField(vm.promptPlaceholder, text: $vm.newPrompt)
                    TextField(vm.answerPlaceholder, text: $vm.newAnswer)
                    Button("Add card", action: vm.addCard)
                }
                
                Section {
                    ForEach(0..<vm.cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(vm.cards[index].prompt)
                                .font(.headline)
                            Text(vm.cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: vm.deleteCard)
                }
                
            }
            .navigationTitle("Edit Cards")
            
            .toolbar {
                Button("Done", action: { dismiss() })
            }
            .listStyle(.grouped)
            .onAppear(perform: vm.loadData)
            
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
