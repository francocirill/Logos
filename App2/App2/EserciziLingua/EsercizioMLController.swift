//
//  EsercizioMLController.swift
//  App2
//
//  Created by Franco Cirillo on 20/04/21.
//

import UIKit
import CoreML
import Vision

class EsercizioMLController: UIViewController {

    private var videoCapture: VideoCapture!
    private let serialQueue = DispatchQueue(label: "com.shu223.coremlplayground.serialqueue")
    private let videoSize = CGSize(width: 1280, height: 720)
    private let preferredFps: Int32 = 2
    private var modelUrls: [URL]!
    private var selectedVNModel: VNCoreMLModel?
    private var selectedModel: MLModel?
    private var cropAndScaleOption: VNImageCropAndScaleOption = .scaleFill
    
    var esercizio:String=""
    var secondsRemaining:Double=60.0
    let defaults = UserDefaults.standard
    var tim:Timer?=nil
    var startTime:Double=0
    var fatto=0
    
    @IBOutlet weak var cornice: UIView!
    @IBOutlet weak var nomeEsercizio: UILabel!
    @IBOutlet weak var descrizione: UILabel!
    @IBOutlet weak var tempo: UILabel!
    @IBOutlet private weak var previewView: UIView!
//    @IBOutlet private weak var modelLabel: UILabel!
    @IBOutlet private weak var resultView: UIView!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var othersLabel: UILabel!
    @IBOutlet weak var errore: UILabel!
    //    @IBOutlet private weak var bbView: BoundingBoxView!
//    @IBOutlet weak var cropAndScaleOptionSelector: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        let spec = VideoSpec(fps: preferredFps, size: videoSize)
        let frameInterval = 1.0 / Double(preferredFps)
        
        //Cambiare in .front
        videoCapture = VideoCapture(cameraType: .back,
                                    preferredSpec: spec,
                                    previewContainer: previewView.layer)
        videoCapture.imageBufferHandler = {[unowned self] (imageBuffer, timestamp, outputBuffer) in
            let delay = CACurrentMediaTime() - timestamp.seconds
            if delay > frameInterval {
                return
            }

            self.serialQueue.async {
                self.runModel(imageBuffer: imageBuffer)
            }
            
            
        }
        
        //Seleziona il primo modello dalla cartella
        let modelPaths = Bundle.main.paths(forResourcesOfType: "mlmodel", inDirectory: "models")
        modelUrls = []
        for modelPath in modelPaths {
            let url = URL(fileURLWithPath: modelPath)
            let compiledUrl = try! MLModel.compileModel(at: url)
            modelUrls.append(compiledUrl)
        }
        selectModel(url: modelUrls.first!)
//        selectModel(url: URL())
        
        
        
        // scaleFill
//        cropAndScaleOptionSelector.selectedSegmentIndex = 2
//        updateCropAndScaleOption()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let videoCapture = videoCapture else {return}
        videoCapture.startCapture()
        
        //da sistemare
        tempo.text=("\(self.secondsRemaining) secondi")
        nomeEsercizio.text=esercizio
        descrizione.text = NSLocalizedString("\(esercizio)", comment: "")
        descrizione.sizeToFit()
        
        cornice.layer.borderWidth = 5
        cornice.layer.borderColor = UIColor.red.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let videoCapture = videoCapture else {return}
        videoCapture.resizePreview()
        // TODO: Should be dynamically determined
//        self.bbView.updateSize(for: CGSize(width: videoSize.height, height: videoSize.width))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let videoCapture = videoCapture else {return}
        videoCapture.stopCapture()
        tim?.invalidate()
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private
    
//    //Mostra lista dei modelli da selezionare
//    private func showActionSheet() {
//        let alert = UIAlertController(title: "Models", message: "Choose a model", preferredStyle: .actionSheet)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//
//        for modelUrl in modelUrls {
//            let action = UIAlertAction(title: modelUrl.modelName, style: .default) { (action) in
//                self.selectModel(url: modelUrl)
//            }
//            alert.addAction(action)
//        }
//        present(alert, animated: true, completion: nil)
//    }

    //Seleziona il modello da utilizzare
    private func selectModel(url: URL) {
        selectedModel = try! MLModel(contentsOf: url)
        do {
            selectedVNModel = try VNCoreMLModel(for: selectedModel!)
//            modelLabel.text = url.modelName
        }
        catch {
            fatalError("Could not create VNCoreMLModel instance from \(url). error: \(error).")
        }
    }
    
