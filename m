Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795685449;
	b=mJ41elC/mSJO4WyJhNiNplwrwRnEAgKIyassS+SCeqhFlUl1oR80JPLNRGtQID925hw4
	 S0hDGAZDTFnrOfjPIOgvqDdulqb8jElcjhsLZxhwBtrD/mkESM3hRyOrbj00/PyjOEG73
	 0Mku1Rwr9gblJEiIv6JvitEIzI2DfVHGoAXfRuGYaEGLoxqPOysj3Q/mnu7pABURuEWe4
	 5muy3qZUdN+j2vniThaezhN1HUZo+OgXb9ENOqTqkGuMkSVXcriLInHxt2MX/208wOud7
	 +bbnzIbwvMtiOVeg+rOBdygGuFnZ4XcZv35YxnplP/Pcr1VNx6y9In+auET5H09hFOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795685449;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=NxbNEMW8k4sy1kQD2AyiZh7inFN/HyPZEd3VSm8VX0I=;
	b=MHQd12nhhr6i3frTlsi7qvwm/3/f/4lKTJXNBJpclP7k04OvhIcwcwxAcGE0d0DT3fXa
	 uUmG+o4AlKm1IGR5OoDMOMOig03wW8YMOrXzvgcUfuDuLhERRL6by69sWzqcddENwo4MR
	 Q08LfNx4vA+PjiqU33G+Xabk0QYJ2WK31lxiSDry6QeRQhK0u9bkxmg+K23b1Jcs1QQky
	 8i7rNc8BNRR3d+ZBteMIryWU8Qhu7cNu9C70J66PzlX6oaWNZ3bDe2RLMHaqUoJ1l/Bk0
	 1k6Kz5YKXPuSU/tfe2UQ3eLCHJOZ7fiogEp78+ioAUfSlUWYaRz42gCbExBYUEcmLOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=nEiyglbo;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89883606A31C;
	Thu, 26 Nov 2026 09:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89883606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=nEiyglbo
Received: from kali.mshome.net (unknown [4.213.232.16])
	by linux.microsoft.com (Postfix) with ESMTPSA id E0A6A20B7166;
	Thu, 26 Nov 2026 01:30:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E0A6A20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795685442;
	bh=NxbNEMW8k4sy1kQD2AyiZh7inFN/HyPZEd3VSm8VX0I=;
	h=From:To:Cc:Subject:Date:From;
	b=nEiyglboBNwSuYrKv+KxNr1o5sEkiJ4s74J23UkvnQQ6Q1pVTu1Ddq0JfCgiRjCt3
	 n+z5tUqaUhMlwsnjH33MKIzBO+TnI4FGVnNTh++p5Q0PsQYq1oPGCaqgwjkiWdMH+i
	 6jcO++PiW7k4XMmUNDIkclJOy+TrqhvpB3xIX5ng=
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
Subject: [PATCH net v5] net: mana: Avoid waiting on dead HWC after device reset
Date: Thu, 26 Nov 2026 03:29:51 -0600
Message-ID: <20261126093032.816436-1-sahilchandna@linux.microsoft.com>
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
   300 ms of sleep per queue. The 300 ms budget is not based on a hardware
   limit: in testing under load, the completions still outstanding on a
   queue had all arrived by its second poll, about 100ms after the first.
2. Setting the hwc_dead flag after a successful device reset. If the
   reset fails, the device may not have been reset and may still access
   memory, so teardown commands are still posted. In that case RTNL can
   still be held for the full hwc_timeout: pcie_flr() can wait in
   pci_dev_wait() before it fails, the first teardown command
   (MANA_CONFIG_VPORT_RX) waits the full hwc_timeout before
   mana_hwc_send_request() lowers it to 1 ms, and mana_fence_rqs()
   sleeps 100 ms per RX queue on error. This is still shorter than
   before this patch, where the same path followed a 120s drain.
3. Checking the hwc_dead flag in mana_hwc_send_request() before taking
   an HWC message slot and again before posting the WQE, and returning
   -ETIMEDOUT immediately without submitting commands to hardware that
   cannot respond. A request that was already posted, or that passed
   these checks just before hwc_dead was set (for example from the
   gf_stats worker or mana_ib, which do not hold RTNL), still waits for
   its own timeout, as before this patch.
