//
//  CardView.swift
//  AppStore
//
//  Created by angel zambrano on 12/6/24.
//

import Foundation
import UIKit

class CardView: UIView {
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //
 
    
    var featuredTitleCenter: NSLayoutConstraint = NSLayoutConstraint()
    
    lazy var featuredTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowOffset = CGSize(width: -1, height: 1)
        label.layer.shadowOpacity = 0.1
        label.layer.shadowRadius = 5
        
        label.textColor = .heroTextColor
        return label
    }()
    
    lazy var featuredSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = cardModel.backgroundType.subtitleTextColor
        label.text = "training plans for our next marathon or run around the park"
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = cardModel.backgroundType.titleTextColor
        
        return label
    }()
    
    var subtitleTop: NSLayoutConstraint = NSLayoutConstraint()
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = cardModel.backgroundType.subtitleTextColor
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = cardModel.backgroundType.subtitleTextColor
        return label
    }()
    
    var leftConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var rightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var topConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var bottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    var appViewTop: NSLayoutConstraint = NSLayoutConstraint()
    var appView: AppView?
    var cardModel: CardViewModel
    var collectionAppViews: [AppView] = []
    
    init(cardModel: CardViewModel, appView: AppView?) {
        self.cardModel = cardModel
        self.appView = appView

        super.init(frame: .zero)
        
        self.appView?.backgroundType = cardModel.backgroundType
        
        leftConstraint = containerView.leftAnchor.constraint(equalTo: self.leftAnchor)
        rightConstraint = containerView.rightAnchor.constraint(equalTo: self.rightAnchor)
        topConstraint = containerView.topAnchor.constraint(equalTo: self.topAnchor)
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Shadow -
    func addShadow() {
        shadowView.layer.cornerRadius = 20
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOffset = CGSize(width: -1, height: 2)
    }
    
    func removeShadow() {
        shadowView.layer.shadowColor = UIColor.clear.cgColor
        shadowView.layer.shadowOpacity = 0
        shadowView.layer.shadowRadius = 0
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func updateLayout(for viewMode: CardViewMode) {
        switch viewMode {
        case .card:
            leftConstraint.constant = 20
            rightConstraint.constant = -20
            topConstraint.constant = 15
            bottomConstraint.constant = -15
            
            subtitleTop.constant = 20
            featuredTitleCenter.constant = featuredTitleconstant
            appViewTop.constant = 25
            
            addShadow()
        case .full:
            
            let topPadding = UIWindow.topPadding
            
            leftConstraint.constant = 0
            rightConstraint.constant = 0
            topConstraint.constant = 0
            bottomConstraint.constant = 0
            
            subtitleTop.constant = max(20, topPadding)
            featuredTitleCenter.constant = max(featuredTitleconstant, topPadding)
            appViewTop.constant = max(25, topPadding + 5)
            

            removeShadow()
        }
    }
    
    func convertContainerViewToCardView() {
        updateLayout(for: .card)

        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
    }
    
    func convertContainerViewToFullScreen() {
        updateLayout(for: .full)

        containerView.layer.cornerRadius = 0
        containerView.layer.masksToBounds = true
    }
    
    // MARK: - Configure View -
    func configureViews() {
        backgroundColor = .clear
        addSubview(shadowView)
        addSubview(containerView)
        
        if cardModel.viewMode == .card {
            convertContainerViewToCardView()
        } else {
            convertContainerViewToFullScreen()
        }
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: containerView.topAnchor),
            shadowView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            shadowView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            shadowView.leftAnchor.constraint(equalTo: containerView.leftAnchor)
        ])
        
        addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        
        switch cardModel.viewType {
        case .appOfTheDay:
            addBackgroundImage(withApp: true)
            addFeaturedTitle()
          
          
        }
        
        
        
    }
    
    // MARK: - Description Label -
    private func addDescriptionLabel() {
        configureDescriptionLabel()
        containerView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20.0),
            descriptionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -40.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15.0)
        ])
        
    }
    
    private func configureDescriptionLabel() {
        guard let description = cardModel.description else { return }

        descriptionLabel.configureAppSubHeaderLabel(withText: description)
    }
    
    // MARK: - Background Image -
    private func addBackgroundImage(withApp hasApp: Bool) {
        configureBackgroundImage()

        containerView.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor)
        ])

        guard let appView = appView, hasApp else { return }
        appView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(appView)

        let topPadding = UIWindow.topPadding
        var top: CGFloat = 25.0
        
        if cardModel.viewMode == .full {
            top = max(top, topPadding + 5)
        }
        
        appViewTop = appView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: top)
        
        NSLayoutConstraint.activate([
            appViewTop,
            appView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
            appView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -0),
            appView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -0)
        ])
        
        
    }
    
    private func configureBackgroundImage() {
        guard let backgroundImage = cardModel.backgroundImage else { return }
        backgroundImageView.image = backgroundImage
        
    }
    
    let featuredTitleconstant: CGFloat = 70
    
    // MARK: - Featured Title -
    private func addFeaturedTitle() {

        containerView.addSubview(featuredTitleLabel)
        containerView.addSubview(featuredSubtitleLabel)
        
        let topPadding = UIWindow.topPadding
        var center: CGFloat = featuredTitleconstant
        
        if cardModel.viewMode == .full {
            center = max(center, topPadding)
        }
        
        featuredTitleCenter = featuredTitleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: center)
        
        NSLayoutConstraint.activate([
            featuredTitleCenter,
            featuredTitleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            featuredSubtitleLabel.topAnchor.constraint(equalTo: featuredTitleLabel.bottomAnchor, constant: 8),
            featuredSubtitleLabel.leftAnchor.constraint(equalTo: featuredTitleLabel.leftAnchor, constant: 0 ),

        ])

        configureFeaturedTitle()
    }
    
    private func configureFeaturedTitle() {
        
        guard let title = cardModel.app?.mainTitle else {return}
        guard let subtitle = cardModel.app?.subtitle else {return}
              
        featuredTitleLabel.configureHeaderLabel(withText: title)
        
        
        
        featuredSubtitleLabel.configureAppSubHeaderLabel2(withText: subtitle)

    }
    

 
    
    // MARK: - Top Title Labels -
    private func addTopTitleLabels() {
        configureTopTitleLabels()

        containerView.addSubview(subtitleLabel)
        containerView.addSubview(titleLabel)
        
        let topPadding = UIWindow.topPadding
        var top: CGFloat = 20.0
        if cardModel.viewMode == .full {
            top = max(top, topPadding)
        }
        
        subtitleTop = subtitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: top)
        
        NSLayoutConstraint.activate([
            subtitleTop,
            subtitleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20.0),
            subtitleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20.0),
        
            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 5.0),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20.0),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20.0),
            
        ])
        
    }
    
    private func configureTopTitleLabels() {
        guard let subtitle = cardModel.subtitle,
              let title = cardModel.title else { return }

        subtitleLabel.configureSubHeaderLabel(withText: subtitle.uppercased())
        titleLabel.configureHeaderLabel(withText: title)
    }
    
    private func setUpCallOutConstraints() {
        guard let app = appView else { return }

        NSLayoutConstraint.activate([
            app.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20.0),
            app.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.0),
            app.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20.0),
            app.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    
    }
    
    func configure(with viewModel: CardViewModel) {
    
        self.cardModel = viewModel

        if let appViewModel = viewModel.app {
            self.appView?.configure(with: appViewModel)
        } else {
            self.appView = nil
        }

        
        switch cardModel.viewType {
        case .appOfTheDay:
            hide(views: [self.titleLabel, self.subtitleLabel, self.descriptionLabel])
            addBackgroundImage(withApp: true)
            addFeaturedTitle()

 
        }
    }
    
    func hide(views: [UIView]) {
        views.forEach{ $0.removeFromSuperview() }
    }
    
    func show(views: [UIView]) {
        views.forEach{ $0.isHidden = false }
    }
    

    
}


