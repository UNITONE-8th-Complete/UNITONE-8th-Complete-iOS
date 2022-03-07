//
//  GalleryVC.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/05.
//

import UIKit
import BSImagePicker
import Photos

class GalleryVC: UIViewController {
    var selectedImages: [UIImage]?
    
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
        
        imagePicker.cancelButton.tintColor = .primary
        imagePicker.doneButton.tintColor = .primary
        imagePicker.settings.theme.selectionFillColor = .primary
        
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
            self.convertAssetToImages(assets)
            
            guard let cameraVC = ViewControllerFactory.viewController(for: .camera) as? CameraVC else { return }
            cameraVC.selectedImages = self.selectedImages
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(cameraVC, animated: true)
        }, completion: {
        })
    }
    
    func convertAssetToImages(_ selectedAssets: [PHAsset]) {
        selectedImages = selectedAssets.map {
            let imageManager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            var image = UIImage()
            
            imageManager.requestImage(for: $0,
                                         targetSize: CGSize(width:300, height: 300),
                                         contentMode: .aspectFit,
                                         options: option) { (result, info) in
                image = result!
            }
            
            let data = image.jpegData(compressionQuality: 0.7)
            let newImage = UIImage(data: data!)!
            
            return newImage
        }
    }
}
