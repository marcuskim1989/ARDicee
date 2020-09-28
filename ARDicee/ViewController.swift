//
//  ViewController.swift
//  ARDicee
//
//  Created by Marcus Y. Kim on 9/27/20.
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
        
       // let plane = SCNPlane(width: 1, height: 1.5)
        
       // let sphere = SCNSphere(radius: 0.2)
                
      //  let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
      // let material = SCNMaterial()
        
     //   material.diffuse.contents = UIImage(named: "art.scnassets/mom_selfie.jpeg")
//
     //   plane.materials = [material]
//
     //   let node = SCNNode()
//
     //   node.position = SCNVector3(0, 0.1, -1)
//
      //  node.geometry = plane
        
       //sceneView.scene.rootNode.addChildNode(node)
        
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
////
//
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//
//        diceNode.position = SCNVector3(0, 0, -0.1)
//
//        sceneView.scene.rootNode.addChildNode(diceNode)
//        }
        
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported {
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
            
            configuration.planeDetection = .horizontal

        
        
        // Run the view's session
        sceneView.session.run(configuration)
        } else {
            print("Your device is not supported. Switching to alternative configuration")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            print("plane detected")
        } else {
            return
        }
    }

}
