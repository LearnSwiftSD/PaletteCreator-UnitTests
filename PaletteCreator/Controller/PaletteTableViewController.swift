//
//  PalettesTableViewController.swift
//  PaletteCreator
//
//  Created by Dave Shu on 11/4/18.
//  Copyright © 2018 Dave Shu. All rights reserved.
//

import UIKit

class PaletteTableViewController: UITableViewController {
    let palettesPlistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("palettes.plist")
    
    var palettes: [Palette] = []
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var deleteAllButton: UIBarButtonItem!
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = PaletteTableViewCell.defaultRowHeight

        // Edit/Done button
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadPalettes()
        
        // Accessibility
        tableView.accessibilityIdentifier = "palette-table"
        addButton.accessibilityIdentifier = "palette-table-add-button"
        editButtonItem.accessibilityIdentifier = "palette-table-edit-button"
        deleteAllButton.accessibilityIdentifier = "palette-table-delete-all-button"
        
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if sender as? UIBarButtonItem === addButton,
            let navController = segue.destination as? UINavigationController,
            let entryVC = navController.topViewController as? PaletteEntryViewController {
            entryVC.delegate = self
            entryVC.mode = .create
        }
        else if let cell = sender as? PaletteTableViewCell,
            let palette = cell.palette,
            let detailVC = segue.destination as? PaletteDetailViewController {
            detailVC.palette = palette
            detailVC.delegate = self
        }
    }

    // MARK: - Table view
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationController?.setToolbarHidden(!editing, animated: animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return palettes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaletteTableViewCell.defaultReuseIdentifier, for: indexPath) as! PaletteTableViewCell
        cell.palette = palettes[indexPath.row]
        
        // Accessibility
        cell.accessibilityIdentifier = "palette-cell"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            palettes.remove(at: indexPath.row)
            savePalettes()

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - IBActions
extension PaletteTableViewController {
    @IBAction func deleteAllPalettesTapped() {
        let alert = UIAlertController(title: "Delete all palettes?", message: "Are you sure you want to delete all palettes? This cannot be undone.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteAllPalettes()
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Private
extension PaletteTableViewController {
    func deleteAllPalettes() {
        guard !palettes.isEmpty else {
            return
        }
        do {
            // Delete the plist file
            try FileManager.default.removeItem(at: palettesPlistURL)
            
            // Update data source and table view
            let oldMaxIndex = palettes.count-1
            palettes = []
            let indexPaths = (0...oldMaxIndex).map { IndexPath(row: $0, section: 0) }
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
        catch {
            print("Error deleting palette plist: \(error)")
        }
    }
    
    func loadPalettes() {
        if let data = try? Data(contentsOf: palettesPlistURL) {
            let decoder = PropertyListDecoder()
            do {
                self.palettes = try decoder.decode([Palette].self, from: data)
                print("Loaded palettes: \(self.palettes)")
                tableView.reloadData()
            }
            catch {
                fatalError("Error while loading palettes: \(error)")
            }
        }
    }
    
    func savePalettes() {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let data = try encoder.encode(palettes)
            try data.write(to: palettesPlistURL)
            print("Saved palettes: \(self.palettes)")
            print("URL: \(palettesPlistURL)")
        }
        catch {
            fatalError("Error while saving palettes: \(error)")
        }
    }
}

// MARK: - Palette Entry Delegate
extension PaletteTableViewController: PaletteEntryViewControllerDelegate {
    func paletteEntryViewController(_ viewController: PaletteEntryViewController, didSavePalette palette: Palette) {
        dismiss(animated: true) {
            self.palettes.append(palette)
            self.savePalettes()

            let indexPath = IndexPath(row: self.palettes.count-1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func paletteEntryViewControllerDidCancel(_ viewController: PaletteEntryViewController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Palette Detail Delegate
extension PaletteTableViewController: PaletteDetailViewControllerDelegate {
    func paletteDetailViewController(_ viewController: PaletteDetailViewController, didEditPalette from: Palette, to: Palette) {
        guard let index = palettes.index(of: from) else {
            return
        }
        palettes[index] = to
        savePalettes()
        
        tableView.reloadData()
    }
}
