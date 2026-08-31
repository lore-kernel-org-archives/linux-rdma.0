Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB37545DA0;
	Mon, 31 Aug 2026 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183976; cv=none; b=BD0C7+/A81AW25yqVOfNAB/uIfce5UMAJ5cDTHzGR4kCCbH7QFvgOng0rSBhaiqBRXCO2sZ8pz1bG6GUAg/IfWg8FzkSoDRnDla40Dx9tktbu6m7JsAQLpfl3LWw44zRuqqJOecHu1LwsCBmdJAZETn50pyNyTxcFOwuuNXXNHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183976; c=relaxed/simple;
	bh=lwxZB4bWP3J4uIT+rsFK8BcHXCnZAEvMa1dJD+vpI7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hsBwcI3WFq/br4cyMjHCekohhKYNCuLQHG/ha82J++3nkw6KpqcTl/3Q5C+fLn5iLZwMm74aKptg2zxdMozB+c73TZAvaYoLAa+AkH9KssF/ECCqlNH45ssYkalWOpqgVOXlownQETNU1mCpoyA2yhJUIKjZukqqOc7dvL0sn8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ckOTl3Os; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ckOTl3Os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E161F00A3D;
	Mon, 31 Aug 2026 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183972;
	bh=ZS3lBWW7hHyb7tV1rLSgTQszmpq24OfCesfSwyDtlJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckOTl3Osn8KpM6AfLQm5QdwUSoMjYuM4GNtlacMqLsMl+PQairlAC+Mw9kNAhg9QV
	 3jV7eINM7yGokOMvzWp3IVO/QRQdXeh7ug2EtCLgbqeGR6LMgL1gkLarQ9yiy2cBF8
	 uwF/q3/0z09EoBXzWvqDIAdgVVDTLdI/+svbd6SDEf5sg6qw0a6qne99PyByWT+anw
	 y1u6RK0G9JN3QcaxA7QyT9Kp48d9q6bRq4m0z0lSrJqC9z5ypiQOI84lEhdjH+nkoh
	 JchJMUv7rTOV/NlFYfIQdITBtd2eNmeq5k9OV6G8XJyHZXIG7gIJsZlFdOJCxU85o2
	 a6gJtr3nNiCPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	saeedm@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net/mlx5: HWS, Check if device is down while polling for completion
Date: Mon, 31 Aug 2026 09:27:21 -0400
Message-ID: <20260831133314.4125787-413-sashal@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit e3ec1570895bcf81f443e8ac60059edc61dbfca3 ]

In case the device is down for any reason (e.g. FLR),
the HW will no longer generate completions - no point
polling and waiting for timeout.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260507173443.320465-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net/mlx5: HWS, Check if device is down
while polling for completion`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`, detached from `stable/linux-6.18.y`)

**Commit under review:** `e3ec1570895bc` (on `net-next`; **not yet** in
this 6.18.43 checkout)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[net/mlx5: HWS]` `[Check]` — Check if device is down while
polling for BWC completion queue.

### Step 1.2: Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Erez Shitrit `<erezsh@nvidia.com>`, Shay Drori
  `<shayd@nvidia.com>`
- **Acked-by:** — none
- **Link:**
  https://patch.msgid.link/20260507173443.320465-2-tariqt@nvidia.com
- **Cc: stable:** — none (not a negative signal)
- **Signed-off-by:** Yevgeny Kliteynik, Tariq Toukan, Jakub Kicinski
  (ignore pipeline SOBs)

Notable: NVIDIA internal review + netdev maintainer merge; no
syzbot/user bug report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** When mlx5 device enters error state (e.g. FLR), hardware
  stops generating completions, but BWC polling still waits for the full
  timeout.
- **Symptom:** Unnecessary polling delay (up to
  `MLX5HWS_BWC_POLLING_TIMEOUT` = 60 seconds per call); during
  rehash/resize/shrink this can chain into multiple timeouts.
- **Root cause:** `mlx5hws_bwc_queue_poll()` enters a polling loop
  without checking `ctx->mdev->state`.
- **Fix approach:** Early-exit with `-ETIMEDOUT` when
  `MLX5_DEVICE_STATE_INTERNAL_ERROR`, reusing existing BWC timeout
  handling to abort rehash/resize/shrink loops.

### Step 1.4: Hidden bug fix?
**Record:** Yes — subject says "Check" rather than "fix", but this is a
real hang/latency bug during device failure recovery, not cosmetic
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:**
  `drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c` (+12
  lines, 0 removed)
- **Function modified:** `mlx5hws_bwc_queue_poll()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk (before):** After early-return when no completions expected,
  function enters polling loop calling `mlx5hws_send_queue_poll()` until
  completions arrive or 60s timeout.
