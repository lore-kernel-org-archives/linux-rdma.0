Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44B431D757;
	Tue,  8 Sep 2026 03:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838170; cv=none; b=P2GZxbYngf3xcRixqvApgEC8V60nDx3VKwmePSJCZ5zC/l+Br53KfYWbNE8Lo2z6gvxWFAOidtNf/huGJ4A3Wwbp8tZYTW3Nm1Dkum9WnlVhjMju7ZqgNdvpl1N3IeJdb8fKxoy/SnIkFT+JrLDI8gzXYDWHdbigYQdue7h8w6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838170; c=relaxed/simple;
	bh=FGZGUgW/aS4Mj6i/ltUBTLl5sBnEUmiIDzUJsxlzTRo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HIfouQuIel7pe2F6tdov0HxM9II4J2e2wHAOZdq4IqAjqwGjwPPIoueqE83CzJN+kmOLyQsz7fIxba3uT9e3Rdo85VqoEGVHSvnA7tSHERLLARrWexbv/H4FsHl3mbV2u+8FrJDDLJ90h7N+IvsQfkB0yfDsIdsT6T8TSr/T5+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id BDBD020B710C; Mon,  7 Sep 2026 20:28:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BDBD020B710C
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Long Li <longli@kernel.org>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com,
	Simon Horman <horms@kernel.org>,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	shirazsaleem@microsoft.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 00/13] net: mana: reconfigure by replacing the queue set
Date: Mon,  7 Sep 2026 20:28:30 -0700
Message-ID: <20260908032843.397667-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace detach/attach reconfiguration with pre-allocation and queue-set
replacement. Allocation failure leaves the running configuration intact.
Publication failure attempts rollback; if rollback also fails, the port
is stopped and requires administrative recovery.

EQs and statistics belong to the port, and valid user RSS tables survive
queue rebuilds. Channel-count changes reuse surviving queues: reductions
retire only the tail, and increases allocate only the added queues. Ring,
MTU, private-flag and XDP changes that rebuild queues still require both
sets temporarily and can fail at hardware resource limits.

Patch layout:
  1-2:   Queue-set helpers and the shared EQ pool.
  3-7:   Convert channel, ring, private-flag, MTU and XDP reconfiguration.
  8:     Remove an unreachable early return from mana_detach().
  9-11:  Preserve statistics, release unused EQs and preserve RSS tables.
  12-13: Reuse queues across channel-count reductions and increases.

Overlap with submitted net fixes:

Two independent fixes have been submitted to net:

  [1] net: mana: restore the XDP program pointer when pre-allocation fails
  https://lore.kernel.org/all/20260904202640.3900685-1-longli@microsoft.com/

  [2] net: mana: do not discard an ethtool-configured RSS table on a queue
      rebuild
  https://lore.kernel.org/all/20260905004401.3937066-1-longli@microsoft.com/

Neither is a prerequisite for this series, and they are not resent here
as standalone patches. Their handling is incorporated into patches 7
and 11, respectively. Merging the trees can conflict in these blocks:

  - Patch 7, mana_bpf.c: retain the queue-set version of mana_xdp_set().
    It leaves the live program unchanged during allocation, replacing
    the pre-allocation failure path repaired by [1].
  - Patch 11, mana_en.c: retain the three-argument mana_rss_table_keep()
    and its callers, which validate the prospective queue count and
    defer swap-path loss notifications until publication succeeds.
    ETHTOOL_OP_NEEDS_RTNL_RSS in mana_ethtool.c is identical in [2] and
    this series.

These resolutions apply to the overlapping blocks, not unrelated net
changes. The two patch mails also carry the corresponding merge notes.

Changes in v4:

  - Retain pcie_flr() instead of pci_try_reset_function(), avoiding the
    device-lock conflict in the remove path.
  - Delay lowering real_num_rx_queues until retiring RQs are destroyed,
    including after rollback.
  - Add the full barrier between reopening port_is_up and reading TX
    ring state, preventing a missed queue wakeup.
  - Report persistent statistics while down or swapping; keep only the
    hardware PHY query gated on port_is_up.
  - Derive the live port inside mana_free_qset() instead of passing a
    redundant port argument.
  - Require RTNL for RSS setters. Remove loss notification from the
    non-swap allocation path, whose callers do not consistently hold
    the required netdev instance lock.
  - Wait for TX-selection readers before freeing the old RSS table in
    both channel-count paths. Clear TX slots after partial teardown.

Changes in v3:

  - Move shared EQ ownership before the first converted caller.
  - Separate retiring RX statistics and fold them on teardown or rollback.
  - Preserve carrier through successful swaps and rollback, and track
    software-forced carrier shutdown separately from hardware link events.
  - Correct kernel-doc and EQ/vector lifetime descriptions.
  - Rebase onto net-next and move the resize-recovery capability to BIT(31).

Changes in v2:

  - Replace post-failure retries with pre-allocated queue-set replacement.

Previous versions:
  v3: https://lore.kernel.org/all/20260901014442.2945689-1-longli@microsoft.com/
  v2: https://patchwork.kernel.org/project/netdevbpf/list/?series=1145125
  v1: https://lore.kernel.org/netdev/20260711041415.3008868-1-dipayanroy@linux.microsoft.com/

Dipayaan Roy (1):
  net: mana: do not bail out of mana_detach on dealloc failure

Long Li (12):
  net: mana: add queue-set allocation and teardown helpers
  net: mana: share the EQ pool across a queue-set swap
  net: mana: swap queue sets in mana_set_channels
  net: mana: swap queue sets in mana_set_ringparam
  net: mana: swap queue sets in mana_set_priv_flags
  net: mana: swap queue sets in mana_change_mtu
  net: mana: swap queue sets in mana_xdp_set
  net: mana: keep per-queue statistics in the port context
  net: mana: release EQs left idle by a channel-count reduction
  net: mana: keep a user-configured RSS table across a queue rebuild
  net: mana: keep the surviving queues when the channel count is reduced
  net: mana: keep the existing queues when the channel count is raised

 .../net/ethernet/microsoft/mana/mana_bpf.c    |   94 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 1256 +++++++++++++++--
 .../ethernet/microsoft/mana/mana_ethtool.c    |  312 ++--
 include/net/mana/gdma.h                       |    8 +-
 include/net/mana/mana.h                       |  105 +-
 5 files changed, 1524 insertions(+), 251 deletions(-)


base-commit: 1bb784eb6e38fd73143f021608e4ef3095d0c0d7
-- 
2.43.0
