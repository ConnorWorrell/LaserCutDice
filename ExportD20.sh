#!/bin/bash

mkdir D20_Export
cd D20_Export

for Side in 1 2 3 4 5 6. 7 8 9. 10 11 12 13 14 15 16 17 18 19 20
do
    openscad -o D20-$Side.dxf -D'Text="'"$Side"'"' -D'Sides=3' -D'TabCount=3' -D'InscribedDiameterInput=18' ../TabTileGenerator.scad
done
