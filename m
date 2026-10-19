Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB8461898E;
	Mon, 19 Oct 2026 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418657; cv=none; b=nge1uFPkAMr3xeyFKtUCcCiRNH2xga1X4hOu4AcvpKiHftg1DVVYqUfmicnYpQvQ2yfopRAK51ifN2vQ8U1dxn/loDpETeGSWJzfbY2wq9tHKX52ptkL+sDFp/smaRSikgPciQZZI5KCeJKombrIKbo2A8B5GaFe3K3HtTJanTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418657; c=relaxed/simple;
	bh=NraNV6uZLErNz3sW5iSRQ/yLE+T+WB0nkIvhKHSHaGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJy/swGCngzQeFSYz5L16HcMeA7BOrmH1IrVA1Y4UPztaf5smKNK6RP+MQpNNTU0gQdme84CcQDqWvDUGgaKS/PP7Wwal9L19kKq76oyvgepn/AOnbQ6/1lLv7dZGCnGhiPBZA2LAD3k2WlqpR8usN2/0fQWAuLxV6BwdIcG2F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSaScUlN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSaScUlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420FC1F000C7;
	Mon, 19 Oct 2026 14:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418655;
	bh=BnpElW4Dkaitp2Wcrqbr+EIvQ0lFsv0BF4gR/P3KqGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSaScUlNC0UtnCQeSNIMZXXqysyvCcjewVtzOD9yUCxDVbwRUxrZxkKuXbT5hM2mf
	 ZdC+NHwnqizP84WZ4kiUVOZa4ZhDRI92bRTBUiVFUWGVDOLjwlE0hHCN5EOF/FOOFt
	 /uFePqWzXrvJrVQQM9Kxikjy4lMUIXr27GYMQVsPIFmAeva6mG2V/nBP//KqOy8UIv
	 bXMLFk8aLKlo5jA7BUe1OACEgxHq5yqYgT/Lc5WLKQTrZJln5PK6kDoZPoMy5cM2Ej
	 4zJvY7cEWB/pLIln9iUQsQBsi2o3HeO4FAYdV69Vd08yyTg6hItDqrwQKHQrDLD04X
	 smQc/yMNd697Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhiwei Zhang <202275009@qq.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] RDMA/rxe: Check PDs for memory window binds
Date: Mon, 19 Oct 2026 09:51:34 -0400
Message-ID: <20261019135441.1420968-403-sashal@kernel.org>
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

From: Zhiwei Zhang <202275009@qq.com>

[ Upstream commit fbbe1d5cd7d400a98afcf337969cfdb808cb198f ]

The IBTA Software Transport Verbs specification requires the QP,
Memory Window and Memory Region for a Bind Memory Window operation
to belong to the same HCA and protection domain.

rxe only checked the QP and MW protection domain for type 2 MWs.
Move the QP/MW PD check to the common bind path and also reject
binding an MW to an MR from a different PD.

Invalid bind requests continue to fail with IB_WC_MW_BIND_ERR.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Zhiwei Zhang <202275009@qq.com>
Link: https://patch.msgid.link/tencent_FD4FB25AA4FFA845E63F5AC36CF4A46CDC0A@qq.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4**. This is a small, spec-required PD
isolation check in Soft-RoCE bind, and the buggy path exists in this
tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[RDMA/rxe] [Check] Check PDs for memory window binds.**
Completes IBTA C10-72 by validating that QP, MW, and MR share a
protection domain on bind.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Reviewed-by:** Zhu Yanjun `<yanjun.zhu@linux.dev>`
- **Signed-off-by:** Zhiwei Zhang `<202275009@qq.com>` (author)
- **Link:** `https://patch.msgid.link/tencent_FD4FB25AA4FFA845E63F5AC36C
  F4A46CDC0A@qq.com`
- **Signed-off-by:** Leon Romanovsky `<leon@kernel.org>` (RDMA
  maintainer)
- No **Fixes:**, **Reported-by:**, **Tested-by:**, **Acked-by:**, **Cc:
  stable**, or syzbot tags (absence of Fixes/Cc-stable is expected for
  this review)
- Pipeline SOBs ignored per instructions

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** IBTA Software Transport Verbs require QP, MW, and MR of a
  Bind Memory Window to be on the same HCA and PD. rxe only compared QP
  vs MW PD, and only for type 2 MWs. It never compared QP/MW vs MR PD.
- **Symptom:** An invalid bind is accepted instead of completing with
  `IB_WC_MW_BIND_ERR`. After bind, the MW can point at an MR from
  another PD.
