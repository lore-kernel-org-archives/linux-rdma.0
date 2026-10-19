Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7E262767B;
	Mon, 19 Oct 2026 14:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418701; cv=none; b=nNLOqUZVxAJOACwlcs49AfwcRflGcZ2HOFSZ+mOdwhVZtdqlSEuYqb5KSDg8UM0DxcJXQ9gzW/3BoZNqYzWgKRZfbqnhs/l9eJGOnz65g2FIcFx3LYjpSWfKeGcweMTFF1J0l0om88rywYMEFqILLxt998FXAxQ4obqdRxV6qpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418701; c=relaxed/simple;
	bh=NF2ixWHRmZkuYK6TcV0TEf5jlgSxou9HK0WmZvoYRo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jnQ5VcVr0TjNNDzEJ2DYm8GODygfxlT/ocaMJ+T9edzO+BumLR26bBAKh1G9h15WRenXsghxT7CZB3Ygkcz9xWR1YOlo+obwFNvHoYl8QwL3plV7CmzOi4eJhvK/N8YCzxxiwE1l4mlu8tq2sNUFPV20rPjDuMpRp1pV/yRh/UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQ3gz7Nh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQ3gz7Nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5334F1F000C5;
	Mon, 19 Oct 2026 14:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418697;
	bh=lpE7in3SaLd94HfkNfamLWAv+AjYDt8XbPu4TGYZbaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQ3gz7NhsK+HjrzMu7EU4fJwsveEp3sbc25iExZCvs/YbzWxRgO/rg/Tg/rBFpeoj
	 AWDDb+HOmLicEh+KwurBuQCBzjB3pK7fMOWBh8avCHJZpEd2EnBvuwWcSLltx0d9RN
	 JPb4oneCjI43Yb7vbnTHSnLksJI7CHBGWmfOnATzK+GhNeNsip1mH2+MzislA7Re5r
	 rCOhDiKfRE052exboIvaO7eaA8O/FO1aiV3rUjSV8EvQxk6b4NU7AdGHeaux+ebG6Q
	 DDELjbvI3Z6DpPOU9Fe+TDu0Jjna/cr27NAe15BEXqc/xggkmmB5dnzKBbqsIC6d1P
	 /rrL8hohm/O6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net/rds: hold the socket while an rds_mr references it
Date: Mon, 19 Oct 2026 09:52:03 -0400
Message-ID: <20261019135441.1420968-432-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 9079adef042c1e7a6141dcdfd3041acd30607297 ]

Each rds_mr stores a bare back pointer to the socket that created it
(mr->r_sock) but takes no reference on it.  When the mr is destroyed it
references the rs. Hence, provisions must be made to avoid the rs
being destroyed before all mrs referencing it have been destroyed.

The MR itself is refcounted, and in-flight messages legitimately hold
MR krefs that can outlive the socket: rds_release() drops the rb-tree
references via rds_rdma_drop_keys(), but a send completion arriving
afterwards drops the final message reference from the CQ handler and
ends up in

  rds_message_purge()
    __rds_put_mr_final()
      rds_destroy_mr()   -> takes rs->rs_rdma_lock

dereferencing a socket that may already have been freed.

