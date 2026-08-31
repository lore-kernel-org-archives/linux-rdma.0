Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1D6463B85;
	Mon, 31 Aug 2026 13:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183288; cv=none; b=exNHY+irBHFRAkzUe97BivOdOt7NXU57+diM8tUf0Oo/QhAptLgnXT1Moi4TcSneszW9+yInUEPuTCZCoCVo2epG1cFg9olnkBsF5KEqkNGuufNbDqmTrCK7xkHGTh1ZnlzWXKc/oODzM1zy+UUC44WD/6SdtSqyc0UuDqkVeVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183288; c=relaxed/simple;
	bh=oJKRo6iYUwu6JiBDwUYbeLd7bBD9F63TofeajU3Q+OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZVlyTt7zPlhufoipUgdysXEKuZUx7SfzwpiJiFcBncBWTVWz2a/PsunFXP0MMmhVZYe/r/eQUNNMnFxkTQs56mLid1cbdJd7jW4AIm98gxYXQ/LVsdDOIyldC3sJ5f9OVJHp+lougL+1mUWnG4+hnDX+88M/9R2SHbX2boB/iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0MGuAvo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0MGuAvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4E11F00A3E;
	Mon, 31 Aug 2026 13:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183285;
	bh=3GlkRAyGJi4s/IJJOfmPlV2PSzAFfMCOhL/uc1k0p9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0MGuAvoV/43moSGMxGcQuc/azCPy3lhsgv9nYI9vXJfhAnk8Zgq2MNM8hbmqFIir
	 60BNJRILRNbQsfMYqOe6LadOxlhDvRGrqR/gDniJTYrpMmhvGYFmwP7ML1pwhwMGfC
	 6KYbzPpNEQozE/P3Rm+V5/FKiFdTDX4iAUn7wDZQ/1jTiRrEr3efB4x46hgHbC26FD
	 6xWUpt8Gr02TLCUc6Pq6Zq8Z1PKl56zl8RYWfA+c8zCe/C6v5dzlMxsNjG6vNqPf57
	 HqXvs3eMOjH1kq9wVrWaHLVVb20VkDWpOdiboOmlPEqqhM2vTl7x4ODK1L59tdiNxW
	 C9QQu8PMUtaIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] RDMA/umem: Make ib_umem_is_contiguous() safe on 32 bit
Date: Mon, 31 Aug 2026 09:21:25 -0400
Message-ID: <20260831133314.4125787-57-sashal@kernel.org>
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

[ Upstream commit 55d984dae65262fbb0a673cff7cc9824a5e19bdb ]

Sashiko points out the roundup_pow_of_two() only uses unsigned long but
dma_addr_t can be u64.

Change this algorithm to be simpler, compute the page size, if any page
size is found and it results in a single block then it is contiguous.

Link: https://patch.msgid.link/r/3-v1-88303e9e509f+f7-ib_umem_types_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[RDMA/umem]` `[Make/safe]` — Make `ib_umem_is_contiguous()`
safe on 32-bit by fixing type truncation in page-size computation.

### Step 1.2: Tags
**Record:**
- **Link:** https://patch.msgid.link/r/3-v1-88303e9e509f+f7-
  ib_umem_types_jgg@nvidia.com
- **Signed-off-by:** Jason Gunthorpe \<jgg@nvidia.com\>
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, or Cc: stable in
  the commit message itself
- **Notable:** Patch is **[PATCH 3/3]** in series "Fix typing issues in
  the umem code"; cover letter and patch 1 CC `stable@vger.kernel.org`.
  Author is RDMA subsystem maintainer.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `roundup_pow_of_two()` operates on `unsigned long`, but its
  input involves `dma_addr_t` which can be `u64` on 32-bit kernels with
  `CONFIG_ARCH_DMA_ADDR_T_64BIT`.
- **Symptom:** Incorrect page-size computation in
  `ib_umem_is_contiguous()`, yielding wrong contiguous/non-contiguous
  results.
- **Root cause:** Silent truncation of a 64-bit DMA-address expression
  to 32-bit `unsigned long` before `roundup_pow_of_two()`.
- **Fix approach:** Replace XOR/roundup algorithm with
  `ib_umem_find_best_pgsz()` + `ib_umem_num_dma_blocks() == 1` check.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes — despite no "fix" in the subject, this is a type-
