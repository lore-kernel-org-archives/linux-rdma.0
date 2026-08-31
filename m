Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCFB43030D;
	Mon, 31 Aug 2026 13:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183451; cv=none; b=IvI2RjLq17PGn6Qa6FoIqT+53O58D166PsEMTvKNK1VOi46sDPsgRvdVhCmg9i6snQ4IPDyZxpydO+3W0sBPtb+nPVxmY+mlOFH/lQJ3pBdUfTfWgaV+g/miy+nLDcgKS0oYtQ3Z9yBiPHj6sShT2qDTlcS2sjqxoau8EwocH6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183451; c=relaxed/simple;
	bh=0y9VTU2fRdaAgEjxRvyLkgI+fw1mXY7dglzR/p93Q+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=apPjN/zoqgNnNDpmYovxy9QTJ/frhpw59uz+jlezMUzVQl7TgN72N4H1508kfP6yfTw0Pp3+fY3gUzyqoYOuLcj7hUVozcyYxPIc6p+n6KQ+jGIpzRiFgRPB3rGZ5pjlek6z4qQuRQAzeSaFC7HQmpomtyqD7n6uPj2Xqpo4/d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DikXe3/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DikXe3/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479D81F000E9;
	Mon, 31 Aug 2026 13:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183449;
	bh=AI3JJqq2/kuyWXFJ4VLo48DAMR2Fci8tpdtAYaLuyFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DikXe3/Kg/NztfEKBo3+JzTDWYaw9Jjgvh0mwfU6F9hwj10sKT0u8/IJEgGfz35RA
	 thzpZU6K7kIntk4KLB+qC4U6lTQiJkAe5MZwlBlgtfKk90t5j4S6WVL6J3Joi353Gz
	 o5ZUD9klYZEflIFqF7DReTjo9+AYQX1m2CLCaPHO4IdL3TpWBH4e/Vz/tuepcNRNUY
	 vQ4fPTf+FXjeqFi2Ge6sK0kr1Ao97LpjTavoVuvYP1RHYbJeellevx+Wj4L65vSi9+
	 wQIIphbLNW+OAvuxVyg+WOKPX6pEH/kNSDyCJjsp3WGEQlqhLsWYc5UVGG6/YkI7Kx
	 V7qY+hDKtdi9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aurelien DESBRIERES <aurelien@hackers.camp>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	jinpu.wang@ionos.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] RDMA/rtrs-srv: Fix integer underflow in process_read and process_write
Date: Mon, 31 Aug 2026 09:22:11 -0400
Message-ID: <20260831133314.4125787-103-sashal@kernel.org>
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

From: Aurelien DESBRIERES <aurelien@hackers.camp>

[ Upstream commit 54bf38b27afc08a0eb6b732f9c14eb8a4bcb66b5 ]

usr_len is read from a network-supplied message field (le16_to_cpu)
and used to compute data_len = off - usr_len without validating that
usr_len <= off. A malicious RDMA client can send usr_len > off causing
an integer underflow, resulting in data_len wrapping to a huge size_t
value which is then passed to the rdma_ev callback as a memory length,
leading to out-of-bounds memory access.

Fix by reading and validating usr_len <= off before rtrs_srv_get_ops_ids()
in both process_read() and process_write(), ensuring the early return
path acquires no reference and has no resource leak.

Link: https://patch.msgid.link/r/20260608134802.5019-1-aurelien@hackers.camp
Reported-by: Aurelien DESBRIERES <aurelien@hackers.camp>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Aurelien DESBRIERES <aurelien@hackers.camp>
Assisted-by: Claude <claude-sonnet-4-6>
Acked-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: RDMA/rtrs-srv integer underflow fix

