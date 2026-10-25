Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792913338;
	b=ljZ7fjkfNaVByrRApserBhkfOULxjrCDn75IT8jzuxZJcPU/qL3Sna7ETvSXLGKGs0pJ
	 T75YwEB2Cq6bIlbAh3XEOGrYW1q4jW1ESwlwv/8L6JblJOJFrwniXJV9jNXPHWAMZy5yS
	 KBmspbfr3GKwDwmKDcQ2f6SOKp2tOxC8MAZIhd1tR0y3HhXMqbEaT/0xIBthc39KkYdqZ
	 Kb0E10JJfPn9JOuQ7kXjpsS8yuOHBKKuyoayriRUuymcm0j3z8lVOfdfq4Vn0sD/EAx61
	 W51y6nRHnxS6LrTCoo9p/E/8VESfDhpHTkxkYBy8kRh6yzxV1obz2IvzykKhGZRp86Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792913338;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=XXMvtFSdUEGKs/5q/+ure9deVaQh3l258VCaXu3OrvE=;
	b=r7nRDrf8GnnHG6AQH9MaLsIvOBqtlYJtcDZLXl0Hoinpk5US06hNsAoR0CHrMKC0K3B5
	 1LygDA4uNKjJChwWRCTxfUIqJTmw47XR90B7jyf8Qgmxr4tnSPU77HhFfHSBhhS2T/M0z
	 AWQpVGglzp0f1GNam3/KeGR1oc1JzyZCygQkw//VmlIAoT7aRUdjd0XuTiYMsKdP/mFBs
	 gKUoYjdTFA3j6IWms8Jsuy8u+62KfjYFuNf8KeR0SyiuNgRgg2o/NWK9fd5yD5kQcF1vM
	 DVbLsP3z04eCJQYDZjK+W4g/hUULwWcDs4SzbqQa70R2ONJavRELBWVSqjsfjMbK+MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Xr+2Y3Zw;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63CE0606A31D;
	Sun, 25 Oct 2026 07:28:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63CE0606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Xr+2Y3Zw
Received: from kali.mshome.net (unknown [4.213.232.20])
	by linux.microsoft.com (Postfix) with ESMTPSA id C1FB520B7166;
	Sun, 25 Oct 2026 00:28:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C1FB520B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792913322;
	bh=XXMvtFSdUEGKs/5q/+ure9deVaQh3l258VCaXu3OrvE=;
	h=From:To:Cc:Subject:Date:From;
	b=Xr+2Y3ZwicqDZ44huF2KOxEFTUEyf+8oEmbSKzkYePzPW30itQP7l+INQrkDnmFjM
	 ILb7LMzmBikQapVxUT97X6ItsqaJKEGATeRGTwDE1xIz+BkOHaw5lXtz+J98qpnQb2
	 658OodSdmQk3jNWpjGnpQmrfRVuOyzrl1wb+j9zo=
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
To: haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	weh@microsoft.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	gargaditya@linux.microsoft.com,
	mawasthi@linux.microsoft.com,
	sahilchandna@linux.microsoft.com,
	kees+treewide@kernel.org,
	schakrabarti@linux.microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH net] net: mana: Avoid waiting on dead HWC after device reset
Date: Sun, 25 Oct 2026 02:28:36 -0500
Message-ID: <20261025072838.1991785-1-sahilchandna@linux.microsoft.com>
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
which the timeout is reduced to 1ms for subsequent commands. This
causes the calling thread to hold the RTNL lock for over 180 seconds
(120s TX drain + 60s HWC timeout), triggering hung task warnings and
blocking all other networking operations on the system.

Fix this by:
1. Replacing the sleep-based TX drain with a CQE polling approach:
   disable NAPI per queue, do a final synchronous poll to collect
   any remaining completions, free uncompleted SKBs, and reset the
   device only if sends remain unacknowledged. The device is reset
   at most once per call, and not at all if an earlier reset already
   marked the HWC dead. This eliminates the 120s sleep entirely.
2. Setting hwc_dead flag after a successful device reset.
3. Checking hwc_timeout and hwc_dead flag in mana_hwc_send_request()
   before posting the WQE and returning -ETIMEDOUT immediately
   without submitting commands to hardware that cannot respond.
4. Skipping mana_fence_rqs() and the SHM channel teardown handshake
   once hwc_dead is set.

