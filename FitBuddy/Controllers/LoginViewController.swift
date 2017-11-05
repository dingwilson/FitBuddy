//
//  LoginViewController.swift
//  FitBuddy
//
//  Created by Wilson Ding on 11/4/17.
//  Copyright © 2017 Wilson Ding. All rights reserved.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var room: String?

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let captureDevice = AVCaptureDevice.default(for: .video)

        do {
            captureSession = AVCaptureSession()

            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession?.addInput(input)

            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)

            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)

            captureSession?.startRunning()

            qrCodeFrameView = UIView()

            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.orange.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
        } catch {
            print(error)
            return
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        captureSession?.stopRunning()
    }

    @IBAction func didPressBackButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToExerciseVC" {
            let destinationViewController = segue.destination as! ExerciseViewController
            
            destinationViewController.room = room
        }
    }
}

extension LoginViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }

        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            if metadataObj.stringValue != nil {
                captureSession?.stopRunning()

                room = metadataObj.stringValue!
                let userName = UserDefaults.standard.object(forKey: "userName") as? String
                print("username: " + userName! + " - " + room!)

                performSegue(withIdentifier: "segueToExerciseVC", sender: self)
            }
        }
    }
}
