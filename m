Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E946E4A015A;
	Mon, 31 Aug 2026 13:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183687; cv=none; b=vC+pYYqH27606HVGj/bp0MjlaIq9DwwrzPGwmnFWDTHur8V6FayuNhyOCHbcHo33geisn4qRVEoYxk9VDUL6fMg6o361xUbx62723WKKdMvX4mAGtDqk2h7OY0iTTkCVG+j4VsmMPgLjX4tdWrHccfhmmiDo5mXc99peeoqz/rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183687; c=relaxed/simple;
	bh=ExYEIBHflgKX7wH0/UegyqsqQrnI96Pdxdc1zx3k55c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F3GVAEL2zoqghhJ1C1+Wo+8R8kvdgk5lUj1ciRZ1Pjnpf3pEDv5ygHfQkoEt91PnkHK1lFIBAcF3+uTpWq/qsd6P4DB4ddZihLXX/UgyXzmoL+Ly5h+0oZMhLt+K/IRVMqzTyUQVjSsLCtN0CYgka4r3FD2NLyDSKg8dzOeOLcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XehznNZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XehznNZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003E01F000E9;
	Mon, 31 Aug 2026 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183684;
	bh=Z+/9zkiq29qZCLnLy+ynK/JkEFK4uDrWz9KvtCHAk9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XehznNZOkTmLfdKlABoXtpKMe8rNUTCCkFLbQS3eM2W/iKSYd74OvwXHuBCPzdkeP
	 f9YLeNuUWM3izKPXs3mGctndAhP7R2cypAAQr3QigQ83/YsdixWHeOkem+GRE5iAF7
	 eITqUNGxp4/eWJFVPMVA+ub1yuYSSdoWpXA6lMaBNRSp8WKMSgWWrJr5yJ1Lf+zgSA
	 8/hfkHh/sRP0yZMGnpmEVUZG0SsmtITRLjwYVW+/D0rx35Zmu7C2Zy2To3kV+ggkeT
	 soaTUnTGAygcP4LE10CaMzuS2g2fbCaDIsDFZJXxYQZc1m56qlFB9WYazfRdskX54p
	 C9uZXknMeWbSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tao Cui <cuitao@kylinos.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] RDMA/counter: Fix num_counters leak on bind_qp failure in alloc_and_bind()
Date: Mon, 31 Aug 2026 09:24:31 -0400
Message-ID: <20260831133314.4125787-243-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 4fbc8230009f5b1bcd13cc74c5a6a43ddba141fd ]

When __rdma_counter_bind_qp() fails in alloc_and_bind(), the error path
jumps to err_mode which frees the counter without decrementing
port_counter->num_counters. The only place that decrements is
rdma_counter_free(), which is unreachable since the counter was never
successfully bound.

This leak accumulates across repeated failures, permanently preventing
the port from switching to AUTO mode (-EBUSY in __counter_set_mode())
and blocking the MANUAL→NONE auto-revert in rdma_counter_free(). When
the mode was NONE before the call, the MANUAL mode set by
__counter_set_mode() also leaks since the revert logic is never
reached.

Add an err_bind label between the num_counters increment and the
existing err_mode label. It decrements num_counters and mirrors the
MANUAL→NONE revert from rdma_counter_free(), ensuring the port state
is fully restored on bind failure.

Link: https://patch.msgid.link/r/20260520104546.1776253-2-cuitao@kylinos.cn
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: RDMA/counter num_counters leak fix

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
`make kernelversion` → `6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[RDMA/counter]` `[Fix]` — Fix `num_counters` leak on
`bind_qp` failure in `alloc_and_bind()`.

### Step 1.2: Parse all commit message tags
**Record:**
- **Link:** `https://patch.msgid.link/r/20260520104546.1776253-2-
  cuitao@kylinos.cn`
