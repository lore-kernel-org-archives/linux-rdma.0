Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EE9499F2B;
	Mon, 31 Aug 2026 13:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183530; cv=none; b=rxZAQrLxwz5dfTF6mXbtsOsUb3KpzZmmm9xiHfRqaYMtRPhEZfB4sUlu05IyCBuKawM1ZrZTsLeID8LXqoUt0tzQSLC3N5lPzcxZa3mxN7lYFrjyrWKex422Ze+A+uWCkYeJeJf5aPv7EXTMZaKTiMMsS3cOG++yNJ0IX2JfiWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183530; c=relaxed/simple;
	bh=jTx1zry5rzdixxC0RgC2msoPn8d7KKD2kbIkXCNjnU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IiJB09zmr56Ks9TOYyI9EKPZU0T54dmie+g5VM2VX6yL1aN3C1R9RtYM64dUZwjvXOtubnUUkjfYScijdn9M95wwQjQt4AmTaZbhwexVJ8Tr7rBARG8dZidvcZACFjM4eJenJ+Wq22hDHZHKPOJxZVxS2gGaVZoN31xWUDeHfV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrZfyaSQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrZfyaSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8942E1F00ADE;
	Mon, 31 Aug 2026 13:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183528;
	bh=IXXvlLiatEpQKDiVZfBexoB5OaI/sRGWE1Z6th1AgUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrZfyaSQMpKJcyP1q0MRb7Xo5lylWUf4H0/gyaSMfUtIp/AgxyYRnJ0JhQy9u93+y
	 lv3bxGJHtYDoRGsRsq6I8oSmtVwuny24HV/jHkRX6MSEH4IlZ9KgTchkupB/KQ97DI
	 reFuQjFEwLNiwGgEc19Otj/xkF1ZEIW0vu4ZAHoNpms58tXoa6jaiR5vbZL0MZ4fjQ
	 GmIIgNdmkqWZ7g13PUfsMyAlI2+UUggY8weYjSOeUMsifjv4q9aDb7B7WthkxS2n4q
	 telKzQDUeKMtSS7JKwYua1Ptbi6GnH3jpjbIR/kPPjXJiAFEGbpMkQ9zgd2XSaV2s9
	 MeMzL1/+SSP5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	saeedm@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] net/mlx5: E-Switch, align disable sequence with switchdev-to-legacy transition
Date: Mon, 31 Aug 2026 09:22:58 -0400
Message-ID: <20260831133314.4125787-150-sashal@kernel.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit b48b6308dfaeae49fcda61b4066773cb5e8a9ce8 ]

This patch align the eswitch disable sequence with the
switchdev-to-legacy mode transition, where eswitch must be disabled
before device detachment. The consistent ordering is required for proper
SD LAG cleanup which depends on eswitch state during teardown.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260531113954.395443-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net/mlx5: E-Switch, align disable sequence
with switchdev-to-legacy transition`

**Local tree:** Linux **6.18.44** (`v6.18.44`, `VERSION=6 PATCHLEVEL=18
SUBLEVEL=44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[net/mlx5: E-Switch] [align] — reorder eswitch disable to
match switchdev-to-legacy teardown ordering`

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Shay Drory `<shayd@nvidia.com>` (author)
- **Reviewed-by:** Mark Bloch `<mbloch@nvidia.com>`
- **Signed-off-by:** Tariq Toukan `<tariqt@nvidia.com>`
- **Link:**
  https://patch.msgid.link/20260531113954.395443-3-tariqt@nvidia.com
  (patch **3/3** in a series)
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (net maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or syzbot
  tags
- Message-ID suffix `-3-` indicates this is the third patch in a series

### Step 1.3: Body analysis
**Record:**
- **Bug:** E-switch disable runs too late in driver unload paths — after
  `mlx5_detach_device()` / `mlx5_unregister_device()` — while the
  switchdev-to-legacy transition disables eswitch **before** detachment.
- **Symptom/failure mode:** Improper **SD LAG** (Socket Direct / shared-
  FDB LAG) cleanup during teardown; commit does not include a crash
  trace.
- **Root cause (author):** SD LAG cleanup in `mlx5_eswitch_disable()`
  depends on eswitch still being in the correct state and representors
  still being present; detaching/unregistering auxiliary devices first
  breaks that.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Described as “align,” but it fixes a **teardown
ordering bug** — same class as other mlx5 LAG/eswitch unload issues.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/ethernet/mellanox/mlx5/core/main.c` only
- **Scope:** ~3 lines moved (net zero lines); 3 functions touched
- **Functions modified:** `mlx5_unload()`, `mlx5_uninit_one()`,
  `mlx5_unload_one_devl_locked()`
