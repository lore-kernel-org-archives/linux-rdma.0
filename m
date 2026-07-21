Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 596F945A295;
	Tue, 21 Jul 2026 23:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784677438; cv=none; b=sPclW3Jgx3YdNsnO2HoMJaPgv4Mx+pnZ7co54NzZBt+F2izhFpVg51JtnoXvbVdokp1s1rCLZRjO8uR2tiqchLJPs6lQ9JToeXVBaxH1C91ZJXD0e2UBluXIl6yX29DAFeglVaTJWw7YytJ4RBmbTTYjebDgDLFvtmjUj/OyOeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784677438; c=relaxed/simple;
	bh=hlYaD4bchown50E8IsdMXH+XuAsz9r4nJcBBSJsT21Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=THTrQdualmZX1LWePiyk88o4yFFt9xduAz4P2HL8O2MghDT+A6w4TR3N6OklUDR9NO+kW+10ordJCmqzCF3C8q+mvi1Wod/xFPjflggVK2Lk1Oaqku/oNq7ENJqp09NbkqeaqTTLvPdJklE7fyw6CGtaZzK4xIfpmM53XCebpTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id B93AC20B7167; Tue, 21 Jul 2026 16:43:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B93AC20B7167
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
Subject: [PATCH net-next v2 0/7] net: mana: harden the HWC and add dynamic queue depth
Date: Tue, 21 Jul 2026 16:43:29 -0700
Message-ID: <20260721234339.1476932-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series hardens the MANA Hardware Channel (HWC) control-plane path
and then builds on that to support a dynamic HWC queue depth.

The HWC is the command channel the driver uses to talk to the device.
Today it is created at a fixed depth of one outstanding request, and
several of its lookup and teardown paths predate the RCU and DMA-lifetime
rules they now need to follow.  Raising the queue depth and allowing
concurrent commands makes those latent races reachable, so the fixes come
first and the feature builds on them.

Patches 1-5 are fixes for pre-existing HWC bugs, each with a Fixes: tag:

  1: cq_table was a plain pointer array freed with no grace period while
     the EQ interrupt handler dereferenced it; put it under RCU.
  2: the HWC RQ and SQ were sized with each other's message size, so a
     response could overflow the RQ buffer and the RX slot stride was
     computed with the wrong size.
  3: comp_buf was freed before the EQ was destroyed, so a late completion
     handler could touch freed memory.
  4: the RX path consumed device-supplied lengths and indices without
     validation; validate them before use (this matters for confidential
     VMs, where the DMA buffer is shared with the host).
  5: a failed mana_hwc_establish_channel() could leave live MST entries
     while the driver freed the queue buffers, and destroy_channel() freed
     the TXQ/RXQ before the EQ was quiesced; add a setup_active teardown
     gate and destroy the CQ first.

Patches 6-7 add the feature:

  6: replace the depth-1 semaphore with a slot bitmap and per-slot
     synchronization so several management commands can be in flight,
     with teardown that drains in-flight senders before freeing the HWC.
  7: bootstrap the HWC at depth 1, query the device maximum and, if it is
     larger, tear down and rebuild the queues at that depth.  The reported
     dimensions are validated before they size DMA allocations, and the
     capability is advertised so firmware enables it only when the driver
     supports it.

Changes since v1:
 - patch 4: bounds-check the SGE pointer derived from the device-supplied
   inline_oob_size_div4 before dereferencing it, so a corrupted OOB size
   cannot push the read past the RQ buffer (found in review).
 - patch 6: fix a use-after-free of gdma_context during teardown -- track
   in-flight senders with a gc->hwc_lock-protected counter and drain it
   with wait_event_lock_irq(), so the last sender's wake_up() cannot touch
   gc after it is freed (found in review).
 - patch 6: move the in-flight sender force-complete and drain ahead of
   the teardown/FLR block, so the FLR-failure early return can no longer
   skip the drain and strand a sender (found in review).
 - Rebased on current net-next; kept all patches within 80 columns.
 - v1: https://lore.kernel.org/netdev/20260715032942.3945317-1-longli@microsoft.com/

Long Li (7):
  net: mana: RCU-protect gc->cq_table lookups against concurrent CQ
    destroy
  net: mana: fix HWC RQ/SQ buffer size swap
  net: mana: free HWC comp_buf after destroying the EQ
  net: mana: validate hardware-supplied values in the HWC RX path
  net: mana: fix HWC teardown safety with setup_active flag and destroy
    ordering
  net: mana: support concurrent HWC requests with proper synchronization
  net: mana: add dynamic HWC queue depth with reinit path

 drivers/infiniband/hw/mana/cq.c               |  46 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  80 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 742 ++++++++++++++++--
 drivers/net/ethernet/microsoft/mana/mana_en.c |  22 +-
 include/net/mana/gdma.h                       |  48 +-
 include/net/mana/hw_channel.h                 |  44 +-
 6 files changed, 890 insertions(+), 92 deletions(-)


base-commit: e354f7d60f14a3eacd5ec7b607346a5612f655ec
-- 
2.43.0