    //Esegui modello
    private func runModel(imageBuffer: CVPixelBuffer) {
        guard let model = selectedVNModel else { return }
        let handler = VNImageRequestHandler(cvPixelBuffer: imageBuffer)
        
        let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
            if let results = request.results as? [VNClassificationObservation] {
                self.processClassificationObservations(results)
            } else if #available(iOS 12.0, *), let results = request.results as? [VNRecognizedObjectObservation] {
//                self.processObjectDetectionObservations(results)
            }
        })
        
        request.preferBackgroundProcessing = true
        request.imageCropAndScaleOption = cropAndScaleOption
        
        do {
            try handler.perform([request])
        } catch {
            print("Unexpected error: \(error).")
            print("failed to perform")
        }
    }

    private func processClassificationObservations(_ results: [VNClassificationObservation]) {
        var firstResult = ""
        var others = ""
        var classe:String=""
        var confidenza:Float=0
        //Prende il primo risultato. 10 sono le classi
        for i in 0...10 {
            guard i < results.count else { break }
            let result = results[i]
            let confidence = String(format: "%.2f", result.confidence * 100)
            if i==0 {
                firstResult = "\(result.identifier) \(confidence)"
                classe=result.identifier
                confidenza=result.confidence * 100
            } else {
                others += "\(result.identifier) \(confidence)\n"
            }
        }
        
        //Avvia timer se mostra LinguaSi e blocca se mostra LinguaNo
        if classe=="LinguaSi" && self.tim==nil && confidenza<150
        {
            self.startTime = NSDate.timeIntervalSinceReferenceDate
//            print(self.startTime)
//            self.tempo.text=("\(self.secondsRemaining) secondi")
//                self.secondsRemaining-=1
            print("LinguaSi")
            //Altrimenti non parte
            DispatchQueue.main.async{
                self.tim=Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
                        if self.secondsRemaining > 0 {
                            self.tempo.text=("\(String(format: "%.2f", self.secondsRemaining)) secondi")
                            self.secondsRemaining -= 0.1
                            print(String(format: "%.2f", self.secondsRemaining))
//                            print("-0.1")
                        } else {
                            Timer.invalidate()
    //                            self.tim=nil
                            //aggiorna statistiche
                            if self.fatto==0{
                                let volte = self.defaults.integer(forKey: "\(self.esercizio)-volte")
                                self.defaults.set(volte+1, forKey: "\(self.esercizio)-volte")
                                print("aggiorna volte")
                                self.fatto=1
                            }
                            
                            
                            
                        }
                    }
            }
        } else if classe=="LinguaNo" && self.tim != nil && confidenza<150{
                print("LinguaNo")
                self.tim?.invalidate()
                self.tim=nil
//                let elapsed = NSDate.timeIntervalSinceReferenceDate - startTime
//                self.secondsRemaining = self.secondsRemaining - elapsed
        } else if classe=="LinguaSi" && self.tim != nil && confidenza>=150 {
            print("LinguaSi rosso")
            self.tim?.invalidate()
            self.tim=nil
        }
        
        DispatchQueue.main.async(execute: {
//            self.bbView.isHidden = true
            self.resultView.isHidden = false
            self.resultLabel.text = firstResult
            self.othersLabel.text = others
            
            if confidenza >= 150{
                self.resultLabel.textColor = UIColor.red
                self.othersLabel.textColor = UIColor.red
                self.errore.isHidden=false
            } else {
                self.resultLabel.textColor = UIColor.white
                self.othersLabel.textColor = UIColor.white
                self.errore.isHidden=true
            }
            
            if self.secondsRemaining > 0 {
//                self.tempo.text=("\(self.secondsRemaining) secondi")
//                print("\(self.secondsRemaining) rimanenti")
            } else{
                self.tempo.text=("Hai terminato")
                print("\(String(format: "%.2f", self.secondsRemaining)) rimanenti")
            }
            
        })
    }

//    private func updateCropAndScaleOption() {
//        let selectedIndex = cropAndScaleOptionSelector.selectedSegmentIndex
//        cropAndScaleOption = VNImageCropAndScaleOption(rawValue: UInt(selectedIndex))!
//    }
    
    // MARK: - Actions
    
//    @IBAction func modelBtnTapped(_ sender: UIButton) {
//        showActionSheet()
//    }
    
//    @IBAction func cropAndScaleOptionChanged(_ sender: UISegmentedControl) {
//        updateCropAndScaleOption()
//    }
}

//extension ViewController: UIPopoverPresentationControllerDelegate {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "popover" {
//            let vc = segue.destination
//            vc.modalPresentationStyle = UIModalPresentationStyle.popover
//            vc.popoverPresentationController!.delegate = self
//        }
//
//        if let modelDescriptionVC = segue.destination as? ModelDescriptionViewController, let model = selectedModel {
//            modelDescriptionVC.modelDescription = model.modelDescription
//        }
//
//    }
//
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }
//
//
//}

extension URL {
    var modelName: String {
        return lastPathComponent.replacingOccurrences(of: ".mlmodelc", with: "")
    }
}