- **Classification:** Single-file, surgical reordering

### Step 2.2: Code flow per hunk

**Hunk 1 — `mlx5_unload()`:**
- **Before:** `mlx5_eswitch_disable()` was the first call in
  `mlx5_unload()`.
- **After:** Removed from `mlx5_unload()`.

**Hunk 2 — `mlx5_uninit_one()`:**
- **Before:** `mlx5_unregister_device()` → … → `mlx5_unload()` (which
  disabled eswitch).
- **After:** `mlx5_eswitch_disable()` → `mlx5_unregister_device()` → … →
  `mlx5_unload()`.

**Hunk 3 — `mlx5_unload_one_devl_locked()`:**
- **Before:** `mlx5_detach_device()` → … → `mlx5_unload()` (which
  disabled eswitch).
- **After:** `mlx5_eswitch_disable()` → `mlx5_detach_device()` → … →
  `mlx5_unload()`.

**Record:** Both primary unload paths now disable eswitch **before**
tearing down auxiliary devices.

### Step 2.3: Bug mechanism
**Record:** **Teardown ordering / logic correctness bug**
- `mlx5_eswitch_disable()` calls `mlx5_lag_disable_change()` →
  `mlx5_disable_lag()`.
- For shared-FDB LAG (`MLX5_LAG_MODE_FLAG_SHARED_FDB`),
  `mlx5_disable_lag()` calls `mlx5_eswitch_reload_ib_reps()`, which
  requires `esw->mode == MLX5_ESWITCH_OFFLOADS` and `REP_LOADED`
  representors.
- `mlx5_detach_device()` / `mlx5_unregister_device()` remove auxiliary
  devices (including eswitch representors) **before** `mlx5_unload()`
  ran, so SD LAG cleanup could not run correctly.
- `mlx5_devlink_eswitch_mode_set()` already disables eswitch **before**
  mode transition — the unload paths were inconsistent.

### Step 2.4: Fix quality
**Record:**
- Fix is minimal and mirrors the known-good
  `mlx5_devlink_eswitch_mode_set()` ordering.
- `mlx5_eswitch_disable()` requires devlink lock; both call sites
  already hold `devl_lock()`.
- **Regression risk:** Low for main unload paths. **Note:**
  `mlx5_unload()` is still called from init error paths (`err_register`,
  `err_attach`) without the new early `mlx5_eswitch_disable()` — those
  paths typically run before switchdev/SD LAG is configured (unverified
  for all edge cases).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `mlx5_eswitch_disable()` in `mlx5_unload()`: added/moved to first
  position by **85b47dc40bbc7** (Sep 2023, Jiri Pirko).
- `mlx5_detach_device()` before `mlx5_unload()` in
  `mlx5_unload_one_devl_locked()`: **72ed5d5624af3** (Jan 2023).
- `mlx5_unregister_device()` before `mlx5_unload()` in
  `mlx5_uninit_one()`: longstanding (Leon Romanovsky, 2020).
- Original `mlx5_eswitch_disable` in unload: **f019679ea5f2a** (May
  2022).
- **Ordering mismatch has existed since ~2023** when detach was placed
  before `mlx5_unload()` while eswitch disable remained inside
  `mlx5_unload()`.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- Shared-FDB LAG introduced **af8c0e25f249a** (Aug 2021) — present in
  this tree.
- Related crash fix **4b8eeed4fb105** (Mar 2025): bridge + shared-FDB
  LAG teardown oops — same subsystem, similar LAG teardown sensitivity.
- Patch appears standalone (only `main.c`); patches 1–2 of the series
  were not found locally.

### Step 3.4: Author context
**Record:** Shay Drory is an active mlx5 contributor (eswitch, LAG,
devlink). Reviewed by Mark Bloch (mlx5 maintainer). Committed via Jakub
Kicinski (netdev).

