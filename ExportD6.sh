#!/bin/bash

mkdir D6_Export
cd D6_Export

for Side in 1 2 3 4 5 6
do
    openscad -o D6-$Side.dxf -D'Text="'"$Side"'"' -D'TextSizeOverride=9' ../TabTileGenerator.scad
done
