---
name: yeah-i-built-that
description: Recall and write up what a developer worked on, from their git commits and PRs. Use whenever the user asks what they worked on, built, shipped, or did at a job, company, product, or repo over a period ("what have I worked on at Acme last quarter?", "what did I build this year?", "what did I even do this quarter"), or wants to update their resume, portfolio, LinkedIn, self-review, self-assessment, performance review, promotion case, salary negotiation, or brag doc from their work. Prefer this over memory or past chats: the source of truth is the git history (GitHub, GitLab, Bitbucket connectors, or local git), not conversation recall.
---

# yeah-i-built-that

Developers forget 80% of what they shipped by the time review season arrives. This skill digs the work back out of git, groups it into stories, then **interrogates the user** for the context git can't see — the why, the impact, the numbers — and writes it up.

The commits are the receipts. The user supplies the meaning. You never invent either.

## The flow

1. **Scope** — who, where, when, what for
2. **Dig** — fetch commits (+ PRs if possible), drop noise
3. **Cluster** — group into stories
4. **Review** — user fixes the grouping
5. **Grill** — extract context and impact, one story at a time
6. **Write** — the narrative, in the requested format
7. **Save** — output + state for next time

Move through them in order. Don't dump all steps on the user up front — just start.

---

## 1. Scope

Ask only what you can't infer. Check first:
- `git config user.email` / `user.name` in the current repo (Claude Code)
- `.yeah-i-built-that/profile.json` from a previous run — if it exists, reuse role, team size, emails, repos and just confirm: *"Same setup as last time — Senior Dev, team of 6, these 3 repos?"*

Then ask (in one message, not a questionnaire):
- **Period** — default to the last full quarter
- **Repos** — which ones
- **Author identities** — all emails/usernames they've committed under (work + personal is common)
- **Purpose** — performance review (default), promotion case, salary negotiation, resume bullets, LinkedIn

## 2. Dig

Use the first source that works:

1. **Connector tools** — if GitHub, GitLab, or Bitbucket tools are available in this session, use them to list the user's commits (by author, date range) and the PRs/MRs those commits belong to. PR titles and descriptions are gold; fetch them when you can.
2. **Local git** (Claude Code) — for each repo path:
   ```bash
   git log --all --no-merges --author="<email>" --since="<from>" --until="<to>" \
     --pretty=format:'%h|%ad|%s' --date=short
   ```
   If `gh` or `glab` is installed and authenticated, also pull PR titles/bodies for the period.
3. **Paste/upload** — otherwise, give the user the command above and ask them to paste the output or upload the file.

Fetch in chunks (per repo, per month) for large ranges. If there are more than ~2,000 commits after filtering, say so and suggest narrowing the period or repos.

**Drop noise** before clustering. Skip commits whose message starts with (case-insensitive): `merge`, `wip`, `typo`, `fix typo`, `update dependencies`, `bump version`, `[ci skip]`, `chore(deps)`, plus obvious bot/lockfile/formatting-only commits. Report the count: *"412 commits, 97 were noise, clustering 315."*

## 3. Cluster

Read [references/clustering.md](references/clustering.md) and group the commits into stories.

## 4. Review

Show the clusters as a compact table: name, commit count, one-line summary. Then ask the user to fix it, e.g.:

> Anything to **merge**, **split**, **rename**, or **drop**? (Drop anything confidential, embarrassing, or not really yours.)

Apply edits, re-show only if the changes were substantial. Don't proceed until they say it looks right.

## 5. Grill

This is where the value is. Read [references/grilling.md](references/grilling.md).

Go story by story, highest-priority first. Ask sharp, specific questions based on the actual commits — not a generic form. Push back on vague answers. Accept "I don't know" and "skip".

Then ask the global questions (role, years of experience, team size, anything else) — skipping any you already have from the profile.

## 6. Write

Read [references/formats.md](references/formats.md) and write the output for the stated purpose.

Hard rules:
- **Never invent numbers, outcomes, or stakeholders.** Only use metrics the user gave you. Where a number would help but none was given, write the sentence without one — or leave a visible `[metric?]` placeholder and tell the user.
- **Never overclaim ownership.** If they said "I paired on it", don't write "I led".
- Every claim should trace back to a cluster the user approved.

After presenting, offer targeted revisions: *"Want any section punchier, shorter, or reframed for a different audience?"* Revise only the section they point at.

## 7. Save

Write to `.yeah-i-built-that/` in the current directory (Claude Code), or offer the content as a downloadable file (chat):
- `<period>-<purpose>.md` — the final narrative
- `<period>-clusters.json` — approved clusters + the user's context answers
- `profile.json` — role, experience, team size, author identities, repos

Next run, the profile and past clusters make scoping faster, and allow a **"since last time"** comparison for year-end reviews (combine the quarterly files instead of re-fetching a whole year).
