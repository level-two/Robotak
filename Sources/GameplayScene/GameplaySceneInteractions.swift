//
//  GameplaySceneInteractions.swift
//  Robotak
//
//  Created by Yauheni Lychkouski on 7/20/19.
//  Copyright © 2019 Yauheni Lychkouski. All rights reserved.
//

import Foundation

class GameplaySceneInteractions {
    init(_ presenter: GameplayScenePresenter) {
        self.presenter = presenter

        assembleInteractions()
    }

    private weak var presenter: GameplayScenePresenter!
}

extension GameplaySceneInteractions {
    private func assembleInteractions() {
    }
}
