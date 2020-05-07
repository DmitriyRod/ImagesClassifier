//
//  ViewController.swift
//  ImageClassifier
//
//  Created by Admin on 06.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var descriptionalLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    
    
    
    
    private let classifierService = ImageClassifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToImageClassifierService()
        
    }
    private func bindToImageClassifierService() {
      classifierService.onDidUpdateState = { [weak self] state in
        self?.setupWithImageClassifierState(state)
      }
    }
    @IBAction func onButton(_ sender: Any) {
        showAlert()
    }
    
   private func showAlert() {
     let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
     let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
       self.showImagePicker(sourceType: .camera)
     }
     
     let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
       self.showImagePicker(sourceType: .photoLibrary)
     }
     
     let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
     alertController.addAction(cameraAction)
     alertController.addAction(photoLibraryAction)
     alertController.addAction(cancelAction)
     present(alertController, animated: true)
   }
    
    
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
       let imagePickerViewController = UIImagePickerController()
       imagePickerViewController.delegate = self
       imagePickerViewController.sourceType = sourceType
       present(imagePickerViewController, animated: true)
     }
        
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
func imagePickerController(_ picker: UIImagePickerController,
                           didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
  let imageKey = UIImagePickerController.InfoKey.originalImage
  guard let image = info[imageKey] as? UIImage else {
    dismiss(animated: true, completion: nil)
    return
  }
  dismiss(animated: true, completion: nil)
  classifierService.classifyImage(image)
  ImageView.image = image
}

    
    private func setupWithImageClassifierState(_ state: ImageClassifierState) {
      descriptionalLabel.isHidden = false
      switch state {
      case .startRequest:
        descriptionalLabel.text = "Сlassification in progress"
      case .requestFailed:
        descriptionalLabel.text = "Classification is failed"
      case .receiveResult(let result):
        descriptionalLabel.text = result.description
      }
    }
    
func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
  picker.dismiss(animated: true, completion: nil)
}
}
