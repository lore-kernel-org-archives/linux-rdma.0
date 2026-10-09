Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF124E77E1;
	Fri,  9 Oct 2026 14:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556907; cv=none; b=Hq02DBAL3XTfzdmBc0AF8LNedDlc41YnmkuIGRNeAgQVq/dHgTPKY+QMF0FVni/hEK5rXqG6IQuqHhCjdMpTSxaERygCN4Gekimsh997mMS89805ws/MH9zy85M7/eUTxfvXUtrYOs8XV7Eji7V12KIblxhr03Cuk/yHNf6gQWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556907; c=relaxed/simple;
	bh=rUY1riY6EGGxjqZQvQpnBFuXwJtp/JPByfC35X8pcig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXevE9Avk1oJ9xq9Q+V4n+GlfPNhO1TFVQo/p2D6LQIhN2eUe7CRBZ8CIXlFfQsymPun17uR/ewe30IJWAmwujA/KM73yINNDjFDL1xyOAm7qgwoGQJYsLHI78C1MTQG3GQnk+U2wDTb4JYjTUCl6HM3PWb2Xa5peEVMnphM6eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=mKlM7CBU; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="mKlM7CBU"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id A568220B716C;
	Fri,  9 Oct 2026 07:41:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A568220B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791556904;
	bh=eKe6lLfi6B6LupbnmwQZudVtOo9zHuA2WpnWo7JU0c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKlM7CBUwd9XVU9G6ic376GOYwnyCOwhL74EHZAJfR+OUSAEv13GSWOddUdWkHUyS
	 mDX8efARvIAmXguXouuvR/0uVQIMCcgoYBxFPzZuSvM9OLvc2tpo3cHH2FXcoeDJ9A
	 zu1iEjnJnMh7juMbmbt5BQjcVDAwa6SqHj/JbwHw=
From: Wei Hu <weh@linux.microsoft.com>
To: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dipayanroy@linux.microsoft.com,
	bpf@vger.kernel.org,
	sdf@fomichev.me,
	daniel@iogearbox.net,
	hawk@kernel.org,
	ast@kernel.org,
	john.fastabend@gmail.com,
	weh@microsoft.com
Subject: [PATCH net-next v6 05/13] net: mana: swap queue sets in mana_set_ringparam
Date: Fri,  9 Oct 2026 14:41:16 +0000
Message-ID: <a3d774b7c36a04a50a4ea9974d3bad1ed2226680.1790795005.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>

Replace detach/attach with queue-set allocation and publication. Failed
allocation now leaves the running queues and ring sizes unchanged,
rather than risking a detached port after attach failure.

Skip requests whose rounded sizes already match. Keep RDMA excluded
through failure cleanup, which can release the vport.

This full rebuild temporarily keeps both sets of SQ/RQ/CQ objects,
RX buffers and page pools live. The port-owned EQ pool is shared,
not doubled. Device resource limits may reject this temporary peak;
allocation failure preserves the live queues and configuration.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../ethernet/microsoft/mana/mana_ethtool.c    | 68 ++++++++++++-------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index ae9a0288a7c0..10d672cc9e60 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -780,13 +780,11 @@ static int mana_set_ringparam(struct net_device *ndev,
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
@@ -804,32 +802,56 @@ static int mana_set_ringparam(struct net_device *ndev,
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
 
