Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F07501280;
	Mon, 19 Oct 2026 13:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418097; cv=none; b=daB1e/70p1KhjGhIQALF7Fsik0Vcm9BChSW9aqiIbxuCaL6SJIxliL4tIVPeBArcMFWdU1BbB7GqvWpI+l7QjKdPR37PiErUDIaE2ExRtfYt5WQHxrwsD1YeKbuZwyD3imDMcgUyOUNMWT77qpxN+HLGA41aMcgXcB6ytxiu5MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418097; c=relaxed/simple;
	bh=4xpDEzR+herJSaTFJhvNkc7qSxNr1lO2IVupfeYRmQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oJGp03CDA6KQndfRCgo+GOBjddYlTYMFEmwbI3Cxj892ciOYaCpPV5QHVczIRVOT6KRplOw8YlPIlmkL2uMV/8attU+aT30SoK6cKQ55oMaBuatxLssbCPxglCnwrjgemZGGEE2xFN5JhwrLolT/rTBKCIZcK9KV8XV5m6RSQVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kdnqzlks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kdnqzlks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E032E1F000CB;
	Mon, 19 Oct 2026 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418094;
	bh=Y5SNz+ZXGnbVUXe0Sdp8UmdiSoEuaWhQmv+y0m0tAq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kdnqzlks9LYHhpvhl4oL+3GsStBQdzjLVPLpYKT4Gs1oDgAfSwRjihEGeDFjgzyQU
	 E6DAaOxGZbk7so2az0RY/aZlXyKetJ/Tpoz7UKCbGa+rhV5prFEN0/B84AfFj2FVbg
	 ObpsBNJYAu2cVnedOxghiFmQ8tuMIBx6rBY/80xA9IxJTay9R+b80zsZjbQqaT81x4
	 tzf/4Qhe7sTfQglcfvgQMPAa7Ch2fV4xenAOvmVRbnWGhtxNOniOIYod1I3J36zbR/
	 dvFhT2SZPJ+uZXsuetNurZI3BkR9c0aIwB1hNoA111Ow5AC5LjO1mPnCC+f09qG97r
	 5Qv2NKyo+gkQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net/rds: don't use unpin_user_pages_dirty_lock() from atomic context
Date: Mon, 19 Oct 2026 09:44:59 -0400
Message-ID: <20261019135441.1420968-8-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Allison Henderson <achender@kernel.org>

[ Upstream commit d100966325f782aa7775e5f0e8fb04f66f56308e ]

rds_rdma_free_op() and rds_atomic_free_op() are reached from the IB
send completion path via

  rds_ib_tasklet_fn_send()
    rds_ib_send_cqe_handler()
      rds_message_put()
        rds_message_purge()
          rds_rdma_free_op() / rds_atomic_free_op()

which runs in tasklet (softirq) context.  Both functions unpin the
user pages of the op with unpin_user_pages_dirty_lock(), which uses
set_page_dirty_lock() and thus may take the folio lock and sleep.
Sleeping in softirq context is not allowed and can deadlock or crash.

Dirtying the pages with the non-sleeping set_page_dirty() instead
would just trade one bug for another, as pointed out during review:
the pinned range can be file-backed.  rds_pin_pages() pins with
FOLL_LONGTERM, which refuses fs-dax but takes the page-cache pages
of a MAP_SHARED file mapping just fine, and RDS does not restrict
what memory the caller registers as an RDMA destination.

For a file-backed page, set_page_dirty() from a tasklet can take
non-irq-safe filesystem locks (e.g. mapping->i_private_lock and
inode->i_lock in block_dirty_folio()) and deadlock against the task
it interrupted.  Without the folio lock, it races with truncation
clearing folio->mapping, which is the race set_page_dirty_lock()
exists to close.  The pre-pin_user_pages() version of this code
dirtied pages that way from the tasklet, so that bug is older than
the sleeping unpin.

The page dirtying therefore has to move to process context, not
merely avoid the folio lock.  When the final rds_message_put() runs
in atomic context, rds_rdma_free_op() and rds_atomic_free_op() now
leave the op's pages pinned and flag the op. Later, rds_message_put()
hands the message to a work item that unpins the flagged ops' pages
and frees the message from process context. Here,
unpin_user_pages_dirty_lock() is safe outside the atomic context.
Everything else keeps running in the caller's context exactly as
before: the rest of the purge - the zerocopy completion, the socket
put and the MR reference drops - as well as RDMA writes, whose pages
the remote side only reads and which unpin without dirtying,
everything on rds_tcp, and final puts that already happen in process
context (socket close, connection teardown).

