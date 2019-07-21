//
//  StateMachine.swift
//  Robotak
//
//  Created by Yauheni Lychkouski on 7/20/19.
//  Copyright © 2019 Yauheni Lychkouski. All rights reserved.
//

import Foundation

class StateMachine<State, Event> where State: Hashable, Event: Hashable {
    init() {
        handlers = [:]
        transitions = [:]
        currentState = nil
    }

    public func setTransition(from: State, to toState: State, on event: Event) {
        if transitions.index(forKey: from) == nil {
            transitions[from] = [event: toState]
        } else {
            transitions[from]![event] = toState
        }
    }

    public func setHandler(for state: State, handler: @escaping () -> Void) {
        handlers[state] = handler
    }

    public func start(with initState: State) {
        currentState = initState

        if let handler = handlers[initState] {
            handler()
        }
    }

    public func fire(_ event: Event) {
        guard let state = currentState else {
            fatalError("State Machine is not started!")
        }

        guard let newState = transitions[state]?[event] else {
            fatalError("Transition from \(String(describing: currentState)) on \(event) is not defined!")
        }

        currentState = newState

        if let handler = handlers[newState] {
            handler()
        }
    }

    private var currentState: State?
    private var handlers: [State : () -> Void]
    private var transitions: [State: [Event: State]]
}
