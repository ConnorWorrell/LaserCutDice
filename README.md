# Laser Dice

This project provides a utility for generating dxf files for tiles with tabs on the edges that mesh with themselves rotated 180 degrees.

These tiles can then be assembled into dice.

This image shows the following: D4, D6, D8, D10, D12, and D20.

![](Media/D468101220%20Assembled.jpg)

Provided are scrips for automating the export of dxf files for pregenerated dice:
1. `ExportAll.sh` : Runs all other scripts.
2. `ExportD4.sh` : 4 Sided Dice
2. `ExportD6.sh` : 6 Sided Dice
2. `ExportD8.sh` : 8 Sided Dice
2. `ExportD10.sh` : 10 Sided Dice
2. `ExportD12.sh` : 12 Sided Dice
2. `ExportD20.sh` : 20 Sided Dice

The following scad files are provided:
1. `TabTileGenerator.scad` Generates the tiles given parameters.
    1. `LaserRelief`: Tuning parameter to account for laser beam radius.
    2. `TabDepthRelief`: Tuning parameter so tabs are cut to aproximately the same depth as the material is thick.
    3. `TabClearance`: Tuning parameter to adjust tab and slot width.
    4. `BaseThickness`: Thickness of material
    5. `TextThickness`: For STL export
    5. `Sides`: Number of equal sides.
    6. `Inscribed DiameterInput`: Diamter of circle intersecting all corners.
    7. `TabCount`: Tabs per side.
    8. `D10`: Use D10 shape instead of equal sides.
    9. `D4`: Cut 3 characters instead of 1.
        1. `D4Pattern`: Array containing ordered characters to be show counterclockwise.
        2. `D4Offset`: Text offset from center
    10. `Text`: Text to cut into dice.
    11. `TextSizeOverride`: Override default text size.
    12. `Offset`: Translate shape from origin (usefull during import to force multiple tiles not be stacked)
2. `LayoutAll.scad` Generates a single dxf with tiles layed out. Grabs dxf files from directories created in ExportD\*.sh.
    1. `offset`: Spacing between tiles.
    2. `DiceToLayout`: Array containing diles to include.
    3. `XDimmOverride`: force override by n layout. 
    3. `YDimmOverride`: force n by override layout.

![](Media/D468101220%20Layout.jpg)
