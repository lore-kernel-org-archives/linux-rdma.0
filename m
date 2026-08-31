Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FF75073B3;
	Mon, 31 Aug 2026 13:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183743; cv=none; b=mONiXLFwcZfCLGnqXe+g8YG934yCxx1E7ra1KPB+pKq2JsKQTsOlnysoS3NSkIXQQIqjRVaeT6s5Z6ia2VwDtl4S3eUN8Spi9N34VEDrvBIIJk7xhbDWKZ0Yr1INCJ3HnnpBnr7/Soql1gsu0Ysk1hQJCgIVYZ1BSCTarrtBjdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183743; c=relaxed/simple;
	bh=l05waIfOGb2md7L51xI/aVnBYpnEjDNXuDkjWtHUh1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OvST1tRM8glW74t3UBpKeN1YmuZEpoq19/hrbh1/zPkfTWpPaDceuOqmb9fVQ1TEqd+WyJ3jmxTVnhfcpLkqbg5DP1glUxRDVcHzy6ZULl6+4pp+dE5WW7njfEVDQg1Pnvxx/87f+SkAeEDSgJaN9d+DKGuYIA0XH2PFH4mvfD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWqqvwJe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWqqvwJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEB01F00ACA;
	Mon, 31 Aug 2026 13:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183741;
	bh=fM0UZjPtgg3mX+QaciP2m/Ie2Zng2aoX6+wtAILlx2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWqqvwJey9Ayo4yaeEMrCw00L6+Z6B761ObW0y/SuqB/UkMjSlMNbGghFEaEyuNTb
	 naCH6h6u7hzlLxSUKvmbLEA+FP09teRZqd1YJlg6JiI4nxES8164XyjpisuyZKZ50L
	 5mShQoT/y6dqHKtnxpOCd3gnswkGbAKr8tPsbXOrAtBNiu8Qox6w/+F8iqHBdzerrA
	 q5OsPxYECrtv1i4KbXN25OQYhsshFx/Z+g5goqqfMputEKrR1PuRz8UyJDrRk8Stgx
	 oChdJ2xkjZsRhetnTvEZvjYF7Ah4bWrJY8mVRhxAsJQAJwwkhLpElTJBvdh3O/a44C
	 C8WAUAfbpDa0g==
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
Subject: [PATCH AUTOSEL 6.18-6.12] net/mlx5e: Verify unique vhca_id count instead of range
Date: Mon, 31 Aug 2026 09:25:04 -0400
Message-ID: <20260831133314.4125787-276-sashal@kernel.org>
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

[ Upstream commit 0b1c4495aa007932e9cbd7b45a8037e7b4fe34b0 ]

Change verify_num_vhca_ids() to count the number of unique vhca_ids
and verify this count doesn't exceed max_num_vhca_id, rather than
validating individual vhca_id values are within a specific range.

The previous implementation checked if each vhca_id was in the range
[0, max_num_vhca_id - 1], which is overly restrictive. The hardware
capability max_rqt_vhca_id represents the maximum number of unique
vhca_ids that can be used, not a range constraint on individual IDs.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260531113954.395443-14-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[net/mlx5e] [verify/change] Verify unique vhca_id count instead
of range` — mlx5e RQT validation correction.

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Shay Drory <shayd@nvidia.com>` (author)
- `Reviewed-by: Mark Bloch <mbloch@nvidia.com>`
- `Signed-off-by: Tariq Toukan <tariqt@nvidia.com>`
- `Link:
  https://patch.msgid.link/20260531113954.395443-14-tariqt@nvidia.com`
  (patch 14 of a series)
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev maintainer
  merge)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or syzbot
  tags
- Notable: NVIDIA internal review + netdev maintainer merge; no
  user/fuzzer reports

**Step 1.3 — Body analysis**

Record:
- **Bug:** `verify_num_vhca_ids()` treats `max_rqt_vhca_id` as an upper
  bound on each individual `vhca_id` value (`[0, max-1]`), but hardware
  defines it as the maximum number of *distinct* `vhca_id` values
  allowed in an RQT.
- **Symptom:** Valid cross-vHCA RQT configurations are rejected when
  actual hardware `vhca_id` values exceed that numeric limit, even when
  the number of unique IDs is within capability.
- **Root cause:** Semantic mismatch between driver validation and
  hardware capability definition.
- **Versions:** Not stated in the commit message.

**Step 1.4 — Hidden bug fix?**

