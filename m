Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794473560;
	b=qiIbr+N9/jO1vwqtTQpV8xTVaD11qEzuKr6xIXjEOafIMJ+NA0+Ydowr6boSGUgMX3bL
	 fLEoS1UN/ALIdOL1NqUP1PQtUsEGO/zh6xPOpJU7MHFdIw7yMukNs3fC6QxiyHELncDit
	 lZRDhef3JHo97SUePSHTjRv0gea+FZ+qOZ0VbIWBRN/w+8MloZ1Z3X5uGmcnD3x0Frr9d
	 sQoMFuDB33fJxsjQ3lVCnZOJjL2L5g9l8pARe5bc9lLNRLszSGDJ0KLt5tgcdeaJUTlQX
	 g+ACyBqG30WYI1en0jSIA2xBNjlyfmaFqK0VEzUKJk6cArXvPrq8CxmUUB/m8qTyBcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794473560;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=+kiwRl0+gV2C2BP7bzttjinUFnQGPefVbMAuYlBgons=;
	b=RNRj1yUSqDEMYtii/EpgIaBgV2HwgNTohLU1c+HrHRn5Dlzr73kpsh2uguNS0s9nMeLf
	 pwCi/jNaXSoSgdF9vingk/xRcCd6A0egY51As7k9zzQVpS/eTzLZpuRr7X+/xE/y7YxRF
	 WNYxGEIrYGXy0IRfbi7cg2bPoqjQiQL3Q5WJJCE+QS2b3HVahuhGES+VvyCFawTrVy2fb
	 9B9VAi93tIwf+JJnthiArzbO/VMAKaCupP6CO3DTz+u0YtlQxXnxCnymZWwH3VePS6XpA
	 y3a3AJP+gaJExbPQeSHPZmJMy+ardluc/OZv7KFSPcWmxs71YK2PY/8RuM22HXO06yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=emYsPyM7;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2795A606A31C;
	Thu, 12 Nov 2026 08:52:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2795A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=emYsPyM7
Received: from kali.mshome.net (unknown [4.213.232.20])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7426C20B7168;
	Thu, 12 Nov 2026 00:52:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7426C20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794473555;
	bh=+kiwRl0+gV2C2BP7bzttjinUFnQGPefVbMAuYlBgons=;
	h=From:To:Cc:Subject:Date:From;
	b=emYsPyM70mF2jwcgtbABlYPz5B4rtl7BH54jsTZwaTJXpd8jpLiSQZsidiEOXgELY
	 RGzOcCuudwkujzdEz2jvQeqSaAHyosek0vksDrG9kIa4RuWWWhqaZsaWCE2DoaNOkM
	 kUjysovfz7qIilo3YKgejWM17QUcCuO0KFctQczY=
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
To: haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	gargaditya@linux.microsoft.com,
	mawasthi@linux.microsoft.com,
	kees+treewide@kernel.org,
	schakrabarti@linux.microsoft.com,
	leitao@debian.org,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH net v3] net: mana: Avoid waiting on dead HWC after device reset
Date: Thu, 12 Nov 2026 02:52:10 -0600
Message-ID: <20261112085226.878780-1-sahilchandna@linux.microsoft.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After device reset is issued due to TX drain timeout in
mana_dealloc_queues(), hardware channel (HWC) state is non-functional.
However, the driver continues to issue HWC commands (mana_disable_vport_rx,
mana_fence_rqs, mana_destroy_wq_obj) which will each wait for a
completion that never arrives.

The first such command (MANA_CONFIG_VPORT_RX) blocks for the full
hwc_timeout (60s as set by the firmware on the tested system), after
which the timeout is reduced to 1 ms for subsequent commands. This
causes the calling thread to hold the RTNL lock for over 180 seconds
(120s TX drain + 60s HWC timeout), triggering hung task warnings and
blocking all other networking operations on the system.

