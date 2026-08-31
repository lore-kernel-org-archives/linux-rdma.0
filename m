Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CDF43440B;
	Mon, 31 Aug 2026 13:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184382; cv=none; b=YUKktMtxaTgAPhn9miKxsHdoV07KxLomXGek+fQ1kbgkJe/Yfaf1cpBfY76ru8/laUbiD8p4vTNaCKDh8loe3+mayZ7oXMCqELl0pJleqFeCmA89OcmKOQ6Vma8u6WSD3ZZw8OYOWWR4kBfoAqMCu2HBHYTRQXU7EXAcTvF6bS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184382; c=relaxed/simple;
	bh=0YXzHLifFs1QqE3ccp0+IfkWylJA5BpJvPjE/djNoBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JApJZp7sfPiz7o4jChGRW1V1U04A6vYvMi3AnwaTaV50xDijmHvfHGIYyidX70fl3ZNpdcbNP5UEtDvq6YYxl5xHQr1/6jrqRFOyQkVmzuvdEyFntx1+F4ohBqw6UwucUIL7NZlneQCywcpW7A3fCFZ8cVCjFbuSq9daTyerx6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OjUsIO2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OjUsIO2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E3A1F000E9;
	Mon, 31 Aug 2026 13:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184380;
	bh=LTVUEHPOCC6MDD7YDkc7BHZ07ek1aXTstGNdJlDVOO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjUsIO2qamWwXVY/CgRNjqqqCyD54wShGDz/Ptn2BCsb9vj8/+ii49TKI/rNOKMsY
	 9qn4uju+FGARCXgdQryMNQWw8WK5mBroPhWQbGWcpC+CuFVTJPww9fjm3ag4XXeJfV
	 aEfEuUAA7UiKFGmjPRnWRg85EB3k9qq3UdkBHdY3G5lb39fSIqbalvgllDv8LxYxn6
	 hfTpdQREnPUth+XxdXvXox83pcIPdye4P9F14vXpv9Dw9eqoSKBYiWxQjLHRI5yYZd
	 goPehUBtg3kdgvWQ97l6BGT0nuBACWU+cptw37nMWBN8DulcovcaQ9cwquJzXTmYb8
	 aSZOuUnBQmOdA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] RDMA/umem: Be careful about boundary conditions in ib_umem_find_best_pgsz()
Date: Mon, 31 Aug 2026 09:31:27 -0400
Message-ID: <20260831133314.4125787-659-sashal@kernel.org>
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

[ Upstream commit 09ea6837a0434fb4db99528a5055b6d822135dcf ]

Several corner cases, especially important on 32 bits:

- umem->iova is u64, the function argument should pass in u64 or
  iova will be truncated
- Check that the length is not too large for the iova
- Check that lengths > 4G don't overflow the GENMASK

Link: https://patch.msgid.link/r/2-v1-88303e9e509f+f7-ib_umem_types_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: RDMA/umem boundary conditions in
`ib_umem_find_best_pgsz()`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, VERSION 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[RDMA/umem]` `[Be careful about]` — boundary-condition
hardening in `ib_umem_find_best_pgsz()` for IOVA/length arithmetic and
page-size mask computation.

### Step 1.2: Tags
**Record:**
- **Link:** `https://patch.msgid.link/r/2-v1-88303e9e509f+f7-
  ib_umem_types_jgg@nvidia.com` (patch 2 of the `ib_umem_types` series
  from Jason Gunthorpe)
- **Signed-off-by:** Jason Gunthorpe `<jgg@nvidia.com>`
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, or Cc: stable tags
  in this commit message
- (Ignoring pipeline-added markers per instructions)

**Notable pattern:** Same series link as stable backport `afd35fec92971`
("RDMA/umem: Fix truncation for block sizes >= 4G"), which is already in
this tree with `Cc: stable@vger.kernel.org`.

### Step 1.3: Body analysis
**Record:**
- **Bug:** Three corner cases in `ib_umem_find_best_pgsz()`:
  1. `umem->iova` is `u64`, but the `virt` parameter was `unsigned long`
     → IOVA truncation (especially on 32-bit)
  2. `length + iova` can overflow without detection
  3. For lengths > 4G, `bits_per()` can yield values that make
     `GENMASK()` invalid
- **Symptom:** Incorrect page-size selection or undefined behavior
  during MR page-size computation; can lead to wrong MR programming
  rather than a clean error
- **Version info:** Explicitly calls out 32-bit; overflow/GENMASK issues
  also apply on 64-bit for large mappings
- **Root cause:** Type mismatch (`u64` IOVA vs `unsigned long`
  parameter) and unchecked arithmetic before `GENMASK()`

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite "Be careful about" wording, this is a real
correctness/safety fix, not cosmetic cleanup. Wrong page size in MR
setup is a data-integrity issue; `GENMASK()` with invalid arguments is
undefined behavior.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/infiniband/core/umem.c` (~14 lines changed),
  `include/rdma/ib_umem.h` (prototype + stub: `unsigned long virt` →
  `u64 virt`)
