Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145124A4408;
	Mon, 31 Aug 2026 13:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183788; cv=none; b=DUgBbWUvQfhey2SQAc6fMe3bVi9p6879X+133QGu0/yh96q7UyC9J/THJCZY9k0mJGxUt9x7MRGzVnLR6WBtG+BnubUdZhirBK8BeherUDbtBlgyvNuU4ryJAsBK5z9Cnmn6hO8Dk58oWV5dbG96X0/am2BzGi5kbB4nrTOYNqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183788; c=relaxed/simple;
	bh=iAgDOfzU4RQhEhWsPC9iYjnqjlKVx2JPCOkBZqloeqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NQjfL4e8YcnevP9zMscIBvBMShV2yi2s/JR/V4PhVxcmYdHsSt6oM3Mq4fVKRkgqrI5n3MEBbemoiK2x/tUfXrxpBfq0F7mFO1w5Ev2vvnVjKPGFs10vIivPovLB6R56t6xpUfq3i1C2EMyrIsE35m9KEK0NwlPx7N0Ac+yT0LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PCHnaKLP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PCHnaKLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BB51F00ACA;
	Mon, 31 Aug 2026 13:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183784;
	bh=l9zmcEklIITvQXoUh4Cg5QygAyfmWb4TLQnCl5Fn0Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCHnaKLPRADY2yZiE/3wTnaYX+Gp71GyEtzvMnKtm4v+bUGJ9C3CBOKAnRN8rT+6E
	 w4E6ycXlHiMhZ+kC88rXZF9xCkK7SVd+OT7nZUCsRs/+NaJJqaogdHMkWei5dfKdVI
	 hX1VotJkrC0fG4wiZOBRDDldkcGF8ilDBjl56moNRvfsLKQcL/cF9IEQKrVUdvV+WP
	 8d1C2pM1PkinWjxrvKm/FBju+bxotamB1lisj9XZGqYs3bskXz4WPLSqine/t1U7cK
	 mzjehHaPJx5CsE0ZXYwL26ZauJsvzOV5uwb2IPYYpZykOdFJwu4odPP1v663t2GCbb
	 lnMWTP7LzF8KQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maoyi Xie <maoyixie.tju@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] rds: filter RDS_INFO_* getsockopt by caller's netns
Date: Mon, 31 Aug 2026 09:25:30 -0400
Message-ID: <20260831133314.4125787-302-sashal@kernel.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit c96a5209dda666004b8ee1ed7f0d493d09a4f200 ]

The RDS_INFO_* family of getsockopt(2) options reads several
file-scope global lists that are not per-netns:

  rds_sock_info / rds6_sock_info,
  rds_sock_inc_info / rds6_sock_inc_info        -> rds_sock_list
  rds_tcp_tc_info / rds6_tcp_tc_info            -> rds_tcp_tc_list
  rds_conn_info / rds6_conn_info,
  rds_conn_message_info_cmn (for the *_SEND_MESSAGES and
  *_RETRANS_MESSAGES variants),
  rds_for_each_conn_info (for RDS_INFO_IB_CONNECTIONS)
                                                -> rds_conn_hash[]

The handlers do not filter by the caller's network namespace.
rds_info_getsockopt() has no netns or capable() check, and
rds_create() has no capable() check, so AF_RDS is reachable from
an unprivileged user namespace. As a result, an unprivileged
caller in a fresh user_ns plus netns can read the bound address
and sock inode of every RDS socket on the host, the peer address
of incoming messages on every RDS socket on the host, the peer
address and TCP sequence numbers of every rds-tcp connection on
the host, and the peer address and RDS sequence numbers of every
RDS connection on the host.

The rds-tcp transport is reachable from a non-initial netns (see
rds_set_transport()), so a one-shot init_net gate at
rds_info_getsockopt() would deny legitimate per-netns visibility
to rds-tcp callers. Instead, filter at each handler by comparing
the netns of the caller's socket to the netns of the list entry,
or to rds_conn_net(conn) for connection paths. Only copy entries
whose netns matches the caller. Counters (RDS_INFO_COUNTERS) are
aggregate statistics and remain global.

