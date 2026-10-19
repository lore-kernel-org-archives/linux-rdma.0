Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CC55BA3AF;
	Mon, 19 Oct 2026 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418454; cv=none; b=lzembIa0bsrIqoHPfw6a+BWsIDqf3tbyqkorImTis2P3VjTC+oF+o/CACn7Z6EwVziL4msoAy4X3ffvzmgzsXfx7SvBvLSN76sOBslYQMOft3IcCaWHLnzyhXRRcKGnEBmgBRDi+8PrPl5eTJEn9ghwI+ZQ1xI343nLlyO1lda8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418454; c=relaxed/simple;
	bh=5no7e+H7WYHDdz+1w0HDK0z71uH03BSsEBrRvk1I8AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VYqIOMjvHdDp5JLqxVntBRc5H3D2lLZtUHIKe18EPh/Q3F4NLmjGyRDqwb1UBaD3476Uv7+p42Nt61q+WhPnLOwdmVAqdgadi32La9TIZKz9E5C3FRnRyjqrEuFf15F6NqYttoB6ghOkK/hqT0GPpv+VzDqama1RudHYLwlBj6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5W85yyf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5W85yyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CD01F000C7;
	Mon, 19 Oct 2026 14:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418451;
	bh=SJFwWmYUbL4dju6SdY/KrJstjd8qjA4jgvDPm2aNnm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5W85yyfyXZE1M73pqOgM+2vlmi93yNA87LHD4FJCxkzTYdR1aTF6RUlSk7D0DSYe
	 8x65Pz//Yf6FiLS9BJmyURpOPAHH+7ocdGYPQjNdi15WWrYAbcIYv+/bn1twPhHuAp
	 QJJ2GOdv9OFJobnXXqCQFQdX03UtIrS6fdE7wadaItrr9Z+ZdIH0lYb9wsYQpvHp81
	 MPrw72skq+8Ht/Y/iPH2IC5/gkGMuJAaJxQYbNFwkhQXJ7p5h8OdctXTyuGomlUwUJ
	 DLe68ClmaROMgRGTb0wHmUEIAiRV0O9tKgXg6RoOxyWJ0HQvJnMDIZ1mQLsluEZ+Si
	 8JYIn73l2VinA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sharath Srinivasan <sharath.srinivasan@oracle.com>,
	Gerd Rausch <gerd.rausch@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net/rds: fix rds_message leak in the rds_send_xmit() drop path
Date: Mon, 19 Oct 2026 09:49:09 -0400
Message-ID: <20261019135441.1420968-258-sashal@kernel.org>
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

From: Sharath Srinivasan <sharath.srinivasan@oracle.com>

[ Upstream commit eb8a59a17f4a8b6f2afb4a8063e99dd96cc3fab0 ]

When rds_send_xmit() picks the next message off cp_send_queue it takes
its own reference with rds_message_addref().  If the message then hits
the never-retransmit check (RDS_MSG_FLUSH, or an RDMA op that was
already retransmitted), it is moved to the local to_be_dropped list and
that reference is dropped after the batch.

However, if RDS_MSG_ON_CONN has already been cleared, the message is
not added to to_be_dropped and the reference taken above is never
dropped: cp_xmit_rm has not been set at this point, so the loop simply
abandons rm and the rds_message (and everything it pins: pages, MRs,
notifiers) leaks after an RDMA error.

The only other places that clear RDS_MSG_ON_CONN are
rds_send_path_drop_acked() and rds_send_drop_to(), and both can run
while rds_send_xmit() has dropped cp_lock between moving the message
to cp_retrans and re-taking the lock in the never-retransmit check:
rds_send_path_drop_acked() can ack away a message that already sat on
cp_retrans - the RDS_MSG_RETRANSMITTED case above - and
rds_send_drop_to() runs on socket close.  Both unlink the message
under cp_lock and put their own reference, leaving the xmit-path
reference stranded.

Drop the reference directly in that case.

This mirrors Oracle UEK commit "net/rds: fix rds_message memleak in
rds_send_xmit".

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
[achender: port to net-next; update commit message, checkpatch nits]
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260730041629.3512480-4-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real, long-standing `rds_message` leak in `rds_send_xmit()`
that exists in this 5.10.270 tree. The fix is small, matches the local
code, and does not need the rest of its series.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[net/rds] [fix] [rds_message leak in rds_send_xmit() drop
path]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