Fix this by:
1. Replacing the sleep-based TX drain with a CQE polling approach:
   disable NAPI per queue and poll its CQ synchronously, with up to 3
   more polls 100 ms apart to collect late completions. Reset the
   device only if sends remain unacknowledged after that, then free
   uncompleted SKBs. The device is reset at most once per call, and
   not at all if an earlier reset already marked the HWC dead. Once a
   queue is found stuck or the HWC is dead, the remaining queues are
   polled only once. This replaces the 120s drain timeout with at most
   300 ms of sleep per queue.
2. Setting the hwc_dead flag after a successful device reset. If the
   reset fails, the device may not have been reset and may still access
   memory, so teardown commands are still posted, but hwc_timeout is
   lowered to 1 ms so that they do not each wait the full timeout.
3. Checking the hwc_dead flag in mana_hwc_send_request() before taking
   an HWC message slot and again before posting the WQE, and returning
   -ETIMEDOUT immediately without submitting commands to hardware that
   cannot respond. A request that was already posted, or that passed
   these checks just before hwc_dead was set (for example from the
   gf_stats worker, which do not hold RTNL), still waits for
   its own timeout, as before this patch.
4. Skipping mana_fence_rqs() and the SHM channel teardown handshake
   once hwc_dead is set.

Fixes: a7dfeda6fdec ("net: mana: Fix MANA VF unload when hardware is unresponsive")
Cc: stable@vger.kernel.org
Co-developed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
---
Changes in v3:
- Resolve sashiko comments, poll last 100 ms before device reset.
- Stop the drain retries once the HWC is dead.
- Fail fast in mana_hwc_send_request() only when hwc_dead is set, not
  when hwc_timeout is 0, so requests made after mana_serv_reset() are
  still posted as before this patch.
- When the device reset fails, do not set hwc_dead, so teardown
  commands are still posted, but lower hwc_timeout to 1 ms so they do
  not each wait the full timeout
- Read hwc_timeout once with READ_ONCE() and lower it with cmpxchg(),
  so a concurrent 0 from mana_serv_reset() is not overwritten.
- Use READ_ONCE() for all hwc_dead reads.
Link to v2: https://lore.kernel.org/all/20261030125009.3758592-1-sahilchandna@linux.microsoft.com/

Changes in v2:
- Add bounded wait for late TX completions before deciding that a
  queue is stuck, poll the CQ up to 3 times, 100 ms apart.
- check hwc_timeout and hwc_dead before taking an HWC message slot,
  not only before posting the WQE.
Link to v1: https://lore.kernel.org/all/20261025072838.1991785-1-sahilchandna@linux.microsoft.com/

 .../net/ethernet/microsoft/mana/gdma_main.c   |   4 +-
 .../net/ethernet/microsoft/mana/gdma_pci.c    |   2 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  |  36 ++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 137 ++++++++++++++----
 include/net/mana/hw_channel.h                 |   1 +
 include/net/mana/mana.h                       |   2 +
 6 files changed, 144 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index ab942d5bfe05..94ee3b61527d 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -153,7 +153,9 @@ bool mana_need_log(struct gdma_context *gc, int err)
 		return true;

 	hwc = gc->hwc.driver_data;
-	if (hwc && hwc->hwc_timeout == 0)
+	if (hwc &&
+	    (READ_ONCE(hwc->hwc_timeout) == 0 ||
+	     READ_ONCE(hwc->hwc_dead)))
 		return false;

 	return true;
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_pci.c b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
index ed8925296c8a..3995e4ab4c96 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_pci.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
@@ -102,7 +102,7 @@ static void mana_serv_reset(struct pci_dev *pdev)
 	}

 	/* HWC is not responding in this case, so don't wait */
