#!/bin/bash

mkdir D4_Export
cd D4_Export

for Side in 1 2 3 4
do
    openscad -o D4-$Side.dxf -D'Text="'"$Side"'"' -D'Sides=3' -D'TabCount=3' ../TabTileGenerator.scad
done
