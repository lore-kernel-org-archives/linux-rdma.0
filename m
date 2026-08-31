Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1A44AF9C2;
	Mon, 31 Aug 2026 13:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184179; cv=none; b=W7PHcnh//0/42YicgazszqavD78IMeIzCkJrj1IEZoh0ZtWyVV10TSk0IsnNh+vr1Gt6KYzJGyEfMa4E+ZuEx30fUbVDTYJOM/IginsUCunTT2KcgniGtLyRC0Y+LPJsIoYycOn1DkKKKgzBnokwcRj8ENc2dnrOc1r3bKQAEYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184179; c=relaxed/simple;
	bh=mYDFe9Woev5Yn6o4jFGL2+64FstpC3/uN5fTMJWYnAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wo7s5M8XTcuBnAXviJunA9+rF+U+OzVDqEr31+wWow6b/C6LjdOe9c9lC1EKRKnLvsaneNHfK6jMMyD40bp1HTi9TOjGzhyrPkRS4A8gSaK17oVHdhQxjwBEPiwfz4lomdHqGYFZC+dCYQi8QBw27g3eZ8dDBN0HBNF3zNQLh30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhJ+lXw1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhJ+lXw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45631F00A3D;
	Mon, 31 Aug 2026 13:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184176;
	bh=bXiNMWPAd1KgTwh0xKnum1+x4d+PdZZkhQ4rx4vd7Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhJ+lXw1qyFSOXLD59i7kPt2cExwWK6rwOEBplwC3qqsdEow/p52xZjganrSfPkmD
	 8vPVeY7Ocy455O4sI9NVFAbCDtVjK72bgal+gxkLUaNoDOkx7HYnQxWeVyZN/8Vh+p
	 RBZpNcvKW/mb4NUp1UvK0CvlQ1rDMz2sw6ujqaJauKJMuc3UJhziZVKVjmdRb7FntB
	 BmnNFviAYLvD5M3NnHzaa0S5KBGDFZYiqjdS9fi2mNTq7Apq50otPYGPDBmOzL4Kxb
	 XK/BRIA2jwbqueJEZi8z5nrL3wlP7NNDgH+fGre8QCVI7bX78bBJSuc/nxHNbWK1Ox
	 hupFVcy9a4Qbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] RDMA/mlx5: Use QP port when decoding responder CQEs
Date: Mon, 31 Aug 2026 09:29:25 -0400
Message-ID: <20260831133314.4125787-537-sashal@kernel.org>
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 194762e6e436acde0f8f6aef44200b0058c36791 ]

The responder CQE path determines the link layer via
rdma_port_get_link_layer(). Use qp->port instead of
hardcoding port 1, which can mis-decode completions on
multi-port devices.

Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Link: https://patch.msgid.link/20260410074046.2044595-1-zhaochenguang@kylinos.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: RDMA/mlx5: Use QP port when decoding
responder CQEs

**Local tree:** `v6.18.43` (`VERSION = 6`, `PATCHLEVEL = 18`, `SUBLEVEL
= 43`, `git describe HEAD` = `v6.18.43-1-gc7f0dac02d232`)

**Fix commit (mainline):** `194762e6e436a` — not present in this
checkout (`git merge-base --is-ancestor` returns false).

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[RDMA/mlx5]` `[use]` — use the QP's actual port instead of
hardcoded port 1 when determining link layer for responder CQE decoding.

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>` (author)
- `Link: https://patch.msgid.link/20260410074046.2044595-1-
  zhaochenguang@kylinos.cn`
