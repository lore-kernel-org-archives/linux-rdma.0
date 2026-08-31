Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070D44A0124;
	Mon, 31 Aug 2026 13:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183680; cv=none; b=ctp53Q+hvLk+YxpjKUxukhIMSWdFPkDanSj16Rud13wt0clgG96B9PoY7ZrPIUpy0Z6tzjEs1wCaVkyUcFwNBQVnV7dcSgD84dyYkTowzrCz52nSOzVUBEmWma5FMtThgTDtohycHvb/T0jTxqs52pPdJZeo9ChjmXBWCixJvwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183680; c=relaxed/simple;
	bh=TweDbUO6D6WDrjVFJqDI+Zwc0n2Ahu5sW6+eU7R8L4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gBogtTZBdCUFZOfHSY7Z8GjpJiaSqxbt7lNpMgu78twQc+oHaxYaSyfYjK/hZNq246x8RnxBn9Mv7B51GgZxMJ3rYwgHVy6ykgiivPWpualIwmvCdJgQzkgW7nB2wKnzZDCx4UBfsSg/usd9f7HsdVMxzsdLVFGinsIs+umSq8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y/TCkBZb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y/TCkBZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BD51F00A3D;
	Mon, 31 Aug 2026 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183676;
	bh=uWT3EYYqQS6pN+gsd++jUXHyRppgcYRYjDcFtshUMlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/TCkBZb7I1gZIVnwVVSAtE4M9usJDYtJXY33OvAXTS1wWrq7P2bCvUqgE2i8cRKg
	 wxzuB3fEHmyjdSGaqWaThX3LQCoA2mnOt8wsH3kNuuQ1DpD7yBnaPNAPArcFRossho
	 3Bl/DsAMZr3A9C01mu2c1RJVmOAlvpO6lbMTD/wbzXM3XIdw7mG6fPnRhHEd2XFhdQ
	 IzCss6Jj5brjN1LEnWqm/yYK1Vhh3tvVU4p95u7cv2tbLEgp9NyXQWh0XXcfcFz3Ug
	 bDdy8ugxZkQpXIIL0s72dH0Q8uAyb+Wmq+cjNbR2BMAFUn7nT5uwomSYLDg9y9Foof
	 YL7oeV//fNa/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Li RongQing <lirongqing@baidu.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] RDMA/mlx5: Fix state and counter desync on loopback enable failure
Date: Mon, 31 Aug 2026 09:24:26 -0400
Message-ID: <20260831133314.4125787-238-sashal@kernel.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 0d32eabccbe4b2f8d45be3192c5f3c76c8af703d ]

In mlx5_ib_enable_lb(), dev->lb.enabled was unconditionally set
to true even if mlx5_nic_vport_update_local_lb() failed.

Fix this by only setting dev->lb.enabled on success. On failure,
roll back the reference counters and return the error.

Link: https://patch.msgid.link/r/20260601095818.2227-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[RDMA/mlx5]` `[Fix]` — Correct state/counter
desynchronization when vport loopback enable fails in
`mlx5_ib_enable_lb()`.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Link:** `https://patch.msgid.link/r/20260601095818.2227-1-
  lirongqing@baidu.com`
