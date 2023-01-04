//
//  StarRatingView.swift
//  BoxOffice
//
//  Created by Judy on 2023/01/03.
//

import UIKit

class StarRatingView: UIView {
    private let starImages = (1...5).map { _ in StarImageView(frame: .zero) }
    private let starSlider: StarRatingUISlider = {
        let slider = StarRatingUISlider()
        slider.maximumValue = 5.0
        slider.minimumValue = 0.0
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.thumbTintColor = .clear
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupStars(to rating: Float) {
        let ratingValue = Int(rating)
        let halfValue = rating - Float(ratingValue)

        if rating == Float.zero {
            clearStar(upto: 0)
            return
        }

        fillStar(upto: ratingValue)

        if halfValue != Float.zero {
            starImages[ratingValue].image = UIImage(systemName: "star.leadinghalf.fill")
        }
    }

    @objc private func sliderStar() {
        let rating = starSlider.value
        let downedRating = rating.rounded(.down)
        let halfRating = rating - downedRating
        let rateValue = Int(downedRating)

        fillStar(upto: rateValue)
        clearStar(upto: rateValue)

        if halfRating >= 0.5 {
            starImages[rateValue].image = UIImage(systemName: "star.leadinghalf.fill")
        } else if rateValue != 5 {
            starImages[rateValue].image = UIImage(systemName: "star")
        }
    }

    private func fillStar(upto index: Int) {
        for fillIndex in 0..<index {
            starImages[fillIndex].image = UIImage(systemName: "star.fill")
        }
    }

    private func clearStar(upto index: Int) {
        for clearIndex in stride(from: starImages.count - 1, to: index, by: -1) {
            starImages[clearIndex].image = UIImage(systemName: "star")
        }
    }
}

//MARK: Setup View
extension StarRatingView {
    private func setupView() {
        setupConstraint()
        addSliderTarget()
    }
    
    private func setupConstraint() {
        starImages.forEach {
            starStackView.addArrangedSubview($0)
        }
        
        self.addSubview(starStackView)
        self.addSubview(starSlider)
        
        NSLayoutConstraint.activate([
            starStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            starStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            starStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            starStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
   
            starSlider.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            starSlider.widthAnchor.constraint(equalTo: starStackView.widthAnchor)
        ])
    }
    
    private func addSliderTarget() {
        starSlider.addTarget(self,
                             action: #selector(sliderStar),
                             for: .valueChanged)
    }
}
