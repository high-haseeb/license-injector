#!/bin/bash

usage() { echo "Usage: $0 project-name [-d <string>]" 1>&2; exit 1; }

if [ "$#" -lt 1 ]; then
    usage
fi

d=""
project_name="$1"
shift
while getopts ":d:" o; do
    case "${o}" in
        d)
            d=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

echo -e "\e[32mProject Name:\e[0m $project_name"
echo -e "\e[32mDescription:\e[0m  $d"
echo -e "\e[32mAuthor:\e[0m       high-haseeb"

COMMENT_SYMBOL="//"
HEADER_COMMENT="Copyright (C) $(date +%Y) \"high-haseeb\"
See end of file for extended copyright information."

FOOTER_COMMENT="$project_name $d
Copyright (C) 2020  "high-haseeb"

This file is part of $project_name.

$project_name is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

$project_name is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with $project_name.  If not, see <https://www.gnu.org/licenses/>."

for file in $(git ls-files -m -o --exclude-standard | grep -v '^\.' | grep -v '\.sh$'); do

    case "$file" in
        *.sh) COMMENT_SYMBOL="#" ;;
        *.py) COMMENT_SYMBOL="#" ;;
        *.cpp|*.h|*.c|*.java|*.js) COMMENT_SYMBOL="//" ;;
        *.html) COMMENT_SYMBOL="<!--" ;;
        *.css) COMMENT_SYMBOL="/*" ;;
        *) COMMENT_SYMBOL="//" ;;
    esac

    if grep "${COMMENT_SYMBOL} Copyright" "$file"  >/dev/null 2>&1; then
        echo -e "\e[33mINFO: License already present in $file"
    else
        echo -e "\e[0mINFO: Adding license in $file"
        {
            echo "$HEADER_COMMENT" | while IFS= read -r line; do
                echo "$COMMENT_SYMBOL $line"
            done
            echo ""
            cat "$file"
            echo ""
            echo "$FOOTER_COMMENT" | while IFS= read -r line; do
                echo "$COMMENT_SYMBOL $line"
            done
        } > temp.txt && mv temp.txt "$file"
    fi
done