Fixes: a7dfeda6fdec ("net: mana: Fix MANA VF unload when hardware is unresponsive")
Cc: stable@vger.kernel.org
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   |   4 +-
 .../net/ethernet/microsoft/mana/gdma_pci.c    |   2 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  |  32 ++++--
 drivers/net/ethernet/microsoft/mana/mana_en.c | 102 +++++++++++++-----
 include/net/mana/hw_channel.h                 |   1 +
 5 files changed, 107 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 8c915e008784..b249752ce828 100644
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
index 3bca4b683134..c9337f49fbe1 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -192,7 +192,7 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,

 		switch (type) {
 		case HWC_DATA_CFG_HWC_TIMEOUT:
-			hwc->hwc_timeout = val;
+			WRITE_ONCE(hwc->hwc_timeout, val);
 			break;

 		case HWC_DATA_HW_LINK_CONNECT:
@@ -819,7 +819,12 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	 * non-zero, the HWC worked and we should tear down the HWC here.
 	 */
 	if (gc->max_num_cqs > 0) {
-		mana_smc_teardown_hwc(&gc->shm_channel, false);
+		if (READ_ONCE(hwc->hwc_dead))
+			dev_warn(hwc->dev,
+				 "HWC unavailable, skip SHM teardown handshake\n");
+		else
+			mana_smc_teardown_hwc(&gc->shm_channel, false);
+
 		gc->max_num_cqs = 0;
 	}

@@ -862,6 +867,7 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	u32 dest_vrcq;
 	u32 dest_vrq;
 	u32 command;
+	u32 timeout = 0;
 	u16 msg_id;
 	int err;

@@ -897,6 +903,17 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	dest_vrq = hwc->dest_vrq_id;
 	dest_vrcq = hwc->dest_vrcq_id;

+	/* If the HWC is unavailable (e.g. hwc_timeout was set to 0 or
+	 * hwc_dead set after device reset), do not post the WQE: the
+	 * hardware cannot respond, so fail fast instead of waiting out
+	 * the full timeout.
+	 */
+	timeout = READ_ONCE(hwc->hwc_timeout);
+	if (timeout == 0 || READ_ONCE(hwc->hwc_dead)) {
+		err = -ETIMEDOUT;
+		goto out;
+	}
+
 	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
 	if (err) {
 		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
@@ -904,14 +921,13 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	}

 	if (!wait_for_completion_timeout(&ctx->comp_event,
-					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
-		if (hwc->hwc_timeout != 0)
-			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
-				command, hwc->hwc_timeout);
+					 (msecs_to_jiffies(timeout)))) {
+		dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
+			command, timeout);

 		/* Reduce further waiting if HWC no response */
-		if (hwc->hwc_timeout > 1)
-			hwc->hwc_timeout = 1;
+		if (READ_ONCE(hwc->hwc_timeout) > 1)
+			WRITE_ONCE(hwc->hwc_timeout, 1);

 		err = -ETIMEDOUT;
 		goto out;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 6b7c027e497e..00885d21a9af 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3753,16 +3753,19 @@ int mana_attach(struct net_device *ndev)
 static int mana_dealloc_queues(struct net_device *ndev)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
-	unsigned long timeout = jiffies + 120 * HZ;
 	struct gdma_dev *gd = apc->ac->gdma_dev;
+	struct hw_channel_context *hwc;
+	bool trigger_flr = false;
+	int flr_pending, i, err;
 	struct mana_txq *txq;
 	struct sk_buff *skb;
-	int i, err;
-	u32 tsleep;
+	u32 flr_txq_id = 0;

 	if (apc->port_is_up)
 		return -EINVAL;

+	hwc = gd->gdma_context->hwc.driver_data;
+
 	if (apc->rxqs)
 		mana_chn_setxdp(apc, NULL);

@@ -3774,42 +3777,92 @@ static int mana_dealloc_queues(struct net_device *ndev)
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
+	 * then process all completions still in the CQ. If some are still
+	 * missing after that, the hardware is not responding: reset device
+	 * and stop waiting on the now-unavailable HWC.
 	 */

 	if (apc->tx_qp) {
 		for (i = 0; i < apc->num_queues; i++) {
+			struct mana_cq *tx_cq;
+			struct napi_struct *napi;
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
+				/* Reap all TX completions currently in the CQ.
+				 * A zero budget frees skbs via the non-NAPI
+				 * path, which is required outside softirq.
+				 */
+				tx_cq->budget = 0;
+				do {
+					tx_cq->work_done = 0;
+					mana_poll_tx_cq(tx_cq);
+				} while (tx_cq->work_done);
 			}
-			if (atomic_read(&txq->pending_sends)) {
-				err = mana_gd_dev_reset(gd->gdma_context);
-				if (err) {
-					netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
-						   err,
-					    atomic_read(&txq->pending_sends),
-					    txq->gdma_txq_id);
-				}
-				break;
+
+			pending = atomic_read(&txq->pending_sends);
+			if (!trigger_flr && pending > 0) {
+				trigger_flr = true;
+				flr_txq_id = txq->gdma_txq_id;
+				flr_pending = pending;
 			}
 		}

+		if (trigger_flr && !(hwc && hwc->hwc_dead)) {
+			/* Completions never arrived: the device is
+			 * unresponsive. Issue device reset and
+			 * mark the HWC dead so subsequent HWC commands
+			 * fail fast instead of each waiting the full
+			 * hwc_timeout.
+			 */
+			err = mana_gd_dev_reset(gd->gdma_context);
+			if (err)
+				netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
+					   err,
+					   flr_pending,
+					   flr_txq_id);
+			else if (hwc)
+				WRITE_ONCE(hwc->hwc_dead, true);
+		}
+
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

@@ -3822,7 +3875,8 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	if (err && mana_en_need_log(apc, err))
 		netdev_err(ndev, "Failed to disable vPort: %d\n", err);

-	mana_fence_rqs(apc);
+	if (!(hwc && hwc->hwc_dead))
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

--
2.53.0