**Local tree:** `v6.18.44` (`6.18.44` per `make kernelversion`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[RDMA/rtrs-srv]` `[Fix]` — integer underflow in
`process_read()` and `process_write()` when computing `data_len` from
network-supplied `usr_len` and offset `off`.

### Step 1.2: Tags
**Record:**
- **Link:**
  https://patch.msgid.link/r/20260608134802.5019-1-aurelien@hackers.camp
- **Reported-by:** Aurelien DESBRIERES \<aurelien@hackers.camp\>
- **Reviewed-by:** Md Haris Iqbal \<haris.iqbal@ionos.com\> (IONOS RTRS
  maintainer)
- **Acked-by:** Md Haris Iqbal \<haris.iqbal@ionos.com\>
- **Signed-off-by:** Aurelien DESBRIERES, Jason Gunthorpe (RDMA
  maintainer)
- **Assisted-by:** Claude (notable but not decision-critical)
- No **Fixes:** tag (expected for manual review pipeline)
- No **Cc: stable** tag (absence is not a negative signal per
  instructions)

Notable: security-relevant report from researcher, reviewed and acked by
subsystem maintainer, signed off by RDMA maintainer.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `usr_len` is read from wire (`le16_to_cpu(msg->usr_len)`) and
  used as `data_len = off - usr_len` without checking `usr_len <= off`.
- **Symptom:** Integer underflow wraps `data_len` to a huge `size_t`,
  passed to `rdma_ev()` as a memory length → out-of-bounds memory
  access.
- **Attack model:** Malicious RDMA client sends crafted messages.
- **Fix approach:** Validate `usr_len <= off` before
  `rtrs_srv_get_ops_ids()` so early return does not leak references.

### Step 1.4: Hidden bug fix detection
**Record:** Not disguised — explicitly labeled a fix. The “no resource
leak on early return” note is a secondary correctness detail (placing
validation before `rtrs_srv_get_ops_ids()` avoids acquiring
`ids_inflight_ref` on invalid input).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/infiniband/ulp/rtrs/rtrs-srv.c` only
- **Scope:** +16 lines, −2 lines moved (net +14); two functions modified
- **Functions:** `process_read()`, `process_write()`
- **Classification:** Single-file, surgical security fix

### Step 2.2: Code flow change
**Record:**

**`process_read()` hunk:**
- **Before:** After state/sg_cnt checks → `rtrs_srv_get_ops_ids()` →
  read `usr_len` → `data_len = off - usr_len` → `rdma_ev()`
- **After:** Read `usr_len` → if `usr_len > off`, return early (no ref
  acquired) → then existing path

**`process_write()` hunk:** Same pattern.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds access via integer
  underflow (unsigned wraparound)
- **Mechanism:** `usr_len` is `size_t`, `off` is `u32`. Expression `off
  - usr_len` uses unsigned arithmetic; when `usr_len > off`, `data_len`
  wraps to ~`SIZE_MAX`. That length is passed to upper-layer `rdma_ev()`
  callbacks with `data` pointing at a fixed-size chunk page
  (`max_chunk_size`, default 128 KiB).

### Step 2.4: Fix quality
**Record:**
- Fix is minimal and obviously correct: reject invalid wire input before
  any side effects.
- Moving validation before `rtrs_srv_get_ops_ids()` is correct — without
  it, early return would leak a percpu ref.
- **Regression risk:** Very low. Legitimate clients must satisfy
  `usr_len <= off` by protocol; invalid messages are silently dropped
  with `pr_debug()`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy lines (`usr_len = le16_to_cpu(...); data_len = off -
usr_len`) introduced in **9cb837480424** (“RDMA/rtrs: server: main
functionality”, Jack Wang, 2020-05-11). Confirmed ancestor of HEAD.

### Step 3.2: Fixes: tag
**Record:** No `Fixes:` tag in commit message. N/A.

### Step 3.3: Related file history
**Record:** Recent related security fix already in this tree:
- **5a45d0aa1fa50** — “RDMA/rtrs-srv: Bound RDMA-Write length to chunk
  size in rdma_write_sg” (different OOB vector, same file, has `Cc:
  stable`, backported by Greg K-H)
- Other recent commits are error-handling and mapping fixes, not
  duplicates of this issue.
- This underflow fix is **not** present in the tree (grep shows
  vulnerable code at lines 1059–1060, 1112–1113).

### Step 3.4: Author context
**Record:** Aurelien DESBRIERES is a security researcher (reporter).
Reviewer/acker Md Haris Iqbal is an active IONOS RTRS contributor with
multiple recent commits in `drivers/infiniband/ulp/rtrs/`. Jason
Gunthorpe is RDMA maintainer.

### Step 3.5: Dependencies
**Record:** Standalone fix. No series markers (“patch X/Y”). No
prerequisite commits. `git apply --check` with the provided diff: **exit
0** (applies cleanly to current tree).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c <commit>` not possible — fix commit not in this
checkout. WebFetch of Link URL returned Anubis bot-wall (no content).
Lore.kernel.org returned 403. **UNVERIFIED:** full mailing-list thread
content.

### Step 4.2: Reviewers (b4 dig -w)
**Record:** Not run (no commit hash in tree). From commit message: Md
Haris Iqbal reviewed and acked; Jason Gunthorpe signed off.

### Step 4.3: Bug report
**Record:** Reported-by Aurelien DESBRIERES with Link to patch
submission. Mechanism described in commit message is consistent with
code analysis. No syzbot report.

### Step 4.4: Related patches
**Record:** Same subsystem recently received **5a45d0aa1fa50** (remote
peer OOB in `rdma_write_sg`), indicating active security hardening of
rtrs-srv. This fix addresses a separate, earlier code path.

### Step 4.5: Stable list history
**Record:** **UNVERIFIED** — could not access lore stable archive (403).
Related commit 5a45d0aa1fa50 was explicitly nominated for stable (`Cc:
stable@vger.kernel.org`).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `process_read()`, `process_write()` (modified); callers:
`process_io_req()`; entry: `rtrs_srv_rdma_done()` on
`IB_WC_RECV_RDMA_WITH_IMM`.

### Step 5.2: Callers
**Record:**
```
rtrs_srv_rdma_done()  [IB completion, off bounded < max_chunk_size]
  → process_io_req()
    → process_read() / process_write()
      → ctx->ops.rdma_ev()  [upper-layer callback]
```

`off` is validated in `rtrs_srv_rdma_done()` at line 1273 (`off >=
max_chunk_size` rejected), but **`usr_len` is not validated there** — it
lives inside the RDMA-written message buffer.

### Step 5.3: Callees
**Record:** `rtrs_srv_get_ops_ids()` (percpu ref),
`rtrs_srv_update_rdma_stats()`, `page_address()`, `ctx->ops.rdma_ev()`.

### Step 5.4: Reachability / impact chain
**Record:** Reachable by any connected RDMA peer sending
`RDMA_WRITE_WITH_IMM` I/O requests. Primary consumer in this tree:

- `drivers/block/rnbd/rnbd-srv.c` registers `rnbd_srv_rdma_ev` via
  `rtrs_srv_open()`
- `rnbd_srv_rdma_ev()` → `process_rdma()` → `bio_add_virt_nofail(bio,
  data, datalen)` when `datalen != 0`

A wrapped `datalen` causes the block layer to reference memory far
beyond the 128 KiB chunk page → **kernel OOB access, potential crash or
information disclosure**.

**Trigger:** Remote RDMA client on the fabric (not arbitrary
unprivileged local users, but a real remote attacker for RNBD/RTRS
deployments).

### Step 5.5: Similar patterns
**Record:** Same file already has `off >= max_chunk_size` check in
`rtrs_srv_rdma_done()` and `plist->length > max_chunk_size` check in
`rdma_write_sg()` (5a45d0aa1fa50). This patch closes the missing
validation on `usr_len` vs `off`.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at lines 1059–1060 and 1112–1113:

```1059:1063:drivers/infiniband/ulp/rtrs/rtrs-srv.c
        usr_len = le16_to_cpu(msg->usr_len);
        data_len = off - usr_len;
        data = page_address(srv->chunks[buf_id]);
        ret = ctx->ops.rdma_ev(srv->priv, id, data, data_len,
                           data + data_len, usr_len);
```

Bug present since 9cb837480424 (2020); not introduced after 6.18 branch.

### Step 6.2: Backport complications
**Record:** Clean apply verified (`git apply --check` exit 0). No
structural refactoring conflicts in this area. Minor context difference:
error messages in current tree use `%d` instead of `%pe` for errors —
unrelated to this hunk.

### Step 6.3: Related fixes already present?
**Record:** The **5a45d0aa1fa50** `rdma_write_sg` bound fix is present.
The **usr_len underflow fix is NOT** present. No duplicate fix found via
grep/log.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/infiniband/ulp/rtrs/` — RDMA transport layer;
server module (`CONFIG_INFINIBAND_RTRS_SERVER`) used by RNBD server.
**IMPORTANT** for RDMA block-export deployments; not universal like
mm/net core, but security-critical for those users.

### Step 7.2: Activity
**Record:** Active maintenance in 6.18.y — multiple rtrs-srv fixes in
recent history including security-related bounds checking.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Systems with `CONFIG_INFINIBAND_RTRS_SERVER` loaded
(typically via `rtrs_srv` / `rnbd-srv` modules) exposed to RDMA network
peers.

### Step 8.2: Trigger conditions
**Record:** Malicious or buggy RTRS client sends I/O message with
`usr_len > off`. `off` can be as small as 0; `usr_len` is `u16` (up to
65535). **Easily triggerable** by a connected peer.

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds memory access via oversized `datalen` passed
to `rdma_ev` → potential **kernel crash, memory corruption, or
information disclosure**. **Severity: CRITICAL/HIGH** (security-relevant
remote attack on RDMA server).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — closes exploitable remote integer-underflow → OOB
  path
- **Risk:** VERY LOW — 8 lines of validation per function, no API
  changes
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real security bug: unsigned underflow → huge length → OOB in `rdma_ev`
  callback
- Verified vulnerable code exists in 6.18.44 since rtrs server inception
  (2020)
- Small, surgical, applies cleanly
- Reviewed/acked by subsystem maintainer, signed off by RDMA maintainer
- Same subsystem already received a related OOB fix (5a45d0aa1fa50) in
  this tree
- Fix also prevents ref leak on error path (correct placement before
  `get_ops_ids`)

**AGAINST backport:**
- Affects only RTRS server users (niche vs whole kernel) — but those
  users face real remote attack surface
- Mailing-list thread content unverified (does not weaken technical
  case)

**UNRESOLVED:**
- Full lore/kernel.org discussion not accessible (403/bot wall)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — simple bounds check;
   reviewed by maintainer
2. Fixes real bug affecting users? **PASS** — remote peer can trigger
   OOB via crafted `usr_len`
3. Important issue? **PASS** — security / OOB memory access (CRITICAL
   for affected deployments)
4. Small and contained? **PASS** — one file, ~16 lines
5. No new features/APIs? **PASS** — input validation only
6. Can apply to local tree? **PASS** — `git apply --check` succeeded

### Step 9.3: Exception categories
**Record:** None of the special exceptions (device ID, quirk, DT, build,
docs). This is a straight security bug fix.

### Step 9.4: Decision rationale
For **6.18.44**, the vulnerable code is present, the bug has existed
since the rtrs server was added, a remote RDMA client can trigger
integer underflow leading to out-of-bounds memory access in the
`rdma_ev` path (including RNBD block I/O), and the fix is minimal with
negligible regression risk. This meets all stable-kernel criteria for a
security fix.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 1] Identified Reported-by, Reviewed-by, Acked-by, Link tags
- [Phase 2] Read current `rtrs-srv.c` lines 1027–1135; confirmed
  vulnerable `data_len = off - usr_len` pattern
