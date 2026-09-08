Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BEFF31D39A;
	Tue,  8 Sep 2026 03:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838171; cv=none; b=QdLFV/ea+7TtAJB845qNeED5jeT3tOwX/LwMuBQLM6H3oi1mrssPtpz2Imy/XD0t2WwE1DsRAIbKVGGuBfnet/EnCd7trcmKRrfjNka3wwxulKnbwswxqLSemws+GGZfz+7NfgfTyDV+HH1JoBrTvyygR3LON+3snblKWmFKtXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838171; c=relaxed/simple;
	bh=p4azKZT2H/pP1058yPzTe+bfAG+9m8+3yNNBrsN+va4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVNbEqxekNYvrD7sZasILK6jzOHU5m5I6NISz7WBwBwV5UH2/yTWqROTII4ZiV/R3qJ5QDVkUtU07y3LtrEXu7d9jvERg8OmCBJ35kGpfZpOnnuaS1ib7qjq2FyEaEqTje428knaBQJ/0xFjnZvUiNHx4+E1YepnlgMeJlWliNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id E76E520B7135; Mon,  7 Sep 2026 20:28:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E76E520B7135
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Long Li <longli@kernel.org>,
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
Subject: [PATCH net-next v4 03/13] net: mana: swap queue sets in mana_set_channels
Date: Mon,  7 Sep 2026 20:28:33 -0700
Message-ID: <20260908032843.397667-4-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260908032843.397667-1-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Build a replacement queue set before quiescing TX, then publish it and
retire the old set. Allocation failure preserves the running queues;
publication failure attempts rollback. If rollback also fails, close the
port and lower carrier, allowing a later administrative reopen.

Keep RX queue indices valid until retiring queues stop delivering. Order
the port-up store before TX ring reads to avoid a missed queue wakeup.

The temporary SQ/RQ peak is old + new. Later patches remove that peak for
channel-count changes; full per-queue rebuilds still require it.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
  - Raise the RX queue count during publication, but defer lowering it
    until retiring RQs are destroyed, including after rollback.
  - Order the port-up store before TX ring reads with a full barrier.
  - Qualify rollback recovery and document the temporary queue peak;
    shorten comments.

 .../net/ethernet/microsoft/mana/mana_bpf.c    |   5 +
 drivers/net/ethernet/microsoft/mana/mana_en.c | 246 +++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  78 ++++--
 include/net/mana/mana.h                       |  16 +-
 4 files changed, 313 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 1c5ac7e2d884ed90bb12993a86718e2ebc0937c9..4365e26cc73874a727ea3cae93ec959956d2d42a 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -59,6 +59,11 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
 	if (unlikely(!apc->port_is_up))
 		return 0;
 
+	/* Pair with the smp_wmb() in mana_publish_qset() before reading queue
+	 * state.
+	 */
+	smp_rmb();
+
 	q_idx = smp_processor_id() % ndev->real_num_tx_queues;
 
 	for (i = 0; i < n; i++) {
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index fc80d4bcde6c453d61222371d7763cff90b2a26a..bb9ef4e634a6edaf097bc85f2248c2ceea88fc05 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -90,6 +90,17 @@ static int mana_open(struct net_device *ndev)
 	smp_wmb();
 
 	netif_tx_wake_all_queues(ndev);
+
+	/* Undo a forced carrier-off unless a disconnect is pending behind RTNL.
+	 */
+	if (apc->carrier_forced_off) {
+		u32 ev = READ_ONCE(apc->ac->link_event);
+
+		apc->carrier_forced_off = false;
+		if (ev != HWC_DATA_HW_LINK_DISCONNECT)
+			netif_carrier_on(ndev);
+	}
+
 	netdev_dbg(ndev, "%s successful\n", __func__);
 	return 0;
 }
