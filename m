Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2963ACF01;
	Thu, 13 Aug 2026 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642998; cv=none; b=WYWZRV3tf5mv6xZSolzdD9x0pFUMvzaAsx+2PMbqEAuY0cMZcwsVUsr0EP/GAv+N+vGA5P+jKZ8vm9aXQayr74w1/lSVx8Yy89t71/+ADTp5V6LieFcBTSEz98HlsRzjeNbBMUhryKh9L8GN2ZFsSx846kWsorcCyzK/4bUDdqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642998; c=relaxed/simple;
	bh=185v7xf8z4MAcCFLWr7NwGezeIz8kXFn+lfzQCdSV4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiGi/6zAaWQ7L1T7C2jiAwAQcQhsfUpzDRGJMwGjNQXf4tRJfD5dFnCvdPxxozp4xFNj12yK0/2mw0LoRrmMMGIvccb2gSDAoUIdLmP4ndEUnvWwbcwuZbbcaiURx4BYtEq2MkNIDLT7z522kUd0husdFE0u3lQZMG/j22MPozI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id A57E920B7135; Thu, 13 Aug 2026 10:42:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A57E920B7135
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
Subject: [PATCH net v7 5/7] net: mana: fix HWC teardown safety with setup_active flag and destroy ordering
Date: Thu, 13 Aug 2026 10:42:37 -0700
Message-ID: <20260813174243.3044348-6-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260813174243.3044348-1-longli@microsoft.com>
References: <20260813174243.3044348-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Three teardown hazards let the hardware touch freed memory.

First, once mana_smc_setup_hwc() succeeds the device can DMA into the HWC
queue buffers.  If a later step in mana_hwc_establish_channel() failed,
the caller had no reliable signal that teardown was needed and could free
those buffers while the mappings were live.  Add a setup_active flag, set
the moment setup_hwc() activates the device; on failure establish_channel()
just returns and the caller's error path does the single teardown, gated
on setup_active.  (max_num_cqs was the old proxy, but it is only set when
the init EQE arrives.)

Second, destroy_channel() freed the TXQ/RXQ while the HWC EQ was still on
the interrupt dispatch list, so an in-flight interrupt could run the
handler against freed buffers.  Destroy the CQ first --
mana_hwc_destroy_cq() deregisters the EQ (list_del_rcu() +
synchronize_rcu()) -- then free the TXQ/RXQ.

Third, if mana_smc_teardown_hwc() itself fails the MST entries stay live,
yet destroy_channel() went on to free buffers the device can still DMA
into.  Leak the HWC resources on teardown failure instead, but still
deregister the EQ IRQ and unpublish the CQ so the leaked buffers are
unreachable from the interrupt handler, and keep setup_active set so it is
not mistaken for a clean teardown.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes since v6:
- The leak-on-teardown-failure branch now fences the interrupt path
  before returning: it deregisters the HWC EQ IRQ (calling the existing
  mana_gd_destroy_eq(), now made non-static) and unpublishes the CQ, so
  no late EQE can reach the leaked buffers.
- Corrected the setup_active kerneldoc comment to match the code.
 .../net/ethernet/microsoft/mana/gdma_main.c   |  4 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 63 ++++++++++++++++---
 include/net/mana/gdma.h                       |  6 ++
 include/net/mana/hw_channel.h                 |  6 ++
 4 files changed, 68 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index b29e078b419b3c16326ad890c8e97401e1d3f3a9..02f901b2cb1faf4a34e6e3e53deebeeb056f528f 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -976,8 +976,8 @@ int mana_gd_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
 	return err;
 }
 
