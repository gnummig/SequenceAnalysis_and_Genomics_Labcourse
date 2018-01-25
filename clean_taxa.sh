#!/bin/bash
sed -E 's/<>//g' $1 | sed -E 's/\;//g' | sed -E 's/<\/>//g' | sed -E 's/ //g' 
