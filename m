Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7DA3D9DDB;
	Fri,  9 Oct 2026 14:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556896; cv=none; b=OkmBmEh4JXqVpb/l+GWY+PqqPE0gh8evLRVOpeYzWRl5nf6lpj95pllEhSCcRmlO8GRKkWsKqRRTIx2I6bJiya0jrXVnIzDdf4Q5UXgKXfqq8EsFzTMjqZzzvXa68D9QMJdO1thauyu8gtHzTsSHKOSt5qgMZjnBPCt7iYgqM88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556896; c=relaxed/simple;
	bh=FxjMmnD+gLqBuGzQ+pTCHPesOvc1TvitPvcQKadYu/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aNw1cp1lTOXyLuEortC27EJjYMIEahO9XGWTVp6Y9SnopzsmLZLkw/GXLp4Fz9mKNYDgP78pIUwumv+2cheMQ+0x3oIIAq8WKCsx1E+q5GTaZlOoc65jcBpdAUBmgoxEKix2YbsyBNj/x9SH5wufGZaj90pANA2EIWo72I/JAq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=bPWiD0ta; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="bPWiD0ta"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6CC2A20B7168;
	Fri,  9 Oct 2026 07:41:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6CC2A20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791556892;
	bh=VoxhCJB/AnphS4ZE+WEIY55vqJIIsHw0TnFSqlfetUo=;
	h=From:To:Cc:Subject:Date:From;
	b=bPWiD0taBZ9DkDwN7WIwtUgJTWCfIz3o2PgBNhOr5rxyDUI4sbpfAuU8GHDlrXXgw
	 X7zf5dRZNBNM9SJAo+snhF7tGqDkr2MWwjIeMPNWpptKpePQGnlxQO7fgyQH0RHmSE
	 mXUYJaRt8UNByhcPVauZHazN/93Iy11TCIEkKD0U=
From: Wei Hu <weh@linux.microsoft.com>
To: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dipayanroy@linux.microsoft.com,
	bpf@vger.kernel.org,
	sdf@fomichev.me,
	daniel@iogearbox.net,
	hawk@kernel.org,
	ast@kernel.org,
	john.fastabend@gmail.com,
	weh@microsoft.com
Subject: [PATCH net-next v6 00/13] net: mana: reconfigure by replacing the queue set
Date: Fri,  9 Oct 2026 14:41:11 +0000
Message-ID: <cover.1790795005.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I am carrying Long Li's queue-set reconfiguration series forward for this
revision. Long remains the author of twelve patches, and Dipayaan Roy
remains the author of the detach change. Their authorship and signoffs
are retained; I have added my signoff for this revision.

Replace detach/attach reconfiguration with pre-allocation and queue-set
replacement. Allocation failure leaves the running configuration intact.
Publication failure attempts rollback; a failed rollback closes the port
and holds carrier down until a successful reopen.

EQs and statistics belong to the port. Valid user-configured RSS tables
survive queue rebuilds. Channel-count changes reuse surviving queues:
reductions retire the tail and increases allocate only the added queues.
Ring, MTU, private-flag and XDP layout changes still perform full rebuilds.

This series does not depend on the pending HWC concurrency/dynamic-depth
v6 series linked below. Their CQ-publication changes overlap in
gdma_main.c and hw_channel.c; whichever series lands second will need a
rebase preserving both table-publication and per-CQ lifetime guarantees.
Related HWC series:
https://lore.kernel.org/all/cover.1790665894.git.weh@linux.microsoft.com/

