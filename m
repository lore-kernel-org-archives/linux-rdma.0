Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0177231B83B;
	Tue,  8 Sep 2026 03:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838172; cv=none; b=BGYHMLlM4J53tcI0MgH+76FxSCLHndZv7O9qrfh4BX3SGrva4IXbP030Ve2ECf2qcVF/AWrs23umeiQKF7bQQxE2qJVjxWU3DfP+ZIEdwJ6qiNT4/T3Xnb1VU+xquh4GRuXpcan9LFVhk9g8Ggo9KFfYVLk4BdBkOrZHXJavaqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838172; c=relaxed/simple;
	bh=O+V3agtSYKt7bhuuYlk4TzCjoB/jO0o3XRToWUxtvlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVAWPqXSpZVnuIirjiVVsmv5ntcbnPHwrBM45ldCcRqLhkvKmTdwXAKkEIuV2DFVegUQvSJ1J//W8+z/z/rJmQyBgBDtZ8/Jv8A5YWj9crxyZhugaRr9kkRKQKrqM/RL9bs3fJt/LHiSkoI0lmgORjUXV6dicOzgHDtQ+wMxXTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 0D61D20B7138; Mon,  7 Sep 2026 20:28:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0D61D20B7138
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
Subject: [PATCH net-next v4 05/13] net: mana: swap queue sets in mana_set_priv_flags
Date: Mon,  7 Sep 2026 20:28:35 -0700
Message-ID: <20260908032843.397667-6-longli@microsoft.com>
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

Rebuild queues through the swap path when USE_FULL_PAGE_RXBUF changes
the RX layout. Carry priv_flags with the queue set so allocation failure
leaves the live configuration unchanged and rollback restores the flags.

Retain the shortcuts for a down port or a configuration that already
requires full-page RX. A failed rollback closes the port.

Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
  - Distinguish allocation failure from failed rollback; drop the
    incorrect claim about removing queue_reset_work scheduling.
  - Shorten comments and the commit message.

 .../ethernet/microsoft/mana/mana_ethtool.c    | 72 +++++++++----------
 1 file changed, 34 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 96f355de9779cc865a896f4834f780a158cdc058..adc65b9146c7e74703db587a619678439ff0d84b 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -851,7 +851,8 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	u32 changed = apc->priv_flags ^ priv_flags;
-	u32 old_priv_flags = apc->priv_flags;
+	struct mana_port_context *scratch;
+	struct mana_qset newq, oldq;
 	int err = 0;
 
 	if (!changed)
@@ -861,54 +862,49 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 	if (priv_flags & ~GENMASK(MANA_PRIV_FLAG_MAX - 1, 0))
 		return -EINVAL;
 
-	apc->priv_flags = priv_flags;
-
-	if (changed & BIT(MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF)) {
-		if (!apc->port_is_up)
-			return 0;
-
-		/* If XDP is attached or MTU is jumbo, single-buffer-per-page
-		 * is already forced regardless of this flag. Skip the
-		 * expensive detach/attach cycle since nothing changes.
-		 */
-		if (ndev->mtu + MANA_RXBUF_PAD > PAGE_SIZE / 2 ||
-		    mana_xdp_get(apc))
-			return 0;
+	/* Skip rebuilding when full-page RX is already required. */
+	if (!(changed & BIT(MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF)) ||
+	    !apc->port_is_up ||
+	    ndev->mtu + MANA_RXBUF_PAD > PAGE_SIZE / 2 ||
+	    mana_xdp_get(apc)) {
+		apc->priv_flags = priv_flags;
+		return 0;
+	}
 
-		/* Block RDMA from grabbing the vport during detach/attach */
-		mutex_lock(&apc->vport_mutex);
-		apc->channel_changing = true;
+	mutex_lock(&apc->vport_mutex);
+	if (apc->channel_changing) {
 		mutex_unlock(&apc->vport_mutex);
+		return -EBUSY;
+	}
+	apc->channel_changing = true;
+	mutex_unlock(&apc->vport_mutex);
 
-		err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
-		if (err) {
-			netdev_err(ndev,
-				   "Insufficient memory for new allocations\n");
-			apc->priv_flags = old_priv_flags;
-			goto clear_flag;
-		}
+	scratch = mana_qset_scratch_alloc(apc);
+	if (!scratch) {
+		err = -ENOMEM;
+		goto clear_flag;
+	}
 
-		err = mana_detach(ndev, false);
-		if (err) {
-			netdev_err(ndev, "mana_detach failed: %d\n", err);
-			apc->priv_flags = old_priv_flags;
-			goto out;
-		}
+	err = mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_size,
+			      apc->tx_queue_size, priv_flags, &newq);
+	if (err)
+		goto free_scratch;
 
-		err = mana_attach(ndev);
-		if (err) {
-			netdev_err(ndev, "mana_attach failed: %d\n", err);
-			apc->priv_flags = old_priv_flags;
-		}
+	err = mana_publish_qset(apc, &newq, &oldq);
+	if (err) {
+		mana_free_qset(scratch, &newq);
+		goto free_scratch;
 	}
 
-out:
-	mana_pre_dealloc_rxbufs(apc);
+	mana_free_qset(scratch, &oldq);
+
+free_scratch:
+	mana_publish_close_if_needed(apc);
+	mana_qset_scratch_free(scratch);
 clear_flag:
 	mutex_lock(&apc->vport_mutex);
 	apc->channel_changing = false;
 	mutex_unlock(&apc->vport_mutex);
-
 	return err;
 }
 
-- 
2.43.0