- [Phase 2] Confirmed `usr_len` is `size_t`, `off` is `u32` — unsigned
  underflow verified by type inspection
- [Phase 3] `git blame -L 1055,1065`: buggy code from 9cb837480424
  (2020-05-11)
- [Phase 3] `git merge-base --is-ancestor 9cb837480424 HEAD`: buggy
  commit is in tree
- [Phase 3] `git log --oneline -20 -- drivers/infiniband/ulp/rtrs/rtrs-
  srv.c`: related security fix 5a45d0aa1fa50 present; underflow fix
  absent
- [Phase 3] `git apply --check` with provided diff: exit 0 (clean apply)
- [Phase 4] WebFetch Link URL: blocked by Anubis — **UNVERIFIED** thread
  content
- [Phase 4] curl lore.kernel.org: 403 — **UNVERIFIED** stable-list
  discussion
- [Phase 4] `b4 dig -c`: not run — commit not in checkout
- [Phase 5] Traced call chain: `rtrs_srv_rdma_done` → `process_io_req` →
  `process_read`/`process_write`
- [Phase 5] Verified `off >= max_chunk_size` check at line 1273 does not
  cover `usr_len`
- [Phase 5] `grep rtrs_srv_open`: only `rnbd-srv.c` uses server; traced
  to `bio_add_virt_nofail(bio, data, datalen)`
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] `make kernelversion`: 6.18.44
- [Phase 6] Grep confirmed fix NOT applied; vulnerable code at
  1059–1060, 1112–1113
