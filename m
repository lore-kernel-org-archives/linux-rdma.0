Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18691547044;
	Mon, 19 Oct 2026 13:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418335; cv=none; b=nECTVgaTs1ZMFr+m6JYAbEsQyXo7gxOGQVdv9Jm23Axv6cjXPnNTUmEaZMMSXSg6BFaJs4+kzW3HxHkmu3SoJr3uNcGUE7EE8DLOjJOc6pKYg0ueJEaRS8Tq5NQZx019AQsU0dSbkhh/GqqGQGtve8qPK6A275Ad5MHDazXo2EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418335; c=relaxed/simple;
	bh=z5+yV6p2UdHxc0LaFhndBT9wDeMvzRixGrSkw4u3g2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KeSfGEF4sGHkYnlnmeLSqlj4DzxxTBc9eqy+9rwncRlG0die7/dVb491QSWInis6fWexWVGk/iPq8DnU1dPf6MnP+PBI8KgWAGSX9ILgjcXGE8nXL6Ok08VwJGH0sbmi4DE/ptHs8L1xQOTwZM0k9jN4sPzsqYMalC/nTEg43ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HVghDEdE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HVghDEdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44261F000C9;
	Mon, 19 Oct 2026 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418332;
	bh=cgxF869cyePwmld8Yhh0fz0txkbff9KE2BCTMD9tIWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVghDEdEOxFODcvF4BdWOjVQTJxJ0S5DDDByvECpNobjj6nBtvmy+P1Sc/M1F+TkM
	 mC60hp+FsEMbcM9QR8CPa6FWXbJJJaw77Xgev6DzBgOP4n5InxYNBobpi0xfWrUCnC
	 IoGEDbr4x8BPesr7HMSwlaqFAaBBsyItf9+0yNlIM/yeAmhcRYWFYIyhtnU+ioUUxs
	 /85En3onz0ePxIBYsda26NVtfwVPtPmk8h/NeAI/qbFKusroIUujA+JWaNM6UKYLF2
	 LomFUJEHpZZG3K727w+Hm2vZ3Y1e1NUjAwlEy0jsVhviXlRSL2E+x9PZDgOGf2ZGpU
	 5iFNDvHp2CG6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net/rds: unpin MR pages with unpin_user_pages_dirty_lock()
Date: Mon, 19 Oct 2026 09:47:43 -0400
Message-ID: <20261019135441.1420968-172-sashal@kernel.org>
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

From: Allison Henderson <achender@kernel.org>

[ Upstream commit a507023e6ff1d0b4e7aac49b2f547fed0c21ea4e ]

The pages backing an RDS memory region are pinned in __rds_rdma_map()
with rds_pin_pages(), which uses pin_user_pages_fast(): each page's
refcount is biased by GUP_PIN_COUNTING_BIAS to account the pin.  The
scatterlist is then handed to the IB transport, and the transport
releases the pages in __rds_ib_teardown_mr() with

	set_page_dirty(page);
	put_page(page);

put_page() drops a single reference instead of removing the pin bias,
so every MR teardown permanently strands the remaining references and
the pages are never freed - a userspace-triggerable memory leak of up
to RDS_MAX_MSG_SIZE per RDS_GET_MR/RDS_GET_MR_FOR_DEST call.

The conversion to the pin API updated the unpin sites in rdma.c but
missed this one on the transport side.  Release the pages with
unpin_user_pages_dirty_lock(), which removes the pin bias and also
dirties the page under the folio lock, closing the truncation race
that a bare set_page_dirty() leaves open.

Dirtying under the folio lock can sleep, which is safe in every path
that reaches __rds_ib_teardown_mr(): the registration-reuse path
(rds_ib_map_frmr()) runs in syscall context, and the pool flush
(rds_ib_unreg_frmr()) runs under pool->flush_lock, a mutex, and
already sleeps in rds_ib_post_inv().  The WARN_ON that guarded the
old irq-context set_page_dirty() case is dropped along with it.

Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260730041629.3512480-5-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **5.10.270** (`pending-5.10`). The buggy RDS IB
teardown path is present here, the pin API mismatch is real, and the fix
applies cleanly.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[net/rds] [unpin] [release MR pages with the pin-API unpin
helper instead of put_page()]**

