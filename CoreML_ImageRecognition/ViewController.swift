//
//  ViewController.swift
//  CoreML_ImageRecognition
//
//  Created by Amarjit Singh on 12/6/18.
//  Copyright © 2018 Amarjit Singh. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else{
                fatalError("Could not convert to CIIMage")
            }
            
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model Failed to process Image")
            }
            
            print("\n")
            for i in 0...5{
                print(results[i].identifier)
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        whichImageType(typeImage: .camera)
    }
    @IBAction func folderTapped(_ sender: UIBarButtonItem) {
        whichImageType(typeImage: .photoLibrary)
    }
    
    func whichImageType(typeImage: UIImagePickerController.SourceType){
        imagePicker.sourceType = typeImage
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
}