Deferring only the unpin means the work item touches nothing but the
pinned pages and the rds module's own memory: it cannot call back
into a transport module, so it changes nothing about the transports'
shutdown and unload ordering.  rds_exit() drains any pending unpin
work via destroy_workqueue(rds_wq) before the module goes away.

The Oracle UEK kernel avoids the sleeping unpin by calling
set_page_dirty() directly from the tasklet, which is subject to the
file-backed page problem above, so this deliberately does not follow
UEK here.

Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260730041629.3512480-2-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real sleep-in-softirq bug on the RDS IB completion path, and
the buggy code is present in this 5.10.270 tree. The fix is self-
contained and should be backported.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [net/rds] [don't use] don't call `unpin_user_pages_dirty_lock()`
from atomic/softirq context. "don't use" is a prevent/avoid-style fix.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Allison Henderson `<achender@kernel.org>` (author;
  ignore pipeline SOB)
- Signed-off-by: Jakub Kicinski `<kuba@kernel.org>` (netdev maintainer)
- Link: `https://patch.msgid.link/20260730041629.3512480-2-
  achender@kernel.org`
- No Reported-by, Tested-by, Reviewed-by, Acked-by, or Cc: stable in the
  provided message
- Mailing-list v4 **did** include `Fixes: 0d4597c8c5ab ("net/rds: Track
  user mapped pages through special API")`; that tag is in this tree
  (verified with `git merge-base --is-ancestor`)
- Message-ID `-2` is patch 1/4 of `[PATCH net v4 0/4] net/rds: Bug fix
  ports` (cover letter is `-1`)
- Assisted-by Claude appears on the lore submission only

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `rds_rdma_free_op()` / `rds_atomic_free_op()` run from the IB
  send tasklet and call `unpin_user_pages_dirty_lock()`, which uses
  `set_page_dirty_lock()` → `lock_page()`, which may sleep.
- Symptom: sleep in softirq → deadlock or crash.
- Switching to `set_page_dirty()` from the tasklet is also wrong for
  file-backed pins (`FOLL_LONGTERM` MAP_SHARED): non-irq-safe fs locks
  and truncation races.
- Fix: if the final put is atomic and pages need dirtying, leave them
  pinned, set `op_unpin_deferred`, and finish unpin+free on `rds_wq`.
- Author notes this is older than the pin API (pre-pin code already
  dirtied from the tasklet) and that UEK’s `set_page_dirty()`-from-
  tasklet approach is intentionally not followed.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. Explicit sleep-in-atomic / deadlock fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- `net/rds/message.c`: add `rds_message_unpin_worker()`, defer `kfree`
  from `rds_message_put()` when unpin was deferred
- `net/rds/rdma.c`: split unpin helpers; `rds_rdma_free_op()` /
  `rds_atomic_free_op()` unpin inline only when safe (`in_task()` or
  RDMA write)
- `net/rds/rds.h`: `m_unpin_work`, `op_unpin_deferred` bitfields, helper
  prototypes
- Scope: ~74 insertions / 11 deletions, three RDS files, surgical

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: final `rds_message_put()` always purges and unpins (possibly
  dirtying) in the caller’s context, including the send CQ tasklet.
- After: purge still runs in the caller (zerocopy, sock_put, MR krefs).
  Dirtying unpin is deferred to process context. RDMA writes still unpin
  immediately (no dirty). Process-context final puts still unpin
  immediately.
- Error path `rds_cmsg_rdma_args()` → `rds_rdma_free_op()` is
  sendmsg/process context, so `in_task()` is true and pages are not
  leaked.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Deadlock / sleep-in-atomic] `lock_page()` from tasklet/softirq.
Workqueue deferral is the correct class of fix; dirtying cannot stay in
the tasklet.