-static void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_evenets,
-			       struct gdma_queue *queue)
+void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_evenets,
+			struct gdma_queue *queue)
 {
 	int err;
 
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 2691d609459122bdbafb144a8b77ac3785c0eddb..88188523dcd4863b254451e77cb569c12c150033 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -747,6 +747,13 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 
 	init_completion(&hwc->hwc_init_eqe_comp);
 
+	/* Set before setup_hwc() activates the device's DMA into our buffers,
+	 * so a later failure still tears the HWC down instead of freeing
+	 * buffers the device may write to.  Do not tear down here: that would
+	 * double the timeout and mask the error.
+	 */
+	hwc->setup_active = true;
+
 	err = mana_smc_setup_hwc(&gc->shm_channel, false,
 				 eq->mem_info.dma_handle,
 				 cq->mem_info.dma_handle,
@@ -837,6 +844,16 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	u16 q_depth_max;
 	int err;
 
+	/* A previous teardown may have failed and left the old context
+	 * reachable.  Retry it before building a new channel; if it still
+	 * fails, return an error so mana_serv_reset() does a full PCI rescan.
+	 */
+	if (gd->driver_data) {
+		mana_hwc_destroy_channel(gc);
+		if (gd->driver_data)
+			return -ETIMEDOUT;
+	}
+
 	hwc = kzalloc_obj(*hwc);
 	if (!hwc)
 		return -ENOMEM;
@@ -894,18 +911,40 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (!hwc)
 		return;
 
-	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
-	 * non-zero, the HWC worked and we should tear down the HWC here.
+	/* Only tear down if setup_hwc() activated the device.  If teardown
+	 * fails the device may still DMA into these buffers, so leak them
+	 * rather than free, and keep setup_active set.
 	 */
-	if (gc->max_num_cqs > 0)
-		mana_smc_teardown_hwc(&gc->shm_channel, false);
-
-	if (hwc->txq)
-		mana_hwc_destroy_wq(hwc, hwc->txq);
+	if (hwc->setup_active) {
+		int td_err = mana_smc_teardown_hwc(&gc->shm_channel, false);
+
+		if (td_err) {
+			dev_err(gc->dev,
+				"HWC teardown failed: %d, leaking resources\n",
+				td_err);
+			/* The device may still DMA into these buffers, so
+			 * leak them.  Still fence the interrupt path: drop
+			 * the EQ from the handler list and unpublish the CQ,
+			 * and NULL them so a later retry does not touch the
+			 * leaked queues again.
+			 */
+			if (hwc->cq && hwc->cq->gdma_eq) {
+				mana_gd_destroy_eq(gc, false, hwc->cq->gdma_eq);
+				hwc->cq->gdma_eq = NULL;
+			}
+			if (hwc->cq && hwc->cq->gdma_cq) {
+				mana_gd_unpublish_cq(gc, hwc->cq->gdma_cq);
+				hwc->cq->gdma_cq = NULL;
+			}
+			return;
+		}
 
-	if (hwc->rxq)
-		mana_hwc_destroy_wq(hwc, hwc->rxq);
+		hwc->setup_active = false;
+	}
 
+	/* Tear down the CQ/EQ first so no interrupt handler can touch the
+	 * RQ/TXQ buffers after this point.
+	 */
 	if (hwc->cq)
 		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
 
@@ -914,6 +953,12 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	 */
 	gc->max_num_cqs = 0;
 
+	if (hwc->txq)
+		mana_hwc_destroy_wq(hwc, hwc->txq);
+
+	if (hwc->rxq)
+		mana_hwc_destroy_wq(hwc, hwc->rxq);
+
 	kfree(hwc->caller_ctx);
 	hwc->caller_ctx = NULL;
 
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index abf243358bf82e2428478cb3cf2f387d9cd9ea28..1642d5413897c1dea49d1d4c5d80684163234e76 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -509,6 +509,12 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
 
 void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
 
+/* Flush (optional), deregister the IRQ for, and disable an EQ, without
+ * freeing its queue memory.
+ */
+void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_events,
+			struct gdma_queue *queue);
+
 /* Add a CQ to cq_table so the EQ handler can dispatch to it.  Returns
  * -EINVAL if the id is out of range or already in use.
  */
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 58ea72f32135674d41fb1469e4cce4b0d8e87560..6e77163a06d8f2622430281647268c54939c4dc0 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -205,6 +205,12 @@ struct hw_channel_context {
 	 */
 	u32 rx_leaked_wqe;
 
+	/* True once setup_hwc() may have activated the device's DMA into the
+	 * HWC buffers: set before the setup command, cleared after teardown
+	 * succeeds.
+	 */
+	bool setup_active;
+
 	struct hwc_caller_ctx *caller_ctx;
 };
 
-- 
2.43.0

