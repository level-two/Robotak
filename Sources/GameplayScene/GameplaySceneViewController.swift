//
//  GameplaySceneView.swift
//  Robotak
//
//  Created by Yauheni Lychkouski on 7/20/19.
//  Copyright © 2019 Yauheni Lychkouski. All rights reserved.
//

import Foundation
import UIKit

class GameplaySceneViewController: UIViewController {
    @IBOutlet var robot_left_big: UIImageView!
    @IBOutlet var robot_left_small: UIImageView!
    @IBOutlet var robot_right_big: UIImageView!
    @IBOutlet var robot_right_small: UIImageView!
    @IBOutlet var turnButton: UIButton!

    @IBAction func onTurnButton() {
        shot(from: .robot_left_big, to: .robot_right_big)
        shot(from: .robot_right_small, to: .robot_left_big)
        shot(from: .robot_right_big, to: .robot_left_small)

        movementAnimation(robotId: .robot_left_big)
        movementAnimation(robotId: .robot_right_big)
    }

    public func shot(from robot0: RobotId, to robot1: RobotId) {
        let robot0Center = robotView(for: robot0).frame.center
        let robot1Center = robotView(for: robot1).frame.center

        let shotFrame = CGRect(center: robot0Center, size: .init(width: 10, height: 10))
        let shot = UIView(frame: shotFrame)
        shot.layer.cornerRadius = shotFrame.width/2
        shot.backgroundColor = .green

        self.view.addSubview(shot)
        UIView.animate(withDuration: 2, animations: {
            UIView.setAnimationCurve(.linear)
            shot.frame = .init(center: robot1Center, size: shot.frame.size)
        }, completion: { isDone in
            shot.removeFromSuperview()
            // fulfill promise
        })
    }

    public func movementAnimation(robotId: RobotId) {
        let robot = robotView(for: robotId)
        let origTransform = robot.transform

        UIView.animate(withDuration: 0.5, animations: {
            //robot.scaleY = 0.9
            robot.transform = origTransform.scaledBy(x: 1.0, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                robot.transform = origTransform
            }, completion: { _ in
                // fulfill promise
            })
        })
    }
}

extension GameplaySceneViewController {
    func robotView(for id: RobotId) -> UIView {
        switch(id) {
        case .robot_left_big:
            return robot_left_big
        case .robot_left_small:
            return robot_left_small
        case .robot_right_big:
            return robot_right_big
        case .robot_right_small:
            return robot_right_small
        }
    }
}

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width/2,
                  y: center.y - size.height/2,
                  width: size.width,
                  height: size.height)
    }

    var center: CGPoint {
        return .init(x: midX, y: midY)
    }
}