From the candidate message:
- `Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>` (original
  author)
- `Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>`
  (UEK/port author)
- `[achender: port to net-next; update commit message, checkpatch nits]`
- `Signed-off-by: Allison Henderson <achender@kernel.org>` (RDS
  maintainer-side porter)
- `Link:
  https://patch.msgid.link/20260730041629.3512480-4-achender@kernel.org`
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev merge)

No `Reported-by`, `Tested-by`, `Reviewed-by`, or `Acked-by` in the
candidate text. Absence of `Fixes:` / `Cc: stable` is expected here.

Mailing-list v4 (same msgid) **did** carry:
- `Fixes: 2ad8099b58f2 ("RDS: rds_send_xmit() locking/irq fixes")`

Oracle UEK source (`94549e4732d8`) carried:
- `Fixes: fbbe0610d057 ("RDS: add support for atomic messages over the
  wire")` — that SHA is **not** in this tree
- `Reviewed-by: William Kucharski <william.kucharski@oracle.com>`
- `Orabug: 38923495` (internal production bug)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `rds_send_xmit()` takes an extra `rds_message_addref()` when
  dequeuing. On the never-retransmit path (`RDS_MSG_FLUSH` or already-
  retransmitted RDMA), that ref is only dropped if the message is moved
  onto `to_be_dropped`. If `RDS_MSG_ON_CONN` was already cleared, the
  extra ref is abandoned.
- **Symptom:** leak of `rds_message` plus pinned pages, MRs, and
  notifiers after an RDMA error / reconnect / socket close.
- **Root cause:** `rds_send_path_drop_acked()` (ACK of a message already
  on `cp_retrans`) and `rds_send_drop_to()` (socket close) can clear
  `RDS_MSG_ON_CONN` and put **their** refs in the window where xmit has
  dropped `cp_lock`. They do not put the xmit-path extra ref.
  `cp_xmit_rm` is not set yet, so the success-path put never runs.
- **Version info:** bug traces to 2010 locking change; present in this
  5.10 tree.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** Subject and body are an explicit leak/refcount
fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `net/rds/send.c` only (~+12/−3 in `rds_send_xmit()`)
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `test_and_clear_bit(RDS_MSG_ON_CONN)` → if set,
  `list_move` to `to_be_dropped`; always unlock; `continue`. If the bit
  was already clear, no put.
- **After:** same if the bit is set; **else** unlock then
  `rds_message_put(rm)` for the extra xmit ref.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Reference-counting / resource leak.** Extra
`rds_message_addref()` at dequeue (local tree `net/rds/send.c:265`) is
not balanced when `RDS_MSG_ON_CONN` is already clear. Verified in this
tree: only `rds_send_path_drop_acked()` (`clear_bit` at line 707) and
`rds_send_drop_to()` (`test_and_clear_bit` at line 774) plus this drop
path itself clear that bit. `rds_send_path_reset()` does **not** (v4
commit message correction vs v1–v3).

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Obviously correct.** Queueing takes a conn-list ref
  (`rds_send_queue_rm` addref + `RDS_MSG_ON_CONN`). Xmit takes a second
  ref. Concurrent drop/ack puts the conn-list ref. Xmit must put its
  own.
- `rds_send_remove_from_sock()` documents that it puts the list-position
  ref; drop_acked uses that. Xmit’s extra ref is separate.
- After `continue`, the next loop iteration does `rm = cp->cp_xmit_rm`
  (still NULL), so the local pointer is not used after put.
- Put happens after `spin_unlock_irqrestore`, same as the existing
  success-path put at line 423. The “irqs on here, so we can put()”
  comment is about not putting **under** `cp_lock`.
- **Regression risk: low.** Does not change locking order or APIs.
  Follow-up `reinitialize to_be_dropped on restart` is documented
  hardening with **no known user-visible bug**; this else-path does not
  even enqueue on `to_be_dropped`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Drop-path structure from `5c11559046c4b3` (“RDS: send.c”, 2009).
