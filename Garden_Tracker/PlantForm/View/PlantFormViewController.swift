//
//  PlantFormViewController.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import UIKit
import Combine

class PlantFormViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var informationTitleLabel: UILabel!
    @IBOutlet weak var careTitleLabel: UILabel!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var typeTextField: BaseTextField!
    @IBOutlet weak var boardingDateTextField: UITextField!
    @IBOutlet weak var harvestDateTextField: UITextField!
    @IBOutlet weak var wateringTextField: BaseTextField!
    @IBOutlet weak var lightTextField: BaseTextField!
    @IBOutlet weak var fertilizersTextField: BaseTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    private let boardingDatePicker = UIDatePicker()
    private let harvestDatePicker = UIDatePicker()
    private let viewModel = PlantFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var complition: (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }

    func setupUI() {
        setNavigationTitle(title: "Add a new plant")
        self.navigationItem.hidesBackButton = true
        contentView.layer.cornerRadius = 4
        contentView.addShadow()
        informationTitleLabel.font = .montserratSemiBold(size: 16)
        careTitleLabel.font = .montserratSemiBold(size: 16)
        titleLabels.forEach({ $0.font = .montserratMedium(size: 14) })
        saveButton.titleLabel?.font = .montserratBold(size: 16)
        cancelButton.titleLabel?.font = .montserratMedium(size: 16)
        let textFields = [boardingDateTextField, harvestDateTextField]
        textFields.forEach { field in
            field?.layer.cornerRadius = 5
            field?.layer.borderWidth = 1
            field?.layer.borderColor = UIColor.border.cgColor
            field?.font = .montserratMedium(size: 16)
            field?.delegate = self
        }
        nameTextField.delegate = self
        typeTextField.delegate = self
        wateringTextField.delegate = self
        lightTextField.delegate = self
        fertilizersTextField.delegate = self
        boardingDateTextField.setupRightViewIcon(.downIcon, size: CGSize(width: 40, height: 20))
        harvestDateTextField.setupRightViewIcon(.downIcon, size: CGSize(width: 40, height: 20))
        boardingDatePicker.locale = NSLocale.current
        boardingDatePicker.datePickerMode = .date
        boardingDatePicker.preferredDatePickerStyle = .inline
        boardingDatePicker.addTarget(self, action: #selector(boardingDateChanged), for: .valueChanged)
        boardingDateTextField.inputView = boardingDatePicker
        harvestDatePicker.locale = NSLocale.current
        harvestDatePicker.datePickerMode = .date
        harvestDatePicker.preferredDatePickerStyle = .inline
        harvestDatePicker.addTarget(self, action: #selector(harvestDateChanged), for: .valueChanged)
        harvestDateTextField.inputView = harvestDatePicker
        registerKeyboardNotifications()
    }
    
    func subscribe() {
        viewModel.$plantModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] plant in
                guard let self = self else { return }
                self.saveButton.isEnabled = (plant.fertilizers.checkValidation() && plant.boardingDate != nil && plant.harvestDate != nil && plant.light.checkValidation() && plant.name.checkValidation() && plant.type.checkValidation() && plant.watering.checkValidation())
            }
            .store(in: &cancellables)
    }
    
    @objc func boardingDateChanged() {
        print(boardingDatePicker.date)
        viewModel.plantModel.boardingDate = boardingDatePicker.date
        boardingDateTextField.text = boardingDatePicker.date.toString()
    }
    
    @objc func harvestDateChanged() {
        print(boardingDatePicker.date)
        viewModel.plantModel.harvestDate = harvestDatePicker.date
        harvestDateTextField.text = harvestDatePicker.date.toString()
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        viewModel.clear()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.complition?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension PlantFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            viewModel.plantModel.name = textField.text
        case typeTextField:
            viewModel.plantModel.type = textField.text
        case wateringTextField:
            viewModel.plantModel.watering = textField.text
        case lightTextField:
            viewModel.plantModel.light = textField.text
        case fertilizersTextField:
            viewModel.plantModel.fertilizers = textField.text
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == boardingDateTextField || textField == harvestDateTextField {
            return false
        }
        return true
    }
}

extension PlantFormViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(PlantFormViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
