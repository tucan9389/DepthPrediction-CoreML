//
//  ViewController.swift
//  DepthPrediction-CoreML
//
//  Created by Doyoung Gwak on 20/07/2019.
//  Copyright © 2019 Doyoung Gwak. All rights reserved.
//

import UIKit

class StillImageViewController: UIViewController {
    
    // MARK: - UI Properties
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var drawingView: DrawingHeatmapView!
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // image picker delegate setup
        imagePickerController.delegate = self
    }

    @IBAction func tapCamera(_ sender: Any) {
        self.present(imagePickerController, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension StillImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage,
            let url = info[.imageURL] as? URL {
            mainImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
