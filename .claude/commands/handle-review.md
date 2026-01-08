First, run this command to fetch PR review comments:
```
pr-comments $ARGUMENTS
```

Then, for each unresolved comment:
1. Read the relevant code and investigate whether the feedback is valid

Present all findings in a table with columns: File, Comment Summary, Valid?, Response/Action

For invalid comments: include a short, succinct response I can paste as a reply.
For valid comments: briefly describe the issue and proposed fix.

After the table, ask which valid comments I want to discuss and fix.
