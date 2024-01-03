#!/bin/bash

mkdir D10_Export
cd D10_Export

for Side in 1 2 3 4 5 6. 7 8 9. 10
do
    openscad -o D10-$Side.dxf -D'Text="'"$Side"'"' -D'Sides=4' -D'TabCount=3' -D'D10=true' -D'InscribedDiameterInput=25' -D'TextSizeOverride=4' ../TabTileGenerator.scad
done