Record: Yes. Despite no "fix" in the subject, this corrects broken
validation logic introduced with cross-vHCA RSS. It is a functional bug
fix, not a refactor or optimization.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c` (+15 / -5
  net)
- **Function modified:** `verify_num_vhca_ids()` only
- **Scope:** Single-file, single-function surgical change

**Step 2.2 — Code flow change**

Record:
- **Hunk 1 (before):** Loop all entries; reject if any `vhca_ids[i] >=
  max_num_vhca_id`.
- **Hunk 1 (after):** Count unique `vhca_ids` via nested loop; accept if
  `unique_count <= max_num_vhca_id`.
- **Affected paths:** All callers of `rqt_verify_vhca_ids()`:
  - `mlx5e_rqt_init()` — returns `-EOPNOTSUPP` on failure
  - `mlx5e_rqt_redirect()` — returns `-EINVAL` on failure
  - `mlx5e_rqt_redirect_indir()` — pre-check before RSS indirection
    redirect

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Logic / correctness fix (incorrect parameter semantics)
- **Mechanism:** `max_rqt_vhca_id` is a *count* cap, not a per-ID range.
  Actual `vhca_id` values come from `MLX5_CAP_GEN(mdev, vhca_id)`
  (firmware-assigned), while `sd.c` already compares `host_buses >
  max_rqt_vhca_id` as a count. The RQT validator used the wrong
  interpretation, rejecting configurations that `sd.c` already approved.

**Step 2.4 — Fix quality**

Record:
- Fix is obviously correct and consistent with `mlx5_sd_is_supported()`
  in `sd.c`.
- Minimal scope; no API changes.
- **Regression risk:** Low. Worst case is allowing configurations
  hardware already supports. Uniqueness counting is O(n²), but `n` is
  bounded by channel count (SD max group size is 2).
- No new locking or memory management changes.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record:
- Buggy validation introduced in `40e6ad9182b48` ("net/mlx5e: Support
  cross-vhca RSS", Tariq Toukan, 2024-02-14, merged 2024-03-07).
- Present in local tree `v6.18.44` (confirmed ancestor of HEAD).
- Bug has existed since the cross-vHCA RSS feature landed.

**Step 3.2 — Fixes: tag**

Record: N/A — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**

Record:
- `rqt.c` history: cross-vHCA RSS (`40e6ad9182b48`), XOR hash channel
  limit (`49e6c93870517`), earlier RQT object conversion.
- SD support added separately in `sd.c` (2023–2024 commits); uses
  correct count semantics for `max_rqt_vhca_id`.
- Standalone fix; not part of a multi-patch dependency chain for this
  specific change.

**Step 3.4 — Author context**

Record: Tariq Toukan authored the original cross-vHCA RSS code and is a
regular mlx5/mlx5e contributor. Shay Drory (fix author) is also an
NVIDIA mlx5 contributor.

**Step 3.5 — Dependencies**

Record: No prerequisite commits required. The diff only modifies an
existing static function in code already present in this tree. Applies
cleanly to current `rqt.c`.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c <commit>` could not be run — the fix commit is not in
this checkout. `Link:` URL and lore.kernel.org fetch blocked by Anubis
bot protection. **UNVERIFIED:** full mailing list thread content and any
explicit stable nominations.

**Step 4.2 — Reviewers**

Record: **UNVERIFIED** via `b4 dig -w`. From commit message: Mark Bloch
(NVIDIA reviewer), Tariq Toukan, Jakub Kicinski (netdev maintainer).

**Step 4.3 — Bug reports**

Record: No `Reported-by:` or bugzilla/syzbot links. No external crash
report — this is a driver logic bug found/reviewed internally.

**Step 4.4 — Series context**

Record: Link indicates patch 14/N of a larger tariqt series
(`20260531113954.395443-14`). This specific patch is self-contained (one
function in one file); no evidence other series patches are required.

**Step 4.5 — Stable list history**

Record: **UNVERIFIED** — could not search lore stable archive due to bot
protection.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `verify_num_vhca_ids()` (modified); callers via
`rqt_verify_vhca_ids()`.

**Step 5.2 — Callers**

Record:
- `mlx5e_rqt_init()` — RQT creation during RSS setup
- `mlx5e_rqt_redirect()` — RQT modification during channel activation
- `mlx5e_rqt_redirect_indir()` — RSS indirection table updates

In SD multi-vHCA mode (`MLX5E_RX_RES_FEATURE_MULTI_VHCA`, enabled when
`mlx5_get_sd()` is set in `en_main.c`):
- `mlx5e_channels_get_regular_rqn()` / `mlx5e_channels_get_xsk_rqn()`
  populate `vhca_id` from `MLX5_CAP_GEN(c->mdev, vhca_id)`
