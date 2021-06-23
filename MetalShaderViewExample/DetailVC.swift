//
//  DetailVC.swift
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

import UIKit

class DetailVC: UIViewController {

    private let vertexShaderName: String
    private let fragmentShaderName: String
    private let metalShaderView: UIView

    init(vertexShaderName: String, fragmentShaderName: String) {
        self.fragmentShaderName = fragmentShaderName
        self.vertexShaderName = vertexShaderName
        metalShaderView = MetalShaderView(vertexShaderName: vertexShaderName,
                                          fragmentShaderName: fragmentShaderName) ?? UIView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }

    private func setUpViews() {
        metalShaderView.translatesAutoresizingMaskIntoConstraints = false
        metalShaderView.backgroundColor = .red
        view.backgroundColor = .black
        view.addSubview(metalShaderView)
    }

    private func setUpConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints += [
            metalShaderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            metalShaderView.heightAnchor.constraint(equalTo: view.widthAnchor),
            metalShaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            metalShaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
