//
//  GBDrawingViewController.swift
//  GraffitiBoard
//
//  Created by jeongkyu kim on 2017. 7. 7..
//  Copyright © 2017년 jeongkyu kim. All rights reserved.
//

import UIKit
import NXDrawKit
import RSKImageCropper
import AVFoundation
import MobileCoreServices

class GBDrawingViewController: UIViewController {

    weak var canvasView: Canvas?
    weak var toolBar: ToolBar?
    weak var palette: UIView?
    
    
    @IBOutlet weak var toolBarContainer: UIView!
    @IBOutlet weak var canvasContainer: UIView!
    @IBOutlet weak var paletteContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.initialize()
        self.updateFrame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.updateFrame()
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            
        }) { (context) in
            self.updateFrame()
        }
    }
    
    @IBAction func onPallette(_ sender: Any) {
    }
    
    func updateFrame() {
        self.canvasView?.frame = self.canvasContainer.bounds
        self.toolBar?.frame = self.toolBarContainer.bounds
        self.palette?.frame = self.paletteContainer.bounds
    }
    
    fileprivate func initialize() {
        self.setupCanvas()
        self.setupPalette()
        self.setupToolBar()
    }
    
    fileprivate func setupPalette() {
        self.view.backgroundColor = UIColor.white
        
        if let view = GBPaletteView.createPalleteView() {
            self.paletteContainer.addSubview(view)
            self.palette = view
        }
    }
    
    fileprivate func setupToolBar() {
//        let height = (self.paletteView?.frame)!.height * 0.25
//        let startY = self.view.frame.height - (paletteView?.frame)!.height - height
//        let toolBar = ToolBar()
//        toolBar.frame = self.toolBarContainer.bounds
//        toolBar.undoButton?.addTarget(self, action: #selector(type(of:self).onClickUndoButton), for: .touchUpInside)
//        toolBar.redoButton?.addTarget(self, action: #selector(type(of:self).onClickRedoButton), for: .touchUpInside)
//        toolBar.loadButton?.addTarget(self, action: #selector(type(of:self).onClickLoadButton), for: .touchUpInside)
//        toolBar.saveButton?.addTarget(self, action: #selector(type(of:self).onClickSaveButton), for: .touchUpInside)
//        // default title is "Save"
//        toolBar.saveButton?.setTitle("Save", for: UIControlState())
//        toolBar.clearButton?.addTarget(self, action: #selector(type(of:self).onClickClearButton), for: .touchUpInside)
//        toolBar.loadButton?.isEnabled = true
//        self.toolBarContainer.addSubview(toolBar)
//        self.toolBar = toolBar
    }
    
    fileprivate func setupCanvas() {
        //        let canvasView = Canvas(backgroundImage: UIImage.init(named: "frame")!) // You can init with custom background image
        let canvasView = Canvas()
        canvasView.frame = self.canvasContainer.bounds
        canvasView.delegate = self
        canvasView.layer.borderColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.8).cgColor
        canvasView.layer.borderWidth = 1.0
        canvasView.layer.cornerRadius = 5.0
        canvasView.clipsToBounds = true
        self.canvasContainer.addSubview(canvasView)
        self.canvasView = canvasView
    }
    
    fileprivate func updateToolBarButtonStatus(_ canvas: Canvas) {
        self.toolBar?.undoButton?.isEnabled = canvas.canUndo()
        self.toolBar?.redoButton?.isEnabled = canvas.canRedo()
        self.toolBar?.saveButton?.isEnabled = canvas.canSave()
        self.toolBar?.clearButton?.isEnabled = canvas.canClear()
    }
    
    func onClickUndoButton() {
        self.canvasView?.undo()
    }
    
    func onClickRedoButton() {
        self.canvasView?.redo()
    }
    
    func onClickLoadButton() {
        self.showActionSheetForPhotoSelection()
    }
    
    func onClickSaveButton() {
        self.canvasView?.save()
    }
    
    func onClickClearButton() {
        self.canvasView?.clear()
    }
    
    
    // MARK: - Image and Photo selection
    fileprivate func showActionSheetForPhotoSelection() {
        
        let album = UIAlertAction(title: "Photo from Album", style: .default) { (action) in
            self.showPhotoLibrary()
        }
        
        let take = UIAlertAction(title: "Take a Photo", style: .default) { (action) in
            self.showCamera()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(album)
        actionSheet.addAction(take)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    fileprivate func showPhotoLibrary () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [String(kUTTypeImage)]
        
        self.present(picker, animated: true, completion: nil)
    }
    
    fileprivate func showCamera() {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch (status) {
        case .notDetermined:
            self.presentImagePickerController()
            break
        case .restricted, .denied:
            self.showAlertForImagePickerPermission()
            break
        case .authorized:
            self.presentImagePickerController()
            break
        }
    }
    
    fileprivate func showAlertForImagePickerPermission() {
        let message = "If you want to use camera, you should allow app to use.\nPlease check your permission"
        
        let action = UIAlertAction(title: "Allow", style: .default) { (alert) in
            self.openSettings()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func openSettings() {
        
        guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    fileprivate func presentImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.mediaTypes = [String(kUTTypeImage)]
            self.present(picker, animated: true, completion: nil)
            return
        }
        
        let message = "This device doesn't support a camera"
        self.showAlertMessage(message: message)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo:UnsafeRawPointer)       {
        
        var message = "Saved successfuly"
        
        if didFinishSavingWithError != nil {
            message = "Saving failed"
        }
        
        self.showAlertMessage(message: message)
    }
    
    func showAlertMessage(message:String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        print(String(describing: previousTraitCollection))
    }
}


// MARK: - CanvasDelegate
extension GBDrawingViewController: CanvasDelegate
{
    func brush() -> Brush? {
        return nil
    }
    
    func canvas(_ canvas: Canvas, didUpdateDrawing drawing: Drawing, mergedImage image: UIImage?) {
        self.updateToolBarButtonStatus(canvas)
    }
    
    func canvas(_ canvas: Canvas, didSaveDrawing drawing: Drawing, mergedImage image: UIImage?) {
        // you can save merged image
        //        if let pngImage = image?.asPNGImage() {
        //            UIImageWriteToSavedPhotosAlbum(pngImage, self, #selector(type(of:self).image(_:didFinishSavingWithError:contextInfo:)), nil)
        //        }
        
        // you can save strokeImage
        //        if let pngImage = drawing.stroke?.asPNGImage() {
        //            UIImageWriteToSavedPhotosAlbum(pngImage, self, #selector(type(of:self).image(_:didFinishSavingWithError:contextInfo:)), nil)
        //        }
        
        //        self.updateToolBarButtonStatus(canvas)
        
        // you can share your image with UIActivityViewController
//        if let pngImage = image?.asPNGImage() {
//            let activityViewController = UIActivityViewController(activityItems: [pngImage], applicationActivities: nil)
//            self.present(activityViewController, animated: true, completion: nil)
//        }
    }
}


// MARK: - UIImagePickerControllerDelegate
extension GBDrawingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
        picker.dismiss(animated: true, completion: { [weak self] in
            let cropper = RSKImageCropViewController(image:selectedImage, cropMode:.square)
            cropper.delegate = self
            self?.present(cropper, animated: true, completion: nil)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


// MARK: - RSKImageCropViewControllerDelegate
extension GBDrawingViewController: RSKImageCropViewControllerDelegate
{
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.canvasView?.update(croppedImage)
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PaletteDelegate
extension GBDrawingViewController: PaletteDelegate
{
    //    func didChangeBrushColor(color: UIColor) {
    //
    //    }
    //
    //    func didChangeBrushAlpha(alpha: CGFloat) {
    //
    //    }
    //
    //    func didChangeBrushWidth(width: CGFloat) {
    //
    //    }
    
    
    // tag can be 1 ... 12
    func colorWithTag(_ tag: NSInteger) -> UIColor? {
        if tag == 4 {
            // if you return clearColor, it will be eraser
            return UIColor.clear
        }
        return nil
    }
    
    // tag can be 1 ... 4
    //    func widthWithTag(tag: NSInteger) -> CGFloat {
    //        if tag == 1 {
    //            return 5.0
    //        }
    //        return -1
    //    }
    
    // tag can be 1 ... 3
    //    func alphaWithTag(tag: NSInteger) -> CGFloat {
    //        return -1
    //    }
}
