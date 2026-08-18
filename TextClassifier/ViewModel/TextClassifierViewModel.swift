//
//  TextClassifierViewModel.swift
//  TextClassifier
//
//  Created by Anurag on 18/08/26.
//
import CoreML
import Combine

struct TestRow: Decodable {
    let text: String
    let label: String
}

struct PredictionModel: Decodable {
    let text: String
    let label: String
    let predictedLabel: String
}


class TextClassifierViewModel: ObservableObject {
    
    @Published var predictionModels: [PredictionModel] = []
    @Published var predictedLabel: String = ""
    private var model: TextClassifier?
    
    init() {
        loadMLModel()
        textAnalyzerModel()
    }
    
    func loadMLModel() {
        do {
            let model = try TextClassifier(configuration: MLModelConfiguration())
            
            // Load JSON manually (no MLDataTable in iOS)
            guard let fileURL = Bundle.main.url(forResource: "TestData", withExtension: "json"),
                  let data = try? Data(contentsOf: fileURL) else {
                print("TestData.json not found")
                return
            }
            
            let rows = try JSONDecoder().decode([TestRow].self, from: data)
            // Run predictions row by row
            for row in rows {
                let prediction = try model.prediction(text: row.text) ///Prediction happens here
                let result = PredictionModel(
                    text: row.text,
                    label: row.label,
                    predictedLabel: prediction.label
                )
                
                // Append to array
                predictionModels.append(result)
            }
            
        } catch {
            debugPrint("ERROR: \(error.localizedDescription)")
        }
    }
    
    func textAnalyzerModel() {
        do {
            model = try TextClassifier(configuration: MLModelConfiguration())
        } catch {
            print("Error loading model: \(error.localizedDescription)")
        }
    }
    
    func classify(text: String) {
        guard let model = model else { return }
        do {
            let prediction = try model.prediction(text: text)
            predictedLabel = prediction.label
        } catch {
            print("Prediction failed: \(error.localizedDescription)")
        }
    }
}