Subsystem prefix `net/rds`. Action verb is `unpin` (correctness of page
release, not a feature). Claimed intent: MR pages pinned with
`pin_user_pages_fast()` must be released with
`unpin_user_pages_dirty_lock()`, not `put_page()`.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

From the candidate message:
- `Signed-off-by: Allison Henderson <achender@kernel.org>` (author;
  Oracle RDS)
- `Link:
  https://patch.msgid.link/20260730041629.3512480-5-achender@kernel.org`
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev merge)
- No `Reported-by`, `Tested-by`, `Reviewed-by`, `Acked-by`, `Cc: stable`
  in the candidate text

From the original lore submission (msgid
`20260730041629.3512480-5-achender@kernel.org`), these additional tags
were present and stripped by candidate prep:
- `Fixes: 0d4597c8c5ab ("net/rds: Track user mapped pages through
  special API")`
- `Assisted-by: Claude-Code:claude-fable-5`

Record: Author is the RDS contributor who submitted a 4-patch bug-fix
series. Netdev maintainer merged it. Original submission carried a
`Fixes:` tag pointing at the 2020 pin-API conversion. Absence of `Cc:
stable` on the candidate is expected.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `__rds_rdma_map()` pins pages with `rds_pin_pages()` →
  `pin_user_pages_fast()`. Teardown in `__rds_ib_teardown_mr()` does
  `set_page_dirty()` + `put_page()`. `put_page()` drops one ref; a
  FOLL_PIN pin adds `GUP_PIN_COUNTING_BIAS` (1024). Remaining refs are
  stranded.
- **Symptom:** Userspace-triggerable unreclaimable page leak, up to
  `RDS_MAX_MSG_SIZE` (1 MiB) per `RDS_GET_MR` / `RDS_GET_MR_FOR_DEST`.
  Same leak on every MR reuse/flush, not only the ioctl.
- **Root cause:** Pin-API conversion updated `net/rds/rdma.c` unpin
  sites and missed the IB transport teardown path.
- **Secondary fix:** `unpin_user_pages_dirty_lock()` dirties under the
  page/folio lock, closing the truncation race of bare
  `set_page_dirty()`.
- **Sleeping:** Author claims every caller of `__rds_ib_teardown_mr()`
  is process context (syscall reuse path, or pool flush under
  `flush_lock` mutex which already `wait_event`s in
  `rds_ib_post_inv()`).
- **Version info:** Bug introduced by the 2020 pin conversion
  (`0d4597c8c5ab`).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. Explicit memory-leak fix with a clear pin vs put