- **Version info in message:** none
- **Root cause (author):** type-2-only C10-72 check; missing MR PD check

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. It is an explicit spec/isolation check. The extra
`rxe_mw_pd()` helper use is equivalent to `to_rpd(mw->ibmw.pd)` and is
not a hidden refactor.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/infiniband/sw/rxe/rxe_mw.c` — **+12 / -8** (net +4)
- Function: `rxe_check_bind_mw()`
- Scope: **single-file surgical fix**

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Hunk 1 (type 2 block):** Before, C10-72 `qp->pd !=
  to_rpd(mw->ibmw.pd)` ran only for `IB_MW_TYPE_2`. After, that check is
  removed from the type-2-only block.
- **Hunk 2 (common path):** After type-1/type-2 state checks, **all**
  binds check `qp->pd != rxe_mw_pd(mw)` and fail with `-EINVAL`.
- **Hunk 3 (when MR present):** Before, a non-NULL MR skipped any PD
  comparison. After, `qp->pd != mr_pd(mr)` rejects a cross-PD MR. Zero-
  length/NULL-MR unbind still returns 0 after the QP/MW PD check.
- Path affected: BIND_MW work-request validation (`rxe_bind_mw` →
  `rxe_check_bind_mw`). Failures still become `IB_WC_MW_BIND_ERR` in
  `rxe_do_local_ops()`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **Logic / correctness + isolation (memory safety via missing PD
check).**
- Broken: `rxe_bind_mw()` looks up MW/MR by key in **device-global**
  pools (`rxe_pool_get_index`), then `rxe_do_bind_mw()` attaches `mw->mr
  = mr`. Remote access in `rxe_resp.c` uses `mw->mr` after
  `rxe_lookup_mw()`, which checks MW PD vs QP PD but **not** the bound
  MR’s PD. `lookup_mr()` does check `mr_pd(mr) != pd`, so the bind path
  was the hole around that check.
- Fix: enforce QP==MW PD for every MW type, and QP==MR PD whenever an MR
  is bound.

Step 2.4: ASSESS THE FIX QUALITY
Record: **Obviously correct and minimal.** Same `-EINVAL` /
`IB_WC_MW_BIND_ERR` policy as existing bind failures. Regression risk is
**low**: only previously illegal cross-PD binds start failing.
`rxe_mw_pd()` / `mr_pd()` already existed on the parent.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Incomplete C10-72 check came from **`32a577b4c3a9d` (2021-06-07)
“RDMA/rxe: Add support for bind MW work requests”**. Ancestor of
**v5.14** (`git merge-base --is-ancestor` vs v5.13 failed, vs v5.14
succeeded). Bug is long-standing.

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Buggy commit identified by history as
`32a577b4c3a9d`. That commit **is** an ancestor of this HEAD.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `rxe_mw.c` work includes access-flag and error-path bind
fixes (`425e1c9018fdf`, `5c719d7aef298`). Those do not replace this PD
check. **Standalone**, not `patch X/Y`. No later commits on `rxe_mw.c`
after this one on HEAD.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Zhiwei Zhang has **only this** rxe commit in this history.
Reviewer Zhu Yanjun and applier Leon Romanovsky are established RDMA
reviewers/maintainers.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Parent already has `rxe_mw_pd()` and `mr_pd()` in `rxe_verbs.h`
(`cdd0b85675aec` 2021, `1858d98b83940` 2020). **Applies standalone**
against this tree’s rxe MW code.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **v1:** https://patch.msgid.link/tencent_88CB6CA0A60CDD53B24EA5E3A865E
  6FF5A0A@qq.com (2026-06-25)
- **v2 (applied):** https://patch.msgid.link/tencent_FD4FB25AA4FFA845E63
  F5AC36CF4A46CDC0A@qq.com (2026-06-26)
- v1→v2: Zhu asked only that the MR-mismatch dbg string say `"attempt to
  bind MW/QP to MR with different PD"` because QP/MW PD is already
  checked. No NAK. v2 applied as-is.
- Leon: “Applied, thanks!” → rdma git `f58ea84a3584d1`

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients included **Leon Romanovsky**, **Jason Gunthorpe**,
**Zhu Yanjun**, `linux-rdma@vger.kernel.org`. Maintainer-reviewed.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot/user **Reported-by**. Issue is spec analysis
(C10-72), not a crash report.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Single-patch series. v2 is the committed version.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: **UNVERIFIED.** lore.kernel.org/stable returned Anubis bot-check
(403/challenge). No evidence in the linux-rdma mbox of a stable
nomination or of a reason to withhold it.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `rxe_check_bind_mw()` only. Callers/callees: `rxe_bind_mw()`,
`rxe_do_bind_mw()`, `rxe_do_local_ops()`, `rxe_lookup_mw()`.

