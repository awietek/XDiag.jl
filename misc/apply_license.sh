#!/bin/bash

# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

license="Apache-2.0"
author="Alexander Wietek <awietek@pks.mpg.de>"

# julia files
# jlfiles=`find ../src -type f -name \*.jl`
jlfiles=`find ../test -type f -name \*.jl`

for f in ${jlfiles[@]}; do
    echo $f
    reuse annotate --copyright="Alexander Wietek <awietek@pks.mpg.de>" --license="Apache-2.0" $f
done