- `Signed-off-by: Leon Romanovsky <leon@kernel.org>` (RDMA maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: maintainer applied; no fuzzer or user bug report tags

### Step 1.3: Body analysis
**Record:**
- **Bug:** `handle_responder()` calls
  `rdma_port_get_link_layer(qp->ibqp.device, 1)` — always port 1.
- **Symptom:** Responder CQEs on multi-port mlx5 devices can be mis-
  decoded when the QP is bound to a port other than 1, or when ports
  differ in link layer.
- **Root cause:** Link-layer branch selection uses the wrong port
  number.
- **Versions:** Bug present from at least v4.8 through v6.18 in this
  repo (verified via tags).

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit correctness fix, not disguised
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/infiniband/hw/mlx5/cq.c` (+2 / -1)
- **Function:** `handle_responder()`
- **Scope:** Single-file, surgical one-line logic fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `ll = rdma_port_get_link_layer(qp->ibqp.device, 1)`
- **After:** `ll = rdma_port_get_link_layer(qp->ibqp.device, qp->port)`
- **Path:** Responder CQE handling during CQ poll — normal hot path for
  incoming RDMA receives.

### Step 2.3: Bug mechanism
**Record:** **Logic / correctness fix.** `ll` controls which branch
decodes completion metadata:

```242:270:drivers/infiniband/hw/mlx5/cq.c
        if (ll != IB_LINK_LAYER_ETHERNET) {
                wc->slid = be16_to_cpu(cqe->slid);
                wc->sl = (be32_to_cpu(cqe->flags_rqpn) >> 24) & 0xf;
                return;
        }

        wc->slid = 0;
        vlan_present = cqe->l4_l3_hdr_type & 0x1;
        roce_packet_type   = (be32_to_cpu(cqe->flags_rqpn) >> 24) & 0x3;
        // ... RoCE VLAN, network_hdr_type decoding ...
```

Using port 1's link layer when the QP is on another port selects the
wrong branch, populating `ib_wc` fields incorrectly (e.g., IB
`slid`/`sl` vs RoCE `vlan_id`/`network_hdr_type`).

### Step 2.4: Fix quality
**Record:**
- Obviously correct — `qp->port` is already used in the same function
  for pkey lookup (line 236).
- mlx4 consistently uses `qp->port` for the same purpose
  (`drivers/infiniband/hw/mlx4/qp.c:3050`).
- Minimal change, no API changes, negligible regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** In this checkout, blame points to import commit
`a112b91dd6349` (tree packaging artifact). Tag inspection shows the
hardcoded `1` is present at v4.8, v4.9, v4.14, v4.19, v5.4, v5.10,
v5.15, v6.1, v6.6, v6.12, v6.18 — a long-standing bug.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** Fix commit `194762e6e436a` is on `net-next` and `all-next`.
Current HEAD (6.18.43) does not contain it. `cq.c` has had other
post-v6.18 changes on `net-next` (UMEM refactors) but this fix is
independent.

### Step 3.4: Author context
**Record:** Chenguang Zhao (Kylinos). Leon Romanovsky (mlx5/RDMA
maintainer) committed the fix. No other related commits from this author
found in this tree.

### Step 3.5: Dependencies
**Record:** None. Standalone, self-contained one-hunk change. `qp->port`
and `struct mlx5_ib_qp` exist in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 194762e6e436a` → https://patch.msgid.link/20260410074046.20
  44595-1-zhaochenguang@kylinos.cn
- Single v1 revision; no v2/v3
- Leon Romanovsky: "Applied, thanks!" — no objections, no stable
  nomination

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd to Leon Romanovsky, Jason Gunthorpe,
linux-rdma@vger.kernel.org. Maintainer applied directly.

### Step 4.3: Bug reports
**Record:** No external bug report, syzbot, or Bugzilla link. Kylinos
authorship suggests internal/production discovery on multi-port
hardware.

### Step 4.4: Series context
**Record:** Standalone 1/1 patch, no series dependencies.

### Step 4.5: Stable list history
**Record:** No stable-list discussion found in thread mbox. No `Cc:
stable` in thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `handle_responder()`, called from CQE poll path.

### Step 5.2: Callers
**Record:**
- `handle_responder()` ← CQE opcode switch in poll path (line 518)
- `mlx5_ib_poll_cq()` (line 610) ← `.poll_cq` in `main.c:4352`
- Reachable from userspace via `ibv_poll_cq()` on mlx5 devices.

### Step 5.3: Callees
**Record:** `rdma_port_get_link_layer()`, `ib_find_cached_pkey()`, CQE
field decoding.

### Step 5.4: Reachability
**Record:** **Userspace-reachable** on every responder completion poll.
Trigger requires mlx5 HCA with `num_ports > 1`, QP on port ≠ 1, and (for
functional impact) different link-layer types between port 1 and
`qp->port`. Dual-port same-type configs (common IB or RoCE) are
unaffected.

### Step 5.5: Similar patterns
**Record:** mlx4 uses `qp->port` in four places for
`rdma_port_get_link_layer()`. mlx5 `handle_responder()` is the outlier;
same function already uses `qp->port` at line 236.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at
`drivers/infiniband/hw/mlx5/cq.c:172`:
```c
enum rdma_link_layer ll = rdma_port_get_link_layer(qp->ibqp.device, 1);
```

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — identical context in 6.18.43. No
conflicts anticipated.

### Step 6.3: Related fixes already present?
**Record:** None. `git log --grep="QP port when decoding"` returns
nothing on current HEAD.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/infiniband/hw/mlx5` — **IMPORTANT** (ConnectX RDMA,
widely deployed in HPC/cloud/enterprise).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; mlx5 is a primary production RDMA
driver.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of multi-port mlx5 HCAs running QPs on port 2+ where
port 1 and `qp->port` have different link layers. Subset of RDMA users,
but includes serious production deployments (HPC clusters, cloud RDMA).

### Step 8.2: Trigger conditions
**Record:** Responder CQE poll on a QP not on port 1, with mismatched
link-layer types between ports. Not every boot; requires specific multi-
port configuration. Unprivileged users can trigger via normal RDMA CQ
polling.

### Step 8.3: Failure mode severity
**Record:** Incorrect `ib_wc` metadata delivered to userspace (wrong
`slid`/`sl` vs `vlan_id`/`network_hdr_type`). **Severity: MEDIUM** — no
kernel oops/UAF, but wrong completion data can break RDMA applications
silently. Fits stable rules' "oh, that's not good" category.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM for affected configs; correctness fix for
  production RDMA
- **Risk:** VERY LOW (one-line, pattern-proven)
- **Ratio:** Favorable — trivial fix for a real, long-standing bug

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verified bug in this 6.18.43 tree
- Trivial, obviously correct fix (matches mlx4 and same-function
  `qp->port` usage)
- Userspace-reachable via CQ poll hot path
- Wrong `ib_wc` data to applications on affected multi-port configs
- Maintainer-applied, zero regression risk
- Present since at least v4.8 — long-lived latent bug

**AGAINST backport:**
- No crash, deadlock, security issue, or kernel memory corruption
- No `Reported-by:` or public bug report
- Practical impact limited to niche config (multi-port + different link
  layers + QP on port ≠ 1)
- Dual-port same-type HCAs (majority of deployments) unaffected
- No explicit stable nomination

**Unresolved:** No independent test report; exact production trigger
case from Kylinos not documented in thread.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logically correct; no
   explicit test but maintainer-applied
2. Fixes real bug affecting users? **PASS** — wrong WC metadata on
   affected multi-port setups
3. Important issue? **PASS (borderline)** — not crash/security, but
   incorrect userspace API data on production RDMA path
4. Small and contained? **PASS** — 3 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — bug confirmed present, clean
   apply expected

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision rationale

This is a clear oversight: `handle_responder()` hardcodes port 1 while
the same function uses `qp->port` for pkey resolution, and mlx4 does the
right thing throughout. On multi-port mlx5 devices where ports differ in
link layer and QPs are bound to port 2+, userspace receives incorrectly
decoded work completions. That is a real correctness bug on a hot
userspace-facing path, fixable with a one-line change and essentially
zero risk. It does not cause kernel crashes, but stable rules explicitly
allow fixes for notable "oh, that's not good" issues, and delivering
wrong RDMA completion metadata qualifies for RDMA production users.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  `git show 194762e6e436a`
- [Phase 1] No syzbot/Reported-by/Fixes: tags found
- [Phase 2] Diff: 1-line logic change in `handle_responder()`,
  `cq.c:172`
- [Phase 2] Read `handle_responder()` lines 169–271 — confirmed branch
  impact on `ib_wc` fields
- [Phase 3] `git describe HEAD` → v6.18.43; `git merge-base --is-
  ancestor 194762e6e436a HEAD` → fix NOT in tree
- [Phase 3] Tags v4.8–v6.18 checked — hardcoded port 1 present in all
- [Phase 3] `git show 194762e6e436a` — full diff confirmed
- [Phase 4] `b4 dig -c 194762e6e436a` — lore URL found
- [Phase 4] `b4 dig -a` — single v1 revision
- [Phase 4] `b4 dig -w` — Leon Romanovsky, Jason Gunthorpe CC'd
- [Phase 4] `b4 dig -m /tmp/mlx5_cq_thread.mbox` — Leon applied, no
  stable/CC discussion
- [Phase 5] `grep handle_responder` — called from CQE poll switch at
  line 518
- [Phase 5] `mlx5_ib_poll_cq` registered as `.poll_cq` in `main.c:4352`
- [Phase 5] mlx4 uses `qp->port` at `mlx4/qp.c:3050` (and 3 other sites)
- [Phase 6] Buggy line confirmed at `cq.c:172` in current checkout
- [Phase 6] `qp->port` field confirmed in `mlx5_ib.h:526`
- [Phase 8] Impact: wrong WC metadata, MEDIUM severity, niche multi-port
  trigger
- [UNVERIFIED] Exact hardware configuration Kylinos used to discover the
  bug

**YES**

 drivers/infiniband/hw/mlx5/cq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 651d76bca114d..c6590dde68332 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -169,7 +169,8 @@ enum {
 static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 			     struct mlx5_ib_qp *qp)
 {
-	enum rdma_link_layer ll = rdma_port_get_link_layer(qp->ibqp.device, 1);
+	enum rdma_link_layer ll =
+		rdma_port_get_link_layer(qp->ibqp.device, qp->port);
 	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.device);
 	struct mlx5_ib_srq *srq = NULL;
 	struct mlx5_ib_wq *wq;
-- 
2.53.0