- **Signed-off-by:** Tao Cui `<cuitao@kylinos.cn>`
- **Signed-off-by:** Jason Gunthorpe `<jgg@nvidia.com>` (RDMA
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: part of a 2-patch series; sibling patch (`1776253-3`) is
  already backported to this tree as `9420871183eab`.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** On `__rdma_counter_bind_qp()` failure in `alloc_and_bind()`,
  error path jumps to `err_mode` and frees the counter without
  decrementing `port_counter->num_counters`.
- **Symptom:** Leak accumulates across repeated failures; port cannot
  switch to AUTO mode (`-EBUSY` from `__counter_set_mode()`);
  MANUAL→NONE auto-revert never runs; if mode was NONE before call,
  MANUAL mode also leaks.
- **Root cause:** `num_counters` is incremented before bind; decrement
  only happens in `rdma_counter_free()`, which is unreachable when bind
  never succeeded.
- **Fix approach:** Add `err_bind` label that decrements `num_counters`
  and mirrors MANUAL→NONE revert from `rdma_counter_free()`.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — explicitly a resource/state leak fix on an
error path.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `drivers/infiniband/core/counters.c` (+9 / -1 lines)
- **Function:** `alloc_and_bind()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (bind failure):** `goto err_mode` → `goto err_bind`
- **Hunk 2 (new `err_bind`):** Lock `port_counter`, decrement
  `num_counters`, if zero and MANUAL mode call
  `__counter_set_mode(NONE)`, unlock, then fall through to `err_mode`
- **Before:** Bind failure leaked counter refcount state and left port
  mode stuck
- **After:** Bind failure fully restores port counter state before
  freeing counter object

### Step 2.3: Bug mechanism
**Record:** **Category:** Error-path resource/state leak (reference-
count-like counter + mode state machine).
- `num_counters++` at line 191 happens before `__rdma_counter_bind_qp()`
  at line 199
- Current tree still has `goto err_mode` on failure (lines 200–201),
  skipping decrement/revert
- Fix mirrors existing cleanup in `rdma_counter_free()` (lines 220–225)

### Step 2.4: Fix quality
**Record:** Obviously correct — duplicates proven cleanup logic from
`rdma_counter_free()`. Minimal, no API changes. Low regression risk;
uses existing lock and `__counter_set_mode()` patterns.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** Buggy lines blame to `e664048784506` (tree import merge).
Shallow stable-tree history; counters subsystem predates 6.18 (file
copyright 2019 Mellanox; sibling fix references `Fixes: 56594ae1d250`).

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag on this commit. Sibling patch fixes
`56594ae1d250` (mutex annotation commit in RDMA core).

### Step 3.3: Related file history
**Record:**
- `9420871183eab` — "RDMA/counter: Fix incorrect port index in
  rdma_counter_init() error cleanup" — **already in this 6.18.44 tree**
  (same author, same series, committed by Greg K-H)
- This `num_counters` leak fix is **not** yet in the tree

### Step 3.4: Author context
**Record:** Tao Cui authored both patches; Jason Gunthorpe (maintainer)
Signed-off-by and replied "Applied to for-next" on the series.

### Step 3.5: Dependencies
**Record:** Standalone 2-patch series; patches are independent. This
patch applies cleanly to current `counters.c` (pre-patch index
`c3aa6d7fc66b6` matches current file). No prerequisite commits required
beyond existing counters code.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **URL:** https://lkml.iu.edu/2605.2/07986.html (patch 1/2)
- **Cover:** https://lkml.iu.edu/2605.2/07985.html
- **Series:** 2 patches, both error-path fixes in `counters.c`
- **Maintainer response:** Jason Gunthorpe: "Applied to for-next"
  (https://lists.openwall.net/linux-kernel/2026/05/25/1182)
- No NAKs found; no explicit stable nomination in thread
- `b4 dig -c <hash>` failed (commit not in local tree); lore.kernel.org
  blocked by bot protection

### Step 4.2: Reviewers
**Record:** CC'd: `leon@kernel.org`, `linux-rdma@vger.kernel.org`,
`linux-kernel@vger.kernel.org`. Jason Gunthorpe reviewed and applied.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot — found via code review in
a small 2-patch series.

### Step 4.4: Related patches
**Record:** Patch 2/2 (`rdma_counter_init()` port index) already
backported here as `9420871183eab` (upstream `b86fd95805a7`).

### Step 4.5: Stable mailing list
**Record:** Not searched (no stable-specific discussion found in
available sources).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `alloc_and_bind()`, `__rdma_counter_bind_qp()`,
`__counter_set_mode()`, `rdma_counter_free()`

### Step 5.2: Callers of `alloc_and_bind()`
**Record:**
- `rdma_counter_bind_qp_auto()` — called from `verbs.c` during QP
  RST→INIT with port specified (common QP creation path)
- `rdma_counter_bind_qpn_alloc()` — called from `nldev.c` via RDMA
  netlink/devlink counter configuration

### Step 5.3: Callees
**Record:** `__rdma_counter_bind_qp()` → driver `counter_bind_qp` op
(e.g. mlx5 `mlx5_ib_counter_bind_qp()` which can fail on hardware
counter allocation or flow binding)

### Step 5.4: Reachability
**Record:** Reachable from userspace via RDMA devlink netlink
(`nldev.c`) and from QP modification during IB/RDMA workload setup.
Unprivileged users with RDMA device access can trigger counter bind
operations.

### Step 5.5: Similar patterns
**Record:** Correct cleanup already exists in `rdma_counter_free()`;
this fix adds the missing mirror on the alloc/bind error path.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **YES.** Current tree at lines 191–201 increments
`num_counters` then `goto err_mode` on bind failure without decrement:

```191:201:drivers/infiniband/core/counters.c
        port_counter->num_counters++;
        mutex_unlock(&port_counter->lock);
        // ...
        ret = __rdma_counter_bind_qp(counter, qp, port);
        if (ret)
                goto err_mode;
```

### Step 6.2: Backport complications
**Record:** Clean apply expected — file matches pre-patch blob index
from the patch (`c3aa6d7fc66b6`). Sibling fix from same series already
applied without conflict.

### Step 6.3: Related fixes already present?
**Record:** `9420871183eab` (rdma_counter_init port-index fix) is
present. This `num_counters` leak fix is **not** present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **RDMA/InfiniBand core** — IMPORTANT for HPC, cloud, and
RoCE deployments using hardware counters (mlx5, ionic, etc.)

### Step 7.2: Subsystem activity
**Record:** Actively maintained; recent stable backport activity in this
tree for same file/author.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of RDMA hardware counters on devices with
`counter_bind_qp` support (notably mlx5). Config-dependent on
`CONFIG_INFINIBAND` and counter-capable hardware.

### Step 8.2: Trigger conditions
**Record:** Any `__rdma_counter_bind_qp()` failure after
`alloc_and_bind()` increments `num_counters` — e.g. mlx5 hardware
counter allocation failure (`mlx5_cmd_exec_inout`) or op-counter flow
binding failure (`mlx5r_fs_bind_op_fc`). Repeated failures accumulate
the leak.

### Step 8.3: Failure mode severity
**Record:** No kernel crash/oops, but **permanent functional breakage**
until reboot:
- `-EBUSY` when trying to enable AUTO mode
- Port stuck in MANUAL when it should revert to NONE
- Counter management via devlink becomes unusable
**Severity: MEDIUM-HIGH** (persistent admin/operational failure, not
data corruption or security)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores correct counter state on bind failure; completes
  the already-started backport of this 2-patch series
- **Risk:** Very low — 9 lines mirroring existing `rdma_counter_free()`
  logic
- **Ratio:** Favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verified state leak on error path in production RDMA counter
  code
- User-visible permanent `-EBUSY` / stuck MANUAL mode until reboot
- Small, obviously correct fix reviewed by RDMA maintainer
- Buggy code confirmed present in Linux 6.18.44
- Companion patch from same series already backported to this tree
- Reachable from userspace devlink and QP creation paths
- `mlx5_ib_counter_bind_qp()` has multiple real failure paths

**AGAINST backport:**
- Not a crash, security issue, or data corruption
- Only affects RDMA counter users (subset of kernel users)
- Requires bind failure (not every-day path)
- No syzbot/user bug report

**Unresolved:** Exact upstream commit SHA not in local tree; precise
introduction commit of `alloc_and_bind()` error path not determinable
from shallow stable history (but code clearly present and long-
standing).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors
   `rdma_counter_free()`; maintainer applied to for-next
2. Fixes real bug affecting users? **PASS** — state leak with permanent
   counter-mode breakage
3. Important issue? **PASS (moderate)** — persistent functional failure
   of RDMA counter subsystem, not crash-level but operationally
   significant
4. Small and contained? **PASS** — 9 lines, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code present, clean apply
   expected

### Step 9.3: Exception categories
**Record:** N/A — standard error-path bug fix, not device
ID/quirk/build/doc exception.

### Step 9.4: Decision rationale

This commit fixes a genuine error-path state leak in `alloc_and_bind()`
that leaves `num_counters` inflated and can permanently block AUTO mode
(`-EBUSY`) or leave ports stuck in MANUAL mode. The bug is present in
this 6.18.44 tree, the fix is minimal and mirrors existing cleanup
logic, and the sibling patch from the same 2-patch series is already
backported here. While the failure mode is operational rather than a
kernel panic, the impact is persistent until reboot and affects real
RDMA counter management paths used in production InfiniBand/RoCE
environments.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed part of 2-patch series via lkml cover letter
  (https://lkml.iu.edu/2605.2/07985.html)
- **[Phase 2]** Read diff: +9/-1 in `alloc_and_bind()`, new `err_bind`
  label
- **[Phase 2]** Read current `counters.c` lines 145–232: confirmed bug
  at 200–201 (`goto err_mode` without decrement)
- **[Phase 2]** Read `rdma_counter_free()` lines 215–225: confirmed fix
  mirrors existing cleanup
- **[Phase 2]** Read `__counter_set_mode()` lines 13–28: confirmed
  `-EBUSY` when `num_counters != 0` in AUTO mode
- **[Phase 3]** `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- **[Phase 3]** `git blame -L 191,201`: lines present in tree
- **[Phase 3]** `git log --grep="num_counters leak"` → empty (fix not
  applied)
- **[Phase 3]** `git show 9420871183eab`: sibling patch already
  backported to this tree
- **[Phase 4]** lkml.iu.edu/2605.2/07986.html: patch content matches
- **[Phase 4]** lists.openwall.net reply: Jason Gunthorpe "Applied to
  for-next"
- **[Phase 4]** `b4 dig -c <hash>`: failed (commit not in tree) —
  UNVERIFIED via b4
- **[Phase 4]** lore.kernel.org: blocked by bot protection — UNVERIFIED
  via lore
- **[Phase 5]** `grep alloc_and_bind`: callers in
  `rdma_counter_bind_qp_auto()` and `rdma_counter_bind_qpn_alloc()`
- **[Phase 5]** `verbs.c:1854`: `rdma_counter_bind_qp_auto()` on QP
  RST→INIT
- **[Phase 5]** `nldev.c:2050-2064`: netlink paths to counter bind/auto-
  mode
- **[Phase 5]** `mlx5/counters.c:624-669`: `mlx5_ib_counter_bind_qp()`
  has failure paths returning errors
- **[Phase 6]** Confirmed buggy code exists at lines 191–201 in local
  tree
- **[Phase 6]** Confirmed fix NOT applied (`grep err_bind` in counters.c
  → no match)
- **[Phase 6]** Confirmed sibling fix IS applied (rdma_counter_init uses
  `port_data[i]` at line 664)
- **[Phase 8]** Assessed failure mode: permanent `-EBUSY`/stuck MANUAL,
  severity MEDIUM-HIGH

**YES**

 drivers/infiniband/core/counters.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 5dad5d77ce274..a9e189194c130 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -198,12 +198,20 @@ static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u32 port,
 
 	ret = __rdma_counter_bind_qp(counter, qp, port);
 	if (ret)
-		goto err_mode;
+		goto err_bind;
 
 	rdma_restrack_parent_name(&counter->res, &qp->res);
 	rdma_restrack_add(&counter->res);
 	return counter;
 
+err_bind:
+	mutex_lock(&port_counter->lock);
+	port_counter->num_counters--;
+	if (!port_counter->num_counters &&
+	    port_counter->mode.mode == RDMA_COUNTER_MODE_MANUAL)
+		__counter_set_mode(port_counter, RDMA_COUNTER_MODE_NONE, 0,
+				   false);
+	mutex_unlock(&port_counter->lock);
 err_mode:
 	rdma_free_hw_stats_struct(counter->stats);
 err_stats:
-- 
2.53.0