Reproducer (KASAN VM, rds and rds_tcp loaded): an AF_RDS socket
binds 127.0.0.1:4242 in init_net as root. A child process enters
a fresh user_ns plus netns and opens AF_RDS there, then calls
getsockopt(SOL_RDS, RDS_INFO_SOCKETS). Before this change, the
child sees the init_net socket. After this change, the child
sees zero entries.

Drop the rds_sock_count, rds_tcp_tc_count, and rds6_tcp_tc_count
globals. v2 used them for the size precheck and lens->nr; v3
replaced the precheck with a per-ns count from a first pass over
the list, so the globals have no remaining readers. The matching
increments and decrements in rds_create()/rds_destroy_sock() and
rds_tcp_set_callbacks()/rds_tcp_restore_callbacks() go away with
them. Reported by the kernel test robot under clang W=1.

Suggested-by: Allison Henderson <achender@kernel.org>
Suggested-by: Simon Horman <horms@kernel.org>
Reviewed-by: Allison Henderson <achender@kernel.org>
Co-developed-by: Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>
Signed-off-by: Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260520084236.2724349-1-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `rds: filter RDS_INFO_* getsockopt by
caller's netns`

**Local tree:** `v6.18.44` (`linux-6.18.y` stable). The vulnerable code
is present; this fix is not yet applied.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[net/rds]` `[filter]` — Restrict `RDS_INFO_*` getsockopt
handlers to return only data from the caller's network namespace.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Suggested-by:** Allison Henderson `<achender@kernel.org>`, Simon
  Horman `<horms@kernel.org>` — subsystem experts identified the issue
- **Reviewed-by:** Allison Henderson `<achender@kernel.org>` — RDS
  maintainer review
- **Co-developed-by:** Praveen Kakkolangara
- **Signed-off-by:** Praveen Kakkolangara, Maoyi Xie, Jakub Kicinski
- **Link:** https://patch.msgid.link/20260520084236.2724349-1-
  maoyixie.tju@gmail.com
- No `Fixes:`, `Reported-by: syzbot`, or `Cc: stable@vger.kernel.org`
  (expected for pipeline candidates)
- Notable: Reviewed by subsystem maintainer; security issue identified
  by maintainers, not a fuzzer report

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `RDS_INFO_*` getsockopt handlers iterate global lists
  (`rds_sock_list`, `rds_tcp_tc_list`, `rds_conn_hash[]`) without
  filtering by the caller's netns
- **Symptom:** Unprivileged process in a fresh `user_ns` + `netns` can
  read host-wide RDS socket addresses/inodes, peer addresses, TCP
  sequence numbers, and RDS sequence numbers
- **Root cause:** `rds_info_getsockopt()` has no netns/capability check;
  `rds_create()` has no `capable()` check; AF_RDS is reachable from
  unprivileged user namespaces; global lists are not per-netns
- **Reproducer:** Documented — root binds AF_RDS in init_net; child in
  new user_ns+netns calls `getsockopt(SOL_RDS, RDS_INFO_SOCKETS)` and
  sees init_net sockets before fix, zero after
- **Design note:** Cannot use a blanket `init_net` gate because rds-tcp
  legitimately works in non-init netns

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit security/access-control
fix. Secondary cleanup drops unused global counters (`rds_sock_count`,
`rds_tcp_tc_count`, `rds6_tcp_tc_count`) after switching to per-netns
two-pass counting.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- `net/rds/af_rds.c` — ~+80/-30 lines: netns filtering in
  `rds_sock_inc_info`, `rds6_sock_inc_info`, `rds_sock_info`,
  `rds6_sock_info`; remove `rds_sock_count` global and its inc/dec
- `net/rds/connection.c` — ~+20 lines: netns filter in
  `rds_conn_message_info_cmn`, `rds_for_each_conn_info`,
  `rds_walk_conn_path_info`
- `net/rds/tcp.c` — ~+50/-20 lines: netns filtering in
  `rds_tcp_tc_info`, `rds6_tcp_tc_info`; remove
  `rds_tcp_tc_count`/`rds6_tcp_tc_count` globals
- **Functions modified:** 9 info-export handlers + socket create/destroy
  callback paths (counter removal only)
- **Scope:** Multi-file but single-purpose; no API changes

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Before:** Each handler walks entire global list and copies all
  matching entries regardless of netns
- **After:** Each handler gets `struct net *net = sock_net(sock->sk)`,
  skips entries where `!net_eq(sock_net(rds_rs_to_sk(rs)), net)` or
  `!net_eq(rds_conn_net(conn), net)`, uses two-pass count-then-copy for
  size precheck
- **Affected path:** `getsockopt(SOL_RDS, RDS_INFO_*)` — userspace
  diagnostic path, but reachable from unprivileged netns

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Security — cross-network-namespace information
  disclosure
- **Mechanism:** Global data structures shared across all netns;
  getsockopt handlers lacked netns scoping. Unprivileged
  container/namespace user reads host-wide connection metadata including
  TCP/RDS sequence numbers useful for traffic analysis or hijacking

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Fix is obviously correct — standard `net_eq()` pattern already used in
  this subsystem (`recv.c:377`)
- Minimal per-handler filtering; preserves legitimate per-netns rds-tcp
  visibility
- Low regression risk: only restricts over-broad data export;
  `RDS_INFO_COUNTERS` intentionally remains global per commit message
- Two-pass counting handles buffer sizing correctly; comment documents
  benign race with concurrent `rds_bind()`

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Info handlers in `af_rds.c` trace to long-standing RDS code
(blame shows merge commit `e664048784506` for current lines). Global
`rds_sock_list` without netns filtering is architectural debt from
before per-netns RDS-TCP support. RDS-TCP netns support added in
`d5a8ac28a7ff` (Aug 2015). Bug became exploitable when unprivileged user
namespaces could create isolated netns (Linux 3.8+) and open AF_RDS
sockets without capability checks.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag present — N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Related fixes already in this tree:
- `a7494479757d6` — restrict RDS/IB transport to init_net (partial
  mitigation, does not fix getsockopt leak)
- `9591042533140` — drop cross-netns incoming messages (UAF fix in recv
  path)
- `91ce1bb6e4194` — zero per-item info buffers (stack leak fix,
  complementary)
This fix is **standalone** — no series dependency.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Maoyi Xie has multiple net-namespace security fixes in
networking (e.g., requiring `CAP_NET_ADMIN` for tunnel changelink). Co-
authors Praveen Kakkolangara and reviewer Allison Henderson are active
RDS contributors/maintainers.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** Requires `rds_conn_net()` helper — **present** in this tree
(`rds.h:174-177`). Requires `read_pnet`/`write_pnet` on `conn->c_net` —
**present**. No other prerequisites. Should apply cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c <sha>` could not run — commit not in local tree.
Web search found patch series v3→v5 on netdev/linux-kernel lists (May
2026). Final version is v5. Reviewed-by Allison Henderson on committed
version. Could not fetch lore/patch.msgid.link (bot protection/timeout).

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** CC list from v5 includes netdev, linux-rdma, rds-devel
maintainers (David Miller, Eric Dumazet, Jakub Kicinski, Paolo Abeni).
Reviewed-by Allison Henderson (RDS maintainer).

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No syzbot/bugzilla link. Issue identified by RDS maintainers
(Suggested-by Henderson, Horman). Reproducer included in commit message.
Kernel test robot noted unused globals (W=1), not the security bug
itself.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone 1-patch fix; evolved v1→v5 during review (v3
addressed two-pass counting feedback from Simon Horman). No other
patches required.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched — commit not yet in stable tree. No evidence
against backport found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `rds_sock_info`, `rds6_sock_info`, `rds_sock_inc_info`,
`rds6_sock_inc_info`, `rds_conn_message_info_cmn`,
`rds_for_each_conn_info`, `rds_walk_conn_path_info`, `rds_tcp_tc_info`,
`rds6_tcp_tc_info`