### Step 3.5: Dependencies
**Record:** Self-contained for `main.c`. No structural/API prerequisites
identified. Patches 1–2 of the series were **not found** in this
workspace; this patch does not appear to depend on them functionally.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c HEAD` did not match (commit not in tree). Lore
search returned **403 Forbidden**. patch.msgid.link blocked by bot
protection. **Could not retrieve mailing list thread.**

### Step 4.2: Reviewers
**Record:** Mark Bloch (Reviewed-by). Jakub Kicinski merged. Full
recipient list unavailable (b4 `-w` requires commit in tree).

### Step 4.3: Bug report
**Record:** No external bug report, syzbot link, or crash trace in the
commit message.

### Step 4.4: Series context
**Record:** Message-ID indicates patch **3/3**; patches 1–2 not
identified locally. This change is independently applicable.

### Step 4.5: Stable list history
**Record:** Not searched (lore inaccessible). No stable nomination found
in commit message.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `mlx5_eswitch_disable()`, `mlx5_unload()`,
`mlx5_uninit_one()`, `mlx5_unload_one_devl_locked()`,
`mlx5_detach_device()`, `mlx5_unregister_device()`,
`mlx5_disable_lag()`, `mlx5_eswitch_reload_ib_reps()`

### Step 5.2: Callers of affected paths
**Record:**
- `mlx5_uninit_one()` ← `remove_one()` (module/PCI remove), SF driver
  teardown
- `mlx5_unload_one_devl_locked()` ← `mlx5_unload_one()` ← devlink
  reload, firmware reset, health recovery, suspend/resume
- Both are common operational paths for mlx5 users

### Step 5.3: Callees
**Record:** `mlx5_eswitch_disable()` → `mlx5_lag_disable_change()` →
`mlx5_disable_lag()` → (shared FDB) `mlx5_eswitch_reload_ib_reps()`;
`mlx5_detach_device()` tears down auxiliary drivers in reverse order

### Step 5.4: Reachability
**Record:** Triggered on driver remove, devlink reload, FW reset
recovery — admin-initiated but routine in datacenter deployments.
Requires **CONFIG_MLX5_ESWITCH**, switchdev mode, and multi-PF Socket
Direct / shared-FDB LAG.

### Step 5.5: Similar patterns
**Record:** `mlx5_devlink_eswitch_mode_set()` disables eswitch before
cleanup (lines 3832–3866 in `eswitch_offloads.c`). Bridge+LAG crash fix
**4b8eeed4fb105** shows mlx5 shared-FDB LAG teardown ordering can cause
kernel oops.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree has:
- `mlx5_eswitch_disable()` at line 1430 inside `mlx5_unload()`
- `mlx5_detach_device()` at line 1623 **before** `mlx5_unload()` at line
  1632
- `mlx5_unregister_device()` at line 1539 **before** `mlx5_unload()` at
  line 1550

### Step 6.2: Backport complications
**Record:** Expected **clean apply** with minor context adjustment (line
ordering in `mlx5_unload()` differs slightly from the provided diff —
`mlx5_vhca_event_stop` position — but the semantic change is identical).

### Step 6.3: Related fixes already present?
**Record:** **4b8eeed4fb105** (bridge LAG crash) is in tree. This
specific eswitch-disable ordering fix is **not** present.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/ethernet/mellanox/mlx5` — **IMPORTANT**
(datacenter NIC driver, widely deployed on stable/LTS kernels)

### Step 7.2: Subsystem activity
**Record:** Actively maintained; frequent mlx5 commits in 6.18.y.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of **Mellanox ConnectX multi-PF Socket Direct**
configurations with **shared-FDB LAG** in **switchdev** mode —
datacenter/cloud NIC deployments. Not universal; config-specific.

### Step 8.2: Trigger conditions
**Record:** Driver unload, devlink reload, FW-reset recovery, or suspend
on configured SD LAG + switchdev. Admin-initiated but routine.
Unprivileged users cannot directly trigger.

### Step 8.3: Failure mode severity
**Record:** Improper LAG/eswitch teardown;
`mlx5_eswitch_reload_ib_reps()` silently skipped when reps already
detached. Can leave inconsistent LAG state; related mlx5 LAG teardown
bugs have caused **kernel oops** (4b8eeed4fb105). **Severity: MEDIUM-
HIGH** for affected configs; **LOW** for typical single-PF users.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM for affected enterprise users; prevents broken SD
  LAG teardown on common unload paths
- **Risk:** LOW — 3-line reorder, mirrors existing mode-set path,
  reviewed by subsystem maintainer
- **Ratio:** Favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Verified ordering bug: detach/unregister before eswitch disable in
  both main unload paths
- SD LAG cleanup (`mlx5_disable_lag` → `mlx5_eswitch_reload_ib_reps`)
  requires eswitch/rep state that detach destroys
- Matches proven-correct `mlx5_devlink_eswitch_mode_set()` ordering
- Small, surgical, low regression risk
- Bug present since ~2023; shared-FDB LAG in tree since 2021
- Same subsystem had LAG teardown oops fixed for stable (4b8eeed4fb105)
- NVIDIA maintainer review

**AGAINST backport:**
- No crash trace, syzbot report, or user bug report in commit message
- Affects niche multi-PF Socket Direct + switchdev configuration
- Patch 3/3 — series context unavailable
- Init error paths (`err_register`/`err_attach`) still call
  `mlx5_unload()` without early eswitch disable (likely low impact —
  switchdev typically not configured at probe failure)

