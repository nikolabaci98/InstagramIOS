//
//  Camera.swift
//  Instagram
//
//  Created by Nikola Baci on 3/26/22.
//

import UIKit
import CameraManager

class Camera: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    let cameraManager = CameraManager()
    var imageTaken: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        configureView()
    
    }
    
    @IBAction func onPhotoTaken(_ sender: UIButton) {
        cameraManager.capturePictureWithCompletion({ result in
            switch result {
                case .failure:
                    print("Unable to capture photo")
                case .success(let content):
                    self.imageTaken = content.asImage
                    self.performSegue(withIdentifier: K.cameraToComposePost, sender: self)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.cameraToComposePost {
            let postVC = segue.destination as! ComposePostViewController
            postVC.image = imageTaken
        }
    }
    
    
    func configureView() {
        cameraManager.addPreviewLayerToView(cameraView)
        let zoomScale = CGFloat(2.0)
        cameraManager.zoom(zoomScale)
        cameraManager.shouldEnableTapToFocus = true
        cameraManager.shouldEnablePinchToZoom = true
        cameraManager.shouldEnableExposure = true
    }
}
