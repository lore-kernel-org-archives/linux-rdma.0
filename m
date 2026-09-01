Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60313C819E;
	Tue,  1 Sep 2026 01:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227130; cv=none; b=ks5PrFb7CudcY87VmrZhMMfhsqqcwLTYN0+AZkn9+VEnAwfCdnCvym3rv/wYSfnN2J8cPYqZ2bB8Dtnw6+tiq4ZLMRtu78Mv0aR3XX8r4nqY8KFxsZHZy2OJynTfjwiVECLMQHJAR1QKhaSokktaMn+5YMJO8VervfOad5muB50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227130; c=relaxed/simple;
	bh=H4Tx40EQnEfS8xn0uHbJjSfYiIdXAoqt++a6Gd/MG4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tE4X61VphyBaHRKrjrrUXJbkqUUcQLn0vlRXU83r4TkO5uwWL4068K0HFJd6m4jh8hFh5NBVgnGImYzhg3xf9T3ZQSkvlIvb4dX9ZlMuRe8U2Nxvf59yfwu0b3CLf18MGQV/6RHM5FjIXVjx/wNqttodnW4R0xVpRPF7Myfd1X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 4290020B7166; Mon, 31 Aug 2026 18:44:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4290020B7166
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
Subject: [PATCH net-next v3 04/13] net: mana: swap queue sets in mana_set_ringparam
Date: Mon, 31 Aug 2026 18:44:33 -0700
Message-ID: <20260901014442.2945689-5-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901014442.2945689-1-longli@microsoft.com>
References: <20260901014442.2945689-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the ring size path to pre-allocate and swap, for the same reasons
as the channel count path: an allocation failure returns the error with
the running configuration untouched, and the vport is never released.

This drops the fallback on failure. Previously a failed mana_attach() was
retried with the previous values, or the defaults, or the minimums, so a
user who asked for a specific size could end up with a different one with
no indication beyond dmesg. There is nothing to recover from now, so the
error is returned.

Also return early when the requested sizes round to the values already in
use.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../ethernet/microsoft/mana/mana_ethtool.c    | 73 +++++++++++++------
 1 file changed, 50 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 2ef3d461e707287f6c9dbb04288c8d63a4bc9993..24353dfddde3ce44367b1f27bd1ca3ee81e2bd60 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -766,13 +766,11 @@ static int mana_set_ringparam(struct net_device *ndev,
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
@@ -790,32 +788,61 @@ static int mana_set_ringparam(struct net_device *ndev,
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
+	err = mana_alloc_qset(apc, scratch, apc->num_queues, new_rx, new_tx,
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