- Leak introduced by `2ad8099b58f27` (“RDS: rds_send_xmit() locking/irq
  fixes”, 2010): that commit **removed** an unconditional
  `rds_message_put(rm)` on this path and only put messages that made it
  onto `to_be_dropped`.
- FLUSH clause: `905dd4184e0732` (2016). Multipath `cp_` conversion:
  `1f9ecd7eacfd9e` (2016).
- Buggy pattern has been in-tree for ~16 years; first appeared long
  before 5.10.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record:
- Mailing-list `Fixes: 2ad8099b58f2` — **is an ancestor of this HEAD**
  (`git merge-base --is-ancestor` exit 0).
- `git show 2ad8099b58f27` confirms the put was moved to the batch-end
  `to_be_dropped` walk only.
- UEK `Fixes: fbbe0610d057` is **not** in this tree (exit 128); that tag
  is a red herring for 5.10. The real introducer here is `2ad8099b58f2`.

**Step 3.3: CHECK FILE HISTORY**
Record: Recent `net/rds/send.c` work in this tree is locking/xmit
serialization (`acquire_in_xmit`, shutdown races), not this drop path.
No prior fix for this leak (`rg` for “already off the conn list” is
empty). **Standalone**, not a refactor prerequisite.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Gerd Rausch / Sharath Srinivasan / Allison Henderson are
established RDS contributors. Henderson has many RDS stable backports in
this tree. This is a UEK→upstream port of a production Orabug.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: v4 series is four **independent** bugs (sleep-in-atomic unpin,
MR socket UAF, **this leak**, IB MR pin leak). This hunk only needs
existing `rds_message_put()` / `RDS_MSG_ON_CONN` / `to_be_dropped`, all
present. **Applies standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c` on the candidate SHA was not possible (commit is not in
  this checkout). `b4 dig -c 5c11559046c4b3` only found the 2009
  original.
- lore.kernel.org fetches returned **403**. Used openwall mirrors.
- Thread: https://lists.openwall.net/netdev/2026/07/30/65 (v4 3/4),
  cover https://lists.openwall.net/netdev/2026/07/30/62
- Revisions: v1 (2026-07-11) → v3 → v4 (2026-07-30). **Code of this
  patch unchanged after v3**; v4 only corrected the commit message to
  name `drop_acked`/`drop_to` instead of `rds_send_path_reset()`.
- Merged by Jakub Kicinski. No NAK found.
- v1–v3 incorrectly named `rds_send_path_reset()` as a clearer of
  `RDS_MSG_ON_CONN`; verified **false** in this tree
  (`rds_send_path_reset` only sets `RDS_MSG_RETRANSMITTED` and splices
  queues).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Sent to netdev, linux-rdma, Kicinski, Dumazet, Abeni, Horms. RDS
lists historically include `rds-devel@oss.oracle.com`. No extra
`Reviewed-by` on the upstream version; UEK had William Kucharski.
Maintainer-side porter is Allison Henderson.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Oracle UEK Orabug 38923495; no public syzbot/bugzilla report
found. Production bug inside Oracle RDS, not theoretical.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Independent of series 1/4, 2/4, 4/4. Later “reinitialize
`to_be_dropped` on restart” is **hardening only** (“no user-visible bug
is known”).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search **403**; web search found **no**
stable-list discussion of this leak. UNVERIFIED whether anyone already
requested/rejected it for 5.10.y.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

semcode MCP is **not** available; used read/grep.

**Step 5.1: KEY FUNCTIONS**
Record: `rds_send_xmit()` only.

**Step 5.2: TRACE CALLERS**
Record (this tree):
- `rds_sendmsg()` → `rds_send_xmit()` (`send.c:1385`) — syscall
- `rds_send_worker()` (`threads.c:200`) — `rds_wq` work
- `rds_ib_tasklet_fn_send()` (`ib_cm.c:334`) — IB send tasklet

**Step 5.3: TRACE CALLEES**
Record: `rds_message_addref` / `rds_message_put` (`message.c`); last put
runs `rds_message_purge()` (pages, `rds_rdma_free_op`, MR krefs).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: **Userspace-reachable** via RDS `sendmsg`. Also on IB completion
and reconnect. Race: xmit drops `cp_lock` after moving to `cp_retrans`;
recv/ACK path (`rds_send_path_drop_acked`) or
`close`/`RDS_CANCEL_SENT_TO` (`rds_send_drop_to`) can run then.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same file already balances other refs carefully (`drop_to` skips
if `ON_CONN` already clear). This path is the missing counterpart. No
duplicate of this exact leak elsewhere in `net/rds/`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `pending-5.10`, `make kernelversion` = **5.10.270**,
`git describe` = `p-5.10-1-gce56b7a73b64b`.

```287:294:net/rds/send.c
                        if (test_bit(RDS_MSG_FLUSH, &rm->m_flags) ||
                            (rm->rdma.op_active &&
                            test_bit(RDS_MSG_RETRANSMITTED,
&rm->m_flags))) {
                                spin_lock_irqsave(&cp->cp_lock, flags);
                                if (test_and_clear_bit(RDS_MSG_ON_CONN,
&rm->m_flags))
                                        list_move(&rm->m_conn_item,
&to_be_dropped);
                                spin_unlock_irqrestore(&cp->cp_lock,
flags);
                                continue;
                        }
