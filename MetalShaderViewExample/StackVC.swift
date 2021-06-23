//
//  StackVC.swift
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

import UIKit

class StackVC: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let screenWidth = UIScreen.main.bounds.size.width

    private let vertexShaderName = "vertex_main"

    private let fragmentShaderNames = ["cells",
                                       "animated_gradient",
                                       "gray_noise",
                                       "colors_rainbow",
                                       "meta_ball",
                                       "the_matrix",
                                       "wobbly_shape",
                                       "noice"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }

    private func setUpViews() {
        view.addSubview(scrollView)
            scrollView.addSubview(stackView)
        fragmentShaderNames.forEach { fragmentShaderName in
            if let sv = MetalShaderView(vertexShaderName: vertexShaderName, fragmentShaderName: fragmentShaderName) {
                sv.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
                sv.heightAnchor.constraint(equalToConstant: screenWidth).isActive = true
                stackView.addArrangedSubview(sv)
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleShaderViewTap(sender:)))
                sv.addGestureRecognizer(tapGR)
            }
        }
        navigationController?.navigationBar.tintColor = .black
    }

    private func setUpConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints += [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        constraints += [
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc
    private func handleShaderViewTap(sender: UITapGestureRecognizer) {
        guard let sv = sender.view as? MetalShaderView else {
            return
        }
        let vc = DetailVC(vertexShaderName:sv.vertexShaderName, fragmentShaderName: sv.fragmentShaderName)
        navigationController?.pushViewController(vc, animated: true)
    }

}