- **Hunk (after):** Before entering the loop, checks `ctx->mdev->state
  == MLX5_DEVICE_STATE_INTERNAL_ERROR`; if set, logs
  `mlx5_core_warn_once()` and returns `-ETIMEDOUT` immediately.
- **Path affected:** All BWC synchronous completion polling (rule
  create/destroy, rehash move loops).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness — missing device-error fast-path in
  polling loop.
- **Mechanism:** On FLR/fatal error, `mlx5_enter_error_state()` sets
  `MLX5_DEVICE_STATE_INTERNAL_ERROR`. `mlx5hws_send_queue_poll()`
  returns 0 when no CQEs are available (`hws_send_engine_poll_cq()`
  returns early at `!cqe` without surfacing device-down). BWC layer then
  busy-waits until `time_after(jiffies, timeout)` — up to 60 seconds per
  `mlx5hws_bwc_queue_poll()` call.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — mirrors existing mlx5 pattern (`send.c`
  `mlx5hws_cq_poll_one()`, `dr_send.c` FLR skip).
- **Minimal:** 12 lines, no unrelated changes.
- **Regression risk:** Low — only triggers in `INTERNAL_ERROR` state;
  `-ETIMEDOUT` is already handled by all callers (rehash abort at lines
  116–120, 139–143 in `bwc.c`; rule insertion at 1072–1081).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `mlx5hws_bwc_queue_poll()` introduced in `5d324e5159d9e`
(Merge tag `usb-6.18-rc8`, 2025-11-28) — first appearance in this tree
at **6.18**. Bug present since HWS BWC introduction.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- `bwc.c` history in this tree: `5d324e5159d9e` (introduction),
  `1dce4f4bb3c1c` (matcher leak fix).
- Part of 3-patch series (`[PATCH 0/3] net/mlx5: Steering misc
  enhancements`); **this patch is standalone** — only touches `bwc.c`;
  patches 2/3 are unrelated (`table.c`, `dr_types.h`).

### Step 3.4: Author context
**Record:** Yevgeny Kliteynik (NVIDIA mlx5 steering). Tariq Toukan
signed off; Jakub Kicinski merged. No prior author commits in this
tree's HWS path (new subsystem in 6.18).

