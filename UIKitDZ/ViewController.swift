// ViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
import Combine

/// ViewController
class ViewController: UIViewController {
    private let textFieldName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ваше имя"
        textField.frame = CGRect(x: 50, y: 100, width: 200, height: 40)
        textField.borderStyle = .roundedRect
        textField.tag = 1
        return textField
    }()

    private let labelName: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 250, y: 150, width: 100, height: 50)
        return label
    }()

    private let labelSurname: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 250, y: 250, width: 100, height: 50)
        return label
    }()
    private let textFieldSurname: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ваша фамилия"
        textField.frame = CGRect(x: 50, y: 200, width: 200, height: 40)
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let viewModel = PipelineUIKitViewModel()
    private var anyCancellable: AnyCancellable?
    private var anyCancellableSurname: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupValidationName()
        setupValidationSurname()
    }

    private func addViews() {
        textFieldName.delegate = self
        view.addSubview(textFieldName)
        textFieldSurname.delegate = self
        view.addSubview(textFieldSurname)
        view.addSubview(labelName)
        view.addSubview(labelSurname)
    }

    private func setupValidationName() {
        anyCancellable = viewModel.$validationName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: labelName)

    }

    private func setupValidationSurname() {
        anyCancellableSurname = viewModel.$validationSurname
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: labelSurname)
    }


}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            viewModel.name = string
        } else {
            viewModel.surname = string
        }
        return true
    }
}

class PipelineUIKitViewModel: ObservableObject {
    @Published var name = ""
    @Published var validationName: String? = ""

    @Published var surname = ""
    @Published var validationSurname: String? = ""

    init() {
        $name
            .map { $0.isEmpty ? "-" : "+"}
            .assign(to: &$validationName)

        $surname
            .map { $0.isEmpty  ? "-" : "+"}
            .assign(to: &$validationSurname)
    }
}
