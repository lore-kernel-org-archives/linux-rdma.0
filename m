Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CA73B103B;
	Tue,  1 Sep 2026 01:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227127; cv=none; b=rms/XHJdcKfPLxYvevmJqLzbtXv0yw5pYaps18g6cctr3btW+/sZOXD7fMgWDmXOLmtooM6ekpcc2cDvhUdBT/tjj8yHOcv7UxS8uanTL/2r+r9TeMFOsx0oLL+gAWQWBc9r12co7/VP5IkpjEsyVFyl770FcRA6/ks3TeyA2nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227127; c=relaxed/simple;
	bh=BzOJBGeE+UxKh8iJXGYqWckIzhDuLl2PMX0Pw4QpVdY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hTCrQ7jP3SuikVjZyrkQWwUvZObZ0LOgErjQbqXv+XXl+o6AjhJmjjfa9R2PjYoqvGVIgKjlwlqh1OeRD5n+f2ksvappCArNIFxHcLdpbM7nzMVsDsQXCQgEkUOIUGnkWvXtJh5MHANraXLqP8Wq5JcxKOaoJgxXh7uFY8KKjXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 50C4920B7166; Mon, 31 Aug 2026 18:44:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 50C4920B7166
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
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
Subject: [PATCH net-next v3 00/13] net: mana: reconfigure by replacing the queue set
Date: Mon, 31 Aug 2026 18:44:29 -0700
Message-ID: <20260901014442.2945689-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MANA reconfigures a port by destroying its queues and building them again.
mana_detach() tears the whole queue set down, mana_attach() allocates a new
one, and every path that changes a queue property does this: the ethtool
channel, ring and private-flag setters, the MTU change and XDP attach.

If the second half fails there is nothing left to fall back to. The old
queues are already gone, so the port stays down and the failure cannot be
undone from userspace:

  # ethtool -G ens1 rx 8192 tx 16384      # under memory pressure
  netlink error: Cannot allocate memory
  mana 7870:00:00.0 ens1: Failed to create 16 TX queues, -12
  mana 7870:00:00.0 ens1: mana_attach failed: -12
  # ip link show ens1
  ... state DOWN

On VM SKUs with no netvsc fallback interface this takes the VM off the
network entirely, and it is reachable from an ordinary ethtool ring resize
that happens to run when memory is tight.

v1 [1] tried to recover after the fact: schedule a reset and retry
mana_attach() with smaller values, falling back to the previous setting or
to the defaults. Review pointed out that silently replacing a user's
setting with a different one is the wrong behaviour, and that
pre-allocating the resources and replacing the queue set looked feasible
and should be investigated instead. This series does that, so there is no
failure to recover from and no user setting to override.

The model is to build the new queue set alongside the running one, publish
it, then retire the old one.

  netif_tx_disable -> swap the queue pointers -> update the netdev queue
  counts -> reprogram RSS/steering -> reattach XDP ->
  netif_tx_start_all_queues

Everything that can fail happens before anything is swapped. If allocation
fails the running queues have not been touched at all: the ethtool call
returns the error, the interface keeps forwarding traffic and the
configuration is unchanged. If the swap itself fails, the previous set is
put back and the port keeps running on it. The carrier is left alone
throughout, so a reconfiguration is not reported to userspace as a link
flap; only the paths that give up entirely take it down.

Patch layout:

  1     the queue-set allocate/publish/free helpers.
  2     give the port a shared EQ pool, so a swap never needs old + new
        MSI-X vectors at once. This lands before the first converted
        caller, so no patch in the series carries that window.
  3-7   convert the five callers: ethtool channels, rings and private
        flags, the MTU change and XDP attach.
  8     the remaining detach/attach users are the TX-timeout reset handler
        and suspend; make mana_detach() always finish its teardown so the
        reset handler cannot leave a port permanently dead.
  9-11  keep behaviour the swap model would otherwise change: per-queue
        counters move into the port context so a rebuild no longer zeroes
        the interface statistics, EQs left idle by a reduction are
        released, and a user-configured RSS indirection table survives a
        rebuild.
  12-13 stop rebuilding queues that do not change. A reduction keeps the
        surviving queues and an increase keeps the existing ones, so
        32 -> 8 channels destroys 24 queue pairs instead of building 8 and
        destroying 32, and 4 -> 8 builds 4 instead of 8.