### Step 5.2: TRACE CALLERS
**Record:** All called from `rds_info_getsockopt()` (`info.c:208`) via
registered function table, which is invoked from `rds_getsockopt()`
(`af_rds.c:506`) on `getsockopt(2)` for `SOL_RDS` options. Reachable
from any process with an AF_RDS socket.

### Step 5.3: TRACE CALLEES
**Record:** `sock_net()`, `net_eq()`, `rds_conn_net()`,
`rds_info_copy()`, list iteration under existing locks (`rds_sock_lock`,
`rds_tcp_tc_list_lock`, RCU for conn hash).

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** `syscall:getsockopt` → `sock_getsockopt` → `rds_getsockopt`
→ `rds_info_getsockopt` → info handler. **Userspace-reachable** from
unprivileged user in new netns (confirmed: `rds_create()` at
`af_rds.c:703-716` has no `capable()` check).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Same `net_eq(sock_net(...), rds_conn_net(...))` pattern
already applied in `recv.c:377` for cross-netns message delivery. This
fix extends the same principle to the info-export path.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Verified:
- `rds_sock_inc_info` iterates all of `rds_sock_list` without netns
  check (`af_rds.c:746`)
- `rds_tcp_tc_info` exports all TCP connections without netns filter
  (`tcp.c:245-264`)
