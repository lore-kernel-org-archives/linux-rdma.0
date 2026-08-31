Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4C04B129F;
	Mon, 31 Aug 2026 13:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184240; cv=none; b=Fr6SlYxCgtQTj7CQSi27H7m9ziC3QfJY8et7tpdPvBrKpnpVuVNHpBTHkxxevCLF4aWkgwZQA27JlGbkpbjxcOOmVq7rpvsj/rVmWVpqWAw+6OvnvWd0m9GV6zT0om9iEJRCiiP7v4M33dK3x4/Bf9I3TAdsS8UzCZgu1Sf6HJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184240; c=relaxed/simple;
	bh=XR9BsfHYeHPnPbZweMGQ328wmefvnjDbXYjhz0Mt+yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f0PhMhepl++iZqILBPV+yJyFy/EFBK/kGbNuaGqYrqlDbtRrecB3fh/RZji8XECtuwVn3kn5UpJbCxrq95ACQ7fIh/bOu8ls9B0lpxjkRGV+9/3UhsBqL+tCm83KUiiw/SYvliiI2aacxU0vF2S3e0NeTRT7Au75Fb7ao0VAVww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZQ4WJUd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZQ4WJUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE261F00A3F;
	Mon, 31 Aug 2026 13:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184237;
	bh=ch9raEjg1/iri6oz2DDBHo/FFB2+tx/tAbTXb9UEPkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZQ4WJUdhmKEFE6VzWjmR6NKVe6bmxjiLuo8MxrTYUsE3OXf8/Z4Zz+80oW2n+6iz
	 hxepjNZvyqjAmUtCPuBm8IgOTVCDFy043DNKbGmBE22m6tpImm1Z4ExZ6TgeJIpx1j
	 qInF2lnM6IssfayTmsEU5pNfzevjS/RvpptYrflMzE2tcnmDJfpOsVxoqIXqVEqCKj
	 jfw08o1zIHfygpV7a2QMbD0N+dYc+RKIU2TZsiWgvivH0mbNgKENtHxBm3lucE7Oru
	 Gbb7+RCMJ0Lzn7p4/fUlT/Hw9JD0tx783HCRM2K3p5IAvq4STjC9EG8hWgo2+im/u5
	 7XVKEdaRqjIOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] RDMA/mlx5: Create ODP EQ for non-pinned dmabuf MRs
Date: Mon, 31 Aug 2026 09:30:02 -0400
Message-ID: <20260831133314.4125787-574-sashal@kernel.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 93e64c7a33ff6679d4d1c0a03021a2ff0e2b6c98 ]

DMABUF generally relies on the ODP EQ mechanism to safely implement the
move semantics. ODP requires a device-global one time startup of the ODP
machinery when the first MR is created, and this was missed on the DMABUF
path.

Call mlx5r_odp_create_eq() when creating a ODP'able DMABUF.

The core code prevents using IB_ACCESS_ON_DEMAND unless the driver
advertises IB_ODP_SUPPORT, so until now, mlx5r_odp_create_eq() cannot be
called unless the device has ODP support.

However, DMABUF has no such protection and a second bug was allowing
DMABUFs to be created on non-ODP capable HW. Add a guard at the start of
mlx5r_odp_create_eq(). This is necessary here anyhow as the
dev->odp_eq_mutex is not initialized without IB_ODP_SUPPORT.

Link: https://patch.msgid.link/r/2-v1-29ebd2c229b5+fd5-ib_mr_pd_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[RDMA/mlx5] [Create] Create ODP EQ for non-pinned dmabuf MRs` —
mlx5 InfiniBand/RDMA driver; adds missing ODP event-queue initialization
on the dmabuf registration path.

**Step 1.2 — Tags**
Record:
- `Link:` https://patch.msgid.link/r/2-v1-29ebd2c229b5+fd5-
  ib_mr_pd_jgg@nvidia.com
