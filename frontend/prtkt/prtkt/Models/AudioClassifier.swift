//
//  AudioClassifier.swift
//  prtkt
//
//  Created by Rushil Madhu on 9/14/24.
//

import CoreML
import SoundAnalysis
import AVFoundation

class AudioClassifier: NSObject, SNResultsObserving, ObservableObject {

    private var analyzer: SNAudioStreamAnalyzer?
    private var inputFormat: AVAudioFormat?
    var audioEngine: AVAudioEngine?
    
    override init() {
        super.init()
        setupAudioEngine()
        setupAnalyzer()
    }
    
    func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else { return }
        
        inputFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { buffer, time in
            self.analyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine could not start: \(error.localizedDescription)")
        }
    }

    func setupAnalyzer() {
        guard let inputFormat = inputFormat else { return }

        analyzer = SNAudioStreamAnalyzer(format: inputFormat)

        do {
            let mlModel = try Gunshot(configuration: MLModelConfiguration())
            let request = try SNClassifySoundRequest(mlModel: mlModel.model)
            try analyzer?.add(request, withObserver: self)
        } catch {
            print("Error setting up analyzer: \(error.localizedDescription)")
        }
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }
        let classification = result.classifications.first
        if let bestClassification = classification {
            print("Detected sound: \(bestClassification.identifier) with confidence: \(bestClassification.confidence)")
        }
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Failed with error: \(error.localizedDescription)")
    }
}
