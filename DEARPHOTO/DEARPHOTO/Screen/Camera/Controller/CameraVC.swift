//
//  CameraVC.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/05.
//

import UIKit
import AVFoundation
import Photos

class CameraVC: UIViewController {
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var overlayView: UIImageView!
    @IBOutlet weak var overlayCV: UICollectionView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var selectedImages: [UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCameraView()
        setUpOverlayImageCV()
        setUpOverlayView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func setupCameraView() {
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print(error.localizedDescription)
        }
    }
    
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    func setUpOverlayImageCV() {
        overlayCV.dataSource = self
        overlayCV.delegate = self
        
        if let flowLayout = overlayCV.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    func setUpOverlayView() {
        overlayView.layer.opacity = 0.5
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(setUpOverlayViewOpacity))
        overlayView.addGestureRecognizer(panGesture)
        overlayView.isUserInteractionEnabled = true
    }
    
    func saveImage() {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            DispatchQueue.main.async {
                guard let image = self.captureImageView.image else {
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: nil)
            }
        }
    }
    
    @objc func setUpOverlayViewOpacity(sender: UIPanGestureRecognizer) {
        var overlayOpacity = 0.5
        if sender.state == .changed {
            let dragPosition = sender.translation(in: self.view).y
            let overlayViewHeight = overlayView.frame.height
            overlayOpacity -= (dragPosition / overlayViewHeight)

            overlayView.layer.opacity = (overlayOpacity <= 0) ? 0.1 : Float(overlayOpacity)
        }
    }
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
        else { return }
        
        let image = UIImage(data: imageData)
        captureImageView.image = image
        
        DispatchQueue.main.async {
            self.saveImage()
        }
    }
}

extension CameraVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = overlayCV.dequeueReusableCell(withReuseIdentifier: Identifiers.overlayImageCVC, for: indexPath) as? OverlayImageCVC else { return UICollectionViewCell() }
        cell.overlayImage.image = selectedImages?[indexPath.row]
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 2
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = overlayCV.cellForItem(at: indexPath) as! OverlayImageCVC
        
        if cell.isReSelect{
            overlayCV.deselectItem(at: indexPath, animated: false)
            overlayView.image = UIImage()
        } else {
            overlayView.image = cell.overlayImage.image
            overlayView.contentMode = .scaleAspectFill
        }
        cell.isReSelect.toggle()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = overlayCV.cellForItem(at: indexPath) as! OverlayImageCVC
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.isReSelect = false
    }
}

extension CameraVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