**Unresolved:**
- Full mailing list review thread (lore inaccessible)
- Patches 1–2 of the series not found
- No quantitative report of how often this causes visible failures

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — ordering matches mode-set
   path; Reviewed-by from mlx5 maintainer (no Tested-by)
2. Fixes a real bug? **PASS** — verifiable teardown ordering violation
3. Important issue? **PASS (MEDIUM)** — improper teardown on
   unload/reload for SD LAG; related bugs caused oopses, though this one
   lacks explicit crash report
4. Small and contained? **PASS** — single file, ~3 lines moved
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code exists; clean/minor-context
   apply expected

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build fix, or docs fix).
Standard bug-fix backport.

### Step 9.4: Decision rationale
For **Linux 6.18.44**, the buggy ordering is present and the fix is
minimal, obviously correct, and aligns unload paths with the already-
correct switchdev-to-legacy transition. While the affected configuration
(multi-PF Socket Direct + shared-FDB LAG + switchdev) is niche and the
commit lacks a crash report, the mechanism is verified in code, the
subsystem has a history of LAG teardown oopses, and the fix carries very
low risk. This meets stable criteria for an important driver teardown
correctness fix.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
- **[Phase 2]** Analyzed diff: 3 hunks in `main.c`, eswitch disable
  moved from `mlx5_unload` to `mlx5_uninit_one` and
  `mlx5_unload_one_devl_locked`
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `Makefile` → 6.18.44
- **[Phase 3]** `git blame` on lines 1428–1450, 1530–1558, 1618–1636 of
  `main.c` — ordering history confirmed
- **[Phase 3]** `git show 85b47dc40bbc7` — eswitch disable moved to
  first in `mlx5_unload` (2023)
- **[Phase 3]** `git show f019679ea5f2a` — original addition of eswitch
  disable to unload (2022)
- **[Phase 3]** `git show af8c0e25f249a` — shared-FDB LAG since Aug 2021
- **[Phase 3]** `git show 4b8eeed4fb105` — related bridge+LAG oops fix
  in tree
- **[Phase 4]** `b4 dig -c HEAD` — no match (commit not in tree)
- **[Phase 4]** Lore/patch.msgid.link fetch — blocked (403/bot
  protection); thread not retrieved
- **[Phase 4]** Workspace `.mbx` search for `align disable sequence` /
  `395443` — not found
- **[Phase 5]** Read `mlx5_eswitch_disable()` in `eswitch.c:1780–1790` —
  calls `mlx5_lag_disable_change`
- **[Phase 5]** Read `mlx5_disable_lag()` in `lag.c:900–937` — shared-
  FDB path calls `mlx5_eswitch_reload_ib_reps`
- **[Phase 5]** Read `mlx5_eswitch_reload_ib_reps()` in
  `eswitch_offloads.c:3346–3368` — requires OFFLOADS mode and REP_LOADED
- **[Phase 5]** Read `mlx5_detach_device()` in `dev.c:414–454` — removes
  auxiliary devices before unload
- **[Phase 5]** Read `mlx5_devlink_eswitch_mode_set()` in
  `eswitch_offloads.c:3807–3890` — disables eswitch before mode change
- **[Phase 5]** `grep mlx5_unload(` — callers: err_register,
  mlx5_uninit_one, err_attach, mlx5_unload_one_devl_locked
- **[Phase 6]** Read current `main.c:1428–1645` — buggy ordering
  confirmed in 6.18.44
- **[Phase 6]** `grep mlx5_eswitch_disable` — present in tree, not yet
  reordered
- **[Phase 8]** Confirmed SD = Socket Direct via `mlx5_get_sd()` usage
  in `eswitch_offloads.c:3826–3828`
- **UNVERIFIED:** Mailing list reviewer stable nominations; patches 1–2
  of series; explicit user crash reports for this specific bug

**YES**

 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 22bdefe5696c9..42bc553d034b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1427,7 +1427,6 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 static void mlx5_unload(struct mlx5_core_dev *dev)
 {
-	mlx5_eswitch_disable(dev->priv.eswitch);
 	mlx5_devlink_traps_unregister(priv_to_devlink(dev));
 	mlx5_sf_dev_table_destroy(dev);
 	mlx5_sriov_detach(dev);
@@ -1536,6 +1535,7 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 
 	mlx5_hwmon_dev_unregister(dev);
 	mlx5_crdump_disable(dev);
+	mlx5_eswitch_disable(dev->priv.eswitch);
 	mlx5_unregister_device(dev);
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
@@ -1620,6 +1620,7 @@ void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev, bool suspend)
 	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&dev->intf_state_mutex);
 
+	mlx5_eswitch_disable(dev->priv.eswitch);
 	mlx5_detach_device(dev, suspend);
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
-- 
2.53.0

