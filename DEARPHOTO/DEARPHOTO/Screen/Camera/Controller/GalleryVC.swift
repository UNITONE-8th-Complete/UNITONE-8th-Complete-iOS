//
//  GalleryVC.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/05.
//

import UIKit
import BSImagePicker

class GalleryVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureImagePicker()
    }
}

extension GalleryVC {
    func configureImagePicker() {
        let imagePicker = ImagePickerController()
        
        // TODO: - Set Color
//        imagePicker.cancelButton.tintColor = .primary
//        imagePicker.doneButton.tintColor = .primary
//        imagePicker.settings.theme.selectionFillColor = .primary
        
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.settings.selection.max = 5
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.theme.selectionStyle = .numbered
        
        imagePicker.cancelButton.primaryAction = UIAction(handler: { _ in
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers![0]
            self.dismiss(animated: true)
        })
        
        self.presentImagePicker(imagePicker, select: { (asset) in
        }, deselect: { (asset) in
        }, cancel: { (assets) in
        }, finish: { (assets) in
            guard let cameraVC = ViewControllerFactory.viewController(for: .camera) as? CameraVC else { return }
            self.navigationController?.pushViewController(cameraVC, animated: true)
        }, completion: {
        })
    }
}
