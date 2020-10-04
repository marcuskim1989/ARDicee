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
    
    var diceArray = [SCNNode]()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported {
            
            let configuration = ARWorldTrackingConfiguration()
            
            configuration.planeDetection = .horizontal
            
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
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .horizontal)
            
            if let hitResult = results {
                
               addDice(atLocation: hitResult)
                    
                }
            }
        }
    
    
    
    //MARK: - Dice Rendering methods
    
    
    func addDice(atLocation location: ARRaycastQuery) {
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            
            diceNode.position = SCNVector3(
                x: location.direction.x,
                y: location.direction.y + diceNode.boundingSphere.radius,
                z: location.direction.z
            )
            
            diceArray.append(diceNode)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            roll(dice: diceNode)
        }
    }
    
    
    
    func roll(dice: SCNNode) {
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5),
                                              y: 0,
                                              z: CGFloat(randomZ * 5),
                                              duration: 0.5))
    }
    
    
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    
    
    
    
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    
    
    
    
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    
    
    
    
    
    
    @IBAction func removeAllDice(_ sender: UIBarButtonItem) {
    
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
    
    }
    
    
    
    //MARK: - ARSceneViewDelegate Methods
    
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        let planeNode = createPlane(withPlaneAnchor: planeAnchor)
        
        node.addChildNode(planeNode)
      
    }
    
    
    //MARK: - Plane rendering methods
    
    func createPlane(withPlaneAnchor planeAnchor: ARPlaneAnchor) -> SCNNode{
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let planeNode = SCNNode()
        
        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        let gridMaterial = SCNMaterial()
        
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        plane.materials = [gridMaterial]
        
        planeNode.geometry = plane
        
        return planeNode
    }
    
}