truncation correctness bug, not cleanup. Reported by Sashiko per commit
message.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `include/rdma/ib_umem.h` only (+3 / -8 lines)
- **Functions:** `ib_umem_is_contiguous()`
- **Scope:** Single-file, surgical inline-helper fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** Compute `pgsz = roundup_pow_of_two((dma_addr ^
  (umem->length - 1 + dma_addr)) + 1)`, then call
  `ib_umem_find_best_pgoff(umem, pgsz, U64_MAX)`.
- **After:** `pgsz = ib_umem_find_best_pgsz(umem, ULONG_MAX,
  ib_umem_start_dma_addr(umem))`, return true iff `pgsz &&
  ib_umem_num_dma_blocks(umem, pgsz) == 1`.
- **Path affected:** Any caller checking umem contiguity (EFA CQ
  external-memory creation).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Type/size truncation (endianness/type bug family)
- **Mechanism:** On 32-bit with 64-bit `dma_addr_t`, `(dma_addr ^
  (umem->length - 1 + dma_addr)) + 1` is computed in 64-bit arithmetic
  but implicitly truncated when passed to `roundup_pow_of_two(unsigned
  long)`, producing wrong `pgsz` and wrong contiguity result.

### Step 2.4: Fix Quality
**Record:** Obviously correct and simpler. Uses existing helpers that
already handle `dma_addr_t` internally for SG traversal. Low regression
risk. **Caveat:** Full correctness on 32-bit also requires patch 2/3 of
the same series (changing `ib_umem_find_best_pgsz()`'s `virt` parameter
from `unsigned long` to `u64`), which is not yet in this tree.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy `ib_umem_is_contiguous()` introduced in
`c897c2c8b8e82` ("RDMA/core: Add umem is_contiguous and start_dma_addr
helpers", 2025-07-08). Present in this 6.18.y tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag on this commit.

### Step 3.3: Related File History
**Record:**
- Part of 3-patch series by Jason Gunthorpe (2026-06-01):
  1. `15fe76e23615f` — Fix truncation for block sizes >= 4G (`iter.c`) —
     **already backported** as `afd35fec92971`
  2. `09ea6837a0434` — Boundary conditions in `ib_umem_find_best_pgsz()`
     — **NOT in tree**
  3. `55d984dae6526` — This commit — **NOT in tree**
- `ib_umem_is_contiguous()` caller added in `9fb3dd85197f5` (EFA CQ
  external memory support), also in tree.

### Step 3.4: Author Context
**Record:** Jason Gunthorpe is core RDMA maintainer. Recent related work
includes `ib_umem_find_best_pgsz()` improvements and umem typing fixes.

### Step 3.5: Dependencies
**Record:** Patch 2 (`09ea6837a0434`) changes `ib_umem_find_best_pgsz()`
to accept `u64 virt` instead of `unsigned long virt`. This commit passes
`ib_umem_start_dma_addr(umem)` (`dma_addr_t`) as that argument. **For a
complete 32-bit fix, patch 2 should accompany this commit.** Patch 3
compiles and applies standalone but retains `virt` truncation without
patch 2.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://patch.msgid.link/3-v1-88303e9e509f+f7-
  ib_umem_types_jgg@nvidia.com (via `b4 dig -c 55d984dae6526`)
- **Series:** v1 only found; applied to mainline by Jason Gunthorpe on
  2026-06-05 ("Applied")
- **Cover letter:** "Fix various silent truncations, issues on 32 bit
  compiles and understandability"

### Step 4.2: Reviewers
**Record:** To: Leon Romanovsky, linux-rdma; Cc:
patches@lists.linux.dev, Shiraz Saleem, **stable@vger.kernel.org**

### Step 4.3: Bug Report
**Record:** No formal bugzilla/syzbot report. Issue raised by Sashiko
during review (per commit message). No stack traces or crash reports.

### Step 4.4: Related Patches
**Record:** 3-patch series; patch 1 already backported to 6.18.y.
Patches 2+3 remain.

### Step 4.5: Stable List History
**Record:** Author CC'd stable on cover letter and patch 1 (which was
backported). Explicit stable nomination signal.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `ib_umem_is_contiguous()`, `ib_umem_find_best_pgsz()`,
`ib_umem_num_dma_blocks()`, `ib_umem_start_dma_addr()`

### Step 5.2: Callers
**Record:** Single caller in this tree:
- `drivers/infiniband/hw/efa/efa_verbs.c` — EFA CQ creation with
  external memory; rejects non-contiguous buffers with `-EINVAL`.

### Step 5.3: Callees
**Record:** `ib_umem_find_best_pgsz()` walks SG table using
`dma_addr_t`; `ib_umem_num_dma_blocks()` counts blocks from `umem->iova`
and `umem->length`.