Step 5.2: TRACE CALLERS
Record:
- `rxe_bind_mw()` ← `rxe_do_local_ops()` on `IB_WR_BIND_MW`
  (`rxe_req.c`)
- Userspace QPs: `rxe_post_send()` only schedules `send_task`; WQEs
  (including `mw_rkey`/`mr_lkey` in `include/uapi/rdma/rdma_user_rxe.h`)
  are written by userspace into the SQ. **Unprivileged RDMA userspace
  can post BIND_MW with arbitrary keys.**

Step 5.3: TRACE CALLEES
Record: Debug prints and PD helpers only. No alloc/lock changes. Bind
still runs under `spin_lock_bh(&mw->lock)`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: userspace BIND_MW → requester local op → `rxe_bind_mw` (global
pool lookup by key) → `rxe_do_bind_mw` (`mw->mr = mr`) → later RDMA to
MW rkey in `rxe_resp.c` uses `mw->mr` **without** `lookup_mr()`’s PD
check. **Userspace-reachable isolation hole.**

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: `lookup_mr()` already requires `mr_pd(mr) == pd`.
`rxe_lookup_mw()` already requires `rxe_mw_pd(mw) == pd`. Bind was the
inconsistent path. No sibling rxe function needs the same change.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes, in this 7.3 line.** `git describe HEAD` =
`v7.3-rc4-27-gf0100363d8c37`; `make kernelversion` = `7.3.0-rc4`. MW
bind exists since v5.14. Pre-fix `rxe_check_bind_mw` (parent of
`fbbe1d5cd7d40`) had type-2-only QP/MW PD check and no MR PD check. This
commit is an ancestor of HEAD (landed by v7.3-rc1; not in v7.2).
Evaluating **this** checkout, the rxe MW bind code is present and the
fix matches the local file (no later `rxe_mw.c` deltas).

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply** on this tree. Helpers and function layout match.
`git diff fbbe1d5 HEAD -- drivers/infiniband/sw/rxe/rxe_mw.c` is empty.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Access-check and error-path bind fixes are already here; they do
**not** implement C10-72 for type 1 or MR PD. No alternate PD-bind fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **RDMA software RoCE (`drivers/infiniband/sw/rxe`)**,
`CONFIG_RDMA_RXE`. **IMPORTANT** (not core mm/VFS): Soft-RoCE is a real
verbs provider; PD is the IB isolation primitive. Not staging.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature. MW bind from 2021; ongoing small correctness fixes. Not
a brand-new subsystem on this branch.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Config/driver-specific:** users of Soft-RoCE
(`CONFIG_RDMA_RXE`) who use memory windows. Multi-PD or multi-process
sharing one rxe device is the interesting case.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Post `IB_WR_BIND_MW` with MW/MR keys from another PD. Userspace
can do that; keys are `index << 8 | u8` (`rxe_get_next_key()`). Trigger
is **intentional/malicious or buggy app**, not every bind. Unprivileged
verbs users **can** trigger it.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **Not a crash.** Invalid bind **succeeds**, then RDMA through
the MW rkey can touch another PD’s registered memory. **Severity: HIGH**
(isolation/security), not panic/deadlock.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit: high** for rxe MW users — closes a PD bypass around
  `lookup_mr()`.
- **Risk: very low** — ~12 lines, validation-only, same error code, no
  API/lock/structure change.
- **Ratio:** favor applying.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**FOR:**
- Real IBTA C10-72 hole, not style
- Userspace-reachable via mapped SQ BIND_MW + global key lookup
- After bind, `mw->mr` is used without MR PD check → isolation bypass
- Tiny, obviously correct; maintainer applied; one-line v2 log tweak
  only
- Helpers already in this tree; applies cleanly
- Bug since v5.14 MW bind support

**AGAINST:**
- No crash/syzbot/CVE/user report
- rxe is not mlx5-class hardware; fewer production hosts
- Could be framed as spec hardening

**UNRESOLVED:**
- Whether stable@ already discussed this (lore/stable blocked)
- No public reproducer beyond code-path analysis (verified in-tree)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — reviewed, v2 applied by
   Leon; logic matches existing checks
2. Fixes a real bug that affects users? **PASS** — invalid binds
   succeed; PD isolation not enforced on bind
3. Important (crash/security/corruption/deadlock)? **PASS** — PD bypass
   / unauthorized MR attach; HIGH isolation, not a panic
