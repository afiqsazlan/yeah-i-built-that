# yeah-i-built-that

> *"What did you work on this quarter?"*
> *"...uh."*

A Claude skill that digs your work back out of git, groups it into stories, grills you for the context git can't see, and writes it up for your performance review, promotion case, salary talk, resume, portfolio, or LinkedIn.

The commits are the receipts. You supply the meaning. It never invents metrics.

## Quick start (Claude Code)

Install:

```
/plugin marketplace add afiqsazlan/yeah-i-built-that
/plugin install yeah-i-built-that@afiqsazlan
```

Open Claude Code in **the folder that holds your projects** (for example `~/work`) and ask:

```
what did I build last quarter?
```

That's it. No tokens, no connectors, no setup. It reads your local clones, so it works with GitHub, GitLab, Bitbucket, self-hosted, or repos that were never pushed.

### Workspace or single repo

| Run it from | It will |
|---|---|
| A folder of projects | find every git repo underneath, keep the ones with your commits in the period, and tell stories across them |
| Inside one repo | look at just that repo |

Your quarter usually spans the API, the frontend, and some infra repo, so the workspace folder is usually the right place.

## How it works

1. **Scope**: period, your author emails, what it's for
2. **Dig**: reads your commits (and PR descriptions via `gh`/`glab` if installed), drops noise like merges, WIP, typo fixes and dependency bumps
3. **Cluster**: groups commits into stories ("Migrated payments to Stripe", not "misc fixes")
4. **Review**: you merge, split, rename, or drop stories
5. **Grill**: one story at a time, it asks what the problem was, what changed, and what your role was, and pushes back on vague answers
6. **Write**: produces a self-review, promotion case, salary pitch, resume bullets, portfolio entry, or LinkedIn post
7. **Save**: keeps your profile and stories in `~/.yeah-i-built-that/`, outside your repos, so next quarter is faster and year-end reviews build on past quarters

## Honesty rules

- It only uses numbers you give it. Missing ones become `[metric?]` placeholders, listed at the end.
- It won't upgrade "I paired on it" to "I led it".
- Every claim traces back to a story you approved.

## No Claude Code?

It also runs in Claude chat (desktop or claude.ai), with one extra step: getting your commits in.

**Install:** Customize → Plugins → Add → Add marketplace → `afiqsazlan/yeah-i-built-that`. Or download the zip from [Releases](https://github.com/afiqsazlan/yeah-i-built-that/releases) and upload it under Customize → Skills.

**Get your commits in:** run this in your projects folder and paste the output (or save it to a file and upload it):

```bash
for d in */; do [ -d "$d/.git" ] && git -C "$d" log --all --no-merges \
  --author="$(git config user.email)" --since="2026-07-01" --until="2026-09-30" \
  --pretty=format:"${d%/}|%h|%ad|%s" --date=short; done
```

If you've added a connector that can list commits (for example GitHub's MCP server), it'll try that first. Note that the built-in GitHub integration in Claude chat attaches files only and can't list commits.

## Origin

This started as a paid SaaS called CommitStory. It got zero users. I kept using it myself every quarter, so here it is as a free skill instead.

## License

MIT