Changes since v5:

  - Rebase the independent queue-set series onto net-next base
    47a1446725732cd3996edf607e8739334bbf4d78.
  - Drain ALL old TX queues after closing the TX/XDP gate and waiting for
    readers, but before publishing pointers, counts or RSS. A shared
    120-second drain deadline rejects a replacement by resuming the old
    configuration without reprogramming RSS or resetting the function.
    Retirement does not use FLR. Ordinary mana_dealloc_queues() remains
    byte-identical to this base: existing reset policy and independent
    failed-FLR hardening are deliberately not changed.
  - Complete the shared EQ/CQ lifetime prerequisite in patch 2. Initialize
    EQ state before IRQ publication. After stopping a retiring CQ's NAPI
    and work and tearing down its WQ object, flush its actual parent EQ
    while the CQ callback is still published. Clear its table entry and
    wait for RCU IRQ readers before freeing the CQ and callback owner.
    Pair IRQ lookups with release publication at all CQ publishers;
    Ethernet publication follows NAPI/DIM initialization. Matching HWC
    and RDMA publication stores do not change their recovery policies.
  - Move port-lifetime statistics preparation ahead of the first live
    swap, now patch 3. Introduce RX retirement, writer handoff and folding
    atomically with the first swap in patch 4, rather than relying on a
    later patch to make intermediate statistics readers safe.
  - Keep publication barriers consistent with open/attach. Latch forced
    carrier shutdown regardless of the previous carrier state and clear
    it only after successful reopen. Retain the rollback reader grace
    period after restoring old pointers, before callers discard scratch
    state.
  - Join TX queue selection to the publication gate in patch 4. Acquire
    port_is_up before count/RSS reads and snapshot real_num_tx_queues.
    Retiring tail RQs can outlive a TX-count reduction; when a recorded
    RX index no longer fits the live TX count, use the current RSS mapping
    instead of returning that stale index.
  - Clear DRV_XOFF on inactive allocated TX queues in patch 4's cold-path
    restart helper, using netif_tx_start_queue() while preserving the
    availability checks and wake behavior for active queues. Publication
    stops all allocated queues, and the netdev watchdog scans allocated
    num_tx_queues, not just real_num_tx_queues. Leaving the inactive tail
    stopped after a channel shrink caused a watchdog timeout and recovery
    on the previous release candidate.
  - Keep old RX statistics retired until rollback steering restoration
    succeeds. Restart DIM only for RXQs actually returning from retirement,
    with NAPI disabled, work cancelled and DIM reinitialized; carried RXQs
    and their counters are not reset.
  - Reserve live MTU/XDP replacement with channel_changing under the
    existing vport_mutex through queue, fail-close and scratch cleanup.
    This excludes concurrent RDMA RAW-QP vport admission without changing
    early validation, no-op or down-port paths.
  - Correct the full-page RX shortcut description to include all existing
    early-return conditions.

Resource and control-path costs:

Full rebuilds temporarily retain both sets of SQ/RQ/CQ objects, RX buffers
and page pools. The port-owned EQ pool is shared, not doubled. Device
resource limits can reject this temporary peak; no fixed hardware queue
threshold is assumed. Allocation failure preserves the live configuration.
The pre-publication TX drain can also reject a replacement without changing
the live pointer/count/RSS configuration.

CQ retirement adds parent-EQ marker operations and RCU reader waits on the
control path; these are not free and no latency improvement is claimed.
The IRQ lookup uses an acquire load, not a new per-packet lock. This series
does not introduce a general recovery policy for failed hardware commands.

Patch layout:
  1:     Queue-set helpers, preserving ordinary deallocation policy.
  2:     Shared EQ pool and EQ/CQ publication/retirement prerequisite.
  3:     Port-lifetime statistics preparation.
  4:     First live swap, nonreset drain, RX handoff and safe TX restart.
  5-8:   Ring, private-flag, MTU and XDP reconfiguration.
  9:     Remove the unreachable detach early return.
  10-11: Release unused EQs and preserve user RSS tables.
  12-13: Reuse queues across channel-count reductions and increases.

Overlap with separately submitted net fixes:

The XDP pre-allocation pointer fix is subsumed by patch 8's queue-set path,
which leaves the live program unchanged during allocation:
https://lore.kernel.org/all/20260904202640.3900685-1-longli@microsoft.com/

The user-RSS-table fix overlaps patch 11. Keep the three-argument
mana_rss_table_keep() and its queue-set callers in the overlapping blocks;
the RTNL RSS requirement is shared with the standalone net submission:
https://lore.kernel.org/all/20260905004401.3937066-1-longli@microsoft.com/

Neither submission is resent as a standalone patch here. These merge
notes do not prescribe changes to unrelated net-tree code.

History:
  v5: https://lore.kernel.org/all/20260909222416.884246-1-longli@microsoft.com/
  v4: https://lore.kernel.org/all/20260908032843.397667-1-longli@microsoft.com/
  v3: https://lore.kernel.org/all/20260901014442.2945689-1-longli@microsoft.com/
  v2 repost:
      https://lore.kernel.org/all/20260813050418.2906468-1-longli@microsoft.com/
  v2 earlier posting:
      https://lore.kernel.org/all/20260811063506.2428213-1-longli@microsoft.com/
  Full-page RX predecessor (v12, not a queue-set v1):
      https://lore.kernel.org/all/20260711041415.3008868-1-dipayanroy@linux.microsoft.com/

The link labelled "v1" in the old queue-set covers actually points to the
four-patch full-page RX v12 predecessor, not an earlier 13-patch queue-set
posting.

Testing:

Submission tip d7c25bddfea3 differs from the tested production history
only by removing attribution/session trailers. All thirteen intermediate
source trees are identical; build/runtime identities below are unchanged.

