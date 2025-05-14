//
//  ReminderViewController.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 29.10.24.
//

import UIKit
import Combine
import DropDown

class ReminderViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var namePlantButton: UIButton!
    @IBOutlet weak var descriptionTextField: BaseTextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var titleLabels: [UILabel]!
    private let datePickerView = UIDatePicker()
    private let viewModel = ReminderFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var complition: (() -> ())?
    private let nameDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropDown()
        subscribe()
        viewModel.fetchPlants()
    }
    
    func setupUI() {
        setNavigationTitle(title: "Add a reminder")
        self.navigationItem.hidesBackButton = true
        contentView.layer.cornerRadius = 4
        contentView.addShadow()
        titleLabels.forEach({ $0.font = .montserratMedium(size: 14) })
        saveButton.titleLabel?.font = .montserratBold(size: 16)
        cancelButton.titleLabel?.font = .montserratMedium(size: 16)
        namePlantButton.titleLabel?.font = .montserratMedium(size: 16)
        let fields = [namePlantButton, dateTextField]
        fields.forEach { field in
            field?.layer.cornerRadius = 5
            field?.layer.borderWidth = 1
            field?.layer.borderColor = UIColor.border.cgColor
        }
        descriptionTextField.delegate = self
        dateTextField.delegate = self
        dateTextField.setupRightViewIcon(.downIcon, size: CGSize(width: 40, height: 20))
        datePickerView.locale = NSLocale.current
        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .inline
        datePickerView.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        dateTextField.inputView = datePickerView
        registerKeyboardNotifications()
    }
    
    func setupDropDown() {
        nameDropDown.backgroundColor = .white
        nameDropDown.dataSource = [""]
        nameDropDown.anchorView = contentView
        nameDropDown.direction = .bottom
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .montserratMedium(size: 16) ?? .systemFont(ofSize: 16)
        DropDown.appearance().selectionBackgroundColor = .lightGray
        nameDropDown.addShadow()
        
        nameDropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            
        }
        
        nameDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.namePlantButton.setTitle(item, for: .normal)
            self.viewModel.reminderModel.name = item
            self.viewModel.reminderModel.plantID = self.viewModel.plants[index].id
        }
    }
    
    override func viewDidLayoutSubviews() {
        nameDropDown.width = namePlantButton.bounds.width
        nameDropDown.bottomOffset = CGPoint(x: namePlantButton.frame.minX, y: namePlantButton.frame.maxY + 2)
    }
    
    func subscribe() {
        viewModel.$reminderModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reminderModel in
                guard let self = self else { return }
                saveButton.isEnabled = (reminderModel.date != nil && reminderModel.info.checkValidation() && reminderModel.name.checkValidation())
                if self.viewModel.isEditing {
                    self.namePlantButton.setTitle(reminderModel.name, for: .normal)
                    self.descriptionTextField.text = reminderModel.info
                    self.dateTextField.text = reminderModel.date?.toString()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$plants
            .receive(on: DispatchQueue.main)
            .sink { [weak self] plantsModel in
                guard let self = self else { return }
                let plants: [String] = plantsModel.map({ $0.name ?? "" })
                self.nameDropDown.dataSource = plants
            }
            .store(in: &cancellables)
    }
    
    @objc func dateChanged() {
        viewModel.reminderModel.date = datePickerView.date
        dateTextField.text = datePickerView.date.toString()
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func chooseName(_ sender: UIButton) {
        nameDropDown.show()
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedSave(_ sender: BaseButton) {
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

extension ReminderViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == descriptionTextField {
            viewModel.reminderModel.info = textField.text
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField == descriptionTextField
    }
}

extension ReminderViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ReminderViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