@@ -106,6 +117,7 @@ static int mana_close(struct net_device *ndev)
 
 static void mana_link_state_handle(struct work_struct *w)
 {
+	struct mana_port_context *apc;
 	struct mana_context *ac;
 	struct net_device *ndev;
 	u32 link_event;
@@ -131,6 +143,9 @@ static void mana_link_state_handle(struct work_struct *w)
 		if (!ndev)
 			continue;
 
+		apc = netdev_priv(ndev);
+		apc->carrier_forced_off = false;
+
 		if (link_up) {
 			netif_carrier_on(ndev);
 
@@ -312,8 +327,8 @@ static void mana_per_port_queue_reset_work_handler(struct work_struct *work)
 
 	rtnl_lock();
 
-	/* Block RDMA from grabbing the vport during the detach/attach
-	 * window, same as mana_set_channels().
+	/* Exclude RDMA across detach/attach; RTNL serializes channel_changing
+	 * writers.
 	 */
 	mutex_lock(&apc->vport_mutex);
 	apc->channel_changing = true;
@@ -366,6 +381,15 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (unlikely(!apc->port_is_up))
 		goto tx_drop;
 
+	/* Pair with mana_publish_qset()'s pre-gate smp_wmb(): observe queue
+	 * fields after reading port_is_up.
+	 */
+	smp_rmb();
+
+	/* Retiring RXQs may use indices beyond the live queue count. */
+	if (unlikely(txq_idx >= apc->num_queues))
+		goto tx_drop_count;
+
 	if (skb_cow_head(skb, MANA_HEADROOM))
 		goto tx_drop_count;
 
@@ -1045,6 +1069,7 @@ static void mana_cleanup_indir_table(struct mana_port_context *apc)
 
 static int mana_init_port_context(struct mana_port_context *apc)
 {
+	kfree(apc->rxqs);
 	apc->rxqs = kzalloc_objs(struct mana_rxq *, apc->num_queues);
 
 	return !apc->rxqs ? -ENOMEM : 0;
@@ -2077,6 +2102,7 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	/* Ensure checking txq_stopped before apc->port_is_up. */
 	smp_rmb();
 
+	/* Order the stopped-state read before the retiring read. */
 	if (txq_stopped && !READ_ONCE(txq->retiring) && apc->port_is_up &&
 	    avail_space >= MAX_TX_WQE_SIZE) {
 		netif_tx_wake_queue(net_txq);
@@ -3993,9 +4019,213 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	return err;
 }
 
+/* Destroy caller-owned CQs before closing this dead-end port: closing also
+ * frees the shared EQ pool. Requires RTNL.
+ */
+void mana_publish_close_if_needed(struct mana_port_context *apc)
+{
+	ASSERT_RTNL();
+
+	if (!apc->publish_dead_end)
+		return;
+
+	apc->publish_dead_end = false;
+
+	if (mana_dealloc_queues(apc->ndev))
+		netdev_err(apc->ndev,
+			   "failed to close the port after a failed rollback\n");
+}
+
+/* Carried-over queues may still have full rings. */
+static void mana_start_txqs(struct mana_port_context *apc)
+{
+	struct net_device *ndev = apc->ndev;
+	unsigned int i;
+
+	if (!apc->tx_qp)
+		return;
+
+	/* Order port_is_up=true before ring reads to avoid a missed wakeup.
+	 * Pair with mana_poll_tx_cq()'s full barrier after its tail update.
+	 */
+	smp_mb();
+
+	for (i = 0; i < apc->num_queues; i++) {
+		if (!apc->tx_qp[i])
+			continue;
+
+		if (mana_can_tx(apc->tx_qp[i]->txq.gdma_sq))
+			netif_tx_wake_queue(netdev_get_tx_queue(ndev, i));
+	}
+}
+
+/* Retiring completions must not wake replacement queues. Mark the leaving set
+ * before unmarking the incoming set.
+ */
+static void mana_qset_set_retiring(struct mana_qset *qset, bool retiring)
+{
+	unsigned int q;
+
+	if (!qset->tx_qp)
+		return;
+
+	for (q = 0; q < qset->num_queues; q++) {
+		if (qset->tx_qp[q])
+			WRITE_ONCE(qset->tx_qp[q]->txq.retiring, retiring);
+	}
+}
+
+/* Leave TX stopped and request RX disable; steering may be unrecoverable. */
+static void mana_publish_give_up(struct mana_port_context *apc)
+{
+	int err;
+
+	apc->rss_state = TRI_STATE_FALSE;
+
+	err = mana_disable_vport_rx(apc);
+	if (err && mana_en_need_log(apc, err))
+		netdev_err(apc->ndev, "failed to disable vPort RX: %d\n", err);
+
+	apc->carrier_forced_off = netif_carrier_ok(apc->ndev);
+	netif_carrier_off(apc->ndev);
+	apc->publish_dead_end = true;
+}
+
+/* Keep the RX count high until retiring RQs stop delivering their indices. */
+static int mana_raise_real_num_rx(struct net_device *ndev, unsigned int count)
+{
+	if (count <= ndev->real_num_rx_queues)
+		return 0;
+
+	return netif_set_real_num_rx_queues(ndev, count);
+}
+
+/* Publish under RTNL with TX gated. An error restores old pointers, not
+ * necessarily service. Free only owned queues.
+ */
+int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
+		      struct mana_qset *out_old)
+{
+	struct net_device *ndev = apc->ndev;
+	int err;
+
+	ASSERT_RTNL();
+
+	/* Close the XDP gate before stopping TX queues. Pair with
+	 * mana_poll_tx_cq()'s smp_rmb() to prevent mid-swap wakeups.
+	 */
+	WRITE_ONCE(apc->port_is_up, false);
+
+	/* Ensure port state updated before txq state */
+	smp_wmb();
+
+	netif_tx_disable(ndev);
+
+	mana_qset_snapshot(apc, out_old);
+
+	/* Mark before the grace period so old completions cannot wake the
+	 * replacement's stopped queue.
+	 */
+	mana_qset_set_retiring(out_old, true);
+
+	/* Drain TX/XDP readers past the gate and polls missing retiring. */
+	synchronize_net();
+
+	mana_qset_set_retiring(newq, false);
+
+	mana_qset_install(apc, newq);
+	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
+
+	err = netif_set_real_num_tx_queues(ndev, apc->num_queues);
+	if (err)
+		goto rollback;
+
+	err = mana_raise_real_num_rx(ndev, apc->num_queues);
+	if (err)
+		goto rollback;
+
+	/* Install XDP and per-RXQ references before steering reaches new
+	 * queues.
+	 */
+	mana_chn_setxdp(apc, mana_xdp_get(apc));
+
+	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
+	if (err)
+		goto rollback;
+
+	/* Publish fields before opening the gate; pair with TX/XDP read
+	 * barriers. The post-gate full barrier cannot replace this.
+	 */
+	smp_wmb();
+
+	WRITE_ONCE(apc->port_is_up, true);
+	mana_start_txqs(apc);
+
+	return 0;
+
+rollback:
+	netdev_err(ndev, "%s failed: %d, restoring previous queue set\n",
+		   __func__, err);
+
+	mana_qset_set_retiring(newq, true);
+	mana_qset_set_retiring(out_old, false);
+
+	mana_qset_install(apc, out_old);
+	apc->rss_state = apc->num_queues > 1 ? TRI_STATE_TRUE : TRI_STATE_FALSE;
+
+	if (netif_set_real_num_tx_queues(ndev, apc->num_queues) ||
+	    mana_raise_real_num_rx(ndev, apc->num_queues)) {
+		/* Inconsistent restored queue counts prohibit TX; leave the
+		 * port stopped.
+		 */
+		netdev_err(ndev, "failed to restore queue counts, closing the port\n");
+		mana_publish_give_up(apc);
+		return err;
+	}
+
+	if (mana_config_rss(apc, TRI_STATE_TRUE, true, true)) {
+		/* Do not reopen TX with mismatched steering; RX disable is
+		 * best-effort.
+		 */
+		netdev_err(ndev, "failed to restore RSS steering, closing the port\n");
+		mana_publish_give_up(apc);
+		return err;
+	}
+
+	/* Publish restored fields before reopening the gate, as on success. */
+	smp_wmb();
+
+	WRITE_ONCE(apc->port_is_up, true);
+	mana_start_txqs(apc);
+
+	return err;
+}
+
+/* Create missing debugfs nodes once retiring names are gone. */
+static void mana_qset_debugfs_publish(struct mana_port_context *apc)
+{
+	unsigned int i;
+
+	ASSERT_RTNL();
+
+	if (IS_ERR_OR_NULL(apc->mana_port_debugfs))
+		return;
+
+	for (i = 0; i < apc->num_queues; i++) {
+		if (apc->tx_qp && apc->tx_qp[i] &&
+		    IS_ERR_OR_NULL(apc->tx_qp[i]->mana_tx_debugfs))
+			mana_create_txq_debugfs(apc, i);
+
+		if (apc->rxqs && apc->rxqs[i] &&
+		    IS_ERR_OR_NULL(apc->rxqs[i]->mana_rx_debugfs))
+			mana_create_rxq_debugfs(apc, i);
+	}
+}
+
 /* Under RTNL, free only queues no longer shared with the installed set. */
 void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 {
+	struct mana_port_context *apc = netdev_priv(scratch->ndev);
 	struct bpf_prog *retiring_prog;
 	unsigned int retiring_queues;
 
@@ -4020,7 +4250,9 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 
 	mana_qset_install(scratch, qset);
 
-	/* Keep retiring RXQs' XDP programs and references until RX teardown. */
+	/* Keep retiring RXQs' XDP programs and references until RX teardown.
+	 * Read the program from the queues, not queue-set metadata.
+	 */
 	retiring_prog = mana_chn_xdp_peek(scratch);
 	retiring_queues = scratch->num_queues;
 
@@ -4029,7 +4261,6 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 		/* FLR also destroys the HWC; rebuilding ports is best-effort.
 		 * This path does not reinitialize the device.
 		 */
-		struct mana_port_context *apc = netdev_priv(scratch->ndev);
 		struct mana_context *ac = apc->ac;
 		struct mana_port_context *sib;
 		unsigned int i;
@@ -4059,6 +4290,13 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	scratch->rxqs = NULL;
 
 	memset(qset, 0, sizeof(*qset));
+
+	/* Retiring RQs can no longer deliver indices beyond the live queue
+	 * count.
+	 */
+	netif_set_real_num_rx_queues(apc->ndev, apc->num_queues);
+
+	mana_qset_debugfs_publish(apc);
 }
 
 int mana_detach(struct net_device *ndev, bool from_close)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index ece7ff9cc409a806b6a6de70a85b44874bfa6dad..45031ca1254e327a9b129bd77c7a08fb8a240838 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -648,52 +648,82 @@ static int mana_set_coalesce(struct net_device *ndev,
 	return 0;
 }
 
-/* mana_set_channels - change the number of queues on a port
- *
- * Returns -EBUSY if RDMA holds the vport with EQs sized to the
- * current num_queues.
- */
 static int mana_set_channels(struct net_device *ndev,
 			     struct ethtool_channels *channels)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned int new_count = channels->combined_count;
-	unsigned int old_count = apc->num_queues;
+	struct mana_port_context *scratch;
+	struct mana_qset newq, oldq;
 	int err;
 
-	/* Set channel_changing to block RDMA from grabbing the vport
-	 * during the detach/attach window. mana_cfg_vport() checks
-	 * this flag under vport_mutex and returns -EBUSY if set.
+	if (new_count < 1 || new_count > apc->max_queues) {
+		netdev_err(ndev, "Invalid combined_count %u (max %u)\n",
+			   new_count, apc->max_queues);
+		return -EINVAL;
+	}
+
+	if (new_count == apc->num_queues)
+		return 0;
+
+	/* Resize rxqs while down: mana_open() does not recreate the port
+	 * context. RDMA must not own the vport while num_queues changes.
 	 */
 	mutex_lock(&apc->vport_mutex);
-	if (!apc->port_is_up && apc->vport_use_count) {
+	if (!apc->port_is_up) {
+		struct mana_rxq **rxqs;
+
+		if (apc->vport_use_count) {
+			mutex_unlock(&apc->vport_mutex);
+			return -EBUSY;
+		}
+
+		rxqs = kzalloc_objs(struct mana_rxq *, new_count);
+		if (!rxqs) {
+			mutex_unlock(&apc->vport_mutex);
+			return -ENOMEM;
+		}
+
+		kfree(apc->rxqs);
+		apc->rxqs = rxqs;
+		apc->num_queues = new_count;
+		mutex_unlock(&apc->vport_mutex);
+		return 0;
+	}
+
+	/* The Ethernet port already holds a vport reference; exclude RDMA
+	 * through failure cleanup.
+	 */
+	if (apc->channel_changing) {
 		mutex_unlock(&apc->vport_mutex);
 		return -EBUSY;
 	}
 	apc->channel_changing = true;
 	mutex_unlock(&apc->vport_mutex);
 
-	err = mana_pre_alloc_rxbufs(apc, ndev->mtu, new_count);
-	if (err) {
-		netdev_err(ndev, "Insufficient memory for new allocations");
+	scratch = mana_qset_scratch_alloc(apc);
+	if (!scratch) {
+		err = -ENOMEM;
 		goto clear_flag;
 	}
 
-	err = mana_detach(ndev, false);
-	if (err) {
-		netdev_err(ndev, "mana_detach failed: %d\n", err);
-		goto out;
-	}
+	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
+			      apc->tx_queue_size, apc->priv_flags, &newq);
+	if (err)
+		goto free_scratch;
 
-	apc->num_queues = new_count;
-	err = mana_attach(ndev);
+	err = mana_publish_qset(apc, &newq, &oldq);
 	if (err) {
-		apc->num_queues = old_count;
-		netdev_err(ndev, "mana_attach failed: %d\n", err);
+		mana_free_qset(scratch, &newq);
+		goto free_scratch;
 	}
 
-out:
-	mana_pre_dealloc_rxbufs(apc);
+	mana_free_qset(scratch, &oldq);
+
+free_scratch:
+	/* Release unpublished queues before closing their shared EQ pool. */
+	mana_publish_close_if_needed(apc);
+	mana_qset_scratch_free(scratch);
 clear_flag:
 	mutex_lock(&apc->vport_mutex);
 	apc->channel_changing = false;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index de026eeb8fc25f80d3e0f9613fb277eae9ae19a9..e965d86b4d8502408f175bdbee5d77fb2e406df3 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -623,12 +623,17 @@ struct mana_port_context {
 	struct mutex vport_mutex;
 	int vport_use_count;
 
-	/* Set by mana_set_channels() under vport_mutex to block RDMA
-	 * from grabbing the vport during the detach/attach window.
-	 * Checked by mana_cfg_vport() when called from the RDMA path.
-	 */
+	/* Exclude RDMA during reconfiguration; protected by vport_mutex. */
 	bool channel_changing;
 
+	/* Caller must close the port after releasing the unpublished set. */
+	bool publish_dead_end;
+
+	/* Carrier lowered by failed rollback; cleared on reopen or a link
+	 * event.
+	 */
+	bool carrier_forced_off;
+
 	/* Net shaper handle*/
 	struct net_shaper_handle handle;
 
@@ -706,6 +711,9 @@ int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, struct mana_qset *out);
+int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
+		      struct mana_qset *out_old);
+void mana_publish_close_if_needed(struct mana_port_context *apc);
 void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
 
 void mana_dim_change(struct mana_cq *cq, bool enable);
-- 
2.43.0
