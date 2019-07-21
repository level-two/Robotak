//
//  GameplaySceneViewController.swift
//  Robotak
//
//  Created by Yauheni Lychkouski on 7/20/19.
//  Copyright © 2019 Yauheni Lychkouski. All rights reserved.
//

import Foundation

class GameplayScenePresenter {

    init(_ viewController: GameplaySceneViewController) {
        self.viewController = viewController
    }

    private weak var viewController: GameplaySceneViewController!
}