4. Skipping mana_fence_rqs() and the SHM channel teardown handshake
   once hwc_dead is set.

Fixes: a7dfeda6fdec ("net: mana: Fix MANA VF unload when hardware is unresponsive")
Cc: stable@vger.kernel.org
Co-developed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
---
Changes in v5:
- update drain loop and device reset comment: if the reset fails,
  the teardown commands are still posted and the first one can wait
  the full hwc_timeout.
- update commit message that RTNL can be held for the
  hwc_timeout when the device reset fails.
- Add Reviewed-by from Haiyang.
Link to v4: https://lore.kernel.org/all/20261118091436.3985155-1-sahilchandna@linux.microsoft.com/

Changes in v4:
- Keep netif_napi_del_locked() in mana_destroy_txq() after the WQ
  object is destroyed; track the dealloc-time disable with
  txq->napi_disabled.
- Drop lowering hwc_timeout on reset failure.
- Fix commit message based on review comments.
Link to v3: https://lore.kernel.org/all/20261112085226.878780-1-sahilchandna@linux.microsoft.com/

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

 .../net/ethernet/microsoft/mana/gdma_main.c   |   6 +-
 .../net/ethernet/microsoft/mana/gdma_pci.c    |   2 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  |  40 ++++--
 drivers/net/ethernet/microsoft/mana/mana_en.c | 122 +++++++++++++-----
 include/net/mana/hw_channel.h                 |   1 +
 include/net/mana/mana.h                       |   3 +
 6 files changed, 134 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index d6ae89c2ccdd..15fde85c9182 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -141,7 +141,7 @@ int mana_gd_init_registers(struct gdma_context *gc)
 		return mana_gd_init_vf_regs(gc);
 }

-/* Suppress logging when we set timeout to zero */
+/* Suppress logging when we set timeout to zero or HWC is dead */
 bool mana_need_log(struct gdma_context *gc, int err)
 {
 	struct hw_channel_context *hwc;
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
index 208dadbcf977..f9d75b5d9e43 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_pci.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
@@ -102,7 +102,7 @@ static void mana_serv_reset(struct pci_dev *pdev)
 	}

 	/* HWC is not responding in this case, so don't wait */
