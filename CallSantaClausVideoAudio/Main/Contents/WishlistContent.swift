//
//  WishlistContent.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import UIKit

class WishlistContent: AUI.BaseListContentView {

    let editButton = AUI.Button()
    let selectAllButton = AUI.Button()
    let deleteButton = AUI.Button()
    let addButton = AUI.Button()
    let titleLabel = AUI.Label()
    
    private var itemsStack = AUI.VerticalView()
    private var isEditingMode = false
    private var selectedIndexes: Set<Int> = []

    override func setup() {
        super.setup()
        backgroundColor = .santaRed
        addSubview(addButton)
        addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            if isEditingMode {
                toggleEditing()
            }
        }
        selectAllButton.actionBlock = { [weak self] _ in
            self?.selectAll()
        }
        deleteButton.actionBlock = { [weak self] _ in
            self?.deleteSelected()
        }
        editButton.actionBlock = { [weak self] _ in
            self?.toggleEditing()
        }
        selectAllButton.isHidden = true
        deleteButton.isHidden = true
        withViews {
            AUI.ZStackView()
                .with(horizontalAligment: .fill)
                .with(margin: .horizontal(16).top(65))
                .withViews {
                    selectAllButton
                        .with(text: "Select All")
                        .with(textColor: .white)
                        .with(font: .systemFont(ofSize: 12))
                        .with(estimatedWidth: 80)
                        .with(estimatedHeight: 30)
                        .with(verticalAligment: .center)
                    
                    titleLabel
                        .with(font: .boldSystemFont(ofSize: 18))
                        .with(textColor: .white)
                        .with(title: "Call Santa Claus")
                        .with(horizontalAligment: .center)
                        .with(verticalAligment: .center)
                    
                    editButton
                        .with(text: "Edit")
                        .with(textColor: .white)
                        .with(font: .boldSystemFont(ofSize: 16))
                        .with(estimatedWidth: 60)
                        .with(estimatedHeight: 30)
                        .with(horizontalAligment: .right)
                        .with(verticalAligment: .center)
                    
                    deleteButton
                        .with(image: UIImage(systemName: "trash.fill"))
                        .with(tintColor: .white)
                        .with(estimatedWidth: 80)
                        .with(estimatedHeight: 30)
                        .with(horizontalAligment: .right)
                        .with(verticalAligment: .center)
                }
            
            itemsStack
                .with(spacing: 20)
                .with(horizontalAligment: .fill)
                .with(margin: .top(20).horizontal(16))
        }
        
        addButton
            .with(image: .plusButton)
        
        reloadItems()
    }

    // MARK: - Editing
    
    private func toggleEditing() {
        isEditingMode.toggle()
        selectAllButton.isHidden = !isEditingMode
        deleteButton.isHidden = !isEditingMode
        editButton.isHidden = isEditingMode ? true : false
        
        selectedIndexes.removeAll()
        reloadItems()
    }
    
    private func selectAll() {
        selectedIndexes = Set(WishlistStorage.shared.items.indices)
        reloadItems()
    }
    
    private func deleteSelected() {
        WishlistStorage.shared.remove(at: Array(selectedIndexes))
        selectedIndexes.removeAll()
        reloadItems()
    }
    
    // MARK: - Reload
    
    func reloadItems() {
        itemsStack.views = WishlistStorage.shared.items.enumerated().map({ index, item in
            let wishView = WishlistItemView()
            wishView.titleLabel.text = item
            wishView.isEditing = isEditingMode
            wishView.isSelected = selectedIndexes.contains(index)
            
            wishView.onTap = { [weak self] in
                guard let self else { return }
                if self.isEditingMode {
                    if self.selectedIndexes.contains(index) {
                        self.selectedIndexes.remove(index)
                    } else {
                        self.selectedIndexes.insert(index)
                    }
                    self.reloadItems()
                }
            }
            return wishView
        })
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomInset: CGFloat = 180
        let buttonWidth: CGFloat = 64
        let buttonHeight: CGFloat = 64
        
        let x = (bounds.width - buttonWidth) / 2
        let y = bounds.height - bottomInset
        addButton.frame = CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)
    }
}

class WishlistItemView: AUI.HorizontalView {
    let titleLabel = AUI.Label()
    var isEditing: Bool = false {
        didSet {
            radioButton.isHidden = !isEditing
        }
    }
    let radioButton = AUI.Button()
    
    var isSelected: Bool = false {
        didSet {
            radioButton.isHidden = !isSelected
        }
    }
    
    var onTap: (() -> Void)?
    
    override func setup() {
        super.setup()
        horizontalAligment = .fill
        verticalAligment = .center
        withViews {
            radioButton
                .with(verticalAligment: .center)
                .with(image: .selectedButton)
                .with(estimatedWidth: 24)
                .with(estimatedHeight: 24)
                .with(margin: .right(8))
            AUI.HorizontalView()
                .with(spacing: 8)
                .with(cornerRadius: 20)
                .with(horizontalAligment: .fill)
                .with(padding: .vertical(12))
                .with(backgroundColor: .santaCardRed)
                .withViews {
                    AUI.ImageView()
                        .with(margin: .left(12))
                        .with(image: .gift)
                    
                    titleLabel
                        .with(font: .systemFont(ofSize: 16))
                        .with(textColor: .white)
                        .with(horizontalAligment: .fill)
                        .with(verticalAligment: .center)
                        .with(margin: .right(12))
                        .with(numberOfLines: 0)
                }
        }
        
        addTapGestureRecognizer { [weak self] in
            self?.onTap?()
        }
    }
}

class AddWishController: UIViewController {
    var onAdd: ((String) -> Void)?
    private let textField = UITextField()
    private let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .santaRed
        
        // MARK: - TextField
        let placeholderText = "Enter your wish"
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: UIColor.black.withAlphaComponent(0.4),
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )

        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.textColor = .black
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        
        textField.frame = CGRect(x: 16, y: 150, width: view.bounds.width - 32, height: 44)
        view.addSubview(textField)
        
        
        // MARK: - Add Button
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.santaRed, for: .normal)
        addButton.backgroundColor = .santaYellow
        addButton.layer.cornerRadius = 22
        addButton.frame = CGRect(x: 16, y: 210, width: view.bounds.width - 32, height: 44)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    @objc private func addTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        onAdd?(text)
        dismiss(animated: true)
    }
}

