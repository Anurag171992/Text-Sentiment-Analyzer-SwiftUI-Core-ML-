//
//  ContentView.swift
//  TextClassifier
//
//  Created by Anurag on 18/08/26.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = TextClassifierViewModel()
    @State private var showCheckTextClassifier = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                List(viewModel.predictionModels, id: \.text) { item in
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text("Review: \(item.text)")
                        HStack {
                            Text("Actual: \(item.label)")
                            Spacer()
                            Image(systemName: item.label == "positive" ? "hand.thumbsup.circle.fill" : "hand.thumbsdown.circle.fill")
                                .foregroundColor(item.label == "positive" ? Color.green : Color.red)
                        }
                        HStack {
                            Text("Predicted: \(item.predictedLabel)")
                            Spacer()
                            Image(systemName: item.predictedLabel == "positive" ? "hand.thumbsup.circle.fill" : "hand.thumbsdown.circle.fill")
                                .foregroundColor(item.predictedLabel == "positive" ? Color.green : Color.red)
                        }
                        
                        Text(item.predictedLabel == item.label ? "Correctly Predicted" : "Wrongly Predicted")
                            .foregroundColor(item.predictedLabel == item.label ? Color.green : Color.red)
                            .fontWeight(.semibold)
                    }
                }
            }
            .navigationTitle("Trained Text Data")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Check Text Analyzer") {
                    showCheckTextClassifier.toggle()
                }
            }
        }
        .sheet(isPresented: $showCheckTextClassifier) {
            CheckTextClassifier(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}

struct CheckTextClassifier: View {
    
    @ObservedObject var viewModel = TextClassifierViewModel()
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            
            Text("Paste a comment from any site to check the text analyzer")
                .foregroundColor(.black)
                .font(.title3)
                .fontWeight(.semibold)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $inputText)
                    .padding(8)
            }
            .frame(height: 200)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5))
            )
            .padding()
            
            
            Button("Classify") {
                viewModel.classify(text: inputText)
            }
            .padding()
            
            Text("Prediction: \(viewModel.predictedLabel)")
                .font(.headline)
                .padding()
        }
        .padding()
    }
}
