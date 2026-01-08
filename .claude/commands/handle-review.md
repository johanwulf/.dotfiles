Fetch and analyze PR review comments for the current branch.

Run: `pr-comments $ARGUMENTS`

For each unresolved comment:
1. Read the relevant code and investigate whether the feedback is valid
2. If the comment is NOT valid: provide a short, succinct response I can paste as a reply
3. If the comment IS valid: explain the issue and discuss the fix with me before implementing

Do not make changes without discussing first. Present findings one comment at a time.