Oracle UEK fixed the same use-after-free ("rds: Add proper refcnt when
an RDS MR references an RDS Socket") after seeing crashes of the form:

  PF: supervisor write access in kernel mode
  _raw_spin_lock_irqsave+0x4a/0x6a
  __rds_put_mr_final+0x2c/0xe0 [rds]
  rds_message_purge+0x13c/0x150 [rds]
  rds_message_put+0x39/0x54 [rds]
  rds_ib_send_cqe_handler+0x147/0x3dd [rds_rdma]

To fix this, take a socket reference when an MR is created and drop it
when the final MR kref goes away.  The reference cycle is broken by
rds_release(), which always runs rds_rdma_drop_keys() on close.  So the
socket reference held by an MR never prevents release, it only delays
sk_free() until the last MR user is done.

The hold sits next to kref_init() at both allocation sites -
__rds_rdma_map() and the on-demand-paging path in
rds_cmsg_rdma_args() - so every MR owns exactly one socket reference
from the moment it becomes kref-managed.  For that to work on the ODP
path, its get_mr() error handling is converted from a bare kfree() to
kref_put(..., __rds_put_mr_final), with r_trans_private cleared first
since it holds an ERR_PTR there; both sites then tear down through
the same path and a future error-path change cannot silently leak or
double-drop the reference.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
[achender: port to net-next (sock_hold/sock_put in place of the UEK
 rds_sock_addref/rds_sock_put helpers); also balance the reference on
 the rds_cmsg_rdma_args() ODP path and unify its error path with
 __rds_put_mr_final(); update commit message]
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260730041629.3512480-3-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a use-after-free in RDS MR teardown. The buggy path is in this
5.10 tree, the fix is small, and it should be backported.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[net/rds] [hold] hold the socket while an rds_mr references
it**
- Subsystem: `net/rds`
- Action verb: “hold” (keep a missing reference so the socket outlives
  the MR)
- Claimed intent: an `rds_mr` keeps a counted socket reference for its
  lifetime

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record (from the candidate / merged `9079adef042c`):
- **Fixes:** absent in the git commit. The v4 mailing-list post had
  `Fixes: eff5f53bef75 ("RDS: RDMA support")`. Absence in git is
  expected here and is not a negative.
- **Reported-by:** none. The body cites an Oracle UEK production crash.
- **Tested-by:** none
- **Reviewed-by / Acked-by:** none on the commit
- **Link:** `https://patch.msgid.link/20260730041629.3512480-3-
  achender@kernel.org`
- **Cc: stable:** absent (expected)
- **Signed-off-by:** Håkon Bugge (Oracle, original); Allison Henderson
  (RDS, port); Jakub Kicinski (net maintainer, merge)
- Notable: Allison’s trailer says this is a UEK port
  (`sock_hold`/`sock_put` instead of UEK
  `rds_sock_addref`/`rds_sock_put`). This tree already has those helpers
  as thin wrappers around `sock_hold`/`sock_put`.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `mr->r_sock` is a bare back-pointer. `rds_destroy_mr()` takes
  `rs->rs_rdma_lock` after the socket may already be freed.
- **Symptom:** kernel oops: `PF: supervisor write access` in
  `_raw_spin_lock_irqsave` from `__rds_put_mr_final` ←
  `rds_message_purge` ← `rds_message_put` ← `rds_ib_send_cqe_handler`.
- **Root cause:** `rds_release()` drops rb-tree MR refs via
  `rds_rdma_drop_keys()`, but in-flight send completions still hold MR
  krefs. The CQ/tasklet path then destroys the MR against a freed
  socket.
- **Version info:** none beyond “Oracle UEK saw this.” The mechanism is
  as old as RDS RDMA (2009).
- **Fix:** `sock_hold()` at both MR alloc sites next to `kref_init()`;
  `sock_put()` in `__rds_put_mr_final()`. Cycle is broken because
  `rds_release()` always runs `rds_rdma_drop_keys()`, so the MR ref only
  delays `sk_free()`, it does not block `release`.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. Explicit UAF fix with a crash stack. The ODP
`kfree` → `kref_put` change is part of making the hold/put pairing
correct on the error path.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- `net/rds/rdma.c`: +13 / −1 (functional)
- `net/rds/rds.h`: +4 / −1 (comment on `r_sock`)
- **Functions:** `__rds_put_mr_final()`, `__rds_rdma_map()`,
  `rds_cmsg_rdma_args()`
- **Scope:** single-subsystem, surgical (~17 lines)

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **`__rds_put_mr_final`:** after `rds_destroy_mr(mr)`, add
  `sock_put(rds_rs_to_sk(mr->r_sock))` before `kfree(mr)`.
- **`__rds_rdma_map`:** after `mr->r_sock = rs`, add `sock_hold()`. This
  tree already `kref_put`s `mr` on every `out:` path (success and
  error), so the hold is paired.
- **ODP path in `rds_cmsg_rdma_args`:** `sock_hold()` next to
  `kref_init()`. On `get_mr()` failure, clear `r_trans_private` (it is
  an `ERR_PTR`) and `kref_put(..., __rds_put_mr_final)` instead of a
  bare `kfree`, so `free_mr()` is not called with an error pointer and
  the socket ref is dropped.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** use-after-free / missing reference count
- **Mechanism:** MR outlives socket; destructor uses `rs->rs_rdma_lock`.
  Fix is one `sock_hold` per kref-managed MR, one `sock_put` on final
  kref.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: classic missing get/put; both alloc sites covered
  (only two `kref_init` of `rds_mr` in `net/rds/`).
- `__rds_rdma_map` already uses `kref_put` on `out:`; ODP error path is
  converted to the same destructor.
- Regression risk is low. `sock_put` from the send tasklet is already
  done in `rds_message_purge()` for `rm->m_rs`. `rds_sock_destruct()` is
  only a `WARN_ON` on an empty list.
- No API or data-structure layout change beyond a comment.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- `mr->r_sock = rs` and `rds_destroy_mr()` using that pointer:
  `eff5f53bef75` (“RDS: RDMA support”), 2009-02-26. Present in 5.10.
- `__rds_put_mr_final` / `kref_init`: `e228a5d05e9ee` (2020-04-09), in
  this tree.
- ODP alloc in `rds_cmsg_rdma_args`: `2eafa1746f178` (2020-01-18), in
  this tree.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` on the git commit. Mailing-list tag `eff5f53bef75`
**is** an ancestor of HEAD (`git merge-base --is-ancestor` exit 0).
Merged mainline SHA `9079adef042c` is **not** an ancestor of this tree
(exit 1). No later sock-hold-on-MR commit exists in this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- `91a44b406bc1f` (“net: rds: fix MR cleanup on copy error”) is already
  here; it only stops double-free of pages/sg on `put_user` failure. It
  does not hold the socket.
- `2fabef4f65b46` (“Fix MR reference counting problem”) is about
  `rds_free_mr()` bypassing kref, not socket lifetime.
- This patch is standalone vs those.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Håkon Bugge has multiple RDS commits in this history. Allison
Henderson is the RDS maintainer and ported the UEK fix. The original
crash was seen in Oracle production.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Submitted as **v4 2/4**. Siblings:
1. `d100966325f7` — don’t `unpin_user_pages_dirty_lock()` from atomic
   context
3. message leak in `rds_send_xmit()` drop path
4. unpin MR pages with `unpin_user_pages_dirty_lock()`
Those are separate bugs. This diff only needs `sock_hold`/`sock_put`,
`kref_put`, and `__rds_put_mr_final`, all present here. **Can apply
standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 9079adef042c`: v4 2/4,
  https://patch.msgid.link/20260730041629.3512480-3-achender@kernel.org
- Revisions: v1 (2026-07-10), v2, v3 (ODP hold after successful
  `get_mr`), v4 (hold next to `kref_init`, error path via
  `__rds_put_mr_final`) — applied version is v4.
- Cover letter: explicit UAF of the RDS socket through long-lived MR
  refs; UEK port https://github.com/oracle/linux-uek/commit/94549e4732d8
- No NAK found on this patch. Jakub applied the series to net-next on
  2026-08-04 (`9079adef042c`).
- v4 changelog: ODP ref moved next to `kref_init` so both alloc sites
  share one ownership rule.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): netdev, linux-rdma, Paolo Abeni, Eric Dumazet,