### Step 3.5: Dependencies
**Record:** No prerequisites. `ctx->mdev` exists in `struct
mlx5hws_context` (`context.h:38`). `MLX5_DEVICE_STATE_INTERNAL_ERROR`
used throughout mlx5 core. Patch applies cleanly (`git apply --check`
passed).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c e3ec1570895bc` →
  https://patch.msgid.link/20260507173443.320465-2-tariqt@nvidia.com
- Series: `[PATCH net-next 1/3]` — single revision found; committed
  version matches submission.
- Cover letter describes series as "steering enhancements / cleanups" —
  patch 1 is clearly a bug fix.
- No explicit stable nomination found in available thread metadata.

### Step 4.2: Reviewers
**Record:** `b4 dig -c e3ec1570895bc -w` — CC'd: Jakub Kicinski, Saeed
Mahameed, Leon Romanovsky, netdev@, linux-rdma@, Simon Horman, and other
mlx5 maintainers/reviewers. Appropriate subsystem coverage.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug identified by
driver authors during development/review of error-path behavior.

### Step 4.4: Series context
**Record:** Patches 2/3 fix a miss-table list UAF and remove an unused
DR field — **not required** for this fix.

### Step 4.5: Stable list history
**Record:** Lore stable search blocked by Anubis bot protection — could
not verify stable-list discussion. Not relied upon for decision.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `mlx5hws_bwc_queue_poll()` (modified); callers unchanged.

### Step 5.2: Callers
**Record:** `mlx5hws_bwc_queue_poll()` called from:
- `bwc.c`: rehash move loops (lines 111, 134),
  `hws_bwc_rule_destroy_hws_sync()` (541), `hws_bwc_rule_create_sync()`
  (703), `hws_bwc_rule_update_sync()` (725)
- `bwc_complex.c`: complex matcher rehash (1031)

All paths are flow-steering operations under mutex protection.

### Step 5.3: Callees
**Record:** Calls `mlx5hws_send_engine_full()`,
`mlx5hws_send_queue_poll()`, uses `mlx5_core_warn_once()`.

### Step 5.4: Reachability
**Record:**
- HWS integrated into mlx5 flow steering via `fs_hws.c` (e.g.
  `mlx5_cmd_hws_create_flow_group()` → `mlx5hws_bwc_matcher_create()`).
- Reachable from kernel flow-offload paths (tc, OVS, etc.) on mlx5 NICs
  with HWS support.
- Device error (FLR, fatal sensors) can occur concurrently with in-
  flight flow operations → this path is realistically triggerable.

### Step 5.5: Similar patterns
**Record:** Existing device-down checks:
- `send.c:581-585` — `mlx5hws_cq_poll_one()` checks `INTERNAL_ERROR`
  when no CQE
- `dr_send.c:632-637` — SWS steering skips post-send on `INTERNAL_ERROR`
- BWC layer lacked equivalent fast-path at its own timeout loop

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **Yes.** `mlx5hws_bwc_queue_poll()` at `bwc.c:407-457` lacks
device-down check. HWS BWC code present since 6.18 merge
(`5d324e5159d9e`). Fix commit `e3ec1570895bc` is on `net-next` but
**not** in 6.18.43.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git show e3ec1570895bc -- bwc.c | git
apply --check` succeeded with no conflicts.