-	hwc->hwc_timeout = 0;
+	WRITE_ONCE(hwc->hwc_timeout, 0);

 	dev_info(&pdev->dev, "MANA reset cycle start\n");

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index fb9f38f65911..ca9dcbfea9e4 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -192,7 +192,7 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,

 		switch (type) {
 		case HWC_DATA_CFG_HWC_TIMEOUT:
-			hwc->hwc_timeout = val;
+			WRITE_ONCE(hwc->hwc_timeout, val);
 			break;

 		case HWC_DATA_HW_LINK_CONNECT:
@@ -819,7 +819,11 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	 * non-zero, the HWC worked and we should tear down the HWC here.
 	 */
 	if (gc->max_num_cqs > 0) {
-		mana_smc_teardown_hwc(&gc->shm_channel, false);
+		if (READ_ONCE(hwc->hwc_dead))
+			dev_warn(hwc->dev,
+				 "HWC unavailable, skip SHM teardown handshake\n");
+		else
+			mana_smc_teardown_hwc(&gc->shm_channel, false);
 		WRITE_ONCE(gc->max_num_cqs, 0);
 	}

@@ -867,9 +871,17 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	u32 dest_vrcq;
 	u32 dest_vrq;
 	u32 command;
+	u32 timeout;
 	u16 msg_id;
 	int err;

+	/* Fail fast before taking the HWC slot, after a device reset, a
+	 * request already holding slots will release them once their own
+	 * timeout expires.
+	 */
+	if (READ_ONCE(hwc->hwc_dead))
+		return -ETIMEDOUT;
+
 	mana_hwc_get_msg_index(hwc, &msg_id);

 	tx_wr = &txq->msg_buf->reqs[msg_id];
@@ -902,21 +914,31 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	dest_vrq = hwc->dest_vrq_id;
 	dest_vrcq = hwc->dest_vrcq_id;

+	/* If the HWC is unavailable after device reset, do not post the WQE,
+	 * the hardware cannot respond, so fail fast instead of waiting for
+	 * the full timeout.
+	 */
+	if (READ_ONCE(hwc->hwc_dead)) {
+		err = -ETIMEDOUT;
+		goto out;
+	}
+
 	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
 	if (err) {
 		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
 		goto out;
 	}

+	timeout = READ_ONCE(hwc->hwc_timeout);
 	if (!wait_for_completion_timeout(&ctx->comp_event,
-					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
-		if (hwc->hwc_timeout != 0)
+					 (msecs_to_jiffies(timeout)))) {
+		if (timeout)
 			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
-				command, hwc->hwc_timeout);
+				command, timeout);

 		/* Reduce further waiting if HWC no response */
-		if (hwc->hwc_timeout > 1)
-			hwc->hwc_timeout = 1;
+		if (timeout > 1)
+			cmpxchg(&hwc->hwc_timeout, timeout, 1);

 		err = -ETIMEDOUT;
 		goto out;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 38249e092090..739021aa09b3 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2086,7 +2086,9 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	if (atomic_sub_return(pkt_transmitted, &txq->pending_sends) < 0)
 		WARN_ON_ONCE(1);

-	/* Feed DIM with the completion rate observed here, in NAPI context. */
+	/* Feed DIM with the completion rate observed here, in NAPI context
+	 * or in the TX drain of mana_dealloc_queues() after NAPI is disabled.
+	 */
 	cq->tx_dim_pkts += pkt_transmitted;
 	cq->tx_dim_bytes += tx_bytes;

@@ -2612,6 +2614,8 @@ static void mana_update_tx_dim(struct mana_cq *cq)
 	/* cq->tx_dim_pkts/bytes are accumulated in mana_poll_tx_cq(), in the
 	 * same NAPI context as this read, so they track the hardware
 	 * completion rate and need no u64_stats_sync protection.
+	 * The TX drain in mana_dealloc_queues() also adds to them,
+	 * but only after NAPI is disabled, so not concurrently with this read.
 	 */
 	dim_update_sample(READ_ONCE(cq->dim_event_ctr), cq->tx_dim_pkts,
 			  cq->tx_dim_bytes, &dim_sample);