Jakub Kicinski, Simon Horman, John Hubbard, Leon Romanovsky. Applied by
the net maintainer. No NAK located.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla link. Evidence is the UEK oops in the commit
message, matching this tree’s call chain (`rds_ib_tasklet_fn_send` →
`rds_ib_send_cqe_handler` → `rds_message_put` → `rds_message_purge` →
`__rds_put_mr_final`).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 4 independent RDS bug-fix ports. This one does not need 1/3/4.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: **UNVERIFIED** — `lore.kernel.org/stable` fetch returned 403. No
local evidence this was rejected for 5.10.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `__rds_put_mr_final`, `__rds_rdma_map`, `rds_cmsg_rdma_args`
(plus `rds_destroy_mr` as callee).

Step 5.2: TRACE CALLERS
Record:
- `__rds_put_mr_final`: `kref_put` from `rds_rdma_drop_keys`,
  `rds_free_mr`, `rds_rdma_unuse`, `rds_rdma_free_op` (ODP),
  `rds_message_purge` (`op_rdma_mr` / atomic MR), and `__rds_rdma_map`
  `out:`.
- `__rds_rdma_map`: `rds_get_mr`, `rds_get_mr_for_dest`,
  `rds_cmsg_rdma_map` (sendmsg cmsg). Userspace RDMA registration.
- `rds_cmsg_rdma_args`: `rds_sendmsg` path for `RDS_CMSG_RDMA_ARGS`.

Step 5.3: TRACE CALLEES
Record: `rds_destroy_mr` → `spin_lock_irqsave(&rs->rs_rdma_lock)` (the
UAF); `free_mr()`; `sock_hold`/`sock_put`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace maps an MR or sends RDMA, then closes the socket while
a send is in flight. Completions run in `rds_ib_tasklet_fn_send`
(softirq). Reachable from AF_RDS sockets with `CONFIG_RDS` +
`CONFIG_RDS_RDMA` (InfiniBand). Typical Oracle RAC / IB RDS workload.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Only two `kref_init` sites for `struct rds_mr`. Both patched.
`rds_cmsg_rdma_dest` only `kref_get`s an existing tree MR.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.**
- Tree: `pending-5.10`, `5.10.270` (`p-5.10-1-gce56b7a73b64b`)
- `net/rds/rdma.c`: `mr->r_sock = rs` with no `sock_hold` (lines 243–246
  and 735–738)