Production 6243b02cc714, kernel 7.3.0-rc4-mana-qset-v6-g6243b02cc714,
passed 39 native functional cases per DUT on VM5 and VM6: >=35-second
reduced-channel watchdog dwells, queue ownership, real IPv4 DF jumbo
traffic at MTU 2000/payload 1972, and native XDP PASS/DROP/TX/REDIRECT.

The separate KASAN/DMA memory/fault fixture,
7.3.0-rc4-mana-qset-memdiag-rethook-g9d9757ecf25c, completed
64 PASS/2 UNSUPPORTED/0 FAIL/0 NOT_RUN per DUT, including all 25 fault
cases with each token consumed exactly once. VM5 also completed twelve
>=180-second warning-reproduction trials with attributed security probes
active and untouched. No unexpected warning, KASAN/DMA-debug error or
peer-health failure was observed. Fault4 recovered locally; its independent
fallback was armed, verified and canceled, not executed.

That fixture's four-line FP64 rethook metadata correction and fault hooks
are test-only, not in these thirteen patches or a production dependency.
The entry window is unchanged; no global unwinding guarantee is claimed.
Full-locking remains baseline-blocked: unmodified 47a reproduced the
platform checker failure, and this fixture has no LOCKDEP/PROVE_RAW/
PROVE_RCU coverage. DIM enable returned EOPNOTSUPP. Native verbs is
UNSUPPORTED in the memory matrix because no approved native baseline
probe/result was supplied; RDMA sanity/link health is covered, not native
verbs transfer. PF/non-host-mode and multiport hardware remain untested.

A final forward-UDP receiver comparison completed five release6243 and
five baseline47a samples with complete raw records, matching identities,
nested windows and valid client/server completion; no rows were rejected.
Adjusted TGID CPU averaged 4056.4 versus 4188.4 USER_HZ ticks. Per iperf
summary application Gbit it was 901.422346 versus 930.754115 (~3.15% lower);
per native full-window path Gbit, 518.165386 versus 543.335320 (~4.63% lower).
The process interval includes omit time; iperf's application summary does
not. These are distinct denominators, not interval-matched application
efficiency. Throughput was 99.9980098 versus 99.9980650 Mbit/s, with loss
0.000689492% versus 0.001422219% (release versus baseline).

This measures guest-scheduler-attributed process runtime, not whole-guest,
driver or physical CPU efficiency. Aggregate /proc/stat is observational
and need not conserve against adjusted process time. A separate earlier
five-plus-five sender crossover did not reproduce the initial ~9% signal;
observer/context and phase confounds remain. These bounded results are
not a no-effect or blanket regression-free guarantee.

Current P4-P13 passed forced GCC W=1 builds, 150/150 target translation
units; unchanged P1-P3 retain their original complete proof. Smatch is
not credited: its frontend fails a valid type assertion on both baseline
and feature. Historical supported Sparse coverage is not relabeled as a
new current-tip run. Full-mail lint was rerun after removing the
Copilot attribution/session trailers at the submitter's request.
Hardware-command failure/recovery policies remain scoped as described
above; these tests do not establish recovery from every device failure.

Full evidence, fixture identities and historical limitations are in the
package's RUNTIME-HANDOFF.txt and audit/final-evidence.json. Public v5
review freshness was checked on 2026-10-02: all 21 findings and 28 thread
messages were unchanged, with no new human replies. No actual Sashiko
approval is claimed.

Signed-off-by: Wei Hu <weh@microsoft.com>

Dipayaan Roy (1):
  net: mana: do not bail out of mana_detach on dealloc failure

Long Li (12):
  net: mana: add queue-set allocation and teardown helpers
  net: mana: share the EQ pool across a queue-set swap
  net: mana: keep per-queue statistics in the port context
  net: mana: swap queue sets in mana_set_channels
  net: mana: swap queue sets in mana_set_ringparam
  net: mana: swap queue sets in mana_set_priv_flags
  net: mana: swap queue sets in mana_change_mtu
  net: mana: swap queue sets in mana_xdp_set
  net: mana: release EQs left idle by a channel-count reduction
  net: mana: keep a user-configured RSS table across a queue rebuild
  net: mana: keep the surviving queues when the channel count is reduced
  net: mana: keep the existing queues when the channel count is raised

 drivers/infiniband/hw/mana/cq.c               |    3 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |   22 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  |    3 +-
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  108 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 1328 +++++++++++++++--
 .../ethernet/microsoft/mana/mana_ethtool.c    |  314 ++--
 include/net/mana/gdma.h                       |    8 +-
 include/net/mana/mana.h                       |   97 +-
 8 files changed, 1610 insertions(+), 273 deletions(-)


base-commit: 47a1446725732cd3996edf607e8739334bbf4d78
