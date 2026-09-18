---
name: yeah-i-built-that
description: Recall and write up what a developer worked on, from their git commits and PRs. Use whenever the user asks what they worked on, built, shipped, or did at a job, company, product, or repo over a period ("what have I worked on at Acme last quarter?", "what did I build this year?", "what did I even do this quarter"), or wants to update their resume, portfolio, LinkedIn, self-review, self-assessment, performance review, promotion case, salary negotiation, or brag doc from their work. Prefer this over memory or past chats: the source of truth is the git history (local repos in Claude Code, or GitHub/GitLab/Bitbucket connectors), not conversation recall.
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

### Pick the mode (Claude Code)

- **Single repo** — the current directory is inside a git repo (`git rev-parse --show-toplevel` succeeds). Use just that repo.
- **Workspace** — otherwise, treat the current directory as a folder of projects. Find repos up to 3 levels deep, skipping `node_modules`, `vendor` and hidden folders:
  ```bash
  find . -maxdepth 4 -name .git -not -path '*/node_modules/*' -not -path '*/vendor/*' -prune | sed 's|/\.git$||'
  ```
  After you know the author identities and period, count the user's commits in each repo and show only repos with at least one:
  > Found 6 repos with your commits in Q3: **api** (142), **web** (88), **infra** (12), ... Include all?

In chat (no shell), skip this; see the Dig step.

### Load what you already know

Read `~/.yeah-i-built-that/profile.json` if it exists (role, experience, team size, author identities). Reuse it and just confirm: *"Same setup as last time: Senior Dev, team of 6, committing as afiq@acme.com?"*

Otherwise, collect author identities from `git config user.email` / `user.name` (global and per repo), plus the most frequent authors in each repo that look like the user:
```bash
git shortlog -sne --all --since="<from>" | head
```

### Ask (one message, not a questionnaire)

Only what you can't infer:
- **Period** — default to the last full quarter
- **Author identities** — confirm the emails/names found above; work and personal emails are common
- **Purpose** — performance review (default), promotion case, salary negotiation, resume bullets, portfolio, LinkedIn

## 2. Dig

### Claude Code (preferred)

For each repo in scope, one call per author identity:
```bash
git -C <repo> log --all --no-merges --author="<email-or-name>" --since="<from>" --until="<to>" \
  --pretty=format:'%h|%ad|%s' --date=short
```
Tag each commit with its repo name. Deduplicate by SHA (the same commit can appear on several branches or under two identities).

Run `git -C <repo> fetch --quiet` first only if the user agrees. Otherwise, mention that unpushed work is included and anything only on the remote is not.

**PR context (optional):** if the repo's remote is GitHub and `gh` is authenticated, pull titles and bodies of the user's merged PRs in the period (`gh pr list --author @me --state merged --search "merged:<from>..<to>" --json number,title,body,mergedAt`). Use `glab` the same way for GitLab. Skip Bitbucket, or any host without a CLI; the grill step covers the gap.

### Chat

Use the first that works:
1. **Connector tools**: if GitHub, GitLab, or Bitbucket tools that can list commits or PRs are available, use them (by author and date range, per repo). Many GitHub integrations only attach files and can't list commits; if so, go to 2.
2. **Paste or upload**: give the user this command to run in each repo (or the parent folder loop below), and ask them to paste or upload the output:
   ```bash
   git log --all --no-merges --author="$(git config user.email)" --since="<from>" --until="<to>" --pretty=format:'%h|%ad|%s' --date=short
   ```
   For many repos at once:
   ```bash
   for d in */; do [ -d "$d/.git" ] && git -C "$d" log --all --no-merges --author="$(git config user.email)" --since="<from>" --until="<to>" --pretty=format:"${d%/}|%h|%ad|%s" --date=short; done
   ```

Also mention that Claude Code does this with no setup, if they have it.

### Volume

For long ranges, fetch per repo and per month. If there are more than ~2,000 commits after filtering, say so and suggest narrowing the period or repos.

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

In Claude Code, save to `~/.yeah-i-built-that/` (in the home directory, never inside a repo, so nothing gets committed by accident):
- `profile.json`: role, experience, team size, author identities
- `<workspace-or-repo-name>/<period>-<purpose>.md`: the final narrative
- `<workspace-or-repo-name>/<period>-clusters.json`: approved clusters, their repos and SHAs, and the user's answers

Tell the user the paths. In chat, offer the narrative as a downloadable file instead.

Next run, the profile makes scoping faster. For year-end or promotion cases, read the saved quarterly clusters for that workspace and build on them instead of re-fetching and re-grilling the whole year. Only dig and grill the quarters that are missing.
