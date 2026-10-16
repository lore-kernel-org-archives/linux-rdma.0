Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91EC1368D74;
	Fri, 16 Oct 2026 15:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165140; cv=none; b=i/FNEcbwTV6SFw5gTx9a/+trDAiVdyU2k/34ZCOUUk8MYdSydnE9rZo0e9Ks5LalSIDoyXPz+9h3gYd0uBcr1lMlFBKTmd4S77myZlZG419vVg0Z1oZOtBoUB9uib32nfG/6sF10UxqA0eb3IOVeDgkpwHg0AQaxuqC1ZlvLaPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165140; c=relaxed/simple;
	bh=kO/e4S78HzZGSW3Rby3HqiXJswAD10l/dj+A8hECeUo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UWOjbdYn+OqUMPOlqq6RFTk85F1f+elve9yExFJCDcLOCu7JCJ4qYJdStLgfJtvI6eXXUdnLPPNRRjWP3NR5QvsyfGUqxDL2h8LaQ+/pEv+sDk6TGbTchZx32l6JDnW51VH4D3Zr1SnxI4tVZ/G6qnnBAE/BQB16KPk3CSlvKq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=fBYBOs2I; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="fBYBOs2I"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 79F9320B7167;
	Fri, 16 Oct 2026 08:38:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 79F9320B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792165126;
	bh=meBZp8XJ5Sc2EPVVaKAwsUCADdzsLD93FScM2Iwp+b4=;
	h=From:To:Cc:Subject:Date:From;
	b=fBYBOs2IYxdLCUXGsIuYkvtgThIv7bjt+zqRKSuq8JM52TKTzkIt3b4iysJsN7xly
	 EjnFSi/Omt7XvgGnnRb8fc8V3dIk4CTOTPCSnAr1XFUHcVWmk6963xACVsZXK2spch
	 Crrp+0JoksKcJs6CLI7XrT7Jt0UZGqPbPUoTAqDQ=
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
	bpf@vger.kernel.org,
	sdf@fomichev.me,
	daniel@iogearbox.net,
	hawk@kernel.org,
	ast@kernel.org,
	john.fastabend@gmail.com,
	weh@microsoft.com,
	edumazet@kernel.org
Subject: [PATCH net-next v7 00/13] net: mana: reconfigure by replacing the queue set
Date: Fri, 16 Oct 2026 15:38:33 +0000
Message-ID: <cover.1791710735.git.weh@linux.microsoft.com>
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

This series remains independent of the HWC concurrency/dynamic-depth
series; it is not stacked on its feature commits. Their CQ-publication
hunks overlap, so the later-applied series needs reconciliation preserving
both table-publication and individual-CQ lifetime guarantees.
https://lore.kernel.org/all/cover.1790665894.git.weh@linux.microsoft.com/

Changes since v6:

  - Rebase onto net-next d8674294aefef02266c4d47ad10131f1bffbe534
    after Simon Horman reported that v6 did not apply and CI did not run.
    Preserve upstream's GDMA core/PCI/CDX split, its separate PCI capability
    group and the RX-headroom-aware full-page shortcut.
  - Fix the DMA-region unwind required by repeated EQ-pool growth in
    patch 2. Destroy a registration still owned by software if EQ creation
    fails. A successful hardware creation invalidates that handle, so a
    later EQ-test failure does not destroy transferred ownership twice.
  - Make mana_detach() return void in patch 9 and remove unreachable
    caller error branches. Preserve deallocation logging and ndo_stop's
    required integer return.
  - Keep the thirteen-patch layout, original authors and existing signoffs.

Review notes:

  - The reported /proc/net/dev stats UAF assumes unregister_netdevice()
    defers its grace period. Its NULL-head path synchronously unlists and
    synchronizes network readers, removes sysfs state, then synchronizes
    again before returning, in both the old and new base.
  - The two stats-folding deadlock reports require unsupported 32-bit
    MANA. PCI and CDX both restrict support to 64-bit, where u64_stats_sync
    has no sequence counter or reader retry loop.
  - The xdp_xmit lost-increment race is real but already present on the
    unmodified base. Moving the counter to port-owned storage does not
    introduce it; keep that independent statistics fix separate.

Rebase request:
https://lore.kernel.org/all/20261010162855.GU83879@horms.kernel.org/
EQ unwind / detach reviews:
https://lore.kernel.org/all/sashiko-outbox-166658@kernel.org/
https://lore.kernel.org/all/sashiko-outbox-166664@kernel.org/
v6 review inventory:
https://sashiko.dev/#/patchset/cover.1790795005.git.weh@linux.microsoft.com

Changes since v5 (retained from v6):


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

Source/static qualification completed:
  - Baseline plus all thirteen commits: 28 fresh GCC/Clang W=1 target
    builds and thirteen strict checkpatch/diff checks.
  - Exact-source EQ-unwind regression: both compilers expose four v6
    leaks; nine cases pass at fixed patch 2 and final v7.
  - Full baseline/release kernels build with identical configurations.
    Sparse retains a baseline warning; Smatch retains baseline frontend
    failures/diagnostics and is not counted as a clean pass.

Fresh runtime results:
  - Stable baseline/release TCP and 64-byte UDP comparisons completed,
    forward/reverse with three samples per workload. Supported PD/MR
    and native PD/CQ/MR resource controls passed.
  - VM5 completed 39 named cases across documented exact-release boots
    and three original mixed-profile cycles, not a single-boot matrix.
  - VM6's earlier run completed 34 cases and failed repeated cleanup.
    A later exact-release run passed the four remaining XDP cases and
    all three original mixed-profile cycles. The earlier failure is
    retained, not relabeled as a complete matrix pass.
  - Three PCI remove/rescan cycles per VM passed with concurrent
    /proc/net/dev and four sysfs-stat readers, per-function resource
    identity/count checks and health dwells.
  - Both VMs were restored to their safe kernels and original controls,
    including RSS keys, tables and default/user policy. Owned fixtures
    and helpers were removed and reservations released.
  - All thirteen mails also applied cleanly to net-next d0bd617658dd.

A later unmodified net-next baseline also reproduced the TX-drain failure
class, with a pending send and a matching owned TX_OKAY completion.
DIM causality and a common root cause across runs remain unproven.
That baseline-present issue is recorded for separate investigation, not
silently treated as a passed test or a demonstrated v7 regression.
No speculative driver workaround has been added.

Prior v6 sanitizer/fault and CPU-accounting results are historical,
not fresh v7 qualification. No fresh 32-bit, CDX hardware, full-locking
or general firmware-failure recovery coverage is claimed.

v6:
https://lore.kernel.org/all/cover.1790795005.git.weh@linux.microsoft.com/

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
 .../net/ethernet/microsoft/mana/gdma_main.c   |   26 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  |    3 +-
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  108 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 1341 +++++++++++++++--
 .../ethernet/microsoft/mana/mana_ethtool.c    |  313 ++--
 include/net/mana/gdma.h                       |    8 +-
 include/net/mana/mana.h                       |   99 +-
 8 files changed, 1615 insertions(+), 286 deletions(-)


base-commit: d8674294aefef02266c4d47ad10131f1bffbe534
-- 
2.43.0