- **Signed-off-by:** Li RongQing `<lirongqing@baidu.com>` (author)
- **Signed-off-by:** Jason Gunthorpe `<jgg@nvidia.com>` (RDMA
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org` tags
- Notable: Signed-off-by from Jason Gunthorpe (RDMA subsystem
  maintainer) is a strong quality signal

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug description:** In `mlx5_ib_enable_lb()`, `dev->lb.enabled` is
  set to `true` unconditionally after calling
  `mlx5_nic_vport_update_local_lb()`, even when that call fails.
- **Symptom/failure mode:** Software state (`enabled` flag and reference
  counters `user_td`/`qps`) becomes inconsistent with hardware state. SW
  believes loopback is enabled; HW is not.
- **Root cause:** Missing error check before setting `enabled`, and
  missing rollback of incremented counters on failure.
- **Version info:** None stated in commit message.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not hidden — explicitly labeled as a fix. This is a classic
error-path state-machine bug (logic/correctness), not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/infiniband/hw/mlx5/main.c` only (+11 / -0 net)
- **Function modified:** `mlx5_ib_enable_lb()`
- **Scope:** Single-file, surgical fix in one function

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**

**Hunk (enable path):**
- **Before:** Increment `user_td`/`qps`, call
  `mlx5_nic_vport_update_local_lb()`, always set `dev->lb.enabled =
  true`, unlock, return `err` (possibly non-zero).
- **After:** On `mlx5_nic_vport_update_local_lb()` failure, jump to
  `err_rollback`, decrement the counters that were just incremented,
  unlock, return error. Only set `enabled = true` on success.

**Affected path:** Error path inside loopback enable, triggered when
`user_td == 2` or `qps == 1`.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Bug category:** Logic/correctness fix — error-path state
  desynchronization (related to reference-counting semantics).
- **Mechanism:** On `mlx5_nic_vport_update_local_lb()` failure, counters
  remain inflated and `enabled` is wrongly `true`. Future calls skip re-
  enabling (`if (!dev->lb.enabled)` guard), and disable thresholds
  (`user_td == 1 && qps == 0`) may never be reached again. State
  corruption persists until driver reload.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Fix quality:** Obviously correct. Mirrors the existing pattern in
  `mlx5_ib_enable_lb_mp()` in the same file, which already checks errors
  from `mlx5_nic_vport_update_local_lb()` before updating state.
- **Regression risk:** Very low. Only affects the failure path; success
  path unchanged.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- Buggy logic introduced in `0042f9e458a560` (Mark Bloch, 2018-09-21):
  "RDMA/mlx5: Enable vport loopback when user context or QP mandate"
- `dev->lb.enabled = true` unconditionally after
  `mlx5_nic_vport_update_local_lb()` has been present since 2018
- Verified: `git merge-base --is-ancestor 0042f9e458a560 HEAD` → bug
  commit is in v6.18.44

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag present. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Related commit already in tree: `65e344925fa30` — "IB/mlx5: Fix
  transport-domain rollback and initialize lb mutex earlier"
  - Fixes TD leak when `mlx5_ib_enable_lb()` returns error from
    `mlx5_ib_alloc_transport_domain()`
  - Does **not** fix the internal state corruption inside
    `mlx5_ib_enable_lb()` itself
- This commit is standalone (not part of a numbered series)
- Complementary to `65e344925fa30`: that commit handles the caller; this
  one fixes the callee's state machine

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** No prior commits from Li RongQing in mlx5 in this tree.
Jason Gunthorpe (Signed-off-by) is a core RDMA maintainer.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. Applies cleanly to current
`mlx5_ib_enable_lb()` in v6.18.44. Fix is self-contained.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** UNVERIFIED — `b4 dig -c <commit>` not possible (commit not
yet in tree). Lore.kernel.org and patch.msgid.link blocked by bot
protection (Anubis). Could not retrieve review thread.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** UNVERIFIED via b4 dig -w. Commit message shows Jason
Gunthorpe Signed-off-by (maintainer acceptance).

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No `Reported-by:` or syzbot link. Bug identified through
code analysis (author's commit message). No external bug report
retrieved.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone 1-commit fix. Related but separate:
`65e344925fa30` already in v6.18.44.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** UNVERIFIED — lore.kernel.org inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `mlx5_ib_enable_lb()` (modified)

### Step 5.2: TRACE CALLERS
**Record:** Three call sites verified via grep:

1. **`mlx5_ib_alloc_transport_domain()`** (`main.c:1946`) — called
   during ucontext creation (`main.c:2144`). Userspace-triggered via
   `ibv_open_device()` / RDMA ucontext alloc. **High-impact path.**
2. **`create_raw_packet_qp_tir()`** (`qp.c:1554`) — raw packet QP with
   self-LB flags
3. **RSS raw QP TIR creation** (`qp.c:1875`)

On failure at sites 2/3, callers invoke destroy paths that call
`mlx5_ib_disable_lb()`, partially mitigating `qps` counter drift. Site 1
does **not** call `disable_lb` on failure (only deallocates TD per
`65e344925fa30`).

### Step 5.3: TRACE CALLEES
**Record:** `mlx5_nic_vport_update_local_lb()` (`vport.c:896`) can fail
with:
- `-ENOMEM` from `kvzalloc()`
- Error from `mlx5_cmd_exec_in()` (firmware/HW command failure)

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:**
- Userspace opens RDMA device → `mlx5_ib_alloc_ucontext()` →
  `mlx5_ib_alloc_transport_domain()` → `mlx5_ib_enable_lb(dev, true,
  false)`
- Reachable from unprivileged userspace on mlx5 RoCE devices with
  `disable_local_lb_uc` or `disable_local_lb_mc` capability
- On transient failure, `user_td` stuck at 2 and `enabled=true`
  permanently breaks loopback for all subsequent operations until module
  reload

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `mlx5_ib_enable_lb_mp()` in the same file
(`main.c:1849-1868`) already implements correct error handling — enable
HW, check error, only then update state; rollback on failure. The fix
brings `mlx5_ib_enable_lb()` in line with this established pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Local tree is **v6.18.44** (`git describe HEAD`).
Buggy code at `main.c:1897-1898`:

```1896:1899:drivers/infiniband/hw/mlx5/main.c
                if (!dev->lb.enabled) {
                        err = mlx5_nic_vport_update_local_lb(dev->mdev,
true);
                        dev->lb.enabled = true;
                }
```

Fix not yet applied (`git log -S "err_rollback"` returns nothing).

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Expected **clean apply**. No recent refactoring of this
function. Only `force_enable` early-return added in 2025
(`08aae7860450c8`); fix integrates cleanly around existing structure.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** `65e344925fa30` (TD rollback on `enable_lb` error) is
present. The internal state corruption inside `mlx5_ib_enable_lb()`
itself is **not** fixed by that commit and remains unfixed.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** RDMA/mlx5 (Mellanox/NVIDIA ConnectX InfiniBand/RoCE driver).
**IMPORTANT** — widely deployed in HPC, cloud, and enterprise RDMA
workloads. Not universal like mm/net core, but critical for mlx5 users.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Actively maintained — multiple mlx5 fixes in recent `main.c`
history (`65e344925fa30`, `d3ff718c0c715`, etc.).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users of mlx5 RoCE devices where `disable_local_lb_uc` or
`disable_local_lb_mc` firmware capabilities are set — devices requiring
explicit vport loopback enable for self-loopback QPs and transport
domains.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- **Trigger:** `mlx5_nic_vport_update_local_lb()` fails during ucontext
  open or QP creation (ENOMEM or firmware command error)
- **Likelihood:** Uncommon but realistic under memory pressure or
  transient HW/firmware issues
- **Userspace reachable:** Yes — ucontext allocation is a normal
  userspace operation

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:**
- **Failure mode:** Persistent driver state corruption — SW/HW loopback
  state mismatch, inflated counters prevent recovery
- **User impact:** Loopback traffic broken for device lifetime after one
  transient failure; RDMA apps using self-loopback may fail silently or
  behave incorrectly
- **Severity:** **MEDIUM-HIGH** — not a kernel crash or security issue,
  but persistent functional corruption on a common initialization path.
  Complements the already-backported TD leak fix.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Prevents permanent loopback state corruption on error
  paths; completes the error-handling story started by `65e344925fa30`
- **Risk:** Very low — ~11 lines, error-path only, matches existing
  `mlx5_ib_enable_lb_mp()` pattern
- **Ratio:** Favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real, long-standing bug (since 2018, commit `0042f9e458a560`)
- Buggy code confirmed present in v6.18.44
- Small, surgical, obviously correct fix
- Maintainer Signed-off-by (Jason Gunthorpe)
- Matches existing correct pattern in same file (`mlx5_ib_enable_lb_mp`)
- Userspace-reachable via ucontext allocation
- Persistent state corruption on transient failure
- Complements already-backported `65e344925fa30`
- No new APIs or features

**AGAINST backporting:**
- Only triggers on error paths (ENOMEM, firmware cmd failure) — not
  common
- No crash, security vulnerability, or data corruption reported
- No user bug reports or syzbot findings documented
- Severity is functional state corruption, not oops/panic

**UNRESOLVED:**
- Mailing list review discussion (lore blocked)
- Whether reviewers explicitly nominated for stable

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — logic is clear; maintainer
   SOB; mirrors existing code pattern. No explicit Tested-by.
2. Fixes a real bug that affects users? **PASS** — persistent SW/HW
   state desync on mlx5 RoCE loopback enable failure.
3. Important issue? **PASS (borderline)** — persistent driver state
   corruption on userspace-initiated path; functional breakage until
   reload, though not crash-level.
4. Small and contained? **PASS** — 1 file, ~11 lines, 1 function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy code present; clean
   apply expected.

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
**Record:** None apply directly (not device ID, quirk, DT, build, or
docs fix). Standard bug fix.

### Step 9.4: DECISION RATIONALE

This commit fixes a real error-path state machine bug in widely used
mlx5 RDMA driver code that has existed since 2018. When
`mlx5_nic_vport_update_local_lb()` fails during ucontext creation, the
driver permanently corrupts its loopback tracking state, preventing
recovery without reload. The fix is minimal, follows an established
pattern in the same file, and completes error handling partially
addressed by the already-backported `65e344925fa30`. While the trigger
is an uncommon error path and severity is functional rather than crash-
level, persistent state corruption on a userspace-initiated
initialization path meets stable backport criteria for mlx5 driver
correctness fixes.

---

## Verification

- **[Phase 1]** Parsed subject, tags; found Link and Jason Gunthorpe
  SOB; no Fixes/Reported-by/syzbot
- **[Phase 2]** Diff analysis: adds error check + `err_rollback` counter
  decrement in `mlx5_ib_enable_lb()`
- **[Phase 3]** `git blame`: buggy code from `0042f9e458a560`
  (2018-09-21); `git merge-base --is-ancestor` confirms in tree
- **[Phase 3]** `git show 65e344925fa30`: related TD rollback fix
  already in tree; does not fix internal `enable_lb` state
- **[Phase 3]** `git log -S "err_rollback"`: fix not yet in tree
- **[Phase 4]** UNVERIFIED: lore.kernel.org and patch.msgid.link
  blocked; `b4 dig` requires commit hash not in tree
- **[Phase 5]** `grep mlx5_ib_enable_lb`: 3 call sites in `main.c` and
  `qp.c`
- **[Phase 5]** Read `mlx5_nic_vport_update_local_lb()` at
  `vport.c:896-933`: returns `-ENOMEM` or cmd errors
- **[Phase 5]** Read `mlx5_ib_enable_lb_mp()` at `main.c:1849-1868`:
  correct error-handling pattern exists
- **[Phase 5]** Read ucontext alloc path `main.c:2144-2147`: `enable_lb`
  failure path does not call `disable_lb`
- **[Phase 6]** `git describe HEAD`: v6.18.44; buggy code at
  `main.c:1897-1898` confirmed
- **[Phase 6]** No conflicting fix found in tree
- **[Phase 8]** Failure mode: persistent loopback state corruption,
  severity MEDIUM-HIGH

**YES**The background searches finished:

- **Keyword search** (`counter desync`, `loopback enable failure`): no
  matches — this fix is **not yet in v6.18.44**.
- **Related commit search**: found `65e344925fa30` (TD rollback when
  `mlx5_ib_enable_lb()` fails), which is already in the tree but does
  not fix the internal state/counter desync inside `mlx5_ib_enable_lb()`
  itself.

That supports the earlier **YES** verdict: the bug is present here, and
this commit is still needed.

 drivers/infiniband/hw/mlx5/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 09709ae5bd471..09d76952372de 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1895,6 +1895,9 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	    dev->lb.qps == 1) {
 		if (!dev->lb.enabled) {
 			err = mlx5_nic_vport_update_local_lb(dev->mdev, true);
+			if (err)
+				goto err_rollback;
+
 			dev->lb.enabled = true;
 		}
 	}
@@ -1902,6 +1905,14 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	mutex_unlock(&dev->lb.mutex);
 
 	return err;
+
+err_rollback:
+	if (td)
+		dev->lb.user_td--;
+	if (qp)
+		dev->lb.qps--;
+	mutex_unlock(&dev->lb.mutex);
+	return err;
 }
 
 void mlx5_ib_disable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
-- 
2.53.0

