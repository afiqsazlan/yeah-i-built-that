# Clustering

Group the filtered commits into **stories** — each one a specific feature, fix, refactor, or initiative the user could talk about in a review.

## How many

| Commits | Clusters | Size |
|---|---|---|
| < 20 | 2–4 | whatever fits |
| 20–49 | 4–8 | 5–15 each |
| 50–149 | 8–15 | 5–20 each; split anything 30+ |
| 150+ | 12–20 | 5–25 each; nothing over 30 |

## Rules

- One story per cluster. "Built real-time notifications", not "Various improvements".
- No catch-all "Misc" cluster. Small leftovers go in their closest story, or a clearly named "Small fixes across X" cluster the user can drop.
- Give **security fixes, performance work, and critical bug fixes** their own clusters — they show reliability and depth.
- Group infra/DevOps/CI work together as platform work.
- Refactors are "codebase health / tech debt reduction" — name them for the outcome, not the churn.
- Use PR titles/descriptions when available; they usually name the story better than commit messages do.
- Stories can span repos.

## For each cluster, note

- **name** — specific, action-oriented, but *accurate*: "Built secure user authentication", not "Revolutionised security"
- **commits** — short SHAs
- **summary** — 1–2 sentences: what was delivered or fixed
- **guesses** (for the grill step, not shown as fact):
  - likely problem solved
  - likely role (sole author? many small fixes on someone else's feature?)
  - suggested priority: `routine` | `moderate` | `high` | `critical`
  - likely audience: `internal` | `client` | `end_users` | `platform`
  - impact areas, any of: `revenue`, `cost_savings`, `ux`, `security`, `performance`

Keep this as working state (JSON is fine in Claude Code; a table is fine in chat). Show the user only name / count / summary at the review step.
