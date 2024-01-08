#!/bin/bash

mkdir D6Skew_Export
cd D6Skew_Export

mkdir SNR
mkdir NSNR
mkdir NSR

for Side in 1 2 3 4 5 6
do
    openscad -o ./SNR/D6SkewSNR-$Side.dxf -D'Text="'"$Side"'"' -D'TextSizeOverride=6' -D'D6Skew=true' -D'D6Phase=30' -D'D6Stretch=1' ../TabTileGenerator.scad
    openscad -o ./NSNR/D6SkewNSNR-$Side.dxf -D'Text="'"$Side"'"' -D'TextSizeOverride=6' -D'D6Skew=true' -D'D6Phase=60' -D'D6Stretch=2' ../TabTileGenerator.scad
    openscad -o ./NSR/D6SkewNSR-$Side.dxf -D'Text="'"$Side"'"' -D'TextSizeOverride=6' -D'D6Skew=true' -D'D6Phase=30' -D'D6Stretch=0' ../TabTileGenerator.scad
done