-	hwc->hwc_timeout = 0;
+	WRITE_ONCE(hwc->hwc_timeout, 0);

 	dev_info(&pdev->dev, "MANA reset cycle start\n");

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index fb9f38f65911..1671944684b8 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -192,7 +192,7 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,

 		switch (type) {
 		case HWC_DATA_CFG_HWC_TIMEOUT:
-			hwc->hwc_timeout = val;
+			WRITE_ONCE(hwc->hwc_timeout, val);
 			break;

 		case HWC_DATA_HW_LINK_CONNECT:
@@ -816,10 +816,16 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 		return;

 	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
-	 * non-zero, the HWC worked and we should tear down the HWC here.
+	 * non-zero, the HWC worked and we should tear down the HWC here,
+	 * unless device reset has already marked it dead: the device then
+	 * no longer holds the HWC state and the handshake would only spin.
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

@@ -867,9 +873,17 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	u32 dest_vrcq;
 	u32 dest_vrq;
 	u32 command;
+	u32 timeout;
 	u16 msg_id;
 	int err;

+	/* Fail fast before taking the HWC slot. After a device reset, requests
+	 * already holding slots will release them once their own timeout
+	 * expires.
+	 */
+	if (READ_ONCE(hwc->hwc_dead))
+		return -ETIMEDOUT;
+
 	mana_hwc_get_msg_index(hwc, &msg_id);

 	tx_wr = &txq->msg_buf->reqs[msg_id];
@@ -902,21 +916,31 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 	dest_vrq = hwc->dest_vrq_id;
 	dest_vrcq = hwc->dest_vrcq_id;

+	/* If the HWC is unavailable after device reset, do not post the WQE:
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
index 7e9223143fc7..b9162e56d85d 100644
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

@@ -2611,6 +2613,8 @@ static void mana_update_tx_dim(struct mana_cq *cq)
 	/* cq->tx_dim_pkts/bytes are accumulated in mana_poll_tx_cq(), in the
 	 * same NAPI context as this read, so they track the hardware
 	 * completion rate and need no u64_stats_sync protection.
+	 * The TX drain in mana_dealloc_queues() also adds to them,
+	 * but only after NAPI is disabled, so not concurrently with this read.
 	 */
 	dim_update_sample(READ_ONCE(cq->dim_event_ctr), cq->tx_dim_pkts,
 			  cq->tx_dim_bytes, &dim_sample);
@@ -2717,16 +2721,17 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 		apc->tx_qp[i]->mana_tx_debugfs = NULL;

 		napi = &apc->tx_qp[i]->tx_cq.napi;
-		if (apc->tx_qp[i]->txq.napi_initialized) {
+		if (apc->tx_qp[i]->txq.napi_initialized &&
+		    !apc->tx_qp[i]->txq.napi_disabled) {
 			napi_synchronize(napi);
 			napi_disable_locked(napi);
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

@@ -2743,6 +2748,7 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 			mana_gd_detach_cq(gc, apc->tx_qp[i]->tx_cq.gdma_cq);
 			netif_napi_del_locked(napi);
 			apc->tx_qp[i]->txq.napi_initialized = false;
+			apc->tx_qp[i]->txq.napi_disabled = false;
 		}

 		mana_deinit_cq(apc, &apc->tx_qp[i]->tx_cq);
@@ -3774,19 +3780,24 @@ int mana_attach(struct net_device *ndev)
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

 	if (apc->port_is_up)
 		return -EINVAL;

+	hwc = gd->gdma_context->hwc.driver_data;
+
 	if (apc->rxqs)
 		mana_chn_setxdp(apc, NULL);

@@ -3799,31 +3810,83 @@ static int mana_dealloc_queues(struct net_device *ndev)
 	 * to false, but it doesn't matter since mana_start_xmit() drops any
 	 * new packets due to apc->port_is_up being false.
 	 *
-	 * Drain all the in-flight TX packets.
-	 * A timeout of 120 seconds for all the queues is used.
-	 * This will break the while loop when h/w is not responding.
-	 * This value of 120 has been decided here considering max
-	 * number of queues.
+	 * Drain the in-flight TX completions for each queue. TX is already
+	 * stopped, so pending_sends can no longer grow. For each queue,
+	 * disable NAPI so it cannot run at the same time as this drain,
+	 * then poll its CQ for up to 300 ms. If sends are still missing,
+	 * the hardware is not responding: reset the device.
+	 * Only a successful reset marks the HWC dead so that later
+	 * HWC commands fail fast. If the reset fails, the teardown
+	 * commands below are still posted, and the first of them can
+	 * wait the full hwc_timeout with RTNL held.
 	 */

 	if (apc->tx_qp) {
 		for (i = 0; i < apc->num_queues; i++) {
+			struct napi_struct *napi;
+			struct mana_cq *tx_cq;
+			int pending;
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
+				txq->napi_disabled = true;
+
+				/* Poll the CQ until no sends are outstanding,
+				 * sleeping 100 ms between polls. Poll only
+				 * once if an earlier queue was stuck or device
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
+			 * unresponsive, so reset it. Mark the HWC dead only
+			 * if the reset succeeds, so that later HWC commands
+			 * fail fast. If it fails, the device may still access
+			 * memory, so the teardown commands are still posted
+			 * and the first one waits the full hwc_timeout.
+			 */
+			err = mana_gd_dev_reset(gd->gdma_context);
+			if (err) {
+				netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
+					   err, flr_pending, flr_txq_id);
+			} else {
+				WRITE_ONCE(hwc->hwc_dead, true);
 			}
 		}

@@ -3846,7 +3909,8 @@ static int mana_dealloc_queues(struct net_device *ndev)
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
index 218d540bc994..0ed638bfe8b2 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -143,6 +143,7 @@ struct mana_txq {
 	atomic_t pending_sends;

 	bool napi_initialized;
+	bool napi_disabled;

 	struct mana_stats_tx stats;
 };
@@ -344,6 +345,8 @@ struct mana_cq {
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

