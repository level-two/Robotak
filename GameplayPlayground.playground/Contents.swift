import Foundation

class StateMachine<State, Event> where State: Hashable, Event: Hashable {
    init() {
        handlers = [:]
        transitions = [:]
        currentState = nil
    }
    
    public func setTransition(from: State, to : State, on event: Event) {
        if transitions.index(forKey: from) == nil {
            transitions[from] = [event:to]
        } else {
            transitions[from]![event] = to
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
        guard let state = currentState else  {
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
    private var handlers: [State : ()->Void]
    private var transitions: [State: [Event: State]]
}

enum State {
    case initial
    case playerMove
    case turning
    case applyBonuses
    case fight
}

enum Event {
    case onInitialAnimationFinished
    case onTrunButton
    case onTurnCompleted
    case onBonusesApplied
    case onFightFinished
}

let stateMachine = StateMachine<State, Event>()

stateMachine.setTransition(from: .initial, to: .playerMove, on: .onInitialAnimationFinished)
stateMachine.setTransition(from: .playerMove, to: .turning, on: .onTrunButton)
stateMachine.setTransition(from: .turning, to: .applyBonuses, on: .onTurnCompleted)
stateMachine.setTransition(from: .applyBonuses, to: .fight, on: .onBonusesApplied)
stateMachine.setTransition(from: .fight, to: .playerMove, on: .onFightFinished)

stateMachine.setHandler(for: .initial) { [weak stateMachine] in
    print("initial state handler")
    stateMachine?.fire(.onInitialAnimationFinished)
}

stateMachine.setHandler(for: .playerMove) {
    print("playerMove state handler")
}

stateMachine.setHandler(for: .turning) {
    print("turning state handler")
}

stateMachine.setHandler(for: .applyBonuses) {
    print("applyBonuses state handler")
}

stateMachine.setHandler(for: .fight) {
    print("fight state handler")
}

stateMachine.start(with: .initial)

// TODO: Implement additional state machine to handle bonus applying substates
//case applyLaser
//case applyHeat
//case applyElectricity
//case applyShield
//case applyHack
//case applyRepair
//case applyRobots`
