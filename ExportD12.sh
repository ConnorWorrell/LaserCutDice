#!/bin/bash

mkdir D12_Export
cd D12_Export

for Side in 1 2 3 4 5 6. 7 8 9. 10 11 12
do
    openscad -o D12-$Side.dxf -D'Text="'"$Side"'"' -D'Sides=5' -D'TabCount=3' -D'InscribedDiameterInput=15' ../TabTileGenerator.scad
done