- SD channels map to different `mlx5_core_dev` instances via
  `mlx5_sd_ch_ix_get_dev()` in `en_main.c`
- `mlx5e_rx_res_channels_activate()` drives RSS enable and per-channel
  direct RQT redirect

**Step 5.3 — Callees**

Record: Uses `MLX5_CAP_GEN_2(mdev, max_rqt_vhca_id)` only; no
allocations or locks.

**Step 5.4 — Reachability**

Record:
- Triggered during netdev open/channel activation on mlx5e devices with
  Socket Direct + `cross_vhca_rqt` hardware.
- Not a direct syscall path, but reached during normal driver operation
  on supported enterprise NIC configurations.
- SD is niche but is a supported, production feature path.

**Step 5.5 — Similar patterns**

Record: `mlx5_sd_is_supported()` in `sd.c:116` correctly uses
`host_buses > MLX5_CAP_GEN_2(dev, max_rqt_vhca_id)` as a count
comparison. The RQT validator was the outlier using range semantics.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Current `rqt.c` lines 7–17 contain the range-based
check. Fix commit is **not** yet applied. Bug introduced in
`40e6ad9182b48`, which is an ancestor of HEAD.

**Step 6.2 — Backport complications**

Record: Expected **clean apply** — single hunk in an unchanged function
with no surrounding churn in recent `rqt.c` history.

**Step 6.3 — Related fixes already present?**

Record: No alternate fix for this issue found in tree. `git log
--grep="unique vhca_id"` returned nothing.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: `drivers/net/ethernet/mellanox/mlx5` — mlx5e NIC driver.
**Criticality: IMPORTANT** (enterprise NIC driver, not core kernel, but
networking data path).

**Step 7.2 — Activity**

Record: mlx5/mlx5e actively maintained; SD and cross-vHCA RSS are
relatively recent additions (2023–2024).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users of Mellanox/NVIDIA ConnectX **Socket Direct** multi-PF
setups with `cross_vhca_rqt` hardware capability. Config-specific,
platform-specific — not universal.

**Step 8.2 — Trigger conditions**

Record:
- SD group configured (`mlx5_get_sd()` non-NULL)
- `MLX5E_RX_RES_FEATURE_MULTI_VHCA` enabled
- Actual firmware-assigned `vhca_id` values ≥ `max_rqt_vhca_id` (common
  when IDs are not 0-based indices)
- Triggered on channel activation / RSS RQT redirect — not a race;
  deterministic validation failure

**Step 8.3 — Failure mode severity**

Record:
- `mlx5e_rqt_init()` → `-EOPNOTSUPP`
- `mlx5e_rqt_redirect()` / `mlx5e_rqt_redirect_indir()` → `-EINVAL`
- `mlx5e_rx_res_channel_activate_direct()` logs warning on redirect
  failure
- **Result:** Cross-vHCA RSS and RX steering from primary to secondaries
  broken — **functional networking failure** for SD users
- **Severity: HIGH** for affected deployments (broken networking), but
  **not CRITICAL** (no kernel crash, no memory corruption, no security
  issue)

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** Restores a supported hardware feature that has been
  broken since introduction whenever `vhca_id` values exceed the
  capability number; aligns driver with hardware semantics and with
  `sd.c`.
- **Risk:** Very low — ~20 lines, vendor-reviewed, no structural
  changes.
- **Ratio:** Good benefit for SD users at minimal risk, but narrow
  audience.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real, verified logic bug since cross-vHCA RSS landed (`40e6ad9182b48`)
- Buggy code confirmed present in local v6.18.44 tree
- Breaks Socket Direct cross-vHCA RX steering (production networking
  failure for affected hardware)
- Small, surgical, vendor-reviewed fix
- Consistent with existing `sd.c` interpretation of `max_rqt_vhca_id`
- No dependencies; clean apply expected
- No new APIs or features

**AGAINST backport:**
- Very niche hardware (Socket Direct, max 2 PFs per
  `MLX5_SD_MAX_GROUP_SZ`)
- No crash, corruption, deadlock, or security impact
- No syzbot/user bug reports
- Some SD configs may coincidentally pass the old check if `vhca_id`
  values happen to be small
- Mailing list/stable discussion not verified

**Unresolved:**
- Whether the bug manifests on all real SD deployments (depends on
  firmware `vhca_id` assignment)
- Full lore review thread content

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — semantics match `sd.c` and
   commit explanation; NVIDIA-reviewed.
2. Fixes a real bug affecting users? **PASS** — incorrect validation
   rejects valid HW configs on SD+cross-vHCA path.
