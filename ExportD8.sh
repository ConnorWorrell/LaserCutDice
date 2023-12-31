#!/bin/bash

mkdir D8_Export
cd D8_Export

for Side in 1 2 3 4 5 6 7 8
do
    echo $Offset
    openscad -o D8-$Side.dxf -D'Text="'"$Side"'"' -D'Sides=3' -D'TabCount=3' -D'InscribedDiameterInput=22.62405' ../TabTileGenerator.scad
done
