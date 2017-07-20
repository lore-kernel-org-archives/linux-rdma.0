From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC net-next 07/10] net/smc: introduce sg-logic for send buffers
Date: Thu, 20 Jul 2017 14:09:43 +0200
Message-ID: <20170720120946.67234-8-ubraun@linux.vnet.ibm.com>
References: <20170720120946.67234-1-ubraun@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170720120946.67234-1-ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org, schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, hwippel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, raspl-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

SMC send buffers are processed the same way as RMBs. Since RMBs have
been converted to sg-logic, do the same for send buffers.

Signed-off-by: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 net/smc/smc_core.c | 46 +++++++++++++++++++++++++++++++++++-----------
 net/smc/smc_core.h |  2 --
 net/smc/smc_ib.c   | 29 -----------------------------
 net/smc/smc_ib.h   |  6 ------
 net/smc/smc_tx.c   |  6 +++---
 5 files changed, 38 insertions(+), 51 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 87bb3e4771a8..8795c7ed9ce4 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -248,6 +248,7 @@ static void smc_link_clear(struct smc_link *lnk)
 
 static void smc_lgr_free_sndbufs(struct smc_link_group *lgr)
 {
+	struct smc_link *lnk = &lgr->lnk[SMC_SINGLE_LINK];
 	struct smc_buf_desc *sndbuf_desc, *bf_desc;
 	int i;
 
@@ -255,10 +256,11 @@ static void smc_lgr_free_sndbufs(struct smc_link_group *lgr)
 		list_for_each_entry_safe(sndbuf_desc, bf_desc, &lgr->sndbufs[i],
 					 list) {
 			list_del(&sndbuf_desc->list);
-			smc_ib_buf_unmap(lgr->lnk[SMC_SINGLE_LINK].smcibdev,
-					 smc_uncompress_bufsize(i),
-					 sndbuf_desc, DMA_TO_DEVICE);
-			kfree(sndbuf_desc->cpu_addr);
+			smc_ib_buf_unmap_sg(lnk->smcibdev, sndbuf_desc,
+					    DMA_TO_DEVICE);
+			sg_free_table(&sndbuf_desc->sgt[SMC_SINGLE_LINK]);
+			free_pages((unsigned long)sndbuf_desc->cpu_addr,
+				   sndbuf_desc->order);
 			kfree(sndbuf_desc);
 		}
 	}