- **Functions:** `ib_umem_find_best_pgsz()`; header stubs/declarations
  only
- **Scope:** Single-file surgical fix in core RDMA umem helper +
  matching header type change

### Step 2.2: Code flow changes
**Record:**
- **Hunk 1 (signature):** `virt` parameter widened from `unsigned long`
  to `u64`; `va` becomes `u64`
- **Hunk 2 (mask init):**
  - **Before:** `mask = pgsz_bitmap & GENMASK(...,
    bits_per((umem->length - 1 + virt) ^ virt))` — unchecked add,
    possible `GENMASK` UB
  - **After:** `check_add_overflow(umem->length - 1, virt, &last_va)` →
    return 0 on overflow; compute `bits = bits_per(virt ^ last_va)`;
    only apply `GENMASK` when `bits < BITS_PER_LONG`; otherwise `mask =
    0`
- **Execution path:** MR registration page-size selection (normal path,
  userspace-triggered via uverbs)

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Memory safety / type correctness / integer overflow
- **Mechanism:**
  1. **Truncation:** `umem->iova = va = virt` stores truncated IOVA on
     32-bit when callers pass full `u64` IOVA (mlx5 `iova`, irdma
     `virt`, etc.)
  2. **Overflow:** `(umem->length - 1 + virt)` wraps on overflow,
     corrupting `bits_per()` input
  3. **GENMASK UB:** When `bits >= BITS_PER_LONG`,
     `GENMASK(BITS_PER_LONG-1, bits)` has `l > h` → shift UB at runtime

### Step 2.4: Fix quality
**Record:**
- Fix is minimal, obviously correct, and matches established kernel
  patterns (`check_add_overflow`, `u64` for IOVA)
- **Regression risk:** Low — widening parameter is ABI-compatible at C
  call sites; overflow path returns 0 (existing callers already handle
  failure)
