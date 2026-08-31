Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF28577E5B;
	Mon, 31 Aug 2026 13:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184154; cv=none; b=NwkUVChLWu9wX3dzgUaEZai6yBUNzPVhFlGN0N4fMxGnMD4DzZCndjRJDx7TV+kT5KldhFy9dOmskZutvnM7mbg9iM+oFF/UNJt59Bcjm5RK8rikSwnw5wxFLIILH81W+Lm3NhevTqQOJNjLRAy2CjgjbzXp2sYojoEOj0VRkX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184154; c=relaxed/simple;
	bh=VHn9YVvx5plf2ISco8KuFSi5jqGC2ERCfz959S5nUHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZoqsiyFVfU4zbGkVnFlolNnlhgUOF07YaUkch6qa21B0Zyb31XVKY0joBUKKWAcWa5rDDDKm2bx1P9vLr+cLidn0dA5kic3X3F5jyX1p+eWQr1KcOnbOqsydXAHjKPbcn+f2xYcdO6RliIDVgUighfQYO+4zuko2XhoE0viu5Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQtzcMCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQtzcMCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D301F00ACA;
	Mon, 31 Aug 2026 13:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184152;
	bh=s3tPMUy1E4mNNIXgwnKvp6pTDoiH5t/efg73Vm5728Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQtzcMCoV5e9IMvrKjC6EhsfsJEFBOvtYhS89EfxTFLD9TXDYXiMR9OCKb1Vx27SJ
	 0bfiyZbiqqDKsNOnXFWjrzqmpIxRfQHcyM8J72dmFF6vv4/gGcsGM1pYx8HBKVNxCh
	 iVevJFd94tQnFNOKz3t5Q6IpEWfWkmPSjjeCn2HQmlIVvwyUGAfVQqpPVxu0v3vay7
	 mrTSex0smrpQUAdxg2WZYDSzpHtLGa93Jk4c/rfuDk0lcAyUOEp+IrmIF4whG7sy8W
	 UyVwlQkUXNxRerb/1F24vAqQGAGFm3GiWHS0NMT56O9mpUiqohd3WLoFyvr2DjS0bP
	 R/2qhkrhd7ZDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net/rds: Don't sleep inside rds_ib_conn_path_shutdown
Date: Mon, 31 Aug 2026 09:29:10 -0400
Message-ID: <20260831133314.4125787-522-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 16f48efaeb6991193fb7775c577f06f5b20b0c90 ]

New rds rdma self tests exposed a hang when tearing down
the ib network configs.  This is caused by the shutdown worker
thread sleeping on the wait_event call, which blocks other work
items in the queue. Fix this by changing wait_event to
wait_event timeout, and looping until the wait check succeeds.

Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260518012443.2629206-2-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net/rds: Don't sleep inside
rds_ib_conn_path_shutdown`

**Local tree:** `v6.18.44` (Makefile: 6.18.44)
**Verdict target:** Should this commit be backported to **this** 6.18.y
tree?

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[net/rds]` `[Don't sleep / fix]` — prevent indefinite
sleeping in `rds_ib_conn_path_shutdown()` during IB connection teardown.

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Allison Henderson `<achender@kernel.org>` (author)
- **Link:** `https://patch.msgid.link/20260518012443.2629206-2-
  achender@kernel.org` (patch 2 of a series, per Message-ID)
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (netdev
  maintainer merge)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags
- Notable: no syzbot report; bug found by new RDS RDMA selftests

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** Hang when tearing down IB network configs during new RDS RDMA
  selftests
- **Symptom:** System/workqueue stalls during teardown (not a
  crash/oops)
- **Root cause (author):** Shutdown worker sleeps on `wait_event`,
  blocking other work items on the same queue
- **Fix approach:** Replace `wait_event` with `wait_event_timeout` in a
  loop; schedule send/recv tasklets on timeout to drive completion

