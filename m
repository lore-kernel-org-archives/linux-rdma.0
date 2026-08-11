Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803113F6C4D;
	Tue, 11 Aug 2026 06:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430138; cv=none; b=b7+T4pHzic/dOYhxQAsHdUWGvHeAinE0WManozXCfNBfOmvPMuq4yqb1FmoAQSYCjlpYAi3No/3r6bHMSbgTAr2BdY8AiQ9GVuOX/wYw5LZlCMQHQyGoBSl8HIjFN9iYzEB2yZUpq/sHRecwPuJ64EAMTHnLxZsFzgna9cNItaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430138; c=relaxed/simple;
	bh=yFVGWAaS+mYi4557iKOpRE+atb+q++ZJQpgmJKCtRNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkA7qkcaNnRtZN7gzEoXeuAl6IwYmnZPyMrOFEL/a1OoZ+hk3gsXVc0e1Y9LbbWTDd88Tu60jRQJ/fEIQnFjWW46EA8+FXtLRoQ4ACSL3UQD5e5vb6dvZb596RnVafnyzVU/ar/+OXYz4mRJDBUJ6SE6WVTxb9svgfmxwS+OYSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id ADAF920B7128; Mon, 10 Aug 2026 23:35:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ADAF920B7128
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
Subject: [PATCH net-next v2 03/13] net: mana: swap queue sets in mana_set_ringparam
Date: Mon, 10 Aug 2026 23:35:00 -0700
Message-ID: <20260811063506.2428213-4-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260811063506.2428213-1-longli@microsoft.com>
References: <20260811063506.2428213-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the ring size path to the pre-allocate and swap helpers, for the
same reasons as mana_set_channels(): the new queues are built before
anything is torn down, so an allocation failure returns the error with
the running configuration untouched, and the vport is never released so
RDMA cannot claim it mid-reconfiguration.

This also drops the fallback behaviour on failure. Previously, when
mana_attach() failed, the code retried with ring sizes chosen to
maximise the chance of recovery - the previous values, or the defaults,
or the minimums - and scheduled queue_reset_work(). A user who asked for
a specific ring size could therefore end up with a different one, with
no indication beyond dmesg. There is nothing to recover from now, so the
error is simply returned and the requested value is never silently
replaced.

Add an early return when the requested sizes round to the values already
in use.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../ethernet/microsoft/mana/mana_ethtool.c    | 81 +++++++++++++------
 1 file changed, 58 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 43ae71eb6b5fecc8973bf7aea4ebbfffd19bd7cd..bff6f69a9457c04c3555e9ef418b0e83b8e54d0d 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -775,19 +775,25 @@ static void mana_get_ringparam(struct net_device *ndev,
 	ring->tx_max_pending = MAX_TX_BUFFERS_PER_QUEUE;
 }
 
+/* mana_set_ringparam - resize the RX/TX rings
+ *
+ * Uses the pre-allocate + swap path: the new queue set is built with the
+ * requested ring sizes while the current one keeps serving traffic. If the
+ * allocation fails the running configuration is untouched and the error is
+ * returned - the requested sizes are never silently replaced by fallback
+ * values.
+ */
 static int mana_set_ringparam(struct net_device *ndev,
 			      struct ethtool_ringparam *ring,
 			      struct kernel_ethtool_ringparam *kernel_ring,
 			      struct netlink_ext_ack *extack)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
+	struct mana_port_context *scratch;
+	struct mana_qset newq, oldq;
 	u32 new_tx, new_rx;
-	u32 old_tx, old_rx;
 	int err;
 
-	old_tx = apc->tx_queue_size;
-	old_rx = apc->rx_queue_size;
-
 	if (ring->tx_pending < MIN_TX_BUFFERS_PER_QUEUE) {
 		NL_SET_ERR_MSG_FMT(extack, "tx:%d less than the min:%d", ring->tx_pending,
 				   MIN_TX_BUFFERS_PER_QUEUE);
@@ -805,32 +811,61 @@ static int mana_set_ringparam(struct net_device *ndev,
 	netdev_info(ndev, "Using nearest power of 2 values for Txq:%d Rxq:%d\n",
 		    new_tx, new_rx);
 
-	/* pre-allocating new buffers to prevent failures in mana_attach() later */
-	apc->rx_queue_size = new_rx;
-	err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
-	apc->rx_queue_size = old_rx;
-	if (err) {
-		netdev_err(ndev, "Insufficient memory for new allocations\n");
-		return err;
+	if (new_rx == apc->rx_queue_size && new_tx == apc->tx_queue_size)
+		return 0;
+
+	/* Port is down: no queues to rebuild, just record the new sizes. */
+	if (!apc->port_is_up) {
+		apc->rx_queue_size = new_rx;
+		apc->tx_queue_size = new_tx;
+		return 0;
 	}
 
-	err = mana_detach(ndev, false);
-	if (err) {
-		netdev_err(ndev, "mana_detach failed: %d\n", err);
-		goto out;
+	/* Block RDMA from acquiring the vport for the duration. The vport
+	 * itself is never released, so vport_use_count stays > 0.
+	 */
+	mutex_lock(&apc->vport_mutex);
+	if (apc->channel_changing) {
+		mutex_unlock(&apc->vport_mutex);
+		return -EBUSY;
+	}
+	apc->channel_changing = true;
+	mutex_unlock(&apc->vport_mutex);
+
+	scratch = mana_qset_scratch_alloc(apc);
+	if (!scratch) {
+		err = -ENOMEM;
+		goto clear_flag;
 	}
 
-	apc->tx_queue_size = new_tx;
-	apc->rx_queue_size = new_rx;
+	err = mana_alloc_qset(scratch, apc->num_queues, new_rx, new_tx,
+			      apc->priv_flags, &newq);
+	if (err) {
+		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
+				   err);
+		goto free_scratch; /* current qset untouched */
+	}
 
-	err = mana_attach(ndev);
+	err = mana_publish_qset(apc, &newq, &oldq);
 	if (err) {
-		netdev_err(ndev, "mana_attach failed: %d\n", err);
-		apc->tx_queue_size = old_tx;
-		apc->rx_queue_size = old_rx;
+		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
+				   err);
+		mana_free_qset(scratch, &newq);
+		goto free_scratch;
 	}
-out:
-	mana_pre_dealloc_rxbufs(apc);
+
+	mana_free_qset(scratch, &oldq);
+
+free_scratch:
+	/* After the caller-side cleanup above, so the EQ pool outlives the
+	 * CQs that reference it.
+	 */
+	mana_publish_close_if_needed(apc);
+	mana_qset_scratch_free(scratch);
+clear_flag:
+	mutex_lock(&apc->vport_mutex);
+	apc->channel_changing = false;
+	mutex_unlock(&apc->vport_mutex);
 	return err;
 }
 
-- 
2.43.0

