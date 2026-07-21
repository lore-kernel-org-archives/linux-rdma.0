Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9881846A5FA;
	Tue, 21 Jul 2026 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784677446; cv=none; b=XGH7jU87gUKf87ZwmrHhWG3XkKLdveCKR3OtER6rlRAXM2egAWUkA5Sug0ac5roj/SUL9o82TA/GzVr+AKCKK5ZpnZBormxXW69u4G6K9W1Zbgx3fdMNPuO16PkkBdn7slyv7JQ7lGaMQi5/vbqyW+4XLQ4lbXsqb6+7QdRboZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784677446; c=relaxed/simple;
	bh=p2ms+QDxkxkErU162nZmKVjpnabLIjLlXpMphuFj6sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CAQ8p7HmL2pkWWwQhxk+YMmgdw53CY1am7Wcsur5lrHwCHVzAXaiv56+2dQNZkWoiVQPpKtr8qcrN2mLi/rYhKdrmqpZKjaob1mJeoEqRv1GfypUFcN3T8hkZHhFIIPIeCgFpqxoeoPUu9ofsLUhPNueNvd7YhAa5CUjFWzEDmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 08FB220B716A; Tue, 21 Jul 2026 16:43:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 08FB220B716A
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
Subject: [PATCH net-next v2 5/7] net: mana: fix HWC teardown safety with setup_active flag and destroy ordering
Date: Tue, 21 Jul 2026 16:43:34 -0700
Message-ID: <20260721234339.1476932-6-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260721234339.1476932-1-longli@microsoft.com>
References: <20260721234339.1476932-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Two teardown hazards let the hardware touch memory the driver freed.

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

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
 .../net/ethernet/microsoft/mana/hw_channel.c  | 102 ++++++++++++++----
 include/net/mana/gdma.h                       |   8 +-
 include/net/mana/hw_channel.h                 |   8 ++
 3 files changed, 96 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 515c45c4a890..5bc873d548d5 100644
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
@@ -902,11 +926,58 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (!hwc)
 		return;
 
-	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
-	 * non-zero, the HWC worked and we should tear down the HWC here.
+	/* Tear down the HWC if setup_hwc previously activated MST entries.
+	 * This is the definitive flag — unlike max_num_cqs which depends
+	 * on the init EQE arriving.
 	 */
-	if (gc->max_num_cqs > 0)
-		mana_smc_teardown_hwc(&gc->shm_channel, false);
+	if (hwc->setup_active) {
+		int td_err = mana_smc_teardown_hwc(&gc->shm_channel, false);
+
+		if (td_err) {
+			dev_err(gc->dev, "HWC teardown failed: %d, issuing FLR\n",
+				td_err);
+
+			/* On systems without IOMMU, freeing DMA memory with
+			 * active hardware MST mappings risks memory corruption.
+			 * Issue FLR to force-reset the device and invalidate
+			 * all hardware state including MST entries.
+			 */
+			td_err = pcie_flr(to_pci_dev(gc->dev));
+			if (td_err) {
+				/* Device wedged: teardown and FLR
+				 * both failed, so hardware may still
+				 * DMA into our queue buffers.  Leak
+				 * all HWC DMA buffers instead of
+				 * freeing memory the device can still
+				 * reach; without an IOMMU the freed
+				 * pages could be reused under live
+				 * DMA.
+				 */
+
+				dev_warn(gc->dev,
+					 "Leaked HWC DMA buffers (CQ/RQ/TXQ) to prevent memory corruption. Device is no longer usable.\n");
+
+				/* Do not call destroy_cq/wq below;
+				 * they would dma_free_coherent().
+				 * Leave hwc/cq/rxq/txq allocated.
+				 */
+				return;
+			}
+
+			dev_info(gc->dev, "FLR succeeded, hardware state cleared\n");
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
@@ -914,17 +985,6 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
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
index da52701e7816..9ca7cf523366 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -428,7 +428,13 @@ struct gdma_context {
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
index 73671f479399..684dcec8e612 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -200,6 +200,14 @@ struct hw_channel_context {
 	u32 pf_dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* Set after mana_smc_setup_hwc() succeeds (hardware has active
+	 * MST entries).  On recoverable paths (establish_channel)
+	 * cleared only after successful teardown so a retry remains
+	 * possible.  On the terminal destroy_channel path, cleared
+	 * unconditionally since hwc is about to be freed.
+	 */
+	bool setup_active;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
-- 
2.43.0