### Step 1.4: Detect hidden bug fixes
**Record:** Yes — despite not using "fix" in the subject, this is a real
hang fix disguised as a sleep/workqueue interaction problem. The
infinite `wait_event` in a single-threaded workqueue context is a
classic teardown hang pattern.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory changes
**Record:**
- **Files:** `net/rds/ib_cm.c` only (+15 lines net, ~1 function added, 1
  function modified)
- **Functions:** new `rds_ib_conn_path_shutdown_check_wait()`, modified
  `rds_ib_conn_path_shutdown()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow change per hunk
**Record:**

**Hunk 1 — new helper `rds_ib_conn_path_shutdown_check_wait()`:**
- Before: N/A
- After: Encapsulates the shutdown-ready condition (recv ring empty, no
  signaled sends, FRWR segments released). Returns `0` when ready, non-
  zero otherwise.

**Hunk 2 — `rds_ib_conn_path_shutdown()`:**
- Before: After `rdma_disconnect()` and `rds_ib_flush_mrs()`, blocks
  forever on:
  ```c
  wait_event(rds_ib_ring_empty_wait, <all conditions true>);
  ```
- After: Loops with 1-second timeout; on timeout, explicitly schedules
  `i_send_tasklet` and `i_recv_tasklet` to make progress, then re-checks
  until conditions are met.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Deadlock/hang in teardown path (workqueue + async
  completion interaction)
- **Mechanism:**
  1. `rds_ib_conn_path_shutdown()` runs on `rds_wq` via
     `rds_shutdown_worker()` → `rds_conn_shutdown()`
  2. `rds_wq` is a **single-threaded** workqueue
     (`create_singlethread_workqueue("krdsd")` in `threads.c:259`)
  3. `wait_event()` puts that sole worker thread to sleep indefinitely
  4. Wait conditions require send/recv ring draining and FRWR cleanup,
     which depends on tasklet progress (`i_send_tasklet` /
     `i_recv_tasklet`, normally kicked from CQ handlers at
     `ib_cm.c:256,384`)
  5. Without explicit tasklet scheduling, the worker can sleep forever
     while also blocking all other `rds_wq` work — including other
     connection shutdowns during IB config teardown

### Step 2.4: Fix quality assessment
**Record:**
- Fix is minimal and logically sound: same wait conditions, but bounded
  sleep + explicit tasklet kicks
- Still calls `tasklet_kill()` after the loop, preserving original
  safety
- Low regression risk: does not change teardown ordering or destroy IB
  resources early
- Minor style note: helper returns `msecs_to_jiffies(1000)` when not
  ready, but only `== 0` is tested — harmless

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:**
- `wait_event(rds_ib_ring_empty_wait, ...)` introduced in
  `ec16227e14141` (Andy Grover, 2009) — RDS/IB transport
- Signaled-sends condition: `f046011cd73c3` (2010)
- `i_fastreg_inuse_count` wait: `3a2886cca703f` (Gerd Rausch, 2019) —
  "Keep track of and wait for FRWR segments in use upon shutdown"
- Buggy infinite wait has been present since at least 2019 in its
  current form; newly exposed under concurrent IB teardown/selftests

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: File history for related changes
**Record:**
- Recent `ib_cm.c` changes in this tree are unrelated (IPv6 NULL deref,
  setup unwind, ib_modify_qp removal)
- RDS selftest infrastructure added in `3ade6ce1255e6` (Aug 2024) — TCP-
  focused initially; new RDMA selftests triggered this hang
- No conflicting recent refactor of the shutdown path in 6.18.y

### Step 3.4: Author's other commits
**Record:**
- Allison Henderson is an active RDS maintainer (Oracle)
- Prior stability fix in this tree: `f1acf1ac84d2a` "net:rds: Fix
  possible deadlock in rds_message_put" (syzbot-reported deadlock, 2024)
- Same subsystem, same author pattern of fixing RDS teardown/concurrency
  bugs

### Step 3.5: Prerequisites / dependencies
**Record:**
- Message-ID indicates patch 2/2 of a series (likely selftests + this
  fix)
- **This fix is standalone** — it only modifies `ib_cm.c` shutdown
  logic; does not depend on selftest patches to be correct
- No structural/API prerequisites; applies cleanly to current 6.18.44
  code

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** **UNVERIFIED** — `b4 dig` requires a commit hash (commit not
in this tree); lore.kernel.org and patch.msgid.link blocked by Anubis
bot protection. Could not read thread discussion.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** — `b4 dig -w` not possible without commit
hash.

### Step 4.3: Bug report
**Record:** Bug found by new RDS RDMA selftests during IB network config
teardown. No external bugzilla/syzbot link. Selftests added separately
(`3ade6ce1255e6` and follow-ups in this tree).

### Step 4.4: Related patches / series
**Record:** Patch 2 of series per Message-ID (`...-2-achender@...`).
Patch 1 likely adds RDMA selftests that expose the hang. Fix itself is
independent.

### Step 4.5: Stable mailing list
**Record:** **UNVERIFIED** — could not search lore stable list due to
bot protection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `rds_ib_conn_path_shutdown()`,
`rds_ib_conn_path_shutdown_check_wait()` (new), callers unchanged.

### Step 5.2: Trace callers
**Record:**
- `rds_ib_conn_path_shutdown` registered as `conn_path_shutdown` in
  `ib.c:571`
- Called from `rds_conn_shutdown()` (`connection.c:401`)
- `rds_conn_shutdown()` called by `rds_shutdown_worker()`
  (`threads.c:249`)
- `rds_shutdown_worker` runs on `rds_wq` via `queue_work(rds_wq,
  &cp->cp_down_w)` (`connection.c:905`)
- Also reached via `rds_conn_path_destroy()` → `rds_conn_path_drop()` →
  `flush_work(&cp->cp_down_w)` (`connection.c:457-458`)
- Module exit: `rds_ib_exit()` → `rds_ib_destroy_nodev_conns()` →
  `rds_conn_destroy()` → shutdown path

### Step 5.3: Key callees
**Record:** `rdma_disconnect()`, `rds_ib_flush_mrs()`,
`wait_event`/`wait_event_timeout`, `tasklet_schedule()`,
`tasklet_kill()`, `rdma_destroy_qp()`, `ib_destroy_cq()`

### Step 5.4: Call chain / reachability
**Record:**
- Triggered during connection drop, module unload (`rds_ib_exit`), IB
  device removal, network namespace teardown
- Requires `CONFIG_RDS` + `CONFIG_RDS_RDMA` (tristate modules)
- Reachable from admin operations (rmmod, IB config changes) — not a
  random syscall path, but real production teardown scenarios (Oracle
  RAC clusters using RDS over IB)

### Step 5.5: Similar patterns
**Record:** Prior RDS hang/deadlock fixes in history (`f1acf1ac84d2a`,
`7b4b000951f09`, `9c79440e2c5e2`) confirm this subsystem has had stable-
worthy concurrency/teardown issues before.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **YES.** Current `net/rds/ib_cm.c:1086-1090` still has the
infinite `wait_event`. Fix is **not** present in v6.18.44.

### Step 6.2: Backport complications
**Record:** Clean apply expected — no recent refactor of this function
in 6.18.y. File structure matches the patch context exactly.

### Step 6.3: Related fixes already present?
**Record:** No equivalent timeout/tasklet-kick fix found. FRWR wait
logic from `3a2886cca703f` is present (the conditions being waited on).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `net/rds` — **IMPORTANT** for Oracle RAC / RDMA cluster
users; **PERIPHERAL** for general Linux users (optional
`CONFIG_RDS_RDMA` module).

### Step 7.2: Subsystem activity
**Record:** Actively maintained — recent fixes in 6.18.y (IPv6 NULL
deref, zerocopy pin failure, selftest infrastructure). Not a dead
subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_RDS_RDMA` enabled — primarily enterprise
cluster deployments (Oracle RAC). Not universal, but production-critical
for that population.