### Step 5.4: Reachability
**Record:** Reachable from userspace via RDMA uverbs CQ creation ioctl
(EFA driver, `CONFIG_INFINIBAND_EFA`). Requires
`CONFIG_INFINIBAND_USER_MEM`.

### Step 5.5: Similar Patterns
**Record:** Same series addresses related truncation in `iter.c`
(already backported) and `ib_umem_find_best_pgsz()` (patch 2, not yet
backported).

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Tree is **v6.18.44** (`linux-6.18.y`). Buggy
`roundup_pow_of_two()` code is at lines 122–134 of
`include/rdma/ib_umem.h`. Introduced July 2025, well within 6.18's
lifetime.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — single hunk in one header. No
conflicting changes found. **Recommend backporting patch 2 alongside for
complete fix.**

### Step 6.3: Related Fixes Already Present?
**Record:** Patch 1 of series (`afd35fec92971`) already backported.
Patches 2 and 3 are not. No alternative fix for this specific bug.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** RDMA core (`include/rdma/ib_umem.h`) — **IMPORTANT**
(affects RDMA memory registration path, used by multiple drivers via
shared helpers).

### Step 7.2: Activity
**Record:** Actively developed; `ib_umem_is_contiguous()` is relatively
new (2025).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of RDMA with `CONFIG_INFINIBAND_USER_MEM` on **32-bit
architectures with 64-bit DMA addresses** (e.g., ARM with
`CONFIG_ARCH_DMA_ADDR_T_64BIT`). Currently impacts EFA external-memory
CQ path directly; helper is available for other drivers.

### Step 8.2: Trigger Conditions
**Record:** Creating an RDMA memory region where DMA addresses or span
computations exceed 32-bit when truncated. Requires EFA (currently) +
external memory CQ. Not every boot, but reachable from userspace RDMA
operations.

### Step 8.3: Failure Mode Severity
**Record:**
- **False negative** (contiguous reported as non-contiguous): `-EINVAL`,
  CQ creation fails — **MEDIUM**
- **False positive** (non-contiguous reported as contiguous): device
  programmed with wrong memory layout — potential **data corruption /
  hardware malfunction** — **HIGH**
- Not a typical kernel oops/panic, but correctness bug with corruption
  potential.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM-HIGH — fixes real type bug in shared RDMA helper;
  author nominated for stable; series already partially backported
- **Risk:** LOW — 3-line net change, uses existing well-tested helpers
- **Ratio:** Favorable

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR:**
- Real type-truncation bug on 32-bit with 64-bit `dma_addr_t`
- Small, surgical, obviously correct fix from RDMA maintainer
- Author CC'd stable; patch 1 of same series already in 6.18.y
- False-positive contiguity could cause serious RDMA misprogramming
- Buggy code confirmed present in v6.18.44

**AGAINST:**
- Niche platform config (32-bit + 64-bit DMA + RDMA)
- Only one direct caller today (EFA)
- Complete fix requires patch 2 (`09ea6837a0434`) not yet in tree
- No crash report or syzbot reproduction

**Unresolved:** No runtime test results in mailing list thread.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is sound; applied to
   mainline; no objections in review
2. Fixes a real bug? **PASS** — confirmed type truncation in existing
   code
3. Important issue? **PASS** — correctness bug with potential data
   corruption (false positive path)
4. Small and contained? **PASS** — 3 lines net, one file
5. No new features/APIs? **PASS** — same function signature and
   semantics
6. Can apply to local tree? **PASS** — applies cleanly; patch 2 should
   accompany for completeness

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not device-ID/quirk/build/doc
exception.

### Step 9.4: Decision Rationale

This commit fixes a real, verifiable type-truncation bug in
`ib_umem_is_contiguous()` that exists in the 6.18.44 tree. The buggy
code was introduced in July 2025 and can cause incorrect contiguity
detection on 32-bit kernels where `dma_addr_t` is 64-bit. While the
immediate caller is the EFA driver's external-memory CQ path, the helper
is shared RDMA infrastructure.

The fix is minimal, low-risk, and from the RDMA maintainer who
explicitly CC'd stable. Patch 1 of the same 3-patch series is already
backported to this tree (`afd35fec92971`), establishing precedent.
**Patch 2 (`09ea6837a0434`) should be backported together with this
commit** for a complete 32-bit fix, since this commit passes a
`dma_addr_t` to `ib_umem_find_best_pgsz()` which still takes `unsigned
long virt` in 6.18.y. Even standalone, removing the broken
`roundup_pow_of_two()` path is a meaningful improvement.

