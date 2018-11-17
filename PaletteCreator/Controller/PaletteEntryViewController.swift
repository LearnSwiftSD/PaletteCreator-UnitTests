//
//  FirstViewController.swift
//  PaletteCreator
//
//  Created by Dave Shu on 10/14/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import UIKit

protocol PaletteEntryViewControllerDelegate: class {
    func paletteEntryViewControllerDidCancel(_ viewController: PaletteEntryViewController)
    func paletteEntryViewController(_ viewController: PaletteEntryViewController, didSavePalette palette: Palette)
}

class PaletteEntryViewController: UIViewController {
    weak var delegate: PaletteEntryViewControllerDelegate?
    
    enum Mode {
        case create, edit
        
        fileprivate var viewControllerTitle: String {
            switch self {
            case .create: return "Create Palette"
            case .edit: return "Edit Palette"
            }
        }
        
        fileprivate var navigationBarAccessibilityIdentifier: String {
            switch self {
            case .create: return "create-palette-bar"
            case .edit: return "edit-palette-bar"
            }
        }
    }
    var mode: Mode = .create
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet var colorButtons: [ColorSelectButton]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var sliders: [UISlider]!

    var palette: Palette = Palette(name: "New Palette", colors: Array(repeating: .gray, count: Palette.colorCount)) {
        didSet {
            refreshViews()
        }
    }
    private(set) var selectedIndex = 0 {
        didSet {
            refreshViews()
        }
    }
    
    var selectedColorButton: ColorSelectButton {
        return colorButtons[selectedIndex]
    }
    
    var selectedColor: UIColor {
        get {
            return palette.colors[selectedIndex]
        }
        set {
            palette.colors[selectedIndex] = newValue
        }
    }

    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Init color buttons
        for (index, button) in colorButtons.enumerated() {
            button.paletteIndex = index
            button.paletteColor = palette.colors[index]
        }
        
        nameTextField.delegate = self
        nameTextField.text = palette.name
        refreshViews()
        
        // Set accesibility identifiers
        view.accessibilityIdentifier = "palette-entry-view"
        nameTextField.accessibilityIdentifier = "palette-entry-name-text-field"
        labels[0].accessibilityIdentifier = "red-label"
        labels[1].accessibilityIdentifier = "green-label"
        labels[2].accessibilityIdentifier = "blue-label"
        sliders[0].accessibilityIdentifier = "red-slider"
        sliders[1].accessibilityIdentifier = "green-slider"
        sliders[2].accessibilityIdentifier = "blue-slider"
        cancelButton.accessibilityIdentifier = "palette-entry-cancel-button"
        saveButton.accessibilityIdentifier = "palette-entry-save-button"
    }
}

// MARK: - IBActions
extension PaletteEntryViewController {
    // For dismissing the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func colorButtonTapped(_ sender: ColorSelectButton) {
        guard let index = colorButtons.firstIndex(where: { sender === $0}) else {
            return
        }
        selectedIndex = index
    }
    
    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        selectedColor = UIColor(red: CGFloat(sliders[0].value),
                                green: CGFloat(sliders[1].value),
                                blue: CGFloat(sliders[2].value),
                                alpha: 1)
        refreshViews()
    }

    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        delegate?.paletteEntryViewControllerDidCancel(self)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        // TODO: test here
        guard let name = nameTextField.text else {
            return
        }
        let newPalette = Palette(name: name, colors: palette.colors)
        delegate?.paletteEntryViewController(self, didSavePalette: newPalette)
    }
}

// MARK: - Private
extension PaletteEntryViewController {
    private func refreshViews() {
        guard isViewLoaded else {
            return
        }
        
        // Mode specific
        title = mode.viewControllerTitle
        navigationController?.navigationBar.accessibilityIdentifier = mode.navigationBarAccessibilityIdentifier
        
        // Show selected color button
        for button in colorButtons {
            button.isSelected = false
        }
        selectedColorButton.isSelected = true
        
        // Update color button background color
        selectedColorButton.backgroundColor = selectedColor
        
        // Update slider labels
        let triplet = selectedColor.rgbTriplet()
        labels[0].text = "r: \(triplet.red)"
        labels[1].text = "g: \(triplet.green)"
        labels[2].text = "b: \(triplet.blue)"
        
        // Update sliders
        for (index, slider) in sliders.enumerated() {
            guard !slider.isTracking else {
                continue
            }
            slider.value = Float(triplet.array[index])/255.0
        }
    }
}

// MARK: - UITextField Delegate
extension PaletteEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