- `__rds_put_mr_final` has no `sock_put` (115–121)
- `rds_release()` still does `rds_rdma_drop_keys()` then `sock_put(sk)`
  (`af_rds.c`)
- Introduced 2009; ODP path 2020. Both in 5.10.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Minor context only.** Mainline uses `kzalloc_obj` /
`kzalloc_objs`; this tree uses `kzalloc` / `kcalloc`. The hold/put lines
sit on identical `kref_init` / `mr->r_sock` / ODP `get_mr` error code.
Local ODP error uses `ret = IS_ERR(...)` then overwrites with
`-EOPNOTSUPP`; the patch uses `PTR_ERR` then the same overwrite.
Semantic apply is straightforward.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No socket-hold-on-MR fix. `91a44b406bc1f` is a different MR
cleanup bug.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **net/rds** — IMPORTANT, not core. RDS over IB is production for
Oracle RAC and similar clusters. UAF is still a kernel oops for those
users.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature (2009). Occasional stable fixes in this tree
(`91a44b406bc1f` in 2026). Not a new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **config/driver-specific:** `CONFIG_RDS` + RDMA
(`CONFIG_RDS_RDMA`). Not all 5.10 boxes, but all RDS/IB RDMA users who
close a socket with in-flight MRs.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Map MR or send RDMA, close socket before CQ completion. Timing-
dependent but realistic (UEK crash). Needs an RDS socket; typical RDS
users are cluster services.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **Use-after-free → oops on spinlock of freed `rds_sock`.**
Severity **CRITICAL/HIGH**. Same class as KASAN UAF; crash stack is
real.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** high for RDS/IB — prevents a known UAF oops.
- **Risk:** low — ~17 lines, standard `sock_hold`/`sock_put`, both alloc
  sites, error path unified.
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**FOR:**
- Real UAF with production oops (Oracle UEK).
- Same call path exists in this 5.10 tree.
- Bug dates to 2009 RDMA support; ODP path also here.
- Small, obviously correct refcount fix; v4 review then net-maintainer
  merge.
- Standalone vs the rest of the series.
- `__rds_rdma_map` already drops the MR via `kref_put` on all exits, so
  the new hold is balanced.

**AGAINST:**
- RDS/IB is not universal.
- Patch was 2/4 of a series (siblings are independent).
- Minor `kzalloc_obj` vs `kzalloc` context when applying.

**UNRESOLVED:**
- Stable-list discussion (lore 403).
- No public syzbot repro (crash is still documented).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — hold at `kref_init`, put in
   finalizer; merged to net-next; UEK precedent.
2. Fixes a real bug that affects users? **PASS** — production oops.
3. Important issue? **PASS** — UAF / kernel oops, HIGH/CRITICAL.
4. Small and contained? **PASS** — 2 files, ~17 lines.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — buggy code present; minor
   context only.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary memory-
safety fix.

Step 9.4: MAKE YOUR DECISION
This 5.10 tree has the bare `r_sock` pointer, the CQ/tasklet free path,
and no socket hold on MRs. The fix is the missing refcount. It should be
backported.

===============================================================
What this solves for stable users
===============================================================
Closing an RDS socket while an RDMA MR is still referenced by an in-
flight send can free `rds_sock` before `__rds_put_mr_final` →
`rds_destroy_mr` takes `rs->rs_rdma_lock`. That is an oops. Holding the
socket until the last MR kref drops keeps the lock valid;
`rds_rdma_drop_keys()` in `rds_release()` still breaks the tree↔socket
cycle.

Risk vs benefit: high benefit for RDS/IB, low regression risk.
`sock_put` from this tasklet is already used for `rm->m_rs`. Backport
may need trivial context adjustment (`kzalloc` vs `kzalloc_obj`); no
missing helpers or types.

Verification:
- [Phase 1] Tags: Link msgid `20260730041629.3512480-3`; SOB Bugge /
  Henderson / Kicinski; no Fixes in git; ML had `Fixes: eff5f53bef75`
- [Phase 2] Diff: `sock_put` in `__rds_put_mr_final`; `sock_hold` in
  `__rds_rdma_map` and ODP alloc; ODP error `kfree` → `kref_put` after
  NULL-out of `ERR_PTR`
