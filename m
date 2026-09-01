Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9835345560D;
	Tue,  1 Sep 2026 20:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788292867; cv=none; b=bhRFWE3XC45+p/HP9nAm53gGNLowVJH+sDHpMlpFkZJVYMcL0qqDZg1mo8T0175tgL+I1YLArNxDxuxkXJXlIJQKHIjleMI34V3Oo55zJaY8KtrosplX6QT4BHa1+8oWRxK0rtWDCI6PTgRye1qxrgiHhQ51LgBPCasUDfkVHa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788292867; c=relaxed/simple;
	bh=KHoqP4WNh378MH1e2xQZFd7aitAGYyEJiGcs1HzscKE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=flzovBHPlj6FjtdTDMZuQ9HQr0jFlfe3IDZmGBBqwuHOinwoMSSlGLG51ZvZa+p46Cs44Aur0t9ojg6qaQHPm3uvUAMfxHWf032cCpGtrTFCRSpe0HkpN3zfVPd/Wg+kJs/WZm7Af9rkYJGbCjVTDzZGiB4CJXVYJ5jBaoVltds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 3A29220B7166; Tue,  1 Sep 2026 13:00:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3A29220B7166
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
Subject: [PATCH net-next v4 0/4] net: mana: concurrent HWC requests and dynamic queue depth
Date: Tue,  1 Sep 2026 13:00:12 -0700
Message-ID: <20260901200018.3194525-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MANA Hardware Channel (HWC) is the control path the driver uses to
talk to the device.  It is created at a fixed depth of one outstanding
request, so every management command serialises behind the previous one.
This series lets several commands be in flight and raises the queue depth
to what the device reports.

Patches 1-2 are preparation and change no behaviour on their own.  Patch 1
records whether mana_smc_setup_hwc() got as far as handing the queue
addresses to the PF, which the reinit path in patch 4 needs in order to
know whether the device may still be using the queues.  Patch 2 gives each
message slot its own lock, refcount and completion state, which is what
makes more than one slot usable at a time.

Patch 3 makes the channel actually concurrent: a per-queue lock around
mana_gd_post_and_ring(), a bounded wait for a free slot, and a teardown
that drains in-flight senders before freeing the HWC.

Patch 4 bootstraps the HWC at depth 1, queries the device maximum and, if
it is larger, tears the queues down and rebuilds them at that depth.  The
device-reported dimensions are validated before they size DMA allocations,
and the dynamic-depth capability is advertised so firmware enables it only
for drivers that support it.

None of the four carries a Fixes: tag; the bug fixes that used to be part
of this series are being handled separately (see below).

Changes since v2:

 - Split the series.  v2 mixed five Fixes:-tagged bug fixes with the two
   feature patches and targeted net-next.  Per review feedback [1] the
   fixes now go via the net tree on their own, and this series carries
   only the feature work.  It no longer depends on that series: it
   applies to net-next as it stands today.

 - Because the fixes are no longer in front of them, the two feature
   patches were reworked rather than rebased.  The groundwork they used
   to inherit is now provided by the two preparation patches 1-2, which
   are deliberately not fixes and carry no Fixes: tag.

 - patch 3: the slot admission was reworked.  Acquisition uses
   down_timeout() so a caller expires rather than blocking on a slot
   that a timed-out request is still holding, and channel_up is
   re-checked under the bitmap lock once a permit is held so teardown
   cannot be missed.

 - patch 3: a slot whose request timed out is no longer released back to
   the pool -- only the matching response, or teardown, reclaims it.
   Releasing it early let a late response land on whichever command had
   since reused the slot.  mlx5 gates its command slots the same way
   ("only real completion can free the cmd slot", drivers/net/ethernet/
   mellanox/mlx5/core/cmd.c).

 - patch 4: validate the device-reported dimensions before they size DMA
   allocations -- require the negotiated message sizes to match the
   bootstrap ones, bound the depth by HW_CHANNEL_MAX_QUEUE_DEPTH, check
   that q_depth * max_msg_size plus alignment fits in u32, and carry the
   depth as u32 since the device field is 24-bit and truncating to u16
   could wrap a large value to a small depth.

 - patch 4: refuse the channel if the initialisation handshake did not
   supply a doorbell, rather than letting INVALID_DOORBELL reach
   mana_gd_ring_doorbell().

 - patch 4: a device that refuses the larger-depth establish now falls
   back to a working bootstrap channel instead of failing probe, but
   only once a retried DESTROY_HWC has confirmed the queue mappings are
   gone.

Testing on Azure hardware, with the series applied on net-next:

 - 17518 HWC commands, all completing successfully, with up to 2 in
   flight at once (the bootstrap channel can only ever have 1).
 - PCI remove/rescan x3: the reinit path runs every time, and the
   channel comes back at the larger depth.
 - iperf3 -P16: 1.24 TBytes at 182 Gbit/s, no taint and no splats.
 - Fault injection: with every HWC response dropped so that all slots
   end up held by timed-out requests, callers return -ETIMEDOUT in
   sub-millisecond time instead of blocking, no hung tasks, and the
   driver recovers once responses resume.

[1] https://lore.kernel.org/all/7108c005-6b8d-4dda-82cc-e665cbe3b6a4@redhat.com/

 - v2: https://lore.kernel.org/all/20260721234339.1476932-1-longli@microsoft.com/
 - v1: https://lore.kernel.org/netdev/20260715032942.3945317-1-longli@microsoft.com/

Long Li (4):
  net: mana: track when the HWC has been handed to the PF
  net: mana: give each HWC message slot its own completion state
  net: mana: support concurrent HWC requests
  net: mana: add dynamic HWC queue depth with reinit path

 .../net/ethernet/microsoft/mana/gdma_main.c   |  63 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 763 ++++++++++++++++--
 .../net/ethernet/microsoft/mana/shm_channel.c |  11 +-
 include/net/mana/gdma.h                       |  19 +
 include/net/mana/hw_channel.h                 |  64 +-
 include/net/mana/shm_channel.h                |   2 +-
 6 files changed, 862 insertions(+), 60 deletions(-)


base-commit: 1bb784eb6e38fd73143f021608e4ef3095d0c0d7
-- 
2.43.0

