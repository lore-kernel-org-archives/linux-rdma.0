Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663552C08CF;
	Wed, 24 Jun 2026 22:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782340016; cv=none; b=BFwd11ykxafMUllDssVkSA9BbIb3hTC108nsQDCdilNSyHVCboVPyRqbF6K/8uJ0Uq9A6BHqZjSxFc6UPu8T3a9aCHtr4Av9GunbV3Nu6eb36UnSXfjfN+xup+/ANiXPQfLojYaXTP0koyKoD+t71zxqkj8YpwVPBRm2XwZDiL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782340016; c=relaxed/simple;
	bh=Ho1ZueKN3CtWcD6Wl+WMy04kWDEdxKBqwxdu0vgj/MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsNUibykpnlr6yUFtEgM/bA+hik9FH+5w8sgBKtcmtBXzabdZMl/wG9gMKo2PvNdufMMagN+HQLe/2siA03RPFXTUr8Q0yFKck/xuDMFgYpijM3p1JCCdEU9sBolOo8msRKjIYWZjxXcDOMSNliAU9SJ7frq0LDCmBSkpyAO/SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1009)
	id D76BA20B7166; Wed, 24 Jun 2026 15:26:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D76BA20B7166
From: Dexuan Cui <decui@microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	dipayanroy@linux.microsoft.com,
	kees@kernel.org,
	jacob.e.keller@intel.com,
	ssengar@linux.microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH net v2 1/2] net: mana: Sync page pool RX frags for CPU
Date: Wed, 24 Jun 2026 15:26:04 -0700
Message-ID: <20260624222605.1794719-2-decui@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260624222605.1794719-1-decui@microsoft.com>
References: <20260624222605.1794719-1-decui@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MANA allocates RX buffers from page pool fragments when frag_count is
greater than 1. In that case the buffers remain DMA mapped by page pool
and the RX completion path does not call dma_unmap_single(). As a result,
the implicit sync-for-CPU normally performed by dma_unmap_single() is
missing before the packet data is passed to the networking stack.

This breaks RX on configurations which require explicit DMA syncing, for
example when booted with swiotlb=force.

Fix this by recording the page pool page and DMA sync offset when the RX
buffer is allocated, and syncing the received packet range for CPU access
before handing the RX buffer to the stack.

Fixes: 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead of full pages to improve memory efficiency.")
Cc: stable@vger.kernel.org
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

Changes since v1:
    v1 is split into two patches in the v2.
    Add Haiyang's Reviewed-by.

 drivers/net/ethernet/microsoft/mana/mana_en.c | 39 +++++++++++++++----
 include/net/mana/mana.h                       |  8 ++++
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index c9b1df1ed109..1875bffd82b7 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2044,12 +2044,16 @@ static void mana_rx_skb(void *buf_va, bool from_pool,
 }
 
 static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
