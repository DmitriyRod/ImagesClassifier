//
//  SecondViewController.swift
//  ImageClassifier
//
//  Created by Admin on 07.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController{

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    private let classifierService = ImageClassifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToImageClassifierService()
    }
    
    @IBAction func downloadbutton(_ sender: Any) {
        
        /*let url = URL(string: )
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        imageView.image = UIImage(data: data!)*/
       // textField.text = "https://image.blockbusterbd.net/00416_main_image_04072019225805.png"
        /*https://c7.uihere.com/files/629/1005/207/canadian-eskimo-dog-miniature-siberian-husky-sakhalin-husky-tamaskan-dog-alaskan-malamute-others-thumb.jpg
         */
        let url = textField.text!
        guard let imageURL = URL(string: url)
        else { return }
            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.classifierService.classifyImage(image!)
                self.imageView.image = image
            }
        }
        
    }
    @IBAction func downloadButto(_ sender: Any) {
    }
    
    private func bindToImageClassifierService() {
      classifierService.onDidUpdateState = { [weak self] state in
        self?.setupWithImageClassifierState(state)
      }
    }
    
    private func setupWithImageClassifierState(_ state: ImageClassifierState) {
      textLabel.isHidden = false
      switch state {
      case .startRequest:
        textLabel.text = "Сlassification in progress"
      case .requestFailed:
        textLabel.text = "Classification is failed"
      case .receiveResult(let result):
        textLabel.text = result.description
      }
    }
    
}