@@ -517,6 +519,9 @@ int smc_sndbuf_create(struct smc_sock *smc)
 	for (bufsize_short = smc_compress_bufsize(smc->sk.sk_sndbuf / 2);
 	     bufsize_short >= 0; bufsize_short--) {
 		bufsize = smc_uncompress_bufsize(bufsize_short);
+		if ((1 << get_order(bufsize)) > SG_MAX_SINGLE_ALLOC)
+			continue;
+
 		/* check for reusable sndbuf_slot in the link group */
 		sndbuf_desc = smc_sndbuf_get_slot(lgr, bufsize_short);
 		if (sndbuf_desc) {
@@ -527,10 +532,12 @@ int smc_sndbuf_create(struct smc_sock *smc)
 		sndbuf_desc = kzalloc(sizeof(*sndbuf_desc), GFP_KERNEL);
 		if (!sndbuf_desc)
 			break; /* give up with -ENOMEM */
-		sndbuf_desc->cpu_addr = kzalloc(bufsize,
-						GFP_KERNEL | __GFP_NOWARN |
-						__GFP_NOMEMALLOC |
-						__GFP_NORETRY);
+
+		sndbuf_desc->cpu_addr =
+			(void *)__get_free_pages(GFP_KERNEL | __GFP_NOWARN |
+						 __GFP_NOMEMALLOC |
+						 __GFP_NORETRY | __GFP_ZERO,
+						 get_order(bufsize));
 		if (!sndbuf_desc->cpu_addr) {
 			kfree(sndbuf_desc);
 			sndbuf_desc = NULL;
@@ -539,14 +546,31 @@ int smc_sndbuf_create(struct smc_sock *smc)
 			 */
 			continue;
 		}
-		rc = smc_ib_buf_map(lgr->lnk[SMC_SINGLE_LINK].smcibdev,
-				    bufsize, sndbuf_desc, DMA_TO_DEVICE);
+		sndbuf_desc->order = get_order(bufsize);
+
+		rc = sg_alloc_table(&sndbuf_desc->sgt[SMC_SINGLE_LINK], 1,
+				    GFP_KERNEL);
 		if (rc) {
-			kfree(sndbuf_desc->cpu_addr);
+			free_pages((unsigned long)sndbuf_desc->cpu_addr,
+				   sndbuf_desc->order);
+			kfree(sndbuf_desc);
+			sndbuf_desc = NULL;
+			continue;
+		}
+		sg_set_buf(sndbuf_desc->sgt[SMC_SINGLE_LINK].sgl,
+			   sndbuf_desc->cpu_addr, bufsize);
+
+		rc = smc_ib_buf_map_sg(lgr->lnk[SMC_SINGLE_LINK].smcibdev,
+				       sndbuf_desc, DMA_TO_DEVICE);
+		if (rc != 1) {
+			sg_free_table(&sndbuf_desc->sgt[SMC_SINGLE_LINK]);
+			free_pages((unsigned long)sndbuf_desc->cpu_addr,
+				   sndbuf_desc->order);
 			kfree(sndbuf_desc);
 			sndbuf_desc = NULL;
 			continue; /* if mapping failed, try smaller one */
 		}
+
 		sndbuf_desc->used = 1;
 		write_lock_bh(&lgr->sndbufs_lock);
 		list_add(&sndbuf_desc->list, &lgr->sndbufs[bufsize_short]);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index f7b40bdbf24c..72c25cb3eb89 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -102,8 +102,6 @@ struct smc_link {
 /* tx/rx buffer list element for sndbufs list and rmbs list of a lgr */
 struct smc_buf_desc {
 	struct list_head	list;
-	u64			dma_addr[SMC_LINKS_PER_LGR_MAX];
-						/* mapped address of buffer */
 	void			*cpu_addr;	/* virtual address of buffer */
 	struct sg_table		sgt[SMC_LINKS_PER_LGR_MAX];/* virtual buffer */
 	struct ib_mr		*mr_rx[SMC_LINKS_PER_LGR_MAX];
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 228aff6ab644..dd75792f6d63 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -292,35 +292,6 @@ int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
 	return 0;
 }
 
-/* map a new TX or RX buffer to DMA */
-int smc_ib_buf_map(struct smc_ib_device *smcibdev, int buf_size,
-		   struct smc_buf_desc *buf_slot,
-		   enum dma_data_direction data_direction)
-{
-	int rc = 0;
-
-	if (buf_slot->dma_addr[SMC_SINGLE_LINK])
-		return rc; /* already mapped */
-	buf_slot->dma_addr[SMC_SINGLE_LINK] =
-		ib_dma_map_single(smcibdev->ibdev, buf_slot->cpu_addr,
-				  buf_size, data_direction);
-	if (ib_dma_mapping_error(smcibdev->ibdev,
-				 buf_slot->dma_addr[SMC_SINGLE_LINK]))
-		rc = -EIO;
-	return rc;
-}
-
-void smc_ib_buf_unmap(struct smc_ib_device *smcibdev, int buf_size,
-		      struct smc_buf_desc *buf_slot,
-		      enum dma_data_direction data_direction)
-{
-	if (!buf_slot->dma_addr[SMC_SINGLE_LINK])
-		return; /* already unmapped */
-	ib_dma_unmap_single(smcibdev->ibdev, *buf_slot->dma_addr, buf_size,
-			    data_direction);
-	buf_slot->dma_addr[SMC_SINGLE_LINK] = 0;
-}
-
 /* Map a new TX or RX buffer SG-table to DMA */
 int smc_ib_buf_map_sg(struct smc_ib_device *smcibdev,
 		      struct smc_buf_desc *buf_slot,
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index b57d29f29042..72acb19ffc67 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -51,12 +51,6 @@ int smc_ib_register_client(void) __init;
 void smc_ib_unregister_client(void);
 bool smc_ib_port_active(struct smc_ib_device *smcibdev, u8 ibport);
 int smc_ib_remember_port_attr(struct smc_ib_device *smcibdev, u8 ibport);
-int smc_ib_buf_map(struct smc_ib_device *smcibdev, int buf_size,
-		   struct smc_buf_desc *buf_slot,
-		   enum dma_data_direction data_direction);
-void smc_ib_buf_unmap(struct smc_ib_device *smcibdev, int bufsize,
-		      struct smc_buf_desc *buf_slot,
-		      enum dma_data_direction data_direction);
 int smc_ib_buf_map_sg(struct smc_ib_device *smcibdev,
 		      struct smc_buf_desc *buf_slot,
 		      enum dma_data_direction data_direction);
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 21ec1832ab51..f4d58e2dd559 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -277,6 +277,7 @@ static int smc_tx_rdma_writes(struct smc_connection *conn)
 	struct smc_link_group *lgr = conn->lgr;
 	int to_send, rmbespace;
 	struct smc_link *link;
+	dma_addr_t dma_addr;
 	int num_sges;
 	int rc;
 
@@ -334,12 +335,11 @@ static int smc_tx_rdma_writes(struct smc_connection *conn)
 		src_len = conn->sndbuf_size - sent.count;
 	}
 	src_len_sum = src_len;
+	dma_addr = sg_dma_address(conn->sndbuf_desc->sgt[SMC_SINGLE_LINK].sgl);
 	for (dstchunk = 0; dstchunk < 2; dstchunk++) {
 		num_sges = 0;
 		for (srcchunk = 0; srcchunk < 2; srcchunk++) {
-			sges[srcchunk].addr =
-				conn->sndbuf_desc->dma_addr[SMC_SINGLE_LINK] +
-				src_off;
+			sges[srcchunk].addr = dma_addr + src_off;
 			sges[srcchunk].length = src_len;
 			sges[srcchunk].lkey = link->roce_pd->local_dma_lkey;
 			num_sges++;
-- 
2.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