- [Phase 2] Local `__rds_rdma_map` `out:` already `kref_put`s if `mr`
  non-NULL (`rdma.c` 348–351)
- [Phase 3] `git blame`: `r_sock` / `rds_destroy_mr` from `eff5f53bef75`
  (2009); kref from `e228a5d05e9ee` (2020)
- [Phase 3] `git merge-base --is-ancestor eff5f53bef75c0 HEAD` → 0;
  `2eafa1746f178` → 0; `9079adef042c` → 1 (not in this tree)
- [Phase 3] `git describe HEAD` / `make kernelversion`: pending-5.10,
  5.10.270
- [Phase 3] Only two `kref_init(&...r_kref)` sites in `net/rds/`
- [Phase 4] `b4 dig -c 9079adef042c`: v4 2/4; recipients
  netdev/rdma/Kicinski/Dumazet/Abeni/Horman
- [Phase 4] `b4 dig -a`: v1→v4; v4 unifies ODP error path
- [Phase 4] Cover letter: UEK UAF port; applied as `9079adef042c`
- [Phase 4] UNVERIFIED: stable@ thread (403)
- [Phase 5] Call chain confirmed: `rds_ib_tasklet_fn_send` →
  `rds_ib_send_cqe_handler` → `rds_message_put` → `rds_message_purge` →
  `__rds_put_mr_final`
- [Phase 5] `rds_release` calls `rds_rdma_drop_keys` then `sock_put`
  (`af_rds.c` 78, 89)
- [Phase 6] Local `rdma.c` has no `sock_hold`/`sock_put`; comment still
  says “back pointer”
- [Phase 8] Failure mode: UAF oops on `rs_rdma_lock`, HIGH/CRITICAL
- UNVERIFIED: whether an unprivileged process can open AF_RDS on a given
  distro; crash still confirmed for RDS/IB users

**YES**

 net/rds/rdma.c | 14 +++++++++++++-
 net/rds/rds.h  |  5 ++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 37695056756be..062c12d9318e9 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -117,6 +117,7 @@ void __rds_put_mr_final(struct kref *kref)
 	struct rds_mr *mr = container_of(kref, struct rds_mr, r_kref);
 
 	rds_destroy_mr(mr);
+	sock_put(rds_rs_to_sk(mr->r_sock));
 	kfree(mr);
 }
 
@@ -243,7 +244,11 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 	kref_init(&mr->r_kref);
 	RB_CLEAR_NODE(&mr->r_rb_node);
 	mr->r_trans = rs->rs_transport;
+	/* The MR can outlive its socket: a socket reference is held
+	 * until the final kref is dropped in __rds_put_mr_final().
+	 */
 	mr->r_sock = rs;
+	sock_hold(rds_rs_to_sk(rs));
 
 	if (args->flags & RDS_RDMA_USE_ONCE)
 		mr->r_use_once = 1;
@@ -762,7 +767,12 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 			RB_CLEAR_NODE(&local_odp_mr->r_rb_node);
 			kref_init(&local_odp_mr->r_kref);
 			local_odp_mr->r_trans = rs->rs_transport;
+			/* The MR can outlive its socket: a socket
+			 * reference is held until the final kref is
+			 * dropped in __rds_put_mr_final().
+			 */
 			local_odp_mr->r_sock = rs;
+			sock_hold(rds_rs_to_sk(rs));
 			local_odp_mr->r_trans_private =
 				rs->rs_transport->get_mr(
 					NULL, 0, rs, &local_odp_mr->r_key, NULL,
@@ -771,7 +781,9 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 				ret = PTR_ERR(local_odp_mr->r_trans_private);
 				rdsdebug("get_mr ret %d %p\"", ret,
 					 local_odp_mr->r_trans_private);
-				kfree(local_odp_mr);
+				local_odp_mr->r_trans_private = NULL;
+				kref_put(&local_odp_mr->r_kref,
+					 __rds_put_mr_final);
 				ret = -EOPNOTSUPP;
 				goto out_pages;
 			}
diff --git a/net/rds/rds.h b/net/rds/rds.h
index a4816da162930..dcbc4610735d5 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -299,7 +299,10 @@ struct rds_mr {
 	unsigned int		r_invalidate:1;
 	unsigned int		r_write:1;
 
-	struct rds_sock		*r_sock; /* back pointer to the socket that owns us */
+	struct rds_sock		*r_sock; /* socket that owns us; counted
+					  * reference, dropped by
+					  * __rds_put_mr_final()
+					  */
 	struct rds_transport	*r_trans;
 	void			*r_trans_private;
 };
-- 
2.53.0