@@ -2724,10 +2728,10 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 			cancel_work_sync(&apc->tx_qp[i]->tx_cq.dim.work);
 		}

-		/* Forget the SKBs freed without being completed after a drain
-		 * timeout, now that NAPI can't complete any. Doing it here also
-		 * covers the queues that a lower channel count won't recreate,
-		 * which could otherwise stay stopped.
+		/* Forget the SKBs freed in mana_dealloc_queues() without
+		 * completion, now that NAPI can't complete any. Doing it
+		 * here also covers the queues that a lower channel count
+		 * won't recreate, which could otherwise stay stopped.
 		 */
 		netdev_tx_reset_queue(apc->tx_qp[i]->txq.net_txq);

@@ -3775,19 +3779,25 @@ int mana_attach(struct net_device *ndev)
 	return 0;
 }

+#define MANA_TX_DRAIN_RETRIES	3
+
 static int mana_dealloc_queues(struct net_device *ndev)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
-	unsigned long timeout = jiffies + 120 * HZ;
 	struct gdma_dev *gd = apc->ac->gdma_dev;
+	struct hw_channel_context *hwc;
+	int flr_pending, i, err, retry;
+	bool trigger_flr = false;
 	struct mana_txq *txq;
 	struct sk_buff *skb;
-	int i, err;
-	u32 tsleep;
+	u32 flr_txq_id = 0;
+	u32 timeout;

 	if (apc->port_is_up)
 		return -EINVAL;

+	hwc = gd->gdma_context->hwc.driver_data;
+
 	if (apc->rxqs)
 		mana_chn_setxdp(apc, NULL);

@@ -3799,42 +3809,110 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	 * a txq because it may not timely see apc->port_is_up being cleared
 	 * to false, but it doesn't matter since mana_start_xmit() drops any
 	 * new packets due to apc->port_is_up being false.