- [Phase 7] Kconfig: `CONFIG_INFINIBAND_RTRS_SERVER` tristate module
- [Phase 8] `DEFAULT_MAX_CHUNK_SIZE` = 128 KiB; chunk is fixed-size page
  — OOB impact confirmed

**YES**

 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 1fc67fdff9fc2..12a9a888fe0ee 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1049,6 +1049,11 @@ static void process_read(struct rtrs_srv_con *con,
 			    "Processing read request failed, invalid message\n");
 		return;
 	}
+	usr_len = le16_to_cpu(msg->usr_len);
+	if (usr_len > off) {
+		pr_debug("rtrs-srv: Invalid usr_len %zu > off %u\n", usr_len, off);
+		return;
+	}
 	rtrs_srv_get_ops_ids(srv_path);
 	rtrs_srv_update_rdma_stats(srv_path->stats, off, READ);
 	id = srv_path->ops_ids[buf_id];
@@ -1056,7 +1061,6 @@ static void process_read(struct rtrs_srv_con *con,
 	id->dir		= READ;
 	id->msg_id	= buf_id;
 	id->rd_msg	= msg;
-	usr_len = le16_to_cpu(msg->usr_len);
 	data_len = off - usr_len;
 	data = page_address(srv->chunks[buf_id]);
 	ret = ctx->ops.rdma_ev(srv->priv, id, data, data_len,
@@ -1102,6 +1106,11 @@ static void process_write(struct rtrs_srv_con *con,
 			     rtrs_srv_state_str(srv_path->state));
 		return;
 	}
+	usr_len = le16_to_cpu(req->usr_len);
+	if (usr_len > off) {
+		pr_debug("rtrs-srv: Invalid usr_len %zu > off %u\n", usr_len, off);
+		return;
+	}
 	rtrs_srv_get_ops_ids(srv_path);
 	rtrs_srv_update_rdma_stats(srv_path->stats, off, WRITE);
 	id = srv_path->ops_ids[buf_id];
@@ -1109,7 +1118,6 @@ static void process_write(struct rtrs_srv_con *con,
 	id->dir    = WRITE;
 	id->msg_id = buf_id;
 
-	usr_len = le16_to_cpu(req->usr_len);
 	data_len = off - usr_len;
 	data = page_address(srv->chunks[buf_id]);
 	ret = ctx->ops.rdma_ev(srv->priv, id, data, data_len,
-- 
2.53.0

