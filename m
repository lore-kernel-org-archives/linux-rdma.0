Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11FCE3A1681;
	Mon,  3 Aug 2026 23:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800666; cv=none; b=WH1AiSEhH4hdNacXKLiHi1Mh//DvbXW2w47GPnrvrkN3jM2L0hHPtNQs17FBE3lj94HYJRvJfpqzPc4qOlZxb/uuhSEO2vR/lncVxHFioa3sVZPdA7cpWm1nZTvWCJFfJ3P+i4wNC5eLFhq0pAdv2wK0uDgqYxwQfGpPw3sYk7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800666; c=relaxed/simple;
	bh=WTiKAsd4+dnhphfF/tSRwT0dOd+SkiyqJQpaOIgn0tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lmedQ8zHcp9NRJVM3jTSpnoY6Lk/g/vK//Z1CRoagiiA9X9qo20s6c2C51c2h6VaIpOpQ3H5Fvzul1x5K3MJyhUOWflMabRBdgoopFpmDpb0jnOHGNf++ttqF9+e0uLNhiHNQLdjsGO5pI6hlOhoGaZxf9tFoMV55CnTi9mzEvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 69F0120B7168; Mon,  3 Aug 2026 16:44:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 69F0120B7168
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
Subject: [PATCH net v3 5/6] net: mana: fix HWC teardown safety with setup_active flag and destroy ordering
Date: Mon,  3 Aug 2026 16:43:43 -0700
Message-ID: <20260803234355.636038-6-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260803234355.636038-1-longli@microsoft.com>
References: <20260803234355.636038-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Three teardown hazards let the hardware touch memory the driver freed.

First, once mana_smc_setup_hwc() succeeds the device has active MST
entries and can DMA into the HWC queue buffers.  If a later step in
mana_hwc_establish_channel() fails, the caller had no reliable way to
know teardown was required and could free those buffers while the
mappings were still live -- a DMA-after-free.  max_num_cqs was used as a
"HWC is up" proxy, but it is only set when the init EQE arrives.

Add a setup_active flag, set the moment setup_hwc activates MST entries.
establish_channel() now tears down on any later failure and clears
setup_active once teardown succeeds; destroy_channel() gates teardown on
setup_active.  max_num_cqs is no longer reset: it is an immutable bound
(see gdma.h) and cq_table == NULL is the sole teardown signal.

Second, destroy_channel() freed the TXQ/RXQ buffers while the HWC EQ was
still on the interrupt dispatch list, so an in-flight interrupt could run
the handler against freed buffers:

  CPU A (mana_gd_intr, hard IRQ)        CPU B (destroy_channel)
  ----------------------------------    ------------------------------
                                        free TXQ/RXQ DMA buffers
  handler accesses RQ/TXQ buffers       (EQ still registered)

Destroy the CQ first: mana_hwc_destroy_cq() -> mana_gd_deregister_irq()
removes the EQ via list_del_rcu() + synchronize_rcu(), after which no
handler can reach the queues; only then free the TXQ and RXQ.

Third, if mana_smc_teardown_hwc() itself fails the MST entries stay
live, yet destroy_channel() went on to free the CQ/RQ/TXQ buffers the
device can still DMA into -- a DMA-after-free on systems without an
IOMMU to fault the stale access.  Leak the HWC resources on teardown
failure instead of freeing memory the hardware can still reach, and
keep setup_active set so the failure is not mistaken for a clean
teardown.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/hw_channel.c  | 82 ++++++++++++++-----
 include/net/mana/gdma.h                       |  8 +-
 include/net/mana/hw_channel.h                 |  9 ++
 3 files changed, 77 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index e378b8ec97c9..1603968d7989 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -4,6 +4,7 @@
 #include <net/mana/gdma.h>
 #include <net/mana/mana.h>
 #include <net/mana/hw_channel.h>
+#include <linux/pci.h>
 #include <linux/vmalloc.h>
 
 static int mana_hwc_get_msg_index(struct hw_channel_context *hwc, u16 *msg_id)
@@ -768,20 +769,33 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	if (err)
 		return err;
 
-	if (!wait_for_completion_timeout(&hwc->hwc_init_eqe_comp, 60 * HZ))
-		return -ETIMEDOUT;
+	/* setup_hwc activated MST entries — hardware can now DMA into
+	 * our queue buffers.  If anything below fails, we must tear
+	 * down before returning so the caller doesn't need to track
+	 * whether setup_hwc succeeded.
+	 */
+	hwc->setup_active = true;
+
+	if (!wait_for_completion_timeout(&hwc->hwc_init_eqe_comp, 60 * HZ)) {
+		err = -ETIMEDOUT;
+		goto teardown;
+	}
 
 	*q_depth = hwc->hwc_init_q_depth_max;
 	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
 	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
 
 	/* Both were set in mana_hwc_init_event_handler(). */