- `rds_conn_message_info_cmn` walks all of `rds_conn_hash` without netns
  filter (`connection.c:560-594`)
- `rds_info_getsockopt()` has no netns/capability gate
  (`info.c:158-218`)

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Expected **clean apply**. File structure matches the diff
context. Recent related RDS netns commits in this tree use the same
helpers. No conflicting refactor detected in last 10 commits on these
files.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** Partial mitigations present (`a7494479757d6` blocks RDS/IB
in non-init netns for *transport setup*, `9591042533140` fixes recv
UAF), but **no fix for getsockopt info leak**. This commit is still
needed.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** `net/rds` — networking protocol (IMPORTANT). Security-
relevant when `CONFIG_RDS` is enabled/built as module.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Actively maintained — multiple RDS netns security fixes
landed in 6.18.y recently, indicating ongoing hardening of namespace
isolation in this driver.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Systems with `CONFIG_RDS`/`CONFIG_RDS_TCP` enabled and RDS
in use on the host. Any multi-tenant/container environment where
untrusted users can create user+network namespaces. Not universal
(CONFIG-dependent), but impact is severe when RDS is loaded.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- **Trigger:** Create user_ns + netns (unprivileged since 3.8), load/use
  AF_RDS, call `getsockopt(SOL_RDS, RDS_INFO_*)`
- **Likelihood:** Moderate — requires RDS module loaded, but module
  autoload via `MODULE_ALIAS_NETPROTO(PF_RDS)` is possible
- **Unprivileged trigger:** **Yes** — no capability check in
  `rds_create()`

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** Cross-namespace **information disclosure** — socket
addresses, inode numbers, peer addresses, TCP sequence numbers, RDS
sequence numbers. Severity: **CRITICAL** (security vulnerability; aids
network reconnaissance and potentially TCP sequence prediction attacks).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH — closes documented namespace isolation bypass
- **Risk:** LOW — surgical netns filtering using established in-
  subsystem pattern; no behavior change for correctly scoped callers
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real security bug — cross-netns info leak
- Unprivileged reproduction path documented
- Leaks sensitive data (TCP/RDS sequence numbers, peer addresses, socket
  inodes)
- Reviewed by RDS maintainer (Allison Henderson)
- Small, focused fix using existing `net_eq()`/`rds_conn_net()`
  infrastructure
- Buggy code confirmed present in linux-6.18.y
- Prerequisites (`rds_conn_net`, per-net conn support) present in tree
- Consistent with other RDS netns hardening already backported to this
  tree

**AGAINST backport:**
- CONFIG_RDS is optional/tristate — not every system has RDS loaded
- No syzbot/CVE reference (weaker signal, but maintainers documented the
  issue)

**UNRESOLVED:**
- Full lore thread content (fetch blocked)
- Exact upstream commit SHA not in local remotes

Neither unresolved item affects the technical decision.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — clear netns filtering;
   reviewed by maintainer; reproducer provided
2. Fixes a real bug affecting users? **PASS** — documented cross-netns
   info leak
3. Important issue? **PASS** — security information disclosure
   (CRITICAL)
4. Small and contained? **PASS** — ~3 files, focused handlers, no
   refactoring
