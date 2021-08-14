//
//  OBAFloatingPanelController.swift
//  OBAKit
//
//  Created by Alan Chu on 8/3/21.
//

import FloatingPanel

/// A subclass of `FloatingPanelController` with additional accessibility features.
class OBAFloatingPanelController: FloatingPanelController {
    override init(delegate: FloatingPanelControllerDelegate?) {
        super.init(delegate: delegate)

        surfaceView.grabberHandle.accessibilityLabel = OBALoc("floating_panel.controller.accessibility_label", value: "Card controller", comment: "A voiceover title describing the 'grabber' for controlling the visibility of a card.")

        let expandName = OBALoc("floating_panel.controller.expand_action_name", value: "Expand", comment: "A voiceover title describing the action to expand the visibility of a card.")
        let collapseName = OBALoc("floating_panel.controller.collapse_action_name", value: "Collapse", comment: "A voiceover title describing the action to minimize (or collapse) the visibility of a card.")
        let expandAction = UIAccessibilityCustomAction(name: expandName, target: self, selector: #selector(accessibilityActionExpandPanel))
        let collapseAction = UIAccessibilityCustomAction(name: collapseName, target: self, selector: #selector(accessibilityActionCollapsePanel))

        surfaceView.grabberHandle.accessibilityCustomActions = [expandAction, collapseAction]
        surfaceView.grabberHandle.isAccessibilityElement = true
        updateAccessibilityValue()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func updateAccessibilityValue() {
        let accessibilityValue: String?
        switch self.position {
        case .full:
            accessibilityValue = OBALoc("floating_panel.controller.position.full", value: "Full screen", comment: "A voiceover title describing that the card's visibility is taking up the full screen.")
        case .half:
            accessibilityValue = OBALoc("floating_panel.controller.position.half", value: "Half screen", comment: "A voiceover title describing that the card's visibility is taking up half of the screen.")
        case .tip:
            accessibilityValue = OBALoc("floating_panel.controller.position.minimized", value: "Minimized", comment: "A voiceover title describing that the card's visibility taking up the minimum amount of screen.")
        case .hidden:
            accessibilityValue = nil
        }

        surfaceView.grabberHandle.accessibilityValue = accessibilityValue
    }

    @objc private func accessibilityActionExpandPanel() -> Bool {
        let availableAnchors = self.layout.supportedPositions.sorted(by: \.rawValue)
        guard let anchor = availableAnchors.firstIndex(of: self.position),
              anchor != 0       // Enum value of `0` is equivalent to `full`.
        else { return false }

        self.move(to: availableAnchors[anchor - 1], animated: true, completion: { [weak self] in
            self?.updateAccessibilityValue()
        })

        return true
    }

    @objc private func accessibilityActionCollapsePanel() -> Bool {
        let availableAnchors = self.layout.supportedPositions.sorted(by: \.rawValue)
        guard let anchor = availableAnchors.firstIndex(of: self.position),
              anchor != availableAnchors.count - 1
        else { return false }

        self.move(to: availableAnchors[anchor + 1], animated: true, completion: { [weak self] in
            self?.updateAccessibilityValue()
        })

        return true
    }

    // Unable to override because this version of FloatingPanel is non-open (`open` keyword).
    // Newer versions of FloatingPanel have `open` implementions of FloatingPanelController.
//    override func move(to: FloatingPanelPosition, animated: Bool, completion: (() -> Void)? = nil) {
//        super.move(to: to, animated: animated, completion: completion)
//        self.updateAccessibilityValue()
//    }
}