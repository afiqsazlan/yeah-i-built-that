# yeah-i-built-that

> *"What did you work on this quarter?"*
> *"...uh."*

A Claude skill that digs your work back out of git, groups it into stories, grills you for the context git can't see, and writes it up for your performance review, promotion case, salary talk, resume, or LinkedIn.

The commits are the receipts. You supply the meaning. It never invents metrics.

## How it works

1. **Scope**: period, repos, your author emails, what it's for
2. **Dig**: pulls your commits (and PR descriptions where it can), drops noise like merges, WIP, typo fixes and dependency bumps
3. **Cluster**: groups commits into stories ("Migrated payments to Stripe", not "misc fixes")
4. **Review**: you merge, split, rename, or drop stories
5. **Grill**: one story at a time, it asks what the problem was, what changed, and what your role was, and pushes back on vague answers
6. **Write**: produces a self-review, promotion case, salary pitch, resume bullets, or LinkedIn post
7. **Save**: keeps your profile and stories in `.yeah-i-built-that/` so next quarter is faster

Works with **GitHub, GitLab, Bitbucket**, or any local git repo.

## Install

### Claude Code

```
/plugin marketplace add afiqsazlan/yeah-i-built-that
/plugin install yeah-i-built-that@yeah-i-built-that
```

Then, in any repo:

```
what did I build last quarter?
```

### Claude desktop / claude.ai

1. Download `yeah-i-built-that.zip` from [Releases](https://github.com/afiqsazlan/yeah-i-built-that/releases), or build it with `./scripts/build-zip.sh`
2. Upload it under **Settings → Capabilities → Skills**
3. Ask *"help me write my self-review for Q3"*

If you have a GitHub, GitLab, or Bitbucket connector enabled, it'll try to fetch commits through it. Otherwise it asks you to paste an export:

```bash
git log --all --no-merges --author="you@example.com" \
  --since="2026-07-01" --until="2026-09-30" \
  --pretty=format:'%h|%ad|%s' --date=short > commits.txt
```

## Honesty rules

- It only uses numbers you give it. Missing ones become `[metric?]` placeholders, listed at the end.
- It won't upgrade "I paired on it" to "I led it".
- Every claim traces back to a story you approved.

## Origin

This started as a paid SaaS called CommitStory. It got zero users. I kept using it myself every quarter, so here it is as a free skill instead.

## License

MIT