Step 2.4: ASSESS THE FIX QUALITY
Record: v4 is the review-hardened design (v1 used `set_page_dirty()` in
the tasklet; v2/v3 deferred the whole purge and needed extra IB-module
flushes). Risk is the usual workqueue lifetime issues; mitigated because
the worker only unpins pages and `kfree`s the message, and `rds_exit()`
→ `rds_threads_exit()` → `destroy_workqueue(rds_wq)` drains it. Messages
are `kzalloc`’d, so new flags/work_struct start zeroed.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Sleeping unpin: `0d4597c8c5abd` ("net/rds: Track user mapped pages
  through special API", Leon Romanovsky, 2020) — **in this tree**
- Call from tasklet: `rds_rdma_free_op` / `rds_message_put` date to
  2009–2010 (Andy Grover)
- Pre-pin code already dirtied from this path

Step 3.2: FOLLOW THE FIXES: TAG
Record: `0d4597c8c5ab` is an ancestor of HEAD (`git merge-base --is-
ancestor` exit 0). No later in-tree substitute for this unpin-from-
tasklet bug. `338a3ba30c5ef` ("net:rds: Fix possible deadlock in
rds_message_put") is a different lock-order bug in `recv.c`.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `net/rds/` work here is unrelated (zerocopy, MR cleanup,
tcp corruption). This is standalone, not patch 2-of-N that needs earlier
series members.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Allison Henderson is a long-time RDS contributor; this tree
already has several of her RDS fixes. Author is the right subsystem
person.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Series mates (socket ref on MR, send_xmit leak, MR teardown
unpin) are independent bugs. Needed APIs exist here: `in_task()`,
`unpin_user_pages_dirty_lock()`, `rds_wq`, `pin_user_pages_fast()` +
`FOLL_LONGTERM`. No missing helpers.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 mbox` on msgid `20260730041629.3512480-2-achender@kernel.org`:
  8-message thread
- Lore/WebFetch of lore.kernel.org and patch.msgid.link returned 403;
  discussion recovered via b4 + openwall
- Revisions: v1 2026-07-11, v2 2026-07-25, v3 2026-07-26, v4 2026-07-29
  (applied)
- v1 NAK’d conceptually: `set_page_dirty()` from softirq can deadlock on
  fs locks and race truncation
- v3 extra `rds_ib_exit()` flushes dropped in v4 by deferring only unpin
- Applied to netdev/net-next as `d100966325f7` (not this tree)

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To/Cc included netdev, linux-rdma, Kicinski, Abeni, Dumazet,
Horms. No subsystem Reviewed-by on v4. Kicinski: “I don't have much
confidence in my ability to review this, so let's queue this for -next.”
Author agreed they are old, non-simple bugs.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla in the thread. Motivation is code analysis +
UEK carrying a related (weaker) fix. Oracle RDS/IB users are the
affected population.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 4-patch “Bug fix ports” series. This patch is 1/4 and does not
depend on 2–4. Patch 4 is a separate pin-vs-put_page leak in
`__rds_ib_teardown_mr()`.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No useful hit on lore.kernel.org/stable for this subject (search
was noisy/unrelated). Originally aimed at `net` because of Fixes:; moved
to net-next. Absence of stable-list discussion is not a NAK.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `rds_message_unpin_worker` (new), `rds_message_put`,
`rds_rdma_op_unpin_pages` (new), `rds_rdma_free_op`,
`rds_atomic_op_unpin_page` (new), `rds_atomic_free_op`

Step 5.2: TRACE CALLERS
Record:
- `rds_message_put()`: send.c, ib_send.c, ib_cm.c, message.c, loop.c,
  connection.c
- Confirmed atomic path: `rds_ib_tasklet_fn_send()` → `poll_scq()` →
  `rds_ib_send_cqe_handler()` → `rds_message_put()` (`net/rds/ib_cm.c`,
  `ib_send.c`)
- `rds_rdma_free_op()`: `rds_message_purge()` and `rds_cmsg_rdma_args()`
  error path (process context)
- `rds_atomic_free_op()`: only `rds_message_purge()`

Step 5.3: TRACE CALLEES
Record: `unpin_user_pages_dirty_lock()` → `set_page_dirty_lock()` →
`lock_page()` (sleeping). Non-dirty path uses `unpin_user_pages()` only.
Worker uses `queue_work(rds_wq)` / `kfree`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace `sendmsg` with `RDS_CMSG_RDMA_ARGS` / atomic cmsg → IB
RDMA READ or atomic WR → CQ completion in tasklet → final put. Reachable
from sockets if `CONFIG_RDS_RDMA`. Not a theoretical path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Local `__rds_ib_teardown_mr()` still does `set_page_dirty()` +
`put_page()` (series patch 4). `rds_info.c` unpins from getsockopt
(process context) — OK. Same class of bug is already treated as
backport-worthy in this tree (`88fdf5948f538` Don't sleep inside
`rds_ib_conn_path_shutdown`).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. This checkout is **5.10.270** (`pending-5.10`, `git
describe` `p-5.10-1-gce56b7a73b64b`).
- `net/rds/rdma.c:500` and `:517` call `unpin_user_pages_dirty_lock()`
- `rds_ib_tasklet_fn_send` still a tasklet
- `rds_pin_pages()` uses `FOLL_LONGTERM`
- Introduced by `0d4597c8c5ab` (v5.7-era), present on this branch

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Semantic apply is straightforward. `rdma.c` / `rds.h` match the
old side of the diff. `message.c` context after `rds_message_put()`
still assigns `hdr->h_exthdr[0]` instead of `memset` of the ext header —
**minor context conflict**, not a rework. `work_struct` / `queue_work` /
`in_task()` are available (`rds.h` → `sock.h` → `netdevice.h` →
`workqueue.h`; `hardirq.h` → `preempt.h`). `rds_wq` is destroyed on
module exit.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No equivalent deferred-unpin fix. `338a3ba30c5ef` is a different
deadlock.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [net/rds] IMPORTANT for RDS-over-IB (Oracle RAC / HPC). Not core
networking; production users of 5.10 LTS do run this.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature. Core free/put path has been stable for years; this is a
long-standing latent bug, not churn on new code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Config-specific / driver-specific: `CONFIG_RDS` +
`CONFIG_RDS_RDMA`, IB completions of RDMA READ / atomic ops against
pinned user memory (including MAP_SHARED file pages).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Common on RDS RDMA READ completion. Timing-dependent on folio
already locked (writeback). Unprivileged user with an RDS socket and
registered memory can hit it. Not every boot.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Sleep in softirq / `lock_page()` from tasklet → deadlock or
crash. **CRITICAL**. File-backed `set_page_dirty()` alternative would
also be CRITICAL (fs lock deadlock / mapping UAF).

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for RDS/IB users (prevents deadlock/oops on a real
  completion path)
- Risk: low–medium (workqueue deferral, ~70 lines, one subsystem; worker
  does not call into the IB module)
- Ratio: benefit outweighs risk. Larger than a 5-line NULL check, but
  the pattern is standard and v4 was specifically reduced to avoid
  unload races.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Sleep in softirq is a real, important bug
- Path exists on this 5.10 tree and is userspace-reachable via RDS RDMA
- Fixes target `0d4597c8c5ab` is in the tree
- Small, RDS-only, no new uAPI
- Needed kernel APIs exist
- v4 design addresses earlier review NAKs
- `destroy_workqueue(rds_wq)` drains deferred work
- RDS maintainer-authored; netdev applied it upstream

AGAINST:
- ~70 lines and a new work item (not a one-liner)
- Queued to net-next; Kicinski was uneasy reviewing it
- No syzbot/Tested-by on the committed message
- Trivial `message.c` context tweak for `rds_message_populate_header()`

UNRESOLVED:
- Could not fetch lore.kernel.org in-browser (403); used b4 mbox instead
- No evidence of a later revert or follow-up for `d100966325f7` (search
  did not turn one up)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — v4 is the review-fixed
   design; mechanism matches the bug. (Confidence is “good”, not
   “trivial one-liner”.)
2. Fixes a real bug that affects users? **PASS**
3. Important issue? **PASS** — deadlock/crash, CRITICAL
4. Small and contained? **PASS** — 3 files, RDS only
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — code present; at most a minor
   context adjustment

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID/quirk/DT/build/docs exception). Qualifies
as a normal important bugfix.

Step 9.4: MAKE YOUR DECISION
This tree still unpins and dirties RDMA/atomic pages in the IB send
tasklet. That can sleep. Deferring only that unpin onto existing
`rds_wq` is the right fix here and does not need the rest of the v4
series.

What it solves for 5.10 users: RDS-over-InfiniBand RDMA READ/atomic
completion can call `lock_page()` in softirq, which can deadlock or
crash. That is exactly the class of bug stable is for.

Risk vs benefit: contained RDS change, process-context unpin, workqueue
drained on unload. Benefit is preventing a serious completion-path
failure.

Concerns: expect a small `message.c` context edit around
`rds_message_populate_header()`; do not pull series patches 2–4 as
prerequisites.

Verification:
- [Phase 1] Tags: SOB Henderson/Kicinski; Link msgid; lore v4 had Fixes:
  0d4597c8c5ab
- [Phase 2] Diff: defer dirtying unpin via work item; RDMA write still
  unpins in caller
- [Phase 3] `git describe` / Makefile: 5.10.270; blame unpin lines →
  0d4597c8c5ab; ancestor check exit 0
- [Phase 3] `338a3ba30c5ef` is a different recv.c deadlock
- [Phase 4] `b4 mbox`: 8 msgs, v1–v4, applied as d100966325f7; Kicinski
  queued net-next
- [Phase 4] WebFetch lore/msgid.link: 403; discussion from b4 + openwall
- [Phase 5] Call chain verified in ib_cm.c / ib_send.c;
  `set_page_dirty_lock()` uses `lock_page()` in mm/page-writeback.c
- [Phase 5] Other `rds_rdma_free_op()` caller is process-context error
  path in rdma.c:796
- [Phase 6] Local rdma.c still has sleeping unpin; `in_task()` and
  `rds_wq` exist; messages kzalloc’d
- [Phase 6] Header context differs (`h_exthdr[0]` vs memset) — minor
  backport
- [Phase 8] Failure mode: sleep-in-softirq / deadlock, CRITICAL
- UNVERIFIED: live lore HTML; no later revert found

**YES**

 net/rds/message.c | 26 +++++++++++++++++++++++++
 net/rds/rdma.c    | 49 ++++++++++++++++++++++++++++++++++++-----------
 net/rds/rds.h     | 10 ++++++++++
 3 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 19202aa33f6f4..bdd340f4cce65 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -180,6 +180,19 @@ static void rds_message_purge(struct rds_message *rm)
 		kref_put(&rm->atomic.op_rdma_mr->r_kref, __rds_put_mr_final);
 }
 
+static void rds_message_unpin_worker(struct work_struct *work)
+{
+	struct rds_message *rm = container_of(work, struct rds_message,
+					      m_unpin_work);
+
+	if (rm->rdma.op_unpin_deferred)
+		rds_rdma_op_unpin_pages(&rm->rdma);
+	if (rm->atomic.op_unpin_deferred)
+		rds_atomic_op_unpin_page(&rm->atomic);
+
+	kfree(rm);
+}
+
 void rds_message_put(struct rds_message *rm)
 {
 	rdsdebug("put rm %p ref %d\n", rm, refcount_read(&rm->m_refcount));
@@ -187,8 +200,21 @@ void rds_message_put(struct rds_message *rm)
 	if (refcount_dec_and_test(&rm->m_refcount)) {
 		BUG_ON(!list_empty(&rm->m_sock_item));
 		BUG_ON(!list_empty(&rm->m_conn_item));
+
 		rds_message_purge(rm);
 
+		/* A final put in atomic context cannot dirty the ops'
+		 * user pages on unpin, so rds_rdma_free_op() and
+		 * rds_atomic_free_op() deferred it.  Finish the unpin,
+		 * and the free, from process context.
+		 */
+		if (rm->rdma.op_unpin_deferred ||
+		    rm->atomic.op_unpin_deferred) {
+			INIT_WORK(&rm->m_unpin_work, rds_message_unpin_worker);
+			queue_work(rds_wq, &rm->m_unpin_work);
+			return;
+		}
+
 		kfree(rm);
 	}
 }
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 34d9333e4229f..37695056756be 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -483,22 +483,36 @@ void rds_rdma_unuse(struct rds_sock *rs, u32 r_key, int force)
 		kref_put(&mr->r_kref, __rds_put_mr_final);
 }
 
-void rds_rdma_free_op(struct rm_rdma_op *ro)
+void rds_rdma_op_unpin_pages(struct rm_rdma_op *ro)
 {
 	unsigned int i;
 
+	for (i = 0; i < ro->op_nents; i++) {
+		struct page *page = sg_page(&ro->op_sg[i]);
+
+		/* Mark page dirty if it was possibly modified, which
+		 * is the case for a RDMA_READ which copies from remote
+		 * to local memory
+		 */
+		unpin_user_pages_dirty_lock(&page, 1, !ro->op_write);
+	}
+}
+
+void rds_rdma_free_op(struct rm_rdma_op *ro)
+{
 	if (ro->op_odp_mr) {
 		kref_put(&ro->op_odp_mr->r_kref, __rds_put_mr_final);
+	} else if (in_task() || ro->op_write) {
+		/* An RDMA write's pages are only read by the remote
+		 * side; unpinning without dirtying does not sleep.
+		 */
+		rds_rdma_op_unpin_pages(ro);
 	} else {
-		for (i = 0; i < ro->op_nents; i++) {
-			struct page *page = sg_page(&ro->op_sg[i]);
-
-			/* Mark page dirty if it was possibly modified, which
-			 * is the case for a RDMA_READ which copies from remote
-			 * to local memory
-			 */
-			unpin_user_pages_dirty_lock(&page, 1, !ro->op_write);
-		}
+		/* Dirtying the pages on unpin can sleep; leave them
+		 * pinned and have rds_message_put() finish the unpin
+		 * from process context.
+		 */
+		ro->op_unpin_deferred = 1;
 	}
 
 	kfree(ro->op_notifier);
@@ -507,7 +521,7 @@ void rds_rdma_free_op(struct rm_rdma_op *ro)
 	ro->op_odp_mr = NULL;
 }
 
-void rds_atomic_free_op(struct rm_atomic_op *ao)
+void rds_atomic_op_unpin_page(struct rm_atomic_op *ao)
 {
 	struct page *page = sg_page(ao->op_sg);
 
@@ -515,6 +529,19 @@ void rds_atomic_free_op(struct rm_atomic_op *ao)
 	 * is the case for a RDMA_READ which copies from remote
 	 * to local memory */
 	unpin_user_pages_dirty_lock(&page, 1, true);
+}
+
+void rds_atomic_free_op(struct rm_atomic_op *ao)
+{
+	if (in_task()) {
+		rds_atomic_op_unpin_page(ao);
+	} else {
+		/* Dirtying the page on unpin can sleep; leave it
+		 * pinned and have rds_message_put() finish the unpin
+		 * from process context.
+		 */
+		ao->op_unpin_deferred = 1;
+	}
 
 	kfree(ao->op_notifier);
 	ao->op_notifier = NULL;
diff --git a/net/rds/rds.h b/net/rds/rds.h
index a029e5fcdea72..a4816da162930 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -424,6 +424,12 @@ struct rds_message {
 
 	void			*m_final_op;
 
+	/* Unpins the ops' user pages and frees the message from
+	 * process context when the final put happens in atomic
+	 * context: dirtying the pages on unpin can sleep.
+	 */
+	struct work_struct	m_unpin_work;
+
 	struct {
 		struct rm_atomic_op {
 			int			op_type;
@@ -447,6 +453,7 @@ struct rds_message {
 			unsigned int		op_mapped:1;
 			unsigned int		op_silent:1;
 			unsigned int		op_active:1;
+			unsigned int		op_unpin_deferred:1;
 			struct scatterlist	*op_sg;
 			struct rds_notifier	*op_notifier;
 
@@ -462,6 +469,7 @@ struct rds_message {
 			unsigned int		op_mapped:1;
 			unsigned int		op_silent:1;
 			unsigned int		op_active:1;
+			unsigned int		op_unpin_deferred:1;
 			unsigned int		op_bytes;
 			unsigned int		op_nents;
 			unsigned int		op_count;
@@ -938,6 +946,8 @@ int rds_cmsg_rdma_map(struct rds_sock *rs, struct rds_message *rm,
 			  struct cmsghdr *cmsg);
 void rds_rdma_free_op(struct rm_rdma_op *ro);
 void rds_atomic_free_op(struct rm_atomic_op *ao);
+void rds_rdma_op_unpin_pages(struct rm_rdma_op *ro);
+void rds_atomic_op_unpin_page(struct rm_atomic_op *ao);
 void rds_rdma_send_complete(struct rds_message *rm, int wc_status);
 void rds_atomic_send_complete(struct rds_message *rm, int wc_status);
 int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
-- 
2.53.0