mismatch. Not cleanup/refactor.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `net/rds/ib_rdma.c` only (−3 / +1)
- Function: `__rds_ib_teardown_mr()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: In the scatterlist-release loop, before: `WARN_ON(!page->mapping
&& irqs_disabled()); set_page_dirty(page); put_page(page);`. After:
`unpin_user_pages_dirty_lock(&page, 1, true);`. DMA unmap,
`kfree(ibmr->sg)`, and pool accounting in `rds_ib_teardown_mr()` are
unchanged. Normal teardown path, not an error-only path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** reference-counting / resource leak (FOLL_PIN bias not
  removed), plus initialization/dirtying correctness
  (`set_page_dirty_lock` vs `set_page_dirty`)
- **Mechanism:** `pin_user_pages_fast()` sets `FOLL_PIN` and bumps
  refcount by `GUP_PIN_COUNTING_BIAS`. `put_page()` subtracts 1, leaving
  1023 refs. Pages never return to the allocator. `unpin_user_page()` /
  `unpin_user_pages_dirty_lock()` call `put_compound_head(...,
  FOLL_PIN)`, which multiplies refs by the bias (or uses
  `hpage_pincount_sub`) and actually releases the pin.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct against the pin-API contract (`mm/gup.c`
documents that FOLL_PIN pages must be released via `unpin_user_page()`).
Same helper is already used in this tree in `net/rds/rdma.c` and
`net/rds/info.c`. Minimal. Regression risk is sleep-in-atomic if
teardown ever runs with IRQs off; verified callers already sleep
(`wait_event` / `mutex_lock`). The dropped `WARN_ON` was a leftover from
a 2015 `BUG_ON(irqs_disabled())` downgrade; current callers take a mutex
or run in syscall context.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- `set_page_dirty` + `put_page` in this function: `08b48a1ed84b19` (Andy
  Grover, 2009) — originally paired with `get_user_pages`.
- `WARN_ON(!page->mapping && irqs_disabled())`: `5c240fa2ab394a` (2015),
  downgraded from `BUG_ON(irqs_disabled())` because that assertion fired
  on “normal execution paths” (FMR-era). FMR support is already removed
  in this tree (`07549ee21ce52`).
- Pin conversion that made `put_page` wrong: `0d4597c8c5abd`
  (2020-02-16), present in this tree.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: `0d4597c8c5abdeeaf50774066c16683f30184dc8` (“net/rds: Track user
mapped pages through special API”) converted `rds_pin_pages()` to
`pin_user_pages_fast()` and updated unpin sites in `rdma.c` only
(`rds_rdma_free_op`, `rds_atomic_free_op`, error paths). It did **not**
touch `ib_rdma.c`. `git merge-base --is-ancestor 0d4597c8c5abd HEAD`
succeeded — the buggy conversion is in this 5.10 tree. Intermediate
related fix already here: `91a44b406bc1f` (“net: rds: fix MR cleanup on
copy error”) — different bug (double-unpin on `put_user` failure), not a
substitute for this leak.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `net/rds/ib_rdma.c` history is unrelated (laddr check,
FRMR reject, null deref). This is standalone vs local history. Upstream
it is v4 4/4 of Allison Henderson’s series; patches 1–3 fix different
RDS bugs (sleeping unpin from tasklet in `rdma.c`, socket UAF via MR,
send-path message leak) and are **not** prerequisites for this hunk.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Allison Henderson has many RDS commits in this tree (locking,
shutdown, zerocopy). Oracle RDS maintainer-side contributor.
`MAINTAINERS` lists Santosh Shilimkar; Allison is a long-time RDS
author. Related contemporaneous work is the rest of the v4 series, not a
dependency of this patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Needs `unpin_user_pages_dirty_lock()` and
`pin_user_pages_fast()` — both exist in 5.10 (`mm/gup.c`,
`EXPORT_SYMBOL`). No new helper, no struct change. Can apply standalone.
`git apply --check` succeeded (hunk offset +4 only).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- Lore/thread via `b4 am` / `b4 mbox`: cover `https://patch.msgid.link/2
  0260730041629.3512480-1-achender@kernel.org`
- Patch: msgid `20260730041629.3512480-5-achender@kernel.org` (`[PATCH
  net v4 4/4]`)
- Openwall mirror: https://lists.openwall.net/netdev/2026/07/30/66
- Revisions: v1–v3 were a 3-patch series; **this leak fix is new in
  v4**. Applied version is v4.
- Merged to `netdev/net-next.git` as `a507023e6ff1` (patchwork-bot,
  2026-08-05)
- Jakub Kicinski: not a NAK — he said he lacked confidence reviewing RDS
  and queued the series for **-next** rather than `net`. Allison agreed
  (Fixes tags, but “not simple bugs” / “really old bugs”).
- No reviewer NAK, no request to drop patch 4, no flag that teardown can
  sleep in IRQ on current code.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: `b4` recipients: netdev, linux-rdma, Pabeni, Edumazet, Kicinski,
Horms; Cc John Hubbard and Leon Romanovsky (original pin-API authors).
No `Reviewed-by` landed. Kicinski merged without a deep RDS review.
Technical correctness of this hunk does not depend on that: it matches
the pin API the Cc list designed.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla. Bug is from code inspection / UEK porting.
Trigger is real (`setsockopt(RDS_GET_MR)` / MR reuse), not theoretical.
No user-count from public reports.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone vs 1/4–3/4. Patch 1 is about `rds_rdma_free_op()`
sleeping from the **send tasklet** — a different function already using
`unpin_user_pages_dirty_lock()` in `rdma.c`. Backporting 4/4 does not
require 1/4; it does not widen that tasklet bug.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search for this subject returned no
discussion that this fix was rejected or already taken. UNVERIFIED that
no private stable thread exists.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `__rds_ib_teardown_mr()` (changed); `rds_ib_teardown_mr()`
(wrapper); `rds_ib_map_frmr()`, `rds_ib_unreg_frmr()` (callers).

**Step 5.2: TRACE CALLERS**

Record:
- `rds_ib_map_frmr()` → `rds_ib_teardown_mr()` — reuse/remap. Called
  from `rds_ib_reg_frmr()` → `rds_ib_get_mr()` → `__rds_rdma_map()` /
  cmsg RDMA map. Syscall (`setsockopt` / `sendmsg`). Already
  `wait_event`s in `rds_ib_post_reg_frmr()`.
- `rds_ib_unreg_frmr()` → `__rds_ib_teardown_mr()` — only from
  `rds_ib_flush_mr_pool()`, which takes `pool->flush_lock` (mutex).
  Callers of flush: delayed work `rds_ib_mr_pool_flush_worker`,
  `rds_ib_try_reuse_ibmr` (GFP_KERNEL alloc path), `rds_ib_free_mr` only
  if `!in_interrupt()`, `rds_ib_flush_mrs()` (socket close /
  `RDS_FREE_MR`), `rds_ib_destroy_mr_pool()`,
  `rds_ib_conn_path_shutdown()` (already `wait_event_timeout`).
  Interrupt `free_mr` queues `flush_worker` instead of flushing inline.

**Step 5.3: TRACE CALLEES**

Record: After the change, the loop calls `unpin_user_pages_dirty_lock()`
→ `set_page_dirty_lock()` (can sleep) + `unpin_user_page()`. Previously
`set_page_dirty()` + `put_page()`. DMA unmap stays first.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Reachable from userspace: `rds_setsockopt` → `RDS_GET_MR` /
`RDS_GET_MR_FOR_DEST` → `rds_get_mr()` → `__rds_rdma_map()` →
`rds_pin_pages()` → transport `get_mr`. Also RDMA cmsg on send. Requires
`CONFIG_RDS=y/m`, `CONFIG_RDS_RDMA`, InfiniBand, and `can_do_mlock()`.
Not universal, but a real syscall path. Unprivileged users typically
need `RLIMIT_MEMLOCK`/CAP_IPC_LOCK to pin; RDS/IB cluster users have
that.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same missed-unpin class was why `rdma.c` was converted in 2020.
Remaining `put_page` in `net/rds/message.c` is for message payload pages
(`__free_page` / zerocopy), not FOLL_PIN MR pages. IB umem/qib/hfi1
already use `unpin_user_pages_dirty_lock()`. This is the leftover RDS IB
MR site.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes. `net/rds/ib_rdma.c` lines 253–260 still have `WARN_ON` +
`set_page_dirty` + `put_page`. `rds_pin_pages()` already uses
`pin_user_pages_fast()` (`net/rds/rdma.c:163`). `GUP_PIN_COUNTING_BIAS`
is `(1U << 10)` in `include/linux/mm.h`. Bug present since this series
branched (v5.10 includes `0d4597c8c5ab` from Feb 2020; v5.10 release is
Dec 2020).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** (`git apply --check`: hunk succeeded at offset
4). Surrounding function matches the mainline hunk. 5.10’s
`unpin_user_pages_dirty_lock()` uses `set_page_dirty_lock()`, not
folios; the public API and sleep/lock properties match what the patch
needs. Commit-message “folio lock” is mainline wording; behavior here is
the page lock, which is correct for 5.10.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No equivalent unpin in `__rds_ib_teardown_mr()`. `91a44b406bc1f`
is a different MR cleanup. `git log --grep='unpin MR pages' -- net/rds`
is empty in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **net/rds** (Reliable Datagram Sockets), IB RDMA MR pool.
Criticality: **IMPORTANT** for RDS/IB users (Oracle RAC-style clusters);
**PERIPHERAL** for everyone else (`CONFIG_RDS_RDMA` + InfiniBand). Not
core mm/VFS, but pinned-page leaks are mm-visible (unreclaimable pages).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature. The teardown loop dates to 2009; the pin mismatch has
been wrong for the entire 5.10 lifetime. Low churn on `ib_rdma.c`
relative to netdev core.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: Driver/config-specific: `CONFIG_RDS` + `CONFIG_RDS_RDMA` + IB
hardware. TCP RDS (`CONFIG_RDS_TCP`) has no RDMA MRs and is unaffected.

**Step 8.2: TRIGGER CONDITIONS**

Record: Common for RDS RDMA: every MR map/reuse/teardown (`RDS_GET_MR`,
RDMA cmsg, pool flush). Not a rare error path. Needs mlock capability.
Not a timing race.

**Step 8.3: FAILURE MODE SEVERITY**

Record: Unreclaimable page leak (pin bias left behind). Repeated
GET_MR/reuse can pin large amounts of RAM until OOM. **Severity: HIGH**
(not a panic, but a userspace-triggerable leak of pinned pages; same
class as other GUP pin leaks taken into stable). Secondary: dirty-
without-lock truncation race on file-backed MRs (**MEDIUM** on that
subset).

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** High for RDS/IB; stops a leak that has existed for the
  whole 5.10 life. Zero functional change for other configs.
- **Risk:** Very low — one call-site, existing exported helper, callers
  already sleepable. Does not add APIs or change userspace.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real FOLL_PIN vs `put_page()` leak; verified in 5.10 `mm/gup.c` and
  `net/rds/rdma.c`/`ib_rdma.c`
- Userspace-reachable (`RDS_GET_MR` / RDMA map)
- Fixes commit `0d4597c8c5ab` is in this tree
- 1-file, 4-line change; `unpin_user_pages_dirty_lock()` already used
  elsewhere in RDS here
- Applies cleanly
- Author is RDS; merged by netdev
- Sleeping unpin is safe on verified 5.10 call chains

**AGAINST:**
- RDS/IB is not a universal path
- Kicinski did not deeply review and put the series in net-next
- No public crash/syzbot report
- Series mates 1–3 are separate bugs (not blockers)

**UNRESOLVED:** No stable@ thread found; WebFetch to lore HTML returned
403 (thread recovered via `b4` + openwall + curl).

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — pin-API contract; same
   helper already in-tree RDS; merged to net-next
2. Fixes a real bug that affects users? **PASS** — pinned pages never
   freed on MR teardown
3. Important (crash/security/corruption/deadlock)? **PASS** —
   unreclaimable leak on a hot RDS RDMA path, up to 1 MiB per map plus
   reuse; eventual OOM
4. Small and contained? **PASS** — one function, −3/+1
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check` clean;
   helpers present