### Step 8.2: Trigger conditions
**Record:**
- IB connection teardown, especially multiple concurrent shutdowns (IB
  network config teardown)
- Module unload (`rds_ib_exit` / `rds_rdma_exit`)
- Not easily triggered by unprivileged users; admin/module operations
- Selftests reliably reproduce; production impact likely under similar
  admin teardown scenarios

### Step 8.3: Failure mode severity
**Record:** **Hang** — single-threaded `rds_wq` worker blocked
indefinitely; teardown never completes, `flush_work` may never return,
module unload stalls. **Severity: HIGH** for affected configs
(system/admin operation hangs); **LOW** for users without RDS/RDMA.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for RDS/IB users — prevents teardown/module-unload
  hangs
- **Risk:** LOW — ~15 lines, same wait conditions, well-understood
  tasklet kick pattern
- **Ratio:** Favorable for backport to 6.18.y

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real hang during connection/IB config teardown
- Buggy code confirmed present in v6.18.44
- Small, surgical, obviously correct fix
- Runs on single-threaded workqueue — blocking sleep is a known anti-
  pattern
- Same maintainer (Allison Henderson) has prior stable-worthy RDS
  deadlock fixes
- Module unload path (`rds_ib_exit` → `rds_conn_destroy` → shutdown) is
  affected