-			     dma_addr_t *da, bool *from_pool)
+			     dma_addr_t *da, bool *from_pool,
+			     struct page **pp_page, u32 *dma_sync_offset)
 {
 	struct page *page;
 	u32 offset;
 	void *va;
+
 	*from_pool = false;
+	*pp_page = NULL;
+	*dma_sync_offset = 0;
 
 	/* Don't use fragments for jumbo frames or XDP where it's 1 fragment
 	 * per page.
@@ -2087,31 +2091,47 @@ static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
 	va  = page_to_virt(page) + offset;
 	*da = page_pool_get_dma_addr(page) + offset + rxq->headroom;
 	*from_pool = true;
+	*pp_page = page;
+	*dma_sync_offset = offset + rxq->headroom;
 
 	return va;
 }
 
 /* Allocate frag for rx buffer, and save the old buf */
 static void mana_refill_rx_oob(struct device *dev, struct mana_rxq *rxq,
-			       struct mana_recv_buf_oob *rxoob, void **old_buf,
-			       bool *old_fp)
+			       struct mana_recv_buf_oob *rxoob, u32 pktlen,
+			       void **old_buf, bool *old_fp)
 {
+	struct page *pp_page;
+	u32 dma_sync_offset;
 	bool from_pool;
 	dma_addr_t da;
 	void *va;
 
-	va = mana_get_rxfrag(rxq, dev, &da, &from_pool);
+	va = mana_get_rxfrag(rxq, dev, &da, &from_pool, &pp_page,
+			     &dma_sync_offset);
 	if (!va)
 		return;
-	if (!rxoob->from_pool || rxq->frag_count == 1)
+	if (!rxoob->from_pool || rxq->frag_count == 1) {
 		dma_unmap_single(dev, rxoob->sgl[0].address, rxq->datasize,
 				 DMA_FROM_DEVICE);
+	} else {
+		/* The page pool maps the whole page and only syncs for device
+		 * automatically (PP_FLAG_DMA_SYNC_DEV). Sync the received bytes
+		 * for the CPU before they are read: this is required if DMA
+		 * is incoherent or bounce buffers are used.
+		 */
+		page_pool_dma_sync_for_cpu(rxq->page_pool, rxoob->pp_page,
+					   rxoob->dma_sync_offset, pktlen);
+	}
 	*old_buf = rxoob->buf_va;
 	*old_fp = rxoob->from_pool;
 
 	rxoob->buf_va = va;
 	rxoob->sgl[0].address = da;
 	rxoob->from_pool = from_pool;
+	rxoob->pp_page = pp_page;
+	rxoob->dma_sync_offset = dma_sync_offset;
 }
 
 static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
@@ -2170,7 +2190,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 		rxbuf_oob = &rxq->rx_oobs[curr];
 		WARN_ON_ONCE(rxbuf_oob->wqe_inf.wqe_size_in_bu != 1);
 
-		mana_refill_rx_oob(dev, rxq, rxbuf_oob, &old_buf, &old_fp);
+		mana_refill_rx_oob(dev, rxq, rxbuf_oob, pktlen, &old_buf, &old_fp);
 
 		/* Unsuccessful refill will have old_buf == NULL.
 		 * In this case, mana_rx_skb() will drop the packet.
@@ -2566,6 +2586,8 @@ static int mana_fill_rx_oob(struct mana_recv_buf_oob *rx_oob, u32 mem_key,
 			    struct mana_rxq *rxq, struct device *dev)
 {
 	struct mana_port_context *mpc = netdev_priv(rxq->ndev);
+	struct page *pp_page = NULL;
+	u32 dma_sync_offset = 0;
 	bool from_pool = false;
 	dma_addr_t da;
 	void *va;
@@ -2573,13 +2595,16 @@ static int mana_fill_rx_oob(struct mana_recv_buf_oob *rx_oob, u32 mem_key,
 	if (mpc->rxbufs_pre)
 		va = mana_get_rxbuf_pre(rxq, &da);
 	else
-		va = mana_get_rxfrag(rxq, dev, &da, &from_pool);
+		va = mana_get_rxfrag(rxq, dev, &da, &from_pool, &pp_page,
+				     &dma_sync_offset);
 
 	if (!va)
 		return -ENOMEM;
 
 	rx_oob->buf_va = va;
 	rx_oob->from_pool = from_pool;
+	rx_oob->pp_page = pp_page;
+	rx_oob->dma_sync_offset = dma_sync_offset;
 
 	rx_oob->sgl[0].address = da;
 	rx_oob->sgl[0].size = rxq->datasize;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 8f721cd4e4a7..4111b93169d2 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -305,6 +305,14 @@ struct mana_recv_buf_oob {
 
 	void *buf_va;
 	bool from_pool; /* allocated from a page pool */
+	/* head page of the page_pool fragment; valid only when
+	 * from_pool && frag_count > 1.
+	 */
+	struct page *pp_page;
+	/* Fragment offset plus rxq->headroom, passed to
+	 * page_pool_dma_sync_for_cpu().
+	 */
+	u32 dma_sync_offset;
 
 	/* SGL of the buffer going to be sent as part of the work request. */
 	u32 num_sge;
-- 
2.34.1

