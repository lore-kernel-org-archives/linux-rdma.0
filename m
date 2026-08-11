Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3093F9A04;
	Tue, 11 Aug 2026 06:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430141; cv=none; b=gzElpQlWSqgPt1wUciaHf1cYTZRcfyN0T9r9SNnkBL6ldTH/7tA0puKlaVwPnDb4DFUCAhsZQe2WA2zJgYdrbdmD09xeELe2S6aPwaOkUAus20Z3ioT2Qga2yD6ijt1Lhii4B6lILnfuW2yNx98cqshZ1oQuLKmcD9G64SlSHGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430141; c=relaxed/simple;
	bh=a4tL0ykC9X/bjpCQQl39UY+/YV33tGaMSucO7Oc8p6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmJrQw+jI09u5/815tn9tE2rP14cpcipu/RW0eM0JLwb9ZKwi1QWDSjq5xPD1yFPwrB1MRHWQ5HsSCLwNhkEEMS9IF/bnUeJbgmOgOIDrFDvFBbWvgkB06ULE5i75m51wshAcTS5NZga2uAcxJbiWzrFmIcD1lE1aYBTZ/NitI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 384AA20B7129; Mon, 10 Aug 2026 23:35:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 384AA20B7129
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
Subject: [PATCH net-next v2 04/13] net: mana: swap queue sets in mana_set_priv_flags
Date: Mon, 10 Aug 2026 23:35:01 -0700
Message-ID: <20260811063506.2428213-5-longli@microsoft.com>
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

MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF changes the RX buffer layout, so
toggling it rebuilds the queues. Convert that path to the pre-allocate
and swap helpers, for the same reasons as the channel count and ring
size paths: an allocation failure now returns the error with both the
queues and the flag word untouched, and the vport is never released so
RDMA cannot claim it mid-reconfiguration.

The flag word is no longer written before the rebuild and rolled back on
failure. It is passed to mana_alloc_qset() as part of the queue-set
configuration and installed by mana_publish_qset() only once the new set
is serving traffic, so there is no window where apc->priv_flags
describes queues that do not exist.

Scheduling queue_reset_work() on failure is dropped along with it. After
this patch the TX timeout handler is the only remaining user of
queue_reset_work().

The existing shortcuts are unchanged in behaviour - a down port, or a
configuration where single-buffer-per-page is already forced by a jumbo
MTU or an attached XDP program, still just records the new value - but
they now share one condition instead of being spread across the
function.

Signed-off-by: Long Li <longli@microsoft.com>
---
 .../ethernet/microsoft/mana/mana_ethtool.c    | 85 ++++++++++---------
 1 file changed, 47 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index bff6f69a9457c04c3555e9ef418b0e83b8e54d0d..9392b82d3d48a2638512a53f9c004629b0c679e5 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -891,11 +891,18 @@ static u32 mana_get_priv_flags(struct net_device *ndev)
 	return apc->priv_flags;
 }
 
+/* mana_set_priv_flags - apply a change to the driver private flags
+ *
+ * MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF changes the RX buffer layout, so the
+ * queues must be rebuilt. Uses the pre-allocate + swap path, so a failed
+ * allocation leaves both the queues and the flag word untouched.
+ */
 static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	u32 changed = apc->priv_flags ^ priv_flags;
-	u32 old_priv_flags = apc->priv_flags;
+	struct mana_port_context *scratch;
+	struct mana_qset newq, oldq;
 	int err = 0;
 
 	if (!changed)
@@ -905,54 +912,56 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
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
+	/* Only the RX buffer layout flag requires a queue rebuild. Anything
+	 * else, a down port, or a configuration where single-buffer-per-page
+	 * is already forced, just records the new value.
+	 */
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
+	/* Block RDMA from acquiring the vport for the duration. */
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
+	err = mana_alloc_qset(scratch, apc->num_queues, apc->rx_queue_size,
+			      apc->tx_queue_size, priv_flags, &newq);
+	if (err)
+		goto free_scratch; /* current qset and priv_flags untouched */
 
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
+	/* After the caller-side cleanup above, so the EQ pool outlives the
+	 * CQs that reference it.
+	 */
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

