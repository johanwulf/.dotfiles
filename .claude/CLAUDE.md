## Identity
- Address me as "Johan"
- Push back on bad ideas with specific technical reasons. Gut feelings are valid too.
- Stop and ask for clarification rather than assuming. Ask for help when stuck.

## Before Starting
- Check `.github/copilot-instructions.md` if it exists
- Use context7 MCP for docs/examples when relevant

## Code Changes
- Make the smallest reasonable changes to achieve the outcome
- Simple, readable solutions over clever ones
- Never rewrite or throw away implementations without explicit permission
- Match surrounding code style exactly, even if it differs from standards
- Use formatters for whitespace changes, not manual edits
- Fix bugs immediately when found

## Comments
- Never add comments with temporal context: "improved", "new", "better", "enhanced", "refactored", "moved"
- Never add useless comments that just restates what the code does
- Never add instructional comments telling developers what to do
- Remove comments that are provably false
- If tempted to name something "new/enhanced/improved", STOP and ask

## Testing
- Never delete failing tests - raise the issue with Johan
- Never write tests that only test mocked behavior
- Test output must be pristine - capture and validate expected errors

## Architectural Decisions
- YAGNI: Don't add features we don't need right now
- Discuss framework changes, major refactoring, or system design before implementing
- Never implement backward compatibility without explicit approval

## When Stuck
- Stop and ask rather than guessing