**Step 9.3: EXCEPTION CATEGORIES**

Record: None. Ordinary bug fix (not ID/quirk/DT/build/docs).

**Step 9.4: DECISION**

This is a small, obviously correct leak fix for a bug that has been in
this 5.10 tree since day one. It does not need the rest of the v4
series. Benefit for RDS/IB users outweighs the low regression risk.

---

### What the commit solves for this tree

`rds_pin_pages()` already pins with `pin_user_pages_fast()` (`FOLL_PIN`,
+1024 refs). IB teardown still `put_page()`s once, so every MR teardown
permanently leaks those pages. Replacing that with
`unpin_user_pages_dirty_lock()` restores the pin/unpin pairing and
dirties under the page lock. That matters to 5.10 RDS-over-InfiniBand
users (clusters using `RDS_GET_MR` / RDMA ops): memory is not optional
reclaim, it is stuck until reboot.

### Risk vs benefit

Benefit is a real, repeating leak on a syscall-visible path. Risk is a
one-line helper swap on paths that already take a mutex and
`wait_event`. The patch applies without rework.

---

### Verification

- [Phase 1] Parsed candidate tags: Allison Henderson SOB, msgid.link,
  Kicinski SOB; lore copy also has `Fixes: 0d4597c8c5ab`
- [Phase 2] Diff: `__rds_ib_teardown_mr()` in `net/rds/ib_rdma.c`,
  replace WARN/`set_page_dirty`/`put_page` with
  `unpin_user_pages_dirty_lock(&page, 1, true)`
