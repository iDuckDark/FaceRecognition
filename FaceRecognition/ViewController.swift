//
//  ViewController.swift
//  FaceRecognition
//
//  Created by iDarkDuck on 2019-02-01.
//  Copyright © 2019 iDarkDuck. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextView: UITextView!
    
    @IBAction func `import`(_ sender: Any){
        //Create image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //display the image picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //Pick photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            myImageView.image = image
        }
        detect()
        self.dismiss(animated: true, completion: nil)
    }
    
    func detect(){
        //Get image from image view
        let myImage = CIImage(image: myImageView.image!)!
        //Set up the detecor
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: myImage, options: [CIDetectorSmile:true])
        
        if (!faces!.isEmpty){
            for face in faces as! [CIFaceFeature] {
                let moutShowing = "\nMouth is showing: \(face.hasMouthPosition)"
                let isSmiling = "\nPerson is smiling: \(face.hasSmile)"
                var bothEyesShowing = "\nBoth eyes showing: true"
                if !face.hasRightEyePosition || !face.hasLeftEyePosition {
                    bothEyesShowing = "\nBoth eyes showing: false"
                }
                //Degree of suspiciousness
                let array = ["Low", "Medium", "High", "Very high"]
                var suspectDegree = 0
                if !face.hasMouthPosition {suspectDegree += 1}
                if !face.hasSmile {suspectDegree += 1}
                if bothEyesShowing.contains("false") {suspectDegree += 1}
                if face.faceAngle > 10 || face.faceAngle < -10 {suspectDegree += 1}
                let suspectText = "\nSuspiciousness: \(array[suspectDegree])"
                myTextView.text = "\(suspectText) \n\(moutShowing) \(isSmiling) \(bothEyesShowing)"
            }
        }
        else{
            myTextView.text = "No faces found"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detect()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
