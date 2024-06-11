#!/bin/bash

skopeo --version

while IFS= read -r line; do
  echo $line
done < images.txt