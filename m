Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BFEC31DDBB;
	Tue,  8 Sep 2026 03:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838169; cv=none; b=XSkQJXHru8PSWrR5BU8siJMI9Qlx0qPHohnvGq594CdzhHtpYvvs4Sk+pjRQhtMbgbKT6ICMXecwr9D1bOxlRUNCRh3+UZRrSoHUGLYBm015FYHuKx6xdpNpjnabdmBNJ7h9i6OerQfyhUbihaDjVNPWWiMpr0jWjys8jsleAVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838169; c=relaxed/simple;
	bh=RD9e3Ce62+69iSIaahKikwo4dVjb1Qt1uCB/wlrvYT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utdvq+EPKIM0+LNxUG0pKYeA/msIJCQTeO7nhpAr2TAEWfHciH8sR4hdfb2C1QMZrVeHpUhNeEeQQP+4YNxIsFPWqVdk8HplOAvrPTHyy0wcfNFfGQ/DBy+/IjUmI0Z+vP3ZFiMVz1bzT1uAuYFAngpqcA6qjFjibKjmq+FM9mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 009BC20B7136; Mon,  7 Sep 2026 20:28:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 009BC20B7136
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
Subject: [PATCH net-next v4 04/13] net: mana: swap queue sets in mana_set_ringparam
Date: Mon,  7 Sep 2026 20:28:34 -0700
Message-ID: <20260908032843.397667-5-longli@microsoft.com>
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

Replace detach/attach with queue-set allocation and publication. Failed
allocation now leaves the running queues and ring sizes unchanged,
rather than risking a detached port after attach failure.

Skip requests whose rounded sizes already match. Keep RDMA excluded
through failure cleanup, which can release the vport.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
  - Describe the old failed-attach behaviour without the nonexistent
    retry chain, and shorten comments.

 .../ethernet/microsoft/mana/mana_ethtool.c    | 68 ++++++++++++-------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 45031ca1254e327a9b129bd77c7a08fb8a240838..96f355de9779cc865a896f4834f780a158cdc058 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -750,13 +750,11 @@ static int mana_set_ringparam(struct net_device *ndev,
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
@@ -774,32 +772,56 @@ static int mana_set_ringparam(struct net_device *ndev,
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
+	if (!apc->port_is_up) {
+		apc->rx_queue_size = new_rx;
+		apc->tx_queue_size = new_tx;
+		return 0;
 	}
 
-	err = mana_detach(ndev, false);
-	if (err) {
-		netdev_err(ndev, "mana_detach failed: %d\n", err);
-		goto out;
+	/* Exclude RDMA through failure cleanup, which may release the vport. */
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
+		goto free_scratch;
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
+	/* Release unpublished queues before closing their shared EQ pool. */
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
