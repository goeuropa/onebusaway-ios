//
//  MoreHeaderViewController.swift
//  OBAKit
//
//  Created by Aaron Brethorst on 7/1/19.
//

import UIKit
import OBAKitCore

class MoreHeaderViewController: UIViewController {

    private let padding: CGFloat = 16.0

    private lazy var stackView = UIStackView.verticalStack(arangedSubviews: [
        topPaddingView,
        headerImageView,
        interiorPaddingView,
        appNameLabel,
        appVersionLabel,
        copyrightLabel,
        supportUsLabel,
        bottomPaddingView
    ])

    private lazy var topPaddingView: UIView = {
        let view = UIView.autolayoutNew()
        view.heightAnchor.constraint(equalToConstant: padding).isActive = true
        return view
    }()

    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView(image: Icons.header)
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        return imageView
    }()

    private lazy var interiorPaddingView: UIView = {
        let view = UIView.autolayoutNew()
        view.heightAnchor.constraint(equalToConstant: padding / 2.0).isActive = true
        return view
    }()

    private lazy var appNameLabel = buildLabel(font: UIFont.preferredFont(forTextStyle: .body).bold)
    private lazy var appVersionLabel = buildLabel()
    private lazy var copyrightLabel = buildLabel()
    private lazy var supportUsLabel = buildLabel()

    private func buildLabel(font: UIFont? = nil) -> UILabel {
        let label = UILabel.autolayoutNew()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = font ?? UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = ThemeColors.shared.lightText
        return label
    }

    private lazy var bottomPaddingView: UIView = {
        let view = UIView.autolayoutNew()
        view.heightAnchor.constraint(equalToConstant: padding).isActive = true
        return view
    }()

    private let application: Application

    init(application: Application) {
        self.application = application
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ThemeColors.shared.primary

        appNameLabel.text = Bundle.main.appName
        appVersionLabel.text = Bundle.main.appVersion
        copyrightLabel.text = Bundle.main.copyright
        supportUsLabel.text = NSLocalizedString("more_header.support_us_label_text", value: "This app is made and supported by volunteers.", comment: "Explanation about how this app is built and maintained by volunteers.")

        view.addSubview(stackView)
        stackView.pinToSuperview(.layoutMargins)

        let debugTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(enableDebugMode))
        debugTapRecognizer.numberOfTapsRequired = 8
        headerImageView.isUserInteractionEnabled = true
        headerImageView.addGestureRecognizer(debugTapRecognizer)
    }

    @objc private func enableDebugMode() {
        application.userDataStore.debugMode = true
        let alert = UIAlertController(title: NSLocalizedString("more_header.debug_enabled.title", value: "Debug Mode Enabled", comment: "Title of the alert that tells the user they've enabled debug mode."), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction.dismissAction)

        present(alert, animated: true, completion: nil)
    }
}