4. Small and contained? **PASS** — one function, +12/-8
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — file and helpers match; no
   rewrite needed

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID, quirk, DT, build, or docs-only change).
Qualifies as a normal bugfix.

Step 9.4: MAKE YOUR DECISION
This should be in this tree: it closes a long-standing Soft-RoCE bind
isolation gap with a few lines of PD checks, no API change, and
negligible regression risk. Missing crash reports does not make a
skipped PD check “theoretical” when userspace supplies the keys and the
data path then uses `mw->mr`.

Verification:
- [Phase 1] Tags: Reviewed-by Zhu Yanjun; SOB Zhiwei Zhang; Link msgid;
  SOB Leon; no Fixes/Reported-by/syzbot
- [Phase 1] Body: C10-72 QP/MW/MR same PD; type-2-only check;
  `IB_WC_MW_BIND_ERR`
- [Phase 2] Diff: `rxe_check_bind_mw` +12/-8; common QP/MW PD check; new
  QP vs `mr_pd(mr)`
- [Phase 2] Parent code: C10-72 only under `IB_MW_TYPE_2`; no MR PD
  check
- [Phase 2] `rxe_do_local_ops`: bind failure → `IB_WC_MW_BIND_ERR`
  (verified `rxe_req.c`)
- [Phase 3] `git describe HEAD` / `make kernelversion`: v7.3-rc4 /
  7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor fbbe1d5 HEAD` → yes; vs v7.2 →
  no; vs v7.3-rc1 → yes
- [Phase 3] Buggy intro `32a577b4c3a9d` is ancestor of v5.14, not v5.13
- [Phase 3] Parent has `rxe_mw_pd` / `mr_pd` in `rxe_verbs.h`
- [Phase 3] Author: only this rxe commit; not a series
- [Phase 4] `b4 dig -c fbbe1d5`: v2 msgid tencent_FD4FB25…; v1
  tencent_88CB6CA0…
- [Phase 4] v1 review: Zhu requested dbg string only; Reviewed-by; no
  NAK
- [Phase 4] Leon applied to rdma tree; no stable nomination in that mbox
- [Phase 4] lore.kernel.org WebFetch 403; stable/? search hit Anubis —
  UNVERIFIED on stable@
- [Phase 5] Call chain: user SQ BIND_MW → `rxe_bind_mw` global pool
  lookup → `mw->mr` → `rxe_resp.c` uses `mw->mr` without `lookup_mr()`
  PD check
- [Phase 5] `lookup_mr()` already has `mr_pd(mr) != pd` (verified
  `rxe_mr.c:713-716`)
- [Phase 5] Userspace WQE fields `mr_lkey`/`mw_rkey` in
  `rdma_user_rxe.h`; `rxe_post_send` does not copy/validate them for
  user QPs
- [Phase 6] `git diff fbbe1d5 HEAD -- rxe_mw.c` empty; clean on this
  tree
- [Phase 8] Keys: `index << 8 | rxe_get_next_key()` (8-bit key);
  isolation severity HIGH
- UNVERIFIED: stable@ history; no in-tree test/reproducer for cross-PD
  bind

**YES**

 drivers/infiniband/sw/rxe/rxe_mw.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index 379e65bfcd49a..bddb7a2578313 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -72,13 +72,6 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 			return -EINVAL;
 		}
 
-		/* C10-72 */
-		if (unlikely(qp->pd != to_rpd(mw->ibmw.pd))) {
-			rxe_dbg_mw(mw,
-				"attempt to bind type 2 MW with qp with different PD\n");
-			return -EINVAL;
-		}
-
 		/* o10-37.2.40 */
 		if (unlikely(!mr || wqe->wr.wr.mw.length == 0)) {
 			rxe_dbg_mw(mw,
@@ -87,10 +80,21 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		}
 	}
 
-	/* remaining checks only apply to a nonzero MR */
+	/* C10-72 */
+	if (unlikely(qp->pd != rxe_mw_pd(mw))) {
+		rxe_dbg_mw(mw, "attempt to bind MW with qp with different PD\n");
+		return -EINVAL;
+	}
+
 	if (!mr)
 		return 0;
 
+	/* remaining checks only apply to a nonzero MR */
+	if (unlikely(qp->pd != mr_pd(mr))) {
+		rxe_dbg_mw(mw, "attempt to bind MW/QP to MR with different PD\n");
+		return -EINVAL;
+	}
+
 	if (unlikely(mr->access & IB_ZERO_BASED)) {
 		rxe_dbg_mw(mw, "attempt to bind MW to zero based MR\n");
 		return -EINVAL;
-- 
2.53.0