- Fix does not require companion selftest patches

**AGAINST backport:**
- `CONFIG_RDS_RDMA` is niche/optional
- No syzbot or widespread user reports — found by new selftests
- Underlying `wait_event` pattern existed since 2009 (may indicate rare
  production trigger)
- Lore review/stable nomination not verified

**UNRESOLVED:**
- Mailing list review discussion and any explicit stable nominations

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic is sound;
selftests found the bug |
| 2. Fixes a real bug? | **PASS** — teardown hang |
| 3. Important issue? | **PASS** — hang on admin teardown/module unload
(HIGH for RDS/IB users) |
| 4. Small and contained? | **PASS** — one file, ~15 lines |
| 5. No new features/APIs? | **PASS** — behavior fix only |
| 6. Can apply to local tree? | **PASS** — code present, clean apply
expected |

### Step 9.3: Exception categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Qualifies on merit as a hang fix.

### Step 9.4: Decision rationale

For **Linux 6.18.44**: the buggy `wait_event` in
`rds_ib_conn_path_shutdown()` is present, the fix is small and self-
contained, and it addresses a real hang during IB connection teardown on
the single-threaded `rds_wq` workqueue. While RDS over IB is not
universal, hangs during module unload or IB network reconfiguration are
exactly the kind of issues stable trees should fix — especially with a
low-risk, surgical patch from the subsystem maintainer.

---

## Verification

- **[Phase 1]** Parsed commit message: subject, tags, body; no
  Fixes:/Reported-by:/Cc: stable