- [Phase 3] `git describe`/Makefile: local tree **5.10.270**, branch
  `pending-5.10`
- [Phase 3] `git blame`: put_page since 2009; WARN_ON from
  `5c240fa2ab394a` (2015)
- [Phase 3] `git show 0d4597c8c5abd`: pin conversion of `rdma.c` only;
  `git merge-base --is-ancestor` → in HEAD
- [Phase 3] `git show dbfe7d74376e1`: only `info.c`, not this leak
- [Phase 3] Read `mm/gup.c`: `pin_user_pages_fast()` sets `FOLL_PIN`;
  `unpin_user_pages_dirty_lock()` / `put_compound_head(..., FOLL_PIN)`
  apply `GUP_PIN_COUNTING_BIAS` (1024)
- [Phase 3] Read local `net/rds/rdma.c` `rds_pin_pages()` and
  `ib_rdma.c` teardown: mismatch confirmed
- [Phase 4] `b4 am`/`b4 mbox`: v4 4/4 series; merged as `a507023e6ff1`;
  Kicinski queued for net-next; no NAK
- [Phase 4] Openwall https://lists.openwall.net/netdev/2026/07/30/66
  matches the diff
- [Phase 4] lore HTML WebFetch: 403; thread recovered via b4
- [Phase 5] Callers: `rds_ib_map_frmr` (syscall), `rds_ib_unreg_frmr`
  via `rds_ib_flush_mr_pool` (mutex + workqueue); `rds_ib_free_mr`
  defers flush when `in_interrupt()`
- [Phase 5] `RDS_MAX_MSG_SIZE` = 1 MiB in `net/rds/rds.h`
- [Phase 6] Buggy code present at `ib_rdma.c:258-260`; `git apply
  --check` succeeded
- [Phase 6] `unpin_user_pages_dirty_lock` already used in
  `net/rds/rdma.c` and `net/rds/info.c`
- [Phase 7] `MAINTAINERS`: RDS supported (Santosh Shilimkar / Oracle)
- [Phase 8] Failure mode: unreclaimable FOLL_PIN leak, HIGH for RDS_RDMA
- UNVERIFIED: no public syzbot/user report; no stable@ thread found

**YES**

 net/rds/ib_rdma.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 751755cd069e0..36fd8dedbce56 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -251,9 +251,7 @@ void __rds_ib_teardown_mr(struct rds_ib_mr *ibmr)
 
 			/* FIXME we need a way to tell a r/w MR
 			 * from a r/o MR */
-			WARN_ON(!page->mapping && irqs_disabled());
-			set_page_dirty(page);
-			put_page(page);
+			unpin_user_pages_dirty_lock(&page, 1, true);
 		}
 		kfree(ibmr->sg);
 
-- 
2.53.0