```

Introduced in 2010 (`2ad8099b58f2`); present for the entire 5.10
lifetime.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** (trivial fuzz at most). Local drop-path text
matches the hunk exactly. Nearby comment still has the old “We cold
possibly” typo; that line is context only.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Fix **not** present. No other send.c commit in this tree plugs
this hole.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **net/rds** — Reliable Datagram Sockets (Oracle RAC / InfiniBand
and TCP). MAINTAINERS: Supported (Santosh Shilimkar / Oracle).
**IMPORTANT** (not core mm/VFS; not staging). `CONFIG_RDS` depends on
`INET`; RDMA ops need `CONFIG_RDS_RDMA`.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Actively maintained in this 5.10 tree (recent shutdown/xmit
locking, TCP corruption, NULL-deref fixes). Mature send path; this leak
is old, not a new-feature bug.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **Config/driver-specific** — `CONFIG_RDS` users, especially
RDMA/IB reconnect and TCP peer-generation flush (`RDS_MSG_FLUSH` in
`recv.c`). Enterprise RDS/RAC deployments.

**Step 8.2: TRIGGER CONDITIONS**
Record:
1. Xmit dequeues a message (addref, move to `cp_retrans`, drop
   `cp_lock`).
2. Never-retransmit: `RDS_MSG_FLUSH` (peer gen change) or RDMA +
   `RDS_MSG_RETRANSMITTED` (after `rds_send_path_reset`).
3. Concurrent ACK (`drop_acked`) or socket close (`drop_to`) already
   cleared `ON_CONN`.

Not every packet; **error/reconnect/close**. Unprivileged RDS sockets
can drive send/close; RDMA/reconnect is the realistic production case
(Orabug).

**Step 8.3: FAILURE MODE SEVERITY**
Record: **Memory/resource leak** of message, pages, MRs, notifiers. Not
a panic. Repeated reconnects accumulate pinned memory → **HIGH** for RDS
users, not a universal crash.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for RDS/RDMA users; stops leaking pinned pages/MRs
  after errors that already happen in production.
- **Risk:** very low (~12 lines, one else-put, same pattern as existing
  puts).
- **Ratio:** favor backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real refcount leak; objects pin pages/MRs/notifiers
- Present in this 5.10 tree since 2010 (`2ad8099b58f2`)
- Small, obviously correct, one function
- Clean apply; no prerequisites
- RDS maintainer port; netdev merge; Oracle production Orabug
- Userspace-reachable via RDS send + close/reconnect

**AGAINST:**
- RDS is not universal
- Error-path race, not every send
- Not a crash/CVE
- No public syzbot report

**UNRESOLVED:**
- Stable-list history (lore 403)
- Whether last-ref `rds_message_put()` from IB **tasklet** can sleep via
  `unpin_user_pages_dirty_lock()` — **already true** for the success-
  path and `to_be_dropped` puts in this tree; this patch does not create
  that class of bug (series 1/4 is a separate sleep-in-atomic fix)

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — refcount math checks out;
   UEK + netdev merge
2. Real bug affecting users? **PASS** — Orabug 38923495; leak is in this
   tree
3. Important (crash/security/corruption/deadlock)? **PASS** — leak of
   pinned pages/MRs after RDMA error/reconnect; severity HIGH for RDS
4. Small and contained? **PASS** — ~12 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS**

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not an ID/quirk/DT/build/docs exception). Qualifies as a
normal leak/refcount fix.

**Step 9.4: DECISION**
Backport to **this** 5.10.270 tree. The buggy code is here, the fix is
surgical, and there is no missing prerequisite.

What it fixes for 5.10 users: after RDMA QP error / reconnect
(`RDS_MSG_RETRANSMITTED`) or peer generation flush (`RDS_MSG_FLUSH`),
racing ACK or socket close can clear `RDS_MSG_ON_CONN` in the xmit lock
gap. The extra `rds_message_addref()` is then never dropped, leaking the
message and everything it pins. Adding `rds_message_put(rm)` in that
else branch restores the balance `2ad8099b58f2` broke.

---

## Verification

- **[Phase 1]** Tags: SOBs Rausch/Srinivasan/Henderson/Kicinski; Link
  msgid `3512480-4`; ML `Fixes: 2ad8099b58f2`; UEK Orabug 38923495
- **[Phase 2]** Diff: else-branch `rds_message_put(rm)` in
  `rds_send_xmit()` never-retransmit path
- **[Phase 2]** Confirmed `rds_send_remove_from_sock()` puts the conn-
  list ref; xmit extra ref is separate (`send.c:605-674`)
- **[Phase 2]** Confirmed only drop_acked (707) and drop_to (774) plus
  this path clear `RDS_MSG_ON_CONN`
- **[Phase 3]** `git blame`: leak from `2ad8099b58f27` (2010), which
  removed unconditional put
- **[Phase 3]** `git merge-base --is-ancestor 2ad8099b58f2 HEAD` → yes;
  `fbbe0610d057` → no
- **[Phase 3]** `git show 2ad8099b58f27`: put moved to `to_be_dropped`
  only
- **[Phase 4]** openwall v4 0/4 and 3/4; v4 commit-message correction;
  Kicinski merge
- **[Phase 4]** Follow-up `to_be_dropped` reinit is hardening only, not
  required
- **[Phase 4]** UNVERIFIED: lore.kernel.org 403; `b4 dig` could not
  target the 2026 SHA (not in this tree)
- **[Phase 5]** Callers: sendmsg, `rds_send_worker`,
  `rds_ib_tasklet_fn_send`
- **[Phase 5]** No semcode MCP
- **[Phase 6]** `git describe HEAD` = `p-5.10-1-gce56b7a73b64b`; `make
  kernelversion` = 5.10.270
- **[Phase 6]** Buggy hunk present at `send.c:287-294`; fix text absent
- **[Phase 8]** Failure mode: leak of message + pages + MRs; HIGH for
  RDS, not a panic
- **UNVERIFIED:** stable@ discussion of this specific backport

**YES**

 net/rds/send.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 5d09c7654f136..0a541cfc90185 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -288,9 +288,21 @@ int rds_send_xmit(struct rds_conn_path *cp)
 			    (rm->rdma.op_active &&
 			    test_bit(RDS_MSG_RETRANSMITTED, &rm->m_flags))) {
 				spin_lock_irqsave(&cp->cp_lock, flags);
-				if (test_and_clear_bit(RDS_MSG_ON_CONN, &rm->m_flags))
-					list_move(&rm->m_conn_item, &to_be_dropped);
-				spin_unlock_irqrestore(&cp->cp_lock, flags);
+				if (test_and_clear_bit(RDS_MSG_ON_CONN,
+						       &rm->m_flags)) {
+					/* our ref is put after the batch */
+					list_move(&rm->m_conn_item,
+						  &to_be_dropped);
+					spin_unlock_irqrestore(&cp->cp_lock,
+							       flags);
+				} else {
+					/* already off the conn list; drop
+					 * the ref taken above ourselves
+					 */
+					spin_unlock_irqrestore(&cp->cp_lock,
+							       flags);
+					rds_message_put(rm);
+				}
 				continue;
 			}
 
-- 
2.53.0