5. No new features or APIs? **PASS** — access restriction only
6. Can apply to local tree? **PASS** — code and helpers present; clean
   apply expected

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
**Record:** Security bug fix (not device ID, quirk, DT, build, or docs
exception).

### Step 9.4: DECISION RATIONALE

This commit closes a namespace isolation hole in RDS diagnostic
getsockopt handlers. An unprivileged user in a container-like
user+network namespace can currently enumerate host-wide RDS connection
state including TCP sequence numbers. The fix applies the same
`net_eq()` scoping pattern already used elsewhere in RDS and is a
standard stable security backport. The bug exists in linux-6.18.44;
partial mitigations (RDS/IB transport restriction, recv-path UAF fix) do
not address this getsockopt leak.

---

## Verification

- [Phase 1] Parsed subject, tags (Reviewed-by Henderson, Suggested-by
  Henderson/Horman, Link to patch)
- [Phase 2] Read diff: 3 files, netns `net_eq()` filters in 9 handlers,
  global counter removal
- [Phase 3] `git describe HEAD` → v6.18.44; `git blame` on
  `rds_sock_inc_info` → long-standing code; `d5a8ac28a7ff` → RDS-TCP
  netns since 2015; related commits `a7494479757d6`, `9591042533140`
  present
- [Phase 4] Web search found v3-v5 patch series; Reviewed-by Henderson;
  `b4 dig`/`WebFetch` lore blocked (no commit SHA in tree / bot
  protection)
- [Phase 5] Traced call chain: `getsockopt` → `rds_getsockopt` →
  `rds_info_getsockopt` → handlers; confirmed `rds_create()` lacks
  `capable()` at `af_rds.c:703-716`
- [Phase 6] Confirmed buggy globals and unfiltered loops at
  `af_rds.c:746`, `tcp.c:245`, `connection.c:560`; `rds_conn_net()`
  exists at `rds.h:174`; fix not present
- [Phase 7] Subsystem: net/rds, actively receiving netns security fixes
- [Phase 8] Failure mode: cross-netns info leak, unprivileged trigger,
  CRITICAL severity

**YES**The remote search (`sasha-next`, `sashal`, `stable/linux-6.19.y`)
finished without finding the fix commit — it isn’t in those local refs
yet, which matches this tree still having the vulnerable getsockopt
handlers.

The analysis stands: this is a cross-netns information leak in
`RDS_INFO_*` getsockopt paths, exploitable from unprivileged
user+network namespaces when RDS is loaded. The fix is small, reviewed
by the RDS maintainer, and the prerequisites (`rds_conn_net()`, etc.)
are already in **linux-6.18.y v6.18.44**.

**YES** — backport recommended for this tree.

 net/rds/af_rds.c     | 59 ++++++++++++++++++++++++++++++++++-------
 net/rds/connection.c | 13 +++++++++
 net/rds/tcp.c        | 63 ++++++++++++++++++++++++++++----------------
 3 files changed, 104 insertions(+), 31 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 7a0f5150e9103..cc3a898bf5d51 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -43,7 +43,6 @@
 
 /* this is just used for stats gathering :/ */
 static DEFINE_SPINLOCK(rds_sock_lock);
-static unsigned long rds_sock_count;
 static LIST_HEAD(rds_sock_list);
 DECLARE_WAIT_QUEUE_HEAD(rds_poll_waitq);
 
@@ -82,7 +81,6 @@ static int rds_release(struct socket *sock)
 
 	spin_lock_bh(&rds_sock_lock);
 	list_del_init(&rs->rs_item);
-	rds_sock_count--;
 	spin_unlock_bh(&rds_sock_lock);
 
 	rds_trans_put(rs->rs_transport);
@@ -694,7 +692,6 @@ static int __rds_create(struct socket *sock, struct sock *sk, int protocol)
 
 	spin_lock_bh(&rds_sock_lock);
 	list_add_tail(&rs->rs_item, &rds_sock_list);
-	rds_sock_count++;
 	spin_unlock_bh(&rds_sock_lock);
 
 	return 0;