- `Signed-off-by:` Jason Gunthorpe `<jgg@nvidia.com>`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org` (absence expected for manual review)
- Notable: patch is `[PATCH 02/10]` in series "Fix races around
  IB_MR_REREG_PD and mr->pd"; upstream SHA `93e64c7a33ff6`

**Step 1.3 — Body analysis**
Record:
- **Bug:** Non-pinned dmabuf MRs use ODP machinery (page-fault EQ, mkey
  tracking) but never call `mlx5r_odp_create_eq()`, which is required
  one-time ODP startup since commit ad50294d moved EQ creation out of
  device init.
- **Symptom:** ODP page-fault events for dmabuf MRs are not handled;
  dmabuf move semantics break; RDMA can hang or error on page faults.
- **Second bug:** dmabuf registration bypasses core
  `IB_ACCESS_ON_DEMAND` / `IB_ODP_SUPPORT` checks, so non-ODP hardware
  could reach `mlx5r_odp_create_eq()` and `mutex_lock()` on
  uninitialized `odp_eq_mutex`.
- **Root cause:** dmabuf path calls `mlx5r_store_odp_mkey()` without
  first ensuring ODP EQ exists; no guard in `mlx5r_odp_create_eq()` for
  non-ODP devices.

**Step 1.4 — Hidden bug fix?**
Record: Yes — subject says "Create" but this is a functional bug fix:
missing initialization + use of uninitialized mutex on unsupported
hardware.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- `drivers/infiniband/hw/mlx5/mr.c`: +4 lines in `reg_user_mr_dmabuf()`
- `drivers/infiniband/hw/mlx5/odp.c`: +3 lines in
  `mlx5r_odp_create_eq()`
- Functions: `reg_user_mr_dmabuf()`, `mlx5r_odp_create_eq()`
- Scope: single-subsystem, surgical (7 lines total)

**Step 2.2 — Code flow**
Record:
- **Hunk 1 (mr.c):** Before: non-pinned dmabuf goes straight to
  `mlx5r_store_odp_mkey()`. After: calls `mlx5r_odp_create_eq()` first;
  on failure jumps to `err_dereg_mr`.
- **Hunk 2 (odp.c):** Before: `mlx5r_odp_create_eq()` immediately locks
  `odp_eq_mutex`. After: returns `-EOPNOTSUPP` if
  `!(dev->odp_caps.general_caps & IB_ODP_SUPPORT)`.

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Initialization bug + logic/correctness bug
- **Mechanism:** Since ad50294d ("Create ODP EQ only when ODP MR is
  created"), `create_user_odp_mr()` calls `mlx5r_odp_create_eq()` but
  `reg_user_mr_dmabuf()` does not. Non-pinned dmabuf MRs store ODP mkeys
  without creating the page-fault EQ. On non-ODP HW, adding the EQ call
  without a guard would lock an uninitialized mutex (`mutex_init()` only
  runs when `IB_ODP_SUPPORT` is set in `mlx5_ib_odp_init_one()`).

**Step 2.4 — Fix quality**
Record: Obviously correct — mirrors the existing `create_user_odp_mr()`
pattern. Minimal, no API changes. Low regression risk on ODP-capable
hardware. On non-ODP hardware, non-pinned dmabuf registration will now
correctly fail with `-EOPNOTSUPP` instead of silently succeeding with
broken semantics.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record:
- `reg_user_mr_dmabuf()` non-pinned ODP mkey path: `de8f847a5114f` (Aug
  2024, data-direct refactor)
- `mlx5r_odp_create_eq()`: created in ad50294d4d6b5 (Mar 2021)
- dmabuf support: `90da7dc8206a5` (Jan 2021)
- Bug window: since ad50294d (Mar 2021), when EQ creation moved from
  `mlx5_ib_odp_init_one()` to lazy init on first ODP MR

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag. Bug introduced by ad50294d4d6b5, which is
in this tree.

**Step 3.3 — Related file history**
Record: Related stable fixes already in tree:
- `cc668a11e6ac8` — DMABUF MR race → CQE error (Feb 2025)
- `abb604a1a9c87` — ODP MR race → CQE error
- Series patches 01/03/05-07 from same submission are already in 6.18.y
  (`f5657d`, `d4f84b`, `fd284b`, `e123f0`)

**Step 3.4 — Author context**
Record: Jason Gunthorpe is RDMA maintainer. Recent mlx5 commits in this
tree include rereg_mr and PD-handling fixes from the same series.

**Step 3.5 — Dependencies**
Record: Standalone for backport purposes. `git apply --check` of
upstream commit against HEAD succeeds. Patch 02/10 was merged
independently as `93e64c7a33ff6`; other series patches are already
present.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c 93e64c7a33ff6` →
  https://patch.msgid.link/2-v1-29ebd2c229b5+fd5-ib_mr_pd_jgg@nvidia.com
