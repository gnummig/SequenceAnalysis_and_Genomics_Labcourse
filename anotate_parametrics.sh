#!/bin/bash

while IFS= read -r ACC
do
        echo -e "HOST\t$ACC" >> $2
done < $1

