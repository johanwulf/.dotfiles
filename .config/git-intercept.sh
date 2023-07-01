#!/bin/bash
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
DIR="$HOME/personal/nutty-notes/worklog/$YEAR"
TEMPLATE=$(find $HOME/personal/nutty-notes -name worklog.md)

FILE="$DIR/$YEAR-$MONTH-$DAY.md"

COMMAND=$1

create_file() {
	if [[ ! -d "$DIR" ]]; then
		mkdir -p "$DIR"
	fi
	if [[ ! -f "$FILE" ]]; then
		cp "$TEMPLATE" "$FILE"
		gsed -i 's/Date/'"$YEAR-$MONTH-$DAY"'/g' $FILE
	fi
}

if [[ $PWD = $WORKFOLDER* ]]; then
	if [ "$COMMAND" == "checkout" ] && [ "$2" == "-b" ]; then
		create_file
		BRANCH=$3
		gsed -i "/^## Branches/a [$BRANCH]($JIRA_LINK$BRANCH)" $FILE
	elif [ "$COMMAND" == "commit" ] && [ "$2" == "-m" ]; then
		create_file
		MESSAGE=$3
		gsed -i "/^## Commits/a $MESSAGE" $FILE
	fi
fi

command git "$@"