### Step 6.3: Related fixes already present?
**Record:** No — `git log --grep="device is down"` and `--grep="BWC
poll"` in mlx5 steering returned no matches in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/ethernet/mellanox/mlx5` — **IMPORTANT** (mlx5
NIC flow steering; not core-kernel-wide, but widely deployed in
cloud/HPC/enterprise).

### Step 7.2: Subsystem activity
**Record:** HWS steering is **new and actively developed** in 6.18
(introduced Nov 2025; multiple follow-up fixes already in 6.18.y: leak
fix, unsupported action rejection).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** mlx5 users with HWS flow steering (BWC API) — cloud/SDN
deployments using tc flow offload on ConnectX devices. Config-dependent
on HWS-capable hardware and flow-steering usage.

### Step 8.2: Trigger conditions
**Record:** Device enters `MLX5_DEVICE_STATE_INTERNAL_ERROR` (FLR, fatal
error, health failure) while BWC operations have pending HW completions.
Timing-dependent but realistic during error recovery. Triggerable
indirectly via admin actions (FLR, PCI reset) concurrent with flow
operations.

### Step 8.3: Failure severity
**Record:** **HIGH** — up to 60-second hang per poll call in kernel
context, potentially while holding BWC queue mutex; during rehash can
chain multiple timeouts ("chain of timeouts" per commit comment). Not a
crash/UAF, but a serious latency/hung-task issue during error recovery.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected mlx5 HWS users — immediate abort
  instead of 60s+ waits during device failure.
- **Risk:** VERY LOW — 12-line early return on error state only; reuses
  established `-ETIMEDOUT` handling.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug in code present since 6.18
- Causes up to 60s hangs per poll during device error (FLR)
- Mutex-held paths make hang user-visible
- Small, reviewed, obviously correct fix
- Applies cleanly to 6.18.43
- Standalone (no series dependencies)
- Follows existing mlx5 device-down patterns
- Callers already handle `-ETIMEDOUT` correctly

**AGAINST backport:**
- Driver-specific, not universal
- No user/syzbot report (author-found)
- HWS is new subsystem (limited exposure window, but code is in 6.18.y)

**Unresolved:** Lore stable-list discussion (blocked by Anubis).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reviewed by NVIDIA
   engineers, merged by netdev maintainer; logic is straightforward.
2. Fixes a real bug? **PASS** — 60s timeout spin on dead device during
   flow operations.
3. Important issue? **PASS** — HIGH severity hang during error recovery.
4. Small and contained? **PASS** — 12 lines, one function, one file.
5. No new features/APIs? **PASS** — error-path behavior fix only.
6. Can apply to local tree? **PASS** — clean apply verified.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs fix —
standard driver bug fix).

### Step 9.4: Decision rationale

For **this** tree (6.18.43), the HWS BWC polling code exists and has had
the missing device-down check since its introduction. During FLR or
fatal device error, users with mlx5 flow steering can hit multi-second
to multi-minute hangs. The fix is minimal, follows existing mlx5
conventions, applies cleanly, and reuses established error handling.
This meets stable kernel criteria.

---

## Verification

- **[Phase 1]** Parsed commit message from user query and `git show
  e3ec1570895bc`
- **[Phase 1]** Tags: Reviewed-by (2), Link, Signed-off-by; no
  Fixes/Reported-by/Cc:stable
- **[Phase 2]** Diff: +12 lines in `mlx5hws_bwc_queue_poll()`, `bwc.c`
  only
- **[Phase 2]** `MLX5HWS_BWC_POLLING_TIMEOUT` = 60 in `bwc.h:19`
- **[Phase 3]** `git blame -L 407,456 bwc.c`: function introduced in
  `5d324e5159d9e` (6.18)
- **[Phase 3]** `git log --oneline -- bwc.c`: 2 commits in tree (intro +
  leak fix)
- **[Phase 3]** `b4 am` cover letter: 3-patch series, patch 1 standalone
- **[Phase 3]** `git apply --check` on commit diff: **clean apply**
- **[Phase 4]** `b4 dig -c e3ec1570895bc`: lore URL found
- **[Phase 4]** `b4 dig -c e3ec1570895bc -w`: maintainers CC'd
  (Kicinski, Saeed, Leon, netdev@)
- **[Phase 4]** `b4 am` mbox: patch content matches committed version
- **[Phase 4]** Lore stable search: **blocked** (Anubis)
- **[Phase 5]** `grep mlx5hws_bwc_queue_poll`: 6 call sites in `bwc.c`,
  `bwc_complex.c`
- **[Phase 5]** `fs_hws.c`: BWC used for flow group/rule operations
- **[Phase 5]** `send.c:610-612`: `hws_send_engine_poll_cq` returns on
  `!cqe` without device check
- **[Phase 5]** `send.c:581-585`: device-down check exists in
  `mlx5hws_cq_poll_one` (different path)
- **[Phase 5]** `health.c:215`: `MLX5_DEVICE_STATE_INTERNAL_ERROR` set
  on fatal error
- **[Phase 6]** `git describe HEAD`: v6.18.43
- **[Phase 6]** Buggy code confirmed at `bwc.c:407-457` without fix
- **[Phase 6]** `git log net-next --grep=...`: commit `e3ec1570895bc` on
  net-next, not in 6.18.43
- **[Phase 6]** `context.h:38`: `struct mlx5hws_context { struct
  mlx5_core_dev *mdev; ...}`
- **[Phase 8]** ETIMEDOUT handling verified at `bwc.c:116-120`,
  `139-143`, `1072-1081`
- **[Phase 8]** Mutex context verified: `mutex_lock(queue_lock)` before
  rule create paths

**YES**

 .../ethernet/mellanox/mlx5/core/steering/hws/bwc.c   | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
index 564ae98316bc9..756b87a3d68dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
@@ -423,6 +423,18 @@ int mlx5hws_bwc_queue_poll(struct mlx5hws_context *ctx,
 	if (!got_comp && !drain)
 		return 0;
 
+	if (unlikely(ctx->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)) {
+		/* If the device is down for any reason (e.g. FLR), the HW will
+		 * no longer generate completions.
+		 * Note that ETIMEDOUT is returned here because the BWC layer
+		 * already has a special handling for timeouts - it breaks the
+		 * rehash / resize / shrink loops to avoid chain of timeouts.
+		 */
+		mlx5_core_warn_once(ctx->mdev,
+				    "BWC poll: device is down, polling for completion aborted\n");
+		return -ETIMEDOUT;
+	}
+
 	queue_full = mlx5hws_send_engine_full(&ctx->send_queue[queue_id]);
 	while (queue_full || ((got_comp || drain) && *pending_rules)) {
 		ret = mlx5hws_send_queue_poll(ctx, queue_id, comp, burst_th);
-- 
2.53.0