- Part of 10-patch series "Fix races around IB_MR_REREG_PD and mr->pd"
- CC'd: `leon@kernel.org`, `linux-rdma@vger.kernel.org`, Doug Ledford
- No NAKs found in thread; maintainer reply discusses mr->pd race
  (separate issue)
- No explicit `Cc: stable` nomination found in thread

**Step 4.2 — Reviewers**
Record: `b4 dig -w`: Leon Romanovsky, linux-rdma, Doug Ledford, NVIDIA
mlx5 team CC'd.

**Step 4.3 — Bug report**
Record: No syzbot/user bug report. Bug identified internally (commit
message + series cover letter reference to Sashiko's mr->pd analysis).
Severity inferred from code path analysis.

**Step 4.4 — Related patches**
Record: Same series; patches 01/03-07/09-10 address mr->pd races. This
patch (02) is independent — only touches ODP EQ initialization.

**Step 4.5 — Stable list**
Record: Not searched (lore 403). Commit `5a6ba1a96f957` exists as a
stable backport to another tree but is NOT in `stable/linux-6.18.y` at
6.18.44.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `reg_user_mr_dmabuf()`, `mlx5r_odp_create_eq()`,
`mlx5r_store_odp_mkey()`, `mlx5_ib_init_dmabuf_mr()`,
`mlx5_ib_mr_memory_pfault_handler()`

**Step 5.2 — Callers**
Record:
- `mlx5_ib_reg_user_mr_dmabuf()` → `reg_user_mr_dmabuf()` (userspace via
  `UVERBS_METHOD_REG_DMABUF_MR` and `UVERBS_METHOD_REG_MR` with fd)
- `create_user_odp_mr()` already calls `mlx5r_odp_create_eq()` — dmabuf
  path was the gap
- Reachable from userspace RDMA uverbs on mlx5 devices with
  `CONFIG_INFINIBAND_ON_DEMAND_PAGING`

**Step 5.3 — Callees**
Record: `mlx5r_odp_create_eq()` creates EQ, workqueue, mempool for page
faults; `mlx5r_store_odp_mkey()` stores mkey in `odp_mkeys` xarray;
`mlx5_ib_init_dmabuf_mr()` → `pagefault_dmabuf_mr()` for initial mapping

**Step 5.4 — Call chain / reachability**
Record: Userspace `reg_dmabuf_mr` uverb → mlx5 dmabuf registration →
(without fix) ODP mkey stored but no EQ → hardware page faults unhandled
→ `mlx5_ib_mr_memory_pfault_handler()` never invoked for async faults.
Userspace-triggerable on mlx5 + dmabuf workloads (GPU/RDMA shared
memory).

**Step 5.5 — Similar patterns**
Record: `create_user_odp_mr()` at line 1530 correctly calls
`mlx5r_odp_create_eq()` before `mlx5r_store_odp_mkey()`. dmabuf path at
line 1682 was the sole missing caller in mr.c.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code exists?**
Record: **YES.** Tree is `stable/linux-6.18.y` at **6.18.44** (`git
describe HEAD` = v6.18.44). `reg_user_mr_dmabuf()` at lines 1681–1684
calls `mlx5r_store_odp_mkey()` without prior `mlx5r_odp_create_eq()`.
`mlx5r_odp_create_eq()` lacks `IB_ODP_SUPPORT` guard. Fix commit
`93e64c7a33ff6` is NOT an ancestor of HEAD.

**Step 6.2 — Backport complications**
Record: **Clean apply** — `git apply --check` of upstream patch against
HEAD succeeds with no conflicts.

**Step 6.3 — Related fixes already present?**
Record: Related dmabuf/ODP race fixes (`cc668a11e6ac8`, `abb604a1a9c87`)
are in tree, but this distinct ODP EQ initialization bug is not fixed.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
Record: `drivers/infiniband/hw/mlx5` — IMPORTANT (ConnectX/NVIDIA RDMA;
HPC, AI/GPU direct RDMA, cloud). Not universal but high value for
affected deployments.

**Step 7.2 — Activity**
Record: Actively maintained; multiple dmabuf/ODP fixes in 6.18.y
history.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users of mlx5 RDMA with non-pinned dmabuf MRs
(`CONFIG_INFINIBAND_ON_DEMAND_PAGING`, mlx5 hardware). GPU memory
sharing, zero-copy RDMA workloads.

**Step 8.2 — Trigger conditions**
Record:
- **Bug 1:** Register non-pinned dmabuf MR as first "ODP-like" MR (no
  prior ODP MR) on ODP-capable mlx5 → subsequent page faults / dmabuf
  moves unhandled
- **Bug 2:** Register non-pinned dmabuf on non-ODP mlx5 → with fix part
  1 alone would crash on uninitialized mutex; currently silently
  succeeds with broken semantics
- Userspace-triggerable via RDMA uverbs

**Step 8.3 — Failure mode severity**
Record:
- Missing ODP EQ: **HIGH** — RDMA hangs, CQE errors, broken dmabuf move
  semantics (similar severity to prior backported mlx5 dmabuf/ODP race
  fixes)
- Uninitialized mutex (if EQ call added without guard): **CRITICAL** —
  kernel oops/undefined behavior
- Severity overall: **HIGH to CRITICAL**

**Step 8.4 — Risk-benefit**
Record:
- **Benefit:** HIGH for mlx5 dmabuf users — fixes long-standing
  functional bug since 2021
- **Risk:** LOW — 7-line surgical fix, mirrors existing pattern, applies
  cleanly
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR backport:
- Fixes real, verifiable bug in production mlx5 dmabuf path
- Missing ODP EQ breaks page-fault handling and dmabuf move semantics
- Guard prevents mutex use on uninitialized `odp_eq_mutex` on non-ODP HW
- Small, obviously correct, applies cleanly to 6.18.44
- Same class of issue as already-backported mlx5 dmabuf/ODP fixes
- RDMA maintainer-authored fix

AGAINST backport:
- Part of larger series (mitigated: standalone, applies cleanly, other
  series patches already in tree)
- Non-pinned dmabuf on non-ODP HW will now fail registration (correct
  behavior, not a regression for working setups)
- No external crash report (mitigated by clear code-path analysis)

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — mirrors
   `create_user_odp_mr()`; no Tested-by but logic is clear
2. Fixes real bug affecting users? **PASS** — dmabuf MR page-fault path
   broken since 2021
3. Important issue? **PASS** — RDMA hangs/errors, potential kernel crash
   on non-ODP HW
4. Small and contained? **PASS** — 7 lines, 2 files
5. No new features/APIs? **PASS** — initialization/guard only
6. Can apply to local tree? **PASS** — clean apply verified

**Step 9.3 — Exception category**
Record: N/A — standard bug fix, not device-ID/quirk/build/doc exception.

**Step 9.4 — Decision rationale**
This commit fixes a long-standing mlx5 driver bug where non-pinned
dmabuf memory regions use ODP infrastructure without creating the
required page-fault event queue. The bug has existed in 6.18.y since
dmabuf support was combined with lazy ODP EQ creation (2021). Without
the fix, dmabuf RDMA workloads can hang or error on page faults; with
only half the fix, non-ODP hardware could hit an uninitialized mutex.
The patch is minimal, applies cleanly, and matches stable backport
criteria.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  `git show 93e64c7a33ff6`
- [Phase 2] Read current `mr.c` lines 1628–1697 and `odp.c` lines
  1814–1820; confirmed missing `mlx5r_odp_create_eq()` call and missing
  guard
- [Phase 3] `git blame` on lines 1681–1684 → `de8f847a5114f`; `git log
  -S mlx5r_odp_create_eq -- mr.c` → only `ad50294d` adds calls (in
  `create_user_odp_mr`); `git merge-base --is-ancestor ad50294d HEAD` →
  in tree
- [Phase 3] `git show 90da7dc8206a5` — original dmabuf support (Jan
  2021); `git show ad50294d` — lazy ODP EQ creation (Mar 2021)
- [Phase 3] Series prerequisites `f5657d`, `d4f84b`, `fd284b`, `e123f0`
  confirmed IN_TREE
- [Phase 4] `b4 dig -c 93e64c7a33ff6` → lore URL; `b4 dig -m` downloaded
  mbox; confirmed patch 02/10, CC list, no NAKs
- [Phase 4] `git show 5a6ba1a96f957` — stable backport exists elsewhere;
  `git merge-base --is-ancestor 5a6ba1a96f957 HEAD` → NOT_IN_TREE
- [Phase 5] `grep mlx5_ib_reg_user_mr_dmabuf` — callers in `main.c`,
  `uverbs_std_types_mr.c`
- [Phase 5] Read `create_user_odp_mr()` at line 1530 — reference pattern
  for fix
- [Phase 5] Read `mlx5_ib_odp_init_one()` —
  `mutex_init(&dev->odp_eq_mutex)` only when `IB_ODP_SUPPORT`
- [Phase 5] Read `ib_check_mr_access()` — checks `IB_ACCESS_ON_DEMAND`
  but dmabuf path does not use that flag
- [Phase 6] `git describe HEAD` → v6.18.44; branch `stable/linux-6.18.y`
- [Phase 6] `git apply --check` of upstream patch → clean apply
- [Phase 6] Confirmed buggy code present at `mr.c:1681-1684`,
  `odp.c:1814-1819`
- [Phase 8] Related fixes `cc668a11e6ac8`, `abb604a11a9c87` confirmed in
  tree via `git log --grep`

**YES**The background git searches finished and line up with the earlier
analysis:

- **Fix commit located:** `93e64c7a33ff6` ("RDMA/mlx5: Create ODP EQ for
  non-pinned dmabuf MRs") — upstream; `5a6ba1a96f957` is a stable
  backport of it elsewhere.
- **Not in this tree:** `stable/linux-6.18.y` at 6.18.44 does not
  include the fix; the bug is still present in `reg_user_mr_dmabuf()`.
- **Root cause commit in tree:** `ad50294d4d6b5` (Mar 2021) moved ODP EQ
  creation to lazy init on first ODP MR; the dmabuf path was never
  updated.

**Verdict remains YES** — small, correct fix for a real mlx5 dmabuf/ODP
bug; applies cleanly to 6.18.y.

 drivers/infiniband/hw/mlx5/mr.c  | 4 ++++
 drivers/infiniband/hw/mlx5/odp.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index bd5a7d1ad14c3..0c8cd84964be0 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1679,6 +1679,10 @@ reg_user_mr_dmabuf(struct ib_pd *pd, struct device *dma_device,
 	atomic_add(ib_umem_num_pages(mr->umem), &dev->mdev->priv.reg_pages);
 	umem_dmabuf->private = mr;
 	if (!pinned_mode) {
+		err = mlx5r_odp_create_eq(dev, &dev->odp_pf_eq);
+		if (err)
+			goto err_dereg_mr;
+
 		err = mlx5r_store_odp_mkey(dev, &mr->mmkey);
 		if (err)
 			goto err_dereg_mr;
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 47bb42576ad5d..5cd1968a33d0d 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1816,6 +1816,9 @@ int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	struct mlx5_eq_param param = {};
 	int err = 0;
 
+	if (!(dev->odp_caps.general_caps & IB_ODP_SUPPORT))
+		return -EOPNOTSUPP;
+
 	mutex_lock(&dev->odp_eq_mutex);
 	if (eq->core)
 		goto unlock;
-- 
2.53.0