-	if (WARN_ON(cq->id >= gc->max_num_cqs))
-		return -EPROTO;
+	if (WARN_ON(cq->id >= gc->max_num_cqs)) {
+		err = -EPROTO;
+		goto teardown;
+	}
 
 	cq_table = vcalloc(gc->max_num_cqs, sizeof(*cq_table));
-	if (!cq_table)
-		return -ENOMEM;
+	if (!cq_table) {
+		err = -ENOMEM;
+		goto teardown;
+	}
 
 	rcu_assign_pointer(cq_table[cq->id], cq);
 	/* Publish the fully-initialised table last; pairs with the
@@ -790,6 +804,16 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	rcu_assign_pointer(gc->cq_table, cq_table);
 
 	return 0;
+
+teardown:
+	{
+		int td_err = mana_smc_teardown_hwc(&gc->shm_channel, false);
+
+		if (!td_err)
+			hwc->setup_active = false;
+
+		return td_err ? td_err : err;
+	}
 }
 
 static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
@@ -907,11 +931,38 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (!hwc)
 		return;
 
-	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
-	 * non-zero, the HWC worked and we should tear down the HWC here.
+	/* Tear down the HWC if setup_hwc previously activated MST entries.
+	 * This is the definitive flag — unlike max_num_cqs which depends
+	 * on the init EQE arriving.
+	 *
+	 * If teardown fails the device may still have active MST entries
+	 * and can DMA into the HWC queue buffers.  Freeing them would risk
+	 * memory corruption on systems without an IOMMU to fault the stale
+	 * DMA, so leak the HWC resources instead of handing the pages back
+	 * to the allocator.  Keep setup_active set so the failure is not
+	 * mistaken for a clean teardown.
 	 */
-	if (gc->max_num_cqs > 0)
-		mana_smc_teardown_hwc(&gc->shm_channel, false);
+	if (hwc->setup_active) {
+		int td_err = mana_smc_teardown_hwc(&gc->shm_channel, false);
+
+		if (td_err) {
+			dev_err(gc->dev,
+				"HWC teardown failed: %d, leaking resources\n",
+				td_err);
+			return;
+		}
+
+		hwc->setup_active = false;
+	}
+
+	/* Tear down the HWC CQ object first — mana_hwc_destroy_cq()
+	 * both unpublishes the CQ from cq_table (+synchronize_rcu) and
+	 * deregisters the HWC EQ from the interrupt handler list (via
+	 * mana_gd_deregister_irq + synchronize_rcu), guaranteeing no
+	 * interrupt handler can access RQ/TXQ buffers after this point.
+	 */
+	if (hwc->cq)
+		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
 
 	if (hwc->txq)
 		mana_hwc_destroy_wq(hwc, hwc->txq);
@@ -919,17 +970,6 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (hwc->rxq)
 		mana_hwc_destroy_wq(hwc, hwc->rxq);
 
-	if (hwc->cq)
-		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
-
-	/* Reset only after mana_hwc_destroy_cq() above has run with a valid
-	 * max_num_cqs so mana_gd_destroy_cq() clears the CQ table slot and
-	 * waits out in-flight EQ handlers (synchronize_rcu) before the CQ is
-	 * freed.  Clearing it earlier would make that path early-return and
-	 * skip the slot clear, leaving a dangling cq_table entry.
-	 */
-	gc->max_num_cqs = 0;
-
 	kfree(hwc->caller_ctx);
 	hwc->caller_ctx = NULL;
 
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 0b48ded0aecd..74eccc80cf6b 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -416,7 +416,13 @@ struct gdma_context {
 	/* L2 MTU */
 	u16 adapter_mtu;
 
-	/* This maps a CQ index to the queue structure. */
+	/* Size of cq_table, i.e. the largest valid CQ index + 1.  Set once
+	 * when cq_table is allocated and treated as immutable for the
+	 * table's lifetime (a bound only) -- it is never reset on teardown.
+	 * cq_table == NULL is the sole "table torn down" signal, so every
+	 * cq_table[id] access must guard with both !cq_table (gone) and
+	 * id >= max_num_cqs (out of bounds).
+	 */
 	unsigned int		max_num_cqs;
 	/* Both the base pointer and each entry are RCU-managed.  The fast
 	 * path (mana_gd_process_eqe) reads the base via rcu_dereference()
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 73671f479399..3d8543acb5cc 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -200,6 +200,15 @@ struct hw_channel_context {
 	u32 pf_dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* Set after mana_smc_setup_hwc() succeeds (hardware has active
+	 * MST entries).  Cleared only after mana_smc_teardown_hwc()
+	 * succeeds, on both the recoverable establish_channel path and the
+	 * terminal destroy_channel path.  If teardown fails it stays set:
+	 * establish_channel() skips its retry and destroy_channel() leaks
+	 * the HWC rather than free buffers the device may still DMA into.
+	 */
+	bool setup_active;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
-- 
2.43.0

