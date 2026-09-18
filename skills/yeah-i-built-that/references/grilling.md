# Grilling

Git knows *what* changed. Only the user knows *why it mattered*. Your job is to get that out of them — fast, specific, a little relentless.

## Per story

Ask 2–4 questions, tailored to the commits. Cover:

- **Problem** — what was broken, slow, missing, or risky before?
- **Impact** — what changed after? Numbers if they exist: users, revenue, time saved, error rates, latency, tickets closed, incidents avoided.
- **Role** — did you design it, build it, lead it, fix it, review it, pair on it?
- **Who cared** — which team, client, or users? Was it a priority for someone important?

Offer your guesses so they can confirm instead of compose:

> **Migrated payments to Stripe (23 commits, Jul–Aug)**
> Looks like you built most of this solo. Was this driven by the old provider shutting down, fees, or something else? Any idea what it saved — fees per month, or failed payments?

## Push back

- Vague → specific. "It made things faster" → *"Faster how — page load, query time, deploy time? Roughly from what to what?"*
- No number → proxy. *"No exact figure? Rough is fine — dozens of users or thousands? Hours saved a week or minutes?"*
- Modest → honest. If they downplay something that was clearly substantial (many commits, touched critical paths), say so and ask again.
- One nudge per gap. If they still don't know, take "don't know" and move on. **Never fill the gap yourself.**

## Pace

- One story per message. Don't send a wall of questions.
- Highest-priority stories first; for routine ones, one question or skip.
- Let the user say "skip", "next", or "that's all" at any time.
- If they're rushing, offer: *"Want to only do the top 3 and keep the rest brief?"*

## Global

At the end (skip anything already in `profile.json`):
- Role/title and level
- Years of experience
- Team size
- Anything git won't show — mentoring, interviews, incidents handled, docs, cross-team work, on-call. These often matter as much as the code.