-	 *
-	 * Drain all the in-flight TX packets.
-	 * A timeout of 120 seconds for all the queues is used.
-	 * This will break the while loop when h/w is not responding.
-	 * This value of 120 has been decided here considering max
-	 * number of queues.
+	 * Drain the in-flight TX completions for each queue. TX is already
+	 * stopped, so pending_sends can no longer grow. For each queue,
+	 * disable NAPI so it cannot run at the same time as this drain,
+	 * then poll its CQ for up to 300 ms. If sends are still missing,
+	 * the hardware is not responding: reset the device and mark the
+	 * HWC dead so that later HWC commands fail fast.
 	 */

 	if (apc->tx_qp) {
 		for (i = 0; i < apc->num_queues; i++) {
+			struct napi_struct *napi;
+			struct mana_cq *tx_cq;
+			int pending;
+
+			if (!apc->tx_qp[i])
+				continue;
+
+			tx_cq = &apc->tx_qp[i]->tx_cq;
 			txq = &apc->tx_qp[i]->txq;
-			tsleep = 1000;
-			while (atomic_read(&txq->pending_sends) > 0 &&
-			       time_before(jiffies, timeout)) {
-				usleep_range(tsleep, tsleep + 1000);
-				tsleep <<= 1;
-			}
-			if (atomic_read(&txq->pending_sends)) {
-				err = mana_gd_dev_reset(gd->gdma_context);
-				if (err) {
-					netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
-						   err,
-					    atomic_read(&txq->pending_sends),
-					    txq->gdma_txq_id);
+			napi = &tx_cq->napi;
+
+			if (txq->napi_initialized) {
+				/* Stop the NAPI poll so it cannot run
+				 * concurrently with the synchronous drain.
+				 */
+				napi_synchronize(napi);
+				napi_disable_locked(napi);
+				cancel_work_sync(&tx_cq->dim.work);
+
+				/* Poll the CQ until no sends are outstanding,
+				 * sleeping 100 ms between polls. Poll once
+				 * if earlier queue was stuck or device
+				 * has already been reset.
+				 * A zero budget frees skbs via the non-NAPI
+				 * path, which is required outside softirq.
+				 */
+				tx_cq->budget = 0;
+				for (retry = 0; retry <= MANA_TX_DRAIN_RETRIES;
+				     retry++) {
+					do {
+						tx_cq->work_done = 0;
+						mana_poll_tx_cq(tx_cq);
+					} while (tx_cq->work_done);
+
+					if (!atomic_read(&txq->pending_sends) ||
+					    trigger_flr ||
+					    READ_ONCE(hwc->hwc_dead))
+						break;
+					if (retry < MANA_TX_DRAIN_RETRIES)
+						msleep(100);
 				}
-				break;
+			}
+
+			pending = atomic_read(&txq->pending_sends);
+
+			if (!trigger_flr && pending > 0) {
+				trigger_flr = true;
+				flr_txq_id = txq->gdma_txq_id;
+				flr_pending = pending;
+			}
+		}
+
+		if (trigger_flr && !READ_ONCE(hwc->hwc_dead)) {
+			/* Completions never arrived: the device is
+			 * unresponsive. Issue device reset and
+			 * mark the HWC dead so subsequent HWC commands
+			 * fail fast instead of each waiting the full
+			 * hwc_timeout.
+			 */
+			err = mana_gd_dev_reset(gd->gdma_context);
+			if (err) {
+				netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
+					   err, flr_pending, flr_txq_id);
+
+				/* reduce timeout if device reset failed */
+				timeout = READ_ONCE(hwc->hwc_timeout);
+				if (timeout > 1)
+					cmpxchg(&hwc->hwc_timeout, timeout, 1);
+			} else {
+				WRITE_ONCE(hwc->hwc_dead, true);
 			}
 		}

 		for (i = 0; i < apc->num_queues; i++) {
+			struct napi_struct *napi;
+			struct mana_cq *tx_cq;
+
+			if (!apc->tx_qp[i])
+				continue;
+
+			tx_cq = &apc->tx_qp[i]->tx_cq;
+			napi = &tx_cq->napi;
+
 			txq = &apc->tx_qp[i]->txq;
 			while ((skb = skb_dequeue(&txq->pending_skbs))) {
 				mana_unmap_skb(skb, apc);
 				dev_kfree_skb_any(skb);
 			}
 			atomic_set(&txq->pending_sends, 0);
+
+			if (txq->napi_initialized) {
+				netif_napi_del_locked(napi);
+				txq->napi_initialized = false;
+			}
 		}
 	}

@@ -3847,7 +3925,8 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	if (err && mana_en_need_log(apc, err))
 		netdev_err(ndev, "Failed to disable vPort: %d\n", err);

-	mana_fence_rqs(apc);
+	if (!READ_ONCE(hwc->hwc_dead))
+		mana_fence_rqs(apc);

 	/* Even in err case, still need to cleanup the vPort */
 	mana_destroy_rxqs(apc);
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 1ab2d66c891e..0bc222c32244 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -179,6 +179,7 @@ struct hw_channel_context {
 	struct gdma_dev *gdma_dev;
 	struct device *dev;

+	bool hwc_dead;
 	u16 num_inflight_msg;
 	u32 max_req_msg_size;

diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 218d540bc994..1da76e7d6950 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -344,6 +344,8 @@ struct mana_cq {
 	/* Cumulative TX completions fed to DIM. Updated and read only in
 	 * NAPI context (mana_poll_tx_cq() / mana_update_tx_dim()), so they
 	 * measure the hardware completion rate and need no u64_stats_sync.
+	 * The TX drain in mana_dealloc_queues() also updates them, but only
+	 * after NAPI is disabled and the DIM work is cancelled.
 	 */
 	u64 tx_dim_pkts;
 	u64 tx_dim_bytes;
--
2.53.0