3. Important issue? **PASS (borderline)** — functional networking
   breakage for SD users, not crash/corruption.
4. Small and contained? **PASS** — one function, ~20 lines.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** — code exists, fix not yet present,
   clean apply expected.

**Step 9.3 — Exception categories**

Record: Hardware workaround / driver correctness fix for an existing
feature — analogous to quirk/correctness fixes for supported enterprise
hardware. Not a device-ID addition, build fix, or docs fix.

**Step 9.4 — Decision rationale**

This is a genuine driver bug that has been present since cross-vHCA RSS
was added to this tree. It causes Socket Direct multi-PF RX steering to
fail when firmware-assigned `vhca_id` values do not fall in `[0,
max_rqt_vhca_id)`, which is the expected interpretation of a *count*
capability. The fix is minimal, low-risk, vendor-authored, and restores
functionality for a supported enterprise NIC configuration. While the
audience is narrow and the failure mode is functional rather than a
kernel panic, broken networking on production SD deployments meets the
stable bar for driver correctness fixes to existing hardware support.

---

## Verification

- [Phase 1] Parsed commit message tags from user-provided commit text
- [Phase 2] Read current `rqt.c` and traced `rqt_verify_vhca_ids()` call
  chain
- [Phase 3] `git blame -L 7,18 rqt.c`: buggy code from `40e6ad9182b48`
  (2024-02-14)
- [Phase 3] `git show 40e6ad9182b48`: confirmed original range-based
  validation at introduction
- [Phase 3] `git merge-base --is-ancestor 40e6ad9182b48 HEAD`: buggy
  commit IS in v6.18.44 tree
- [Phase 3] `git log --oneline -20 -- rqt.c`: no conflicting later
  changes
- [Phase 4] `b4 dig`: could not run — fix commit not in checkout
- [Phase 4] WebFetch lore/patch.msgid.link: blocked by Anubis —
  **UNVERIFIED** mailing list discussion
- [Phase 5] `grep vhca_ids` in `en/`: traced population via `channels.c`
  → `MLX5_CAP_GEN(c->mdev, vhca_id)`
- [Phase 5] Read `en_main.c:2769` — SD channels use
  `mlx5_sd_ch_ix_get_dev()` for per-PF `mdev`
- [Phase 5] Read `sd.c:116` — `max_rqt_vhca_id` used as count limit for
  `host_buses`
- [Phase 5] Read `rx_res.c:578-598` — channel activation populates
  vhca_ids and enables RSS
- [Phase 6] `git describe HEAD` / `make kernelversion`: **v6.18.44 /
  6.18.44**
- [Phase 6] Current `rqt.c` lines 13-16: range check still present (fix
  NOT applied)
- [Phase 6] `git log --grep="unique vhca_id"`: no existing fix in tree
- [Phase 8] `MLX5_SD_MAX_GROUP_SZ` = 2 in `sd.h` — bounded input size
  for uniqueness loop
- [Phase 8] Failure paths verified: `-EOPNOTSUPP` in `mlx5e_rqt_init`,
  `-EINVAL` in redirect paths

**YES**

 .../net/ethernet/mellanox/mlx5/core/en/rqt.c  | 27 ++++++++++++++-----
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
index 8d9a3b5ec973b..c845ed8f9ebfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
@@ -8,13 +8,28 @@ static bool verify_num_vhca_ids(struct mlx5_core_dev *mdev, u32 *vhca_ids,
 				unsigned int size)
 {
 	unsigned int max_num_vhca_id = MLX5_CAP_GEN_2(mdev, max_rqt_vhca_id);
-	int i;
+	unsigned int unique_count = 0;
+	int i, j;
+
+	/* Count unique vhca_ids */
+	for (i = 0; i < size; i++) {
+		bool is_unique = true;
+
+		/* Check if vhca_ids[i] was already seen */
+		for (j = 0; j < i; j++) {
+			if (vhca_ids[j] == vhca_ids[i]) {
+				is_unique = false;
+				break;
+			}
+		}
+		if (is_unique)
+			unique_count++;
+	}
 
-	/* Verify that all vhca_ids are in range [0, max_num_vhca_ids - 1] */
-	for (i = 0; i < size; i++)
-		if (vhca_ids[i] >= max_num_vhca_id)
-			return false;
-	return true;
+	/* Verify that number of unique vhca_ids doesn't exceed
+	 * max_num_vhca_id
+	 */
+	return unique_count <= max_num_vhca_id;
 }
 
 static bool rqt_verify_vhca_ids(struct mlx5_core_dev *mdev, u32 *vhca_ids,
-- 
2.53.0