- **[Phase 2]** Read diff and current `net/rds/ib_cm.c:1051-1092`;
  confirmed `wait_event` → timeout loop + tasklet schedule change
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame -L 1086,1090`
  → wait since 2009, FRWR conditions since 2019 (`3a2886cca703f`); `git
  log --oneline -20 -- net/rds/ib_cm.c`
- **[Phase 3]** `git show 3a2886cca703f` — FRWR shutdown wait
  introduction
- **[Phase 3]** `git show f1acf1ac84d2a` — prior RDS deadlock fix by
  same author
- **[Phase 4]** `b4 dig` — failed (commit not in tree, needs `-c
  COMMITISH`)
- **[Phase 4]** WebFetch/curl lore.kernel.org — blocked by Anubis;
  **UNVERIFIED** mailing list review
- **[Phase 5]** `grep rds_ib_conn_path_shutdown` — call chain through
  `connection.c`, `threads.c`, `ib.c`
- **[Phase 5]** Read `threads.c:257-263` — confirmed
  `create_singlethread_workqueue("krdsd")`
- **[Phase 5]** Read `connection.c:368-401, 905, 457-458` — shutdown
  worker path
- **[Phase 5]** Read `ib_cm.c:247-257, 375-385` — CQ handlers schedule
  tasklets
- **[Phase 5]** Read `ib_rdma.c:161-173, 524-537` — `rds_ib_flush_mrs()`
  and destroy path
- **[Phase 6]** `grep wait_event(rds_ib_ring_empty_wait` — buggy code at
  `ib_cm.c:1086` in this tree
- **[Phase 6]** `grep rds_ib_conn_path_shutdown_check_wait` — not
  present (fix not applied)
- **[Phase 7]** Read `net/rds/Kconfig` — CONFIG_RDS_RDMA is tristate,
  depends on INFINIBAND
- **[Phase 8]** Traced module exit: `ib.c:536-548` →
  `rds_ib_destroy_nodev_conns()` → `rds_conn_destroy()`

This commit should be backported to the local 6.18.y tree: it fixes a
confirmed teardown hang with a minimal, low-risk change that applies
cleanly to code already present in v6.18.44.

**YES**The background searches finished. They didn’t turn up the commit
itself in this tree (expected — the fix isn’t in v6.18.44 yet), but they
did add useful context:

- The `wait_event` shutdown logic traces back to the original RDS/IB
  transport (2009), with the FRWR wait conditions added in
  `3a2886cca703f` (2019).
- Allison Henderson has other RDS stability fixes here, including
  `f1acf1ac84d2a` (deadlock in `rds_message_put`).

That supports the earlier analysis: the hang is in long-standing
teardown code, and this is a small, maintainer-authored stability fix
worth backporting to 6.18.y.

**YES**

 net/rds/ib_cm.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index e50e01abb0799..d9b6c9d2f6791 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1043,6 +1043,19 @@ int rds_ib_conn_path_connect(struct rds_conn_path *cp)
 	return ret;
 }
 
+static unsigned long rds_ib_conn_path_shutdown_check_wait(struct rds_conn_path *cp)
+{
+	struct rds_connection *conn = cp->cp_conn;
+	struct rds_ib_connection *ic = conn->c_transport_data;
+
+	return (!ic->i_cm_id ||
+		(rds_ib_ring_empty(&ic->i_recv_ring) &&
+		 (atomic_read(&ic->i_signaled_sends) == 0) &&
+		 (atomic_read(&ic->i_fastreg_inuse_count)) == 0 &&
+		 (atomic_read(&ic->i_fastreg_wrs) == RDS_IB_DEFAULT_FR_WR))) ? 0
+		: msecs_to_jiffies(1000);
+}
+
 /*
  * This is so careful about only cleaning up resources that were built up
  * so that it can be called at any point during startup.  In fact it
@@ -1083,11 +1096,13 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 		 * sends to complete we're ensured that there will be no
 		 * more tx processing.
 		 */
-		wait_event(rds_ib_ring_empty_wait,
-			   rds_ib_ring_empty(&ic->i_recv_ring) &&
-			   (atomic_read(&ic->i_signaled_sends) == 0) &&
-			   (atomic_read(&ic->i_fastreg_inuse_count) == 0) &&
-			   (atomic_read(&ic->i_fastreg_wrs) == RDS_IB_DEFAULT_FR_WR));
+		while (!wait_event_timeout(rds_ib_ring_empty_wait,
+					   rds_ib_conn_path_shutdown_check_wait(cp) == 0,
+					   msecs_to_jiffies(1000))) {
+			tasklet_schedule(&ic->i_send_tasklet);
+			tasklet_schedule(&ic->i_recv_tasklet);
+		}
+
 		tasklet_kill(&ic->i_send_tasklet);
 		tasklet_kill(&ic->i_recv_tasklet);
 
-- 
2.53.0

