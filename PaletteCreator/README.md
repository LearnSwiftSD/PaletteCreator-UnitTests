#  PaletteCreator

App for demonstrating UI Tests

A palette is a collection of 5 colors. To keep things simple for the purposes of this demo, all colors are RGB color space only.

There are 4 main screens of the app:
1. Main Palette Table
  * Displays all palettes
  * Delete a single palette, or all palettes
  * Tap on a palette cell to view it in detail
  * Palettes saved to disk will be loaded when the app launches
  * Navigate to Create New Palette
2. Create New Palette
  * Set palette name
  * Use 3 sliders to adjust palette colors
3. Palette Detail
  * View the palette name and colors
  * Navigate to Edit Palette
4. Edit Palette
  * Same as Create New Palette, but edits an existing palette

Fun fact: each bullet point feature listed above corresponds to a UI test!

## Known Limitations
1. The app does not perform any text entry validation, and the UI Test classes assume all palette names will be unique. This is left as an exercise for the reader.

