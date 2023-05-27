#!/bin/bash
# Usage: git <command> <args>
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
DIR="$HOME/personal/nutty-notes/worklog/$YEAR"
TEMPLATE="$HOME/personal/nutty-notes/worklog/TEMPLATE.md"
FILE="$DIR/$YEAR-$MONTH-$DAY.md"

COMMAND=$1
shift
ARGS=$@

create_file() {
	if [[ ! -d "$DIR" ]]; then
		mkdir -p "$DIR"
	fi
	if [[ ! -f "$FILE" ]]; then
		echo "no file"
		cp "$TEMPLATE" "$FILE"
	fi
}

if [[ $PWD = $WORKFOLDER* ]]; then
	if [ "$COMMAND" == "checkout" ] && [ "$1" == "-b" ]; then
		# Intercept git checkout -b
		create_file
		BRANCH=$2
		gsed -i "/^## Branches/a [$BRANCH]($JIRA_LINK$BRANCH)" $FILE
	elif [ "$COMMAND" == "commit" ] && [ "$1" == "-m" ]; then
		# Intercept git commit -m
		create_file
		MESSAGE=$2
		gsed -i "/^## Commits/a $MESSAGE" $FILE
	fi
fi

# Call the original git command with the same arguments
git $COMMAND $ARGS