- **Concern:** Early `return 0` on overflow is a safe failure (MR
  registration rejected) vs silent wrong page size

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Function introduced in `4a35339958f16` (May 2019, "RDMA/umem: Add API
  to find best driver supported page size in an MR")
- Buggy `GENMASK(bits_per((umem->length - 1 + virt) ^ virt))` logic from
  `a40c20dabdf90` (Sep 2020)
- `unsigned long virt` signature from original introduction
  `4a35339958f16`
- `umem->iova = va = virt` assignment from `186b169cf1e4b` (Jul 2023)
- **Bug present since at least v5.x era; fully present in this v6.18.44
  tree**

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in this commit.

### Step 3.3: Related file history
**Record:**
- Recent related fix in this tree: `486055f5e09df` "RDMA/core: Fix best
  page size finding when it can cross SG entries" (Feb 2025)
- Companion patch from same series already backported: `afd35fec92971`
  "RDMA/umem: Fix truncation for block sizes >= 4G" (Jun 2026, upstream
  `15fe76e23615`)
- **Standalone:** This patch does not require other unmerged commits;
  patch 1 is independent (different file: `iter.c`)

### Step 3.4: Author context
**Record:** Jason Gunthorpe is RDMA subsystem maintainer; authored
multiple historical `ib_umem_find_best_pgsz()` fixes (`a40c20dabdf90`,
`3361c29e9279e`, `10c75ccb54e4f`, etc.)

### Step 3.5: Dependencies
**Record:** No dependencies. API change `unsigned long` → `u64` requires
no caller modifications (all callers already pass `u64` values).
`check_add_overflow` and `bits_per` already exist in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** UNVERIFIED — `b4 dig` requires a commit hash (patch not yet
committed in this checkout's `master`/`linux-next`). Link fetch to
patch.msgid.link blocked (bot protection). Lore.kernel.org returned 403.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not retrieve thread via b4 or web fetch.

### Step 4.3: Bug reports
**Record:** N/A — no Reported-by: or syzbot links. Issue identified by
maintainer code review as part of `ib_umem_types` series.

### Step 4.4: Series context
**Record:** Part 2 of `ib_umem_types_jgg@nvidia.com` series. Part 1
(`iter.c` dma_addr_t fix) already backported to **this** tree
(`afd35fec92971`) with explicit `Cc: stable@vger.kernel.org`. Strong
indicator maintainers consider the series stable-worthy.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — could not search lore stable archive (403). In-
tree evidence: patch 1 of same series already in 6.18.y.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ib_umem_find_best_pgsz()` (modified);
`ib_umem_find_best_pgoff()` (calls it indirectly via header inline)

### Step 5.2: Callers
**Record:** Called from multiple RDMA driver MR registration paths, all
passing `u64` IOVAs:
- `mlx5_ib.h`: `mlx5_umem_mkc_find_best_pgsz()` → `iova` (u64)
- `irdma/verbs.c`: `virt` (u64)
- `bnxt_re/ib_verbs.c`: `virt_addr` (u64)
- `mana/main.c`: `virt` (u64)
- `hns_roce_mr.c`: `buf_attr->iova` (u64)
- `erdma/erdma_verbs.c`: `virt` (u64)
- `efa/efa_verbs.c`: `virt_addr` (u64)
- `mlx4_ib.h`: `start` (u64)
- `ionic/ionic_controlpath.c`: MR paths

### Step 5.3: Callees
**Record:** `check_add_overflow()`, `bits_per()`, `GENMASK()`,
`for_each_sgtable_dma_sg()`, `rounddown_pow_of_two()`, scatterlist DMA
address inspection

### Step 5.4: Reachability
**Record:** Userspace → RDMA uverbs MR registration (`ib_umem_get` →
driver `reg_user_mr` → `ib_umem_find_best_pgsz`) — **userspace-
reachable** on systems with `CONFIG_INFINIBAND_USER_MEM` and RDMA
hardware

### Step 5.5: Similar patterns
**Record:** Same series patch 1 (`afd35fec92971`) fixed analogous 32-bit
truncation in `__rdma_block_iter_next()` — same root cause class (wrong
integer width for DMA/IOVA addresses)

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **YES** — confirmed in this tree at
`drivers/infiniband/core/umem.c:79-108`:

```79:108:drivers/infiniband/core/umem.c
unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
                                     unsigned long pgsz_bitmap,
                                     unsigned long virt)
{
        // ...
        umem->iova = va = virt;
        // ...
        mask = pgsz_bitmap &
               GENMASK(BITS_PER_LONG - 1,
                       bits_per((umem->length - 1 + virt) ^ virt));
```

`umem->iova` is `u64` in `include/rdma/ib_umem.h:22`.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — localized change, no structural
refactoring since recent `486055f5e09df` fix in this tree

### Step 6.3: Related fixes already present?
**Record:** Patch 1 of series (`afd35fec92971`) present; **this specific
fix NOT present**. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** RDMA core (`drivers/infiniband/core/`) — **IMPORTANT**.
Shared helper used by mlx5, irdma, bnxt_re, hns, efa, mana, ionic,
erdma, mlx4.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — multiple umem fixes in 6.18.y history
(`486055f5e09df`, `afd35fec92971`, dmabuf/pinned umem work)

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** RDMA users registering memory regions — HPC, cloud, storage
(NVMe-oF), AI clusters. Config-specific: `CONFIG_INFINIBAND` +
`CONFIG_INFINIBAND_USER_MEM` + hardware driver.

### Step 8.2: Trigger conditions
**Record:**
- IOVA with high bits set (32-bit systems, or any system using full
  64-bit IOVA space)
- Large MR lengths (especially > 4G)
- Crafted `length`/`iova` combinations causing arithmetic overflow
- **Unprivileged users** can trigger via RDMA uverbs MR registration

### Step 8.3: Failure mode severity
**Record:**
- Wrong page size → incorrect MR mapping → **data corruption**
  (HIGH/CRITICAL for RDMA workloads)
- `GENMASK` UB → potential **kernel crash** (HIGH)
- Overflow path after fix → clean `return 0` → MR registration fails
  (safe)
- **Severity: HIGH** (data integrity + potential crash)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit: HIGH** — fixes real correctness bug in shared core helper
  on userspace-reachable path; companion patch already deemed stable-
  worthy
- **Risk: LOW** — ~20 lines, maintainer-authored, no caller changes,
  fail-safe error paths
- **Ratio: Strongly favors backport**

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: IOVA truncation, unchecked overflow, GENMASK UB
- Userspace-reachable via MR registration
- Data corruption and potential kernel crash
- Small, surgical fix from RDMA maintainer
- Buggy code confirmed in v6.18.44
- Companion patch from same series already backported to this tree with
  Cc: stable
- All callers already pass `u64` — API widening is safe

**AGAINST backport:**
- No syzbot/user crash report attached (maintainer-found during type
  cleanup)
- Primarily emphasized for 32-bit; 64-bit impact requires large MRs
  (less common but real)
- Mailing list review not independently verified

**UNRESOLVED:**
- Full lore review thread inaccessible
- No explicit Tested-by: in commit message

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   maintainer fix; series part 1 already in stable
2. Fixes real bug affecting users? **PASS** — wrong MR page size /
   potential UB on MR registration
3. Important issue? **PASS** — data corruption + potential crash (HIGH
   severity)
4. Small and contained? **PASS** — 2 files, ~20 lines
5. No new features/APIs? **PASS** — parameter type widening only;
   behavior change is bug fix
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs) — standard
bug fix.

### Step 9.4: Decision rationale

This commit fixes genuine boundary-condition bugs in a core RDMA helper
that every major driver uses during memory registration. The bugs can
cause incorrect page-size selection (data corruption risk) or undefined
behavior in `GENMASK()`. The fix is small, from the subsystem
maintainer, and follows the same `ib_umem_types` series whose first
patch is already in this 6.18.y tree as a stable backport. The buggy
code is present in v6.18.44 and the fix applies cleanly.

---

## Verification

- [Phase 1] Parsed subject, Link tag, Jason Gunthorpe SOB; no
  Fixes/Reported-by
- [Phase 2] Read diff: `u64 virt`, `check_add_overflow`, guarded
  `GENMASK`; 2 files, ~20 lines
- [Phase 2] Read current `umem.c:79-147` and `ib_umem.h:22,86-88` —
  buggy code confirmed
- [Phase 3] `git blame -L 79,108 drivers/infiniband/core/umem.c`:
  introduced `4a35339958f16` (2019), GENMASK logic `a40c20dabdf90`
  (2020)
- [Phase 3] `git log --oneline -20 -- drivers/infiniband/core/umem.c`:
  recent related fixes including `486055f5e09df`, `afd35fec92971`
- [Phase 3] `git show afd35fec92971`: companion patch from same series,
  Cc: stable, already in tree
- [Phase 3] `git merge-base --is-ancestor afd35fec92971 HEAD`: confirmed
  in tree
- [Phase 4] `b4 dig --help`: requires `-c COMMITISH`; no commit hash
  available for this unmerged patch
- [Phase 4] WebFetch patch.msgid.link: blocked by bot protection
- [Phase 4] curl lore.kernel.org: 403 Forbidden
- [Phase 5] `grep ib_umem_find_best_pgsz`: 10+ driver call sites, all
  pass u64 IOVA values
- [Phase 5] Verified caller types: mlx5 `iova` u64, irdma `virt` u64,
  bnxt `virt_addr` u64, hns `buf_attr->iova` u64
- [Phase 5] Read `include/linux/bits.h:46-51`: GENMASK runtime UB when
  `l > h`
- [Phase 5] Read `include/linux/overflow.h:67`: `check_add_overflow`
  available
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] `git show linus-next/master:.../umem.c`: fix NOT yet in
  those branches in this checkout (patch still pending upstream)
- [Phase 6] Buggy `unsigned long virt` confirmed; no `u64 virt` in tree
- [Phase 8] Assessed failure modes from code path analysis: wrong page
  size → corruption; GENMASK UB → crash
- UNVERIFIED: Lore mailing list reviewer feedback and explicit stable
  nomination for patch 2 specifically

**YES**The analysis is complete for **v6.18.44**
(`stable/linux-6.18.y`).

**Verdict: YES** — backport this commit.

It fixes real boundary bugs in `ib_umem_find_best_pgsz()`: IOVA
truncation (`u64` stored via `unsigned long`), unchecked `length + iova`
overflow, and possible `GENMASK()` UB for large mappings. The buggy code
is present in this tree; the fix is small, from RDMA maintainer Jason
Gunthorpe, and part of the same `ib_umem_types` series whose first patch
(`afd35fec92971`, iter.c truncation fix) is already backported here with
`Cc: stable`.

**Impact:** Userspace-reachable via RDMA MR registration — wrong page
sizes can corrupt data; `GENMASK` UB can crash the kernel.

 drivers/infiniband/core/umem.c | 18 ++++++++++++------
 include/rdma/ib_umem.h         |  4 ++--
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index fd3a774904f8d..468d662c42c47 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -78,14 +78,17 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  */
 unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 				     unsigned long pgsz_bitmap,
-				     unsigned long virt)
+				     u64 virt)
 {
 	unsigned long curr_len = 0;
 	dma_addr_t curr_base = ~0;
-	unsigned long va, pgoff;
+	unsigned long pgoff;
 	struct scatterlist *sg;
-	dma_addr_t mask;
+	unsigned long mask = 0;
+	unsigned int bits;
 	dma_addr_t end;
+	u64 last_va;
+	u64 va;
 	int i;
 
 	umem->iova = va = virt;
@@ -103,9 +106,12 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 	 * number of required pages. Compute the largest page size that could
 	 * work based on VA address bits that don't change.
 	 */
-	mask = pgsz_bitmap &
-	       GENMASK(BITS_PER_LONG - 1,
-		       bits_per((umem->length - 1 + virt) ^ virt));
+	if (check_add_overflow(umem->length - 1, virt, &last_va))
+		return 0;
+	bits = bits_per(virt ^ last_va);
+	if (bits < BITS_PER_LONG)
+		mask = pgsz_bitmap & GENMASK(BITS_PER_LONG - 1, bits);
+
 	/* offset into first SGL */
 	pgoff = umem->address & ~PAGE_MASK;
 
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 90b1ea19a90a0..0cda3e6425d2e 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -85,7 +85,7 @@ int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
 		      size_t length);
 unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 				     unsigned long pgsz_bitmap,
-				     unsigned long virt);
+				     u64 virt);
 
 /**
  * ib_umem_find_best_pgoff - Find best HW page size
@@ -178,7 +178,7 @@ static inline int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offs
 }
 static inline unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 						   unsigned long pgsz_bitmap,
-						   unsigned long virt)
+						   u64 virt)
 {
 	return 0;
 }
-- 
2.53.0