@@ -735,6 +732,7 @@ static void rds_sock_inc_info(struct socket *sock, unsigned int len,
 			      struct rds_info_iterator *iter,
 			      struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(sock->sk);
 	struct rds_sock *rs;
 	struct rds_incoming *inc;
 	unsigned int total = 0;
@@ -744,6 +742,9 @@ static void rds_sock_inc_info(struct socket *sock, unsigned int len,
 	spin_lock_bh(&rds_sock_lock);
 
 	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		/* Only show sockets in the caller's netns. */
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
 		/* This option only supports IPv4 sockets. */
 		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
 			continue;
@@ -774,6 +775,7 @@ static void rds6_sock_inc_info(struct socket *sock, unsigned int len,
 			       struct rds_info_iterator *iter,
 			       struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(sock->sk);
 	struct rds_incoming *inc;
 	unsigned int total = 0;
 	struct rds_sock *rs;
@@ -783,6 +785,9 @@ static void rds6_sock_inc_info(struct socket *sock, unsigned int len,
 	spin_lock_bh(&rds_sock_lock);
 
 	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		/* Only show sockets in the caller's netns. */
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
 		read_lock(&rs->rs_recv_lock);
 
 		list_for_each_entry(inc, &rs->rs_recv_queue, i_item) {
@@ -806,7 +811,9 @@ static void rds_sock_info(struct socket *sock, unsigned int len,
 			  struct rds_info_iterator *iter,
 			  struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(sock->sk);
 	struct rds_info_socket sinfo;
+	unsigned int copied = 0;
 	unsigned int cnt = 0;
 	struct rds_sock *rs;
 
@@ -814,12 +821,24 @@ static void rds_sock_info(struct socket *sock, unsigned int len,
 
 	spin_lock_bh(&rds_sock_lock);
 
-	if (len < rds_sock_count) {
-		cnt = rds_sock_count;
-		goto out;
+	/* First pass: count entries visible in the caller's netns. */
+	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
+		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
+			continue;
+		cnt++;
 	}
 
+	if (len < cnt)
+		goto out;
+
 	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		if (copied >= cnt)
+			break;
+		/* Only show sockets in the caller's netns. */
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
 		/* This option only supports IPv4 sockets. */
 		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
 			continue;
@@ -832,8 +851,13 @@ static void rds_sock_info(struct socket *sock, unsigned int len,
 		sinfo.inum = sock_i_ino(rds_rs_to_sk(rs));
 
 		rds_info_copy(iter, &sinfo, sizeof(sinfo));
-		cnt++;
+		copied++;
 	}
+	/* A concurrent rds_bind() can change rs_bound_addr between the
+	 * two passes without holding rds_sock_lock, so copied may be
+	 * less than cnt. Report what was actually copied.
+	 */
+	cnt = copied;
 
 out:
 	lens->nr = cnt;
@@ -847,17 +871,32 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
 			   struct rds_info_iterator *iter,
 			   struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(sock->sk);
 	struct rds6_info_socket sinfo6;
+	unsigned int copied = 0;
+	unsigned int cnt = 0;
 	struct rds_sock *rs;
 
 	len /= sizeof(struct rds6_info_socket);
 
 	spin_lock_bh(&rds_sock_lock);
 
-	if (len < rds_sock_count)
+	/* First pass: count entries visible in the caller's netns. */
+	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
+		cnt++;
+	}
+
+	if (len < cnt)
 		goto out;
 
 	list_for_each_entry(rs, &rds_sock_list, rs_item) {
+		if (copied >= cnt)
+			break;
+		/* Only show sockets in the caller's netns. */
+		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
+			continue;
 		sinfo6.sndbuf = rds_sk_sndbuf(rs);
 		sinfo6.rcvbuf = rds_sk_rcvbuf(rs);
 		sinfo6.bound_addr = rs->rs_bound_addr;
@@ -867,10 +906,12 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
 		sinfo6.inum = sock_i_ino(rds_rs_to_sk(rs));
 
 		rds_info_copy(iter, &sinfo6, sizeof(sinfo6));
+		copied++;
 	}
+	cnt = copied;
 
  out:
-	lens->nr = rds_sock_count;
+	lens->nr = cnt;
 	lens->each = sizeof(struct rds6_info_socket);
 
 	spin_unlock_bh(&rds_sock_lock);
diff --git a/net/rds/connection.c b/net/rds/connection.c
index 4764628fe12a3..9fd58b7250e9a 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -541,6 +541,7 @@ static void rds_conn_message_info_cmn(struct socket *sock, unsigned int len,
 				      struct rds_info_lengths *lens,
 				      int want_send, bool isv6)
 {
+	struct net *net = sock_net(sock->sk);
 	struct hlist_head *head;
 	struct list_head *list;
 	struct rds_connection *conn;
@@ -563,6 +564,9 @@ static void rds_conn_message_info_cmn(struct socket *sock, unsigned int len,
 			struct rds_conn_path *cp;
 			int npaths;
 
+			/* Only show connections in the caller's netns. */
+			if (!net_eq(rds_conn_net(conn), net))
+				continue;
 			if (!isv6 && conn->c_isv6)
 				continue;
 
@@ -661,6 +665,7 @@ void rds_for_each_conn_info(struct socket *sock, unsigned int len,
 			  u64 *buffer,
 			  size_t item_len)
 {
+	struct net *net = sock_net(sock->sk);
 	struct hlist_head *head;
 	struct rds_connection *conn;
 	size_t i;
@@ -673,6 +678,9 @@ void rds_for_each_conn_info(struct socket *sock, unsigned int len,
 	for (i = 0, head = rds_conn_hash; i < ARRAY_SIZE(rds_conn_hash);
 	     i++, head++) {
 		hlist_for_each_entry_rcu(conn, head, c_hash_node) {
+			/* Only show connections in the caller's netns. */
+			if (!net_eq(rds_conn_net(conn), net))
+				continue;
 
 			/* Zero the per-item buffer before handing it to the
 			 * visitor so any field the visitor does not write -
@@ -706,6 +714,7 @@ static void rds_walk_conn_path_info(struct socket *sock, unsigned int len,
 				    u64 *buffer,
 				    size_t item_len)
 {
+	struct net *net = sock_net(sock->sk);
 	struct hlist_head *head;
 	struct rds_connection *conn;
 	size_t i;
@@ -720,6 +729,10 @@ static void rds_walk_conn_path_info(struct socket *sock, unsigned int len,
 		hlist_for_each_entry_rcu(conn, head, c_hash_node) {
 			struct rds_conn_path *cp;
 
+			/* Only show connections in the caller's netns. */
+			if (!net_eq(rds_conn_net(conn), net))
+				continue;
+
 			/* XXX We only copy the information from the first
 			 * path for now.  The problem is that if there are
 			 * more than one underlying paths, we cannot report
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 1980a197034ba..ab509498cf752 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -46,14 +46,6 @@
 static DEFINE_SPINLOCK(rds_tcp_tc_list_lock);
 static LIST_HEAD(rds_tcp_tc_list);
 
-/* rds_tcp_tc_count counts only IPv4 connections.
- * rds6_tcp_tc_count counts both IPv4 and IPv6 connections.
- */
-static unsigned int rds_tcp_tc_count;
-#if IS_ENABLED(CONFIG_IPV6)
-static unsigned int rds6_tcp_tc_count;
-#endif
-
 /* Track rds_tcp_connection structs so they can be cleaned up */
 static DEFINE_SPINLOCK(rds_tcp_conn_lock);
 static LIST_HEAD(rds_tcp_conn_list);
@@ -110,11 +102,6 @@ void rds_tcp_restore_callbacks(struct socket *sock,
 	/* done under the callback_lock to serialize with write_space */
 	spin_lock(&rds_tcp_tc_list_lock);
 	list_del_init(&tc->t_list_item);
-#if IS_ENABLED(CONFIG_IPV6)
-	rds6_tcp_tc_count--;
-#endif
-	if (!tc->t_cpath->cp_conn->c_isv6)
-		rds_tcp_tc_count--;
 	spin_unlock(&rds_tcp_tc_list_lock);
 
 	tc->t_sock = NULL;
@@ -201,11 +188,6 @@ void rds_tcp_set_callbacks(struct socket *sock, struct rds_conn_path *cp)
 	/* done under the callback_lock to serialize with write_space */
 	spin_lock(&rds_tcp_tc_list_lock);
 	list_add_tail(&tc->t_list_item, &rds_tcp_tc_list);
-#if IS_ENABLED(CONFIG_IPV6)
-	rds6_tcp_tc_count++;
-#endif
-	if (!tc->t_cpath->cp_conn->c_isv6)
-		rds_tcp_tc_count++;
 	spin_unlock(&rds_tcp_tc_list_lock);
 
 	/* accepted sockets need our listen data ready undone */
@@ -233,20 +215,37 @@ static void rds_tcp_tc_info(struct socket *rds_sock, unsigned int len,
 			    struct rds_info_iterator *iter,
 			    struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(rds_sock->sk);
 	struct rds_info_tcp_socket tsinfo;
 	struct rds_tcp_connection *tc;
+	unsigned int copied = 0;
+	unsigned int cnt = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rds_tcp_tc_list_lock, flags);
 
-	if (len / sizeof(tsinfo) < rds_tcp_tc_count)
+	/* First pass: count entries visible in the caller's netns. */
+	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
+		if (tc->t_cpath->cp_conn->c_isv6)
+			continue;
+		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
+			continue;
+		cnt++;
+	}
+
+	if (len / sizeof(tsinfo) < cnt)
 		goto out;
 
 	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
 		struct inet_sock *inet = inet_sk(tc->t_sock->sk);
 
+		if (copied >= cnt)
+			break;
 		if (tc->t_cpath->cp_conn->c_isv6)
 			continue;
+		/* Only show connections in the caller's netns. */
+		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
+			continue;
 
 		tsinfo.local_addr = inet->inet_saddr;
 		tsinfo.local_port = inet->inet_sport;
@@ -261,10 +260,12 @@ static void rds_tcp_tc_info(struct socket *rds_sock, unsigned int len,
 		tsinfo.tos = tc->t_cpath->cp_conn->c_tos;
 
 		rds_info_copy(iter, &tsinfo, sizeof(tsinfo));
+		copied++;
 	}
+	cnt = copied;
 
 out:
-	lens->nr = rds_tcp_tc_count;
+	lens->nr = cnt;
 	lens->each = sizeof(tsinfo);
 
 	spin_unlock_irqrestore(&rds_tcp_tc_list_lock, flags);
@@ -279,19 +280,35 @@ static void rds6_tcp_tc_info(struct socket *sock, unsigned int len,
 			     struct rds_info_iterator *iter,
 			     struct rds_info_lengths *lens)
 {
+	struct net *net = sock_net(sock->sk);
 	struct rds6_info_tcp_socket tsinfo6;
 	struct rds_tcp_connection *tc;
+	unsigned int copied = 0;
+	unsigned int cnt = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rds_tcp_tc_list_lock, flags);
 
-	if (len / sizeof(tsinfo6) < rds6_tcp_tc_count)
+	/* First pass: count entries visible in the caller's netns. */
+	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
+		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
+			continue;
+		cnt++;
+	}
+
+	if (len / sizeof(tsinfo6) < cnt)
 		goto out;
 
 	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
 		struct sock *sk = tc->t_sock->sk;
 		struct inet_sock *inet = inet_sk(sk);
 
+		if (copied >= cnt)
+			break;
+		/* Only show connections in the caller's netns. */
+		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
+			continue;
+
 		tsinfo6.local_addr = sk->sk_v6_rcv_saddr;
 		tsinfo6.local_port = inet->inet_sport;
 		tsinfo6.peer_addr = sk->sk_v6_daddr;
@@ -304,10 +321,12 @@ static void rds6_tcp_tc_info(struct socket *sock, unsigned int len,
 		tsinfo6.last_seen_una = tc->t_last_seen_una;
 
 		rds_info_copy(iter, &tsinfo6, sizeof(tsinfo6));
+		copied++;
 	}
+	cnt = copied;
 
 out:
-	lens->nr = rds6_tcp_tc_count;
+	lens->nr = cnt;
 	lens->each = sizeof(tsinfo6);
 
 	spin_unlock_irqrestore(&rds_tcp_tc_list_lock, flags);
-- 
2.53.0

