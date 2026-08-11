Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A46BE33EB1B;
	Tue, 11 Aug 2026 06:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430136; cv=none; b=TXW3BobSzINPEWrH/iQZfj4PHWyeOeBtjSE6vP7F3elBFTRrm0mGmUjiDjGlG5lZbjqBa6g3HeNSz9cjoSWc6Wm0TboqOMwsNgn1VsjRpyjRhp4eorHPw6vWVp4CGAIiGc4AUnZ3uKVqTB1thgMflUAXXtm5L6FpSfttheTKgyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430136; c=relaxed/simple;
	bh=VQyMgeKpOaMF12Ry9WaNUO7mrQ01tKZ1P0zb6YPUHNw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nCL3tqCqUr9ZXHuJloCcpImetwSZ/PTYMJUNINNwKdrJUyH7rpnzDqsC3LwKQlAZizZ9CRM7ruqJVvUdigqrXx78wrGmQm2n1eMwvWNEQvUWexypLPzlY4LibrYcAcV13n4JqSOp8KRKNB6iQscXQWH+0WLMMK2QBX3I/cJ4Eto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id A4B9A20B7167; Mon, 10 Aug 2026 23:35:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A4B9A20B7167
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
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 00/13] net: mana: reconfigure by replacing the queue set
Date: Mon, 10 Aug 2026 23:34:57 -0700
Message-ID: <20260811063506.2428213-1-longli@microsoft.com>
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

  carrier off -> netif_tx_disable -> swap the queue pointers -> update the
  netdev queue counts -> reprogram RSS/steering -> reattach XDP ->
  netif_tx_start_all_queues -> restore carrier

Everything that can fail happens before anything is swapped. If allocation
fails the running queues have not been touched at all: the ethtool call
returns the error, the interface keeps forwarding traffic and the
configuration is unchanged. If the swap itself fails, the previous set is
put back and the port keeps running on it.

Patch layout:

  1     the queue-set allocate/publish/free helpers.
  2-6   convert the five callers: ethtool channels, rings and private
        flags, the MTU change and XDP attach.
  7     the remaining detach/attach users are the TX-timeout reset handler
        and suspend; make mana_detach() always finish its teardown so the
        reset handler cannot leave a port permanently dead.
  8-11  keep behaviour the swap model would otherwise change: per-queue
        counters move into the port context so a rebuild no longer zeroes
        the interface statistics, the EQ pool is shared across a swap
        instead of being duplicated, EQs left idle by a reduction are
        released, and a user-configured RSS indirection table survives a
        rebuild.
  12-13 stop rebuilding queues that do not change. A reduction keeps the
        surviving queues and an increase keeps the existing ones, so
        32 -> 8 channels destroys 24 queue pairs instead of building 8 and
        destroying 32, and 4 -> 8 builds 4 instead of 8.

Known trade-off, since it is deliberate: RX counters are now indexed by
queue number in the port context, so during the window between steering
moving to the new queues and the old ones being destroyed, both generations
can update one slot. MANA is 64-bit only, so u64_stats_sync carries no
seqcount and nothing can be corrupted; at worst a few increments are lost.
Serialising them would put a lock in the per-packet receive path, and
giving each set its own slots would make ndo_get_stats64() report a dip
during a swap, which is the regression this is meant to remove.

[1] https://lore.kernel.org/netdev/20260711041415.3008868-1-dipayanroy@linux.microsoft.com/

Dipayaan Roy (1):
  net: mana: do not bail out of mana_detach on dealloc failure

Long Li (12):
  net: mana: add queue-set allocation and teardown helpers
  net: mana: swap queue sets in mana_set_channels
  net: mana: swap queue sets in mana_set_ringparam
  net: mana: swap queue sets in mana_set_priv_flags
  net: mana: swap queue sets in mana_change_mtu
  net: mana: swap queue sets in mana_xdp_set
  net: mana: keep per-queue statistics in the port context
  net: mana: share the EQ pool across a queue-set swap
  net: mana: release EQs left idle by a channel-count reduction
  net: mana: keep a user-configured RSS table across a queue rebuild
  net: mana: keep the surviving queues when the channel count is reduced
  net: mana: keep the existing queues when the channel count is raised

 .../net/ethernet/microsoft/mana/mana_bpf.c    |  117 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 1698 ++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  333 +++-
 include/net/mana/gdma.h                       |   11 +-
 include/net/mana/mana.h                       |  130 +-
 5 files changed, 2066 insertions(+), 223 deletions(-)


base-commit: d67e5dbda22604d0fcde32fce58c65f88676e676
-- 
2.43.0

