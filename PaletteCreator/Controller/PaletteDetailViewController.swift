//
//  PaletteDetailViewController.swift
//  PaletteCreator
//
//  Created by Dave Shu on 11/4/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import UIKit

protocol PaletteDetailViewControllerDelegate: class {
    func paletteDetailViewController(_ viewController: PaletteDetailViewController, didEditPalette from: Palette, to: Palette)
}

class PaletteDetailViewController: UIViewController {
    weak var delegate: PaletteDetailViewControllerDelegate?
    
    var palette: Palette? {
        didSet {
            refreshViews()
        }
    }
    @IBOutlet var colorViews: [ColorView]!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshViews()
        
        // Set accesibility identifiers
        navigationController?.navigationBar.accessibilityIdentifier = "palette-detail-bar"
        view.accessibilityIdentifier = "palette-detail-view"
        editButton.accessibilityIdentifier = "palette-detail-edit-button"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as? UIBarButtonItem === editButton,
            let navController = segue.destination as? UINavigationController,
            let entryVC = navController.topViewController as? PaletteEntryViewController,
            let palette = palette {
            entryVC.delegate = self
            entryVC.mode = .edit
            entryVC.palette = palette
        }
    }
}

extension PaletteDetailViewController {
    func refreshViews() {
        guard isViewLoaded, let palette = palette else {
            return
        }
        title = palette.name
        for (color, view) in zip(palette.colors, colorViews) {
            view.backgroundColor = color
        }
    }
}

// MARK: - Palette Entry Delegate
extension PaletteDetailViewController: PaletteEntryViewControllerDelegate {
    func paletteEntryViewController(_ viewController: PaletteEntryViewController, didSavePalette palette: Palette) {
        let old = self.palette!
        self.palette = palette
        delegate?.paletteDetailViewController(self, didEditPalette: old, to: palette)
        dismiss(animated: true, completion: nil)
    }
    
    func paletteEntryViewControllerDidCancel(_ viewController: PaletteEntryViewController) {
        dismiss(animated: true, completion: nil)
    }
}