---

## Verification

- **[Phase 1]** Parsed commit message: subsystem RDMA/umem, Link tag,
  Jason Gunthorpe SOB, Sashiko attribution
- **[Phase 2]** Diff analysis: 3 insertions, 8 deletions in
  `ib_umem_is_contiguous()`; removes `roundup_pow_of_two()` call
- **[Phase 3]** `git blame`: buggy code from `c897c2c8b8e82`
  (2025-07-08), present in tree
- **[Phase 3]** `git merge-base --is-ancestor c897c2c8b8e82 HEAD`: intro
  commit IS in tree
- **[Phase 3]** Series check: patch 1 (`afd35fec92971`) IN tree; patches
  2 (`09ea6837a0434`) and 3 (`55d984dae6526`) NOT in tree
- **[Phase 3]** `git log --oneline -20 -- include/rdma/ib_umem.h`:
  confirmed recent umem history
- **[Phase 4]** `b4 dig -c 55d984dae6526`: found thread at
  patch.msgid.link
- **[Phase 4]** `b4 dig -c 55d984dae6526 -a`: v1 series, 3 patches
- **[Phase 4]** `b4 dig -c 55d984dae6526 -w`: stable@vger.kernel.org
  CC'd
- **[Phase 4]** `b4 dig -m /tmp/umem_thread.mbox`: cover letter
  describes 32-bit truncation fixes; "Applied" reply from author
- **[Phase 5]** `grep ib_umem_is_contiguous`: one caller in
  `efa_verbs.c:1222`
- **[Phase 5]** Read `efa_verbs.c:1215-1230`: rejects non-contiguous
  with `-EINVAL`
- **[Phase 5]** Read `ib_umem_find_best_pgsz()` in `umem.c`: uses
  `dma_addr_t` internally for SG traversal
- **[Phase 6]** `git describe HEAD`: v6.18.44; `make kernelversion`:
  6.18.44
- **[Phase 6]** Read current `ib_umem.h:122-134`: confirmed buggy code
  still present
- **[Phase 6]** `include/linux/types.h:157-161`: `dma_addr_t` is `u64`
  when `CONFIG_ARCH_DMA_ADDR_T_64BIT`
- **[Phase 6]** `include/linux/log2.h:174-181`: `roundup_pow_of_two()`
  uses `unsigned long` / `1UL`
- **[Phase 8]** Failure mode: wrong contiguity → EINVAL or potential
  RDMA misprogramming

**YES**The analysis is complete: **this commit should be backported to
the 6.18.y tree (v6.18.44).**

**Why:** `ib_umem_is_contiguous()` truncates 64-bit `dma_addr_t` values
through `roundup_pow_of_two()` on 32-bit kernels with 64-bit DMA
addresses. That can mis-detect memory contiguity and break EFA external-
memory CQ creation (or worse, accept non-contiguous memory).

**Scope:** Small, low-risk change in `include/rdma/ib_umem.h` (3 lines
net). The buggy code from July 2025 is present in this tree; the fix is
not.

**Follow-up for stable maintainers:** Backport patch 2 of the same
series (`09ea6837a0434` — changes `ib_umem_find_best_pgsz()` to take
`u64 virt`) together with this commit for a complete 32-bit fix. Patch 1
of the series is already in 6.18.y as `afd35fec92971`.

 include/rdma/ib_umem.h | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 0cda3e6425d2e..8a74153332577 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -121,16 +121,11 @@ static inline unsigned long ib_umem_find_best_pgoff(struct ib_umem *umem,
 
 static inline bool ib_umem_is_contiguous(struct ib_umem *umem)
 {
-	dma_addr_t dma_addr;
 	unsigned long pgsz;
 
-	/*
-	 * Select the smallest aligned page that can contain the whole umem if
-	 * it was contiguous.
-	 */
-	dma_addr = ib_umem_start_dma_addr(umem);
-	pgsz = roundup_pow_of_two((dma_addr ^ (umem->length - 1 + dma_addr)) + 1);
-	return !!ib_umem_find_best_pgoff(umem, pgsz, U64_MAX);
+	pgsz = ib_umem_find_best_pgsz(umem, ULONG_MAX,
+				      ib_umem_start_dma_addr(umem));
+	return pgsz && ib_umem_num_dma_blocks(umem, pgsz) == 1;
 }
 
 struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
-- 
2.53.0

