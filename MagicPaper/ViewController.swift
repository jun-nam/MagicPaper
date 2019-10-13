//
//  ViewController.swift
//  MagicPaper
//
//  Created by June Nam on 10/4/19.
//  Copyright © 2019 Jun Nam. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()
        
        let configuration = ARImageTrackingConfiguration()
        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "NewsPaperImages", bundle: Bundle.main) {
            configuration.trackingImages = imagesToTrack
            configuration.maximumNumberOfTrackedImages = 10
            print("Images were added successfullly")
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        print("renderer was called!")
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            print("image was detected! : \(imageAnchor.name!)")
            
            let videoNode = SKVideoNode(fileNamed: "harrypotter.mp4")
            videoNode.play()
            
            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
            
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            videoNode.yScale = -1.0
            videoScene.addChild(videoNode)
                        
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            //plane.firstMaterial?.diffuse.contents =  UIColor.blue
            plane.firstMaterial?.diffuse.contents =  videoScene
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2 //rotate counter-clockwise by 90 degrees
            
            node.addChildNode(planeNode)
        }
        
        return node
    }
}
