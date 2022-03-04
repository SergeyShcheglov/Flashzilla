//
//  ContentView.swift
//  Flashzilla
//
//  Created by Sergey Shcheglov on 25.02.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(vm.timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(Array(vm.cards.enumerated()), id:\.element) { card in
                        CardView(card: card.element) { reinsert in
                            withAnimation {
                                vm.removeCard(at: card.offset, reinsert: reinsert)
                            }
                        }
                        .stacked(at: card.offset, in: vm.cards.count)
                        .allowsHitTesting(card.offset == vm.cards.count - 1)
                        .accessibilityHidden(card.offset < vm.cards.count - 1)
                    }
                }
                .allowsHitTesting(vm.timeRemaining > 0)
                
                if vm.cards.isEmpty {
                    Button("Start again", action: vm.resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        vm.showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                vm.removeCard(at: vm.cards.count - 1, reinsert: true)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        Spacer()
                        
                        Button {
                            withAnimation {
                                vm.removeCard(at: vm.cards.count - 1, reinsert: false)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(vm.timer) { time in
            guard vm.isActive else { return }
            if vm.timeRemaining > 0 {
                vm.timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if vm.cards.isEmpty {
                    vm.isActive = true
                }
            } else {
                vm.isActive = false
            }
        }
        .sheet(isPresented: $vm.showingEditScreen, onDismiss: vm.resetCards, content: EditView.init)
        .onAppear(perform: vm.resetCards)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