Testing, on Standard_D32ds_v6 (MANA) running Ubuntu 24.04:

  - the failure above, made deterministic with fail_page_alloc: before the
    series the port ends up down and unrecoverable; after it, ethtool
    returns -ENOMEM, the ring sizes are unchanged, the link stays up and
    traffic is uninterrupted.
  - 33-case functional matrix over channel counts 1/2/4/8/32, ring sizes,
    MTU, the private flag and XDP attach/detach across each, including
    reconfiguration while the port is administratively down.
  - XDP: all four verdicts exercised. PASS and TX across every
    reconfiguration, DROP and REDIRECT verified by counter and by effect.
    The program stays attached and RX keeps flowing across channel
    shrink/grow, ring resize, MTU change and private-flag toggle, with
    16.8 Gbit/s of received traffic running through the program while the
    queue set is replaced underneath it.
  - a queue-set allocation forced to fail while an XDP program is attached,
    to exercise the unpublished-set teardown.
  - carrier: no transition is reported across a successful reconfiguration,
    and a port left down by a give-up path comes back with "ip link set
    down/up".
  - no KASAN reports, BUGs or WARNs in any of the above.
  - every patch builds with W=1 with no new warnings, checkpatch clean, and
    scripts/kernel-doc -Wall is clean on every patch rather than only the
    tip.

On the review process point raised on v1: the AI review of that series is
what prompted this rework rather than a fix on top of it, since the
comments were about the detach/attach model itself. This series has been
through further rounds of the same review since v2. Where a comment was
acted on the change is in the patches - the carrier and RX statistics items
in the changelog below both came from that. The classes not acted on are
the pre-existing lockless ndo_xdp_xmit() arrangement and the existing
teardown-after-failed-reset behaviour, both of which predate and are
unchanged by this series. I am happy to go through any of them in detail.

Changes in v3:

  - Move the shared EQ pool from patch 9 to patch 2, so no intermediate
    patch needs old + new MSI-X vectors at once. Confirmed on hardware:
    with the v2 order, "ethtool -L ens1 combined 32" applied at patch 2
    fails with "netlink error: No space left on device" and "No free MSI
    vectors available" in dmesg; with the new order the same command
    succeeds.

  - RX statistics across a swap: a retiring queue now counts into its own
    storage, which the port folds back when the queue is destroyed. The two
    generations no longer share a counter slot during the window between
    steering moving to the new queues and the old ones being freed. v2's
    cover letter documented that overlap as an accepted trade-off; it is
    fixed rather than documented now.

  - Carrier handling:
      * a successful swap no longer takes the carrier down and back up, so
        a reconfiguration is not seen by userspace as a link flap;
      * the paths that give up and force the carrier down record that, and
        the next successful open restores it, which is what makes the
        documented "recoverable with a down/up" actually true;
      * a real link event clears that record, so a stale software claim
        cannot override the hardware state;
      * open does not restore the carrier if a disconnect is pending.

  - kernel-doc: add the missing "Return:" descriptions on mana_grow_eqs()
    and mana_qset_scratch_alloc(), and drop the /** markers from
    mana_alloc_qset() and mana_publish_qset(), which were never meant to be
    kernel-doc. Found by running scripts/kernel-doc with -Wall, which our
    gate was not doing.

  - Patch 10: drop an incorrect claim from the commit message. v2 said the
    MSI-X vectors are released along with the EQs. They are not -
    mana_gd_setup_irqs() references every vector at probe, so
    "grep -c mana /proc/interrupts" is unchanged at every queue count. What
    a shrink returns is the pool slot, so a later increase can take it
    again.

  - Rebased on net-next. The driver capability flag this series adds now
    sits at BIT(31), since BIT(30) was taken by
    GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS in the meantime.

Changes in v2:

  - Complete rework, as described above: replace the queue set rather than
    recover after a failed mana_attach().

[1] v1: https://lore.kernel.org/netdev/20260711041415.3008868-1-dipayanroy@linux.microsoft.com/
[2] v2: https://lore.kernel.org/all/20260813050418.2906468-1-longli@microsoft.com/

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

 .../net/ethernet/microsoft/mana/mana_bpf.c    |  110 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 1629 ++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  332 +++-
 include/net/mana/gdma.h                       |   11 +-
 include/net/mana/mana.h                       |  155 +-
 5 files changed, 2011 insertions(+), 226 deletions(-)


base-commit: 1bb784eb6e38fd73143f021608e4ef3095d0c0d7
-- 
2.43.0

