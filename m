From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC net-next 04/10] net/smc: use separate memory regions for RMBs
Date: Thu, 20 Jul 2017 14:09:40 +0200
Message-ID: <20170720120946.67234-5-ubraun@linux.vnet.ibm.com>
References: <20170720120946.67234-1-ubraun@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170720120946.67234-1-ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org, schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, hwippel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, raspl-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

SMC currently uses the unsafe_global_rkey of the protection domain,
which exposes all memory for remote reads and writes once a connection
is established. This patch introduces separate memory regions with
separate rkeys for every RMB. Now the unsafe_global_rkey of the
protection domain is no longer needed.

Signed-off-by: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 net/smc/smc_clc.c  |  4 ++--
 net/smc/smc_core.c | 18 ++++++++++++++++++
 net/smc/smc_core.h |  6 +++++-
 net/smc/smc_ib.c   | 42 ++++++++++++++++++++++++++++++++++++++++--
 net/smc/smc_ib.h   |  5 +++--
 5 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 15cb76019009..3934913ab835 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -204,7 +204,7 @@ int smc_clc_send_confirm(struct smc_sock *smc)
 	memcpy(&cclc.lcl.mac, &link->smcibdev->mac[link->ibport - 1], ETH_ALEN);
 	hton24(cclc.qpn, link->roce_qp->qp_num);
 	cclc.rmb_rkey =
-		htonl(link->roce_pd->unsafe_global_rkey);
+		htonl(conn->rmb_desc->mr_rx[SMC_SINGLE_LINK]->rkey);
 	cclc.conn_idx = 1; /* for now: 1 RMB = 1 RMBE */
 	cclc.rmbe_alert_token = htonl(conn->alert_token_local);
 	cclc.qp_mtu = min(link->path_mtu, link->peer_mtu);
@@ -256,7 +256,7 @@ int smc_clc_send_accept(struct smc_sock *new_smc, int srv_first_contact)
 	memcpy(&aclc.lcl.mac, link->smcibdev->mac[link->ibport - 1], ETH_ALEN);
 	hton24(aclc.qpn, link->roce_qp->qp_num);
 	aclc.rmb_rkey =
-		htonl(link->roce_pd->unsafe_global_rkey);
+		htonl(conn->rmb_desc->mr_rx[SMC_SINGLE_LINK]->rkey);
 	aclc.conn_idx = 1;			/* as long as 1 RMB = 1 RMBE */
 	aclc.rmbe_alert_token = htonl(conn->alert_token_local);
 	aclc.qp_mtu = link->path_mtu;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index bfdbda795f67..f1dd4e1cd3e1 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -218,6 +218,7 @@ static void smc_sndbuf_unuse(struct smc_connection *conn)
 static void smc_rmb_unuse(struct smc_connection *conn)
 {
 	if (conn->rmb_desc) {
+		conn->rmb_desc->reused = true;
 		conn->rmb_desc->used = 0;
 		conn->rmbe_size = 0;
 	}
@@ -274,6 +275,8 @@ static void smc_lgr_free_rmbs(struct smc_link_group *lgr)
 		list_for_each_entry_safe(rmb_desc, bf_desc, &lgr->rmbs[i],
 					 list) {
 			list_del(&rmb_desc->list);
+			smc_ib_put_memory_region(
+					rmb_desc->mr_rx[SMC_SINGLE_LINK]);
 			smc_ib_buf_unmap_sg(lnk->smcibdev, rmb_desc,
 					    DMA_FROM_DEVICE);
 			kfree(rmb_desc->cpu_addr);
@@ -627,6 +630,21 @@ int smc_rmb_create(struct smc_sock *smc)
 			rmb_desc = NULL;
 			continue; /* if mapping failed, try smaller one */
 		}
+		rc = smc_ib_get_memory_region(lgr->lnk[SMC_SINGLE_LINK].roce_pd,
+					      IB_ACCESS_REMOTE_WRITE |
+					      IB_ACCESS_LOCAL_WRITE,
+					      rmb_desc);
+		if (rc) {
+			smc_ib_buf_unmap_sg(lgr->lnk[SMC_SINGLE_LINK].smcibdev,
+					    rmb_desc, DMA_FROM_DEVICE);
+			sg_free_table(&rmb_desc->sgt[SMC_SINGLE_LINK]);
+			free_pages((unsigned long)rmb_desc->cpu_addr,
+				   rmb_desc->order);
+			kfree(rmb_desc);
+			rmb_desc = NULL;
+			continue;
+		}
+
 		rmb_desc->used = 1;
 		write_lock_bh(&lgr->rmbs_lock);
 		list_add(&rmb_desc->list, &lgr->rmbs[bufsize_short]);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 0ee450d69907..17b5fea09901 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -94,8 +94,13 @@ struct smc_buf_desc {
 						/* mapped address of buffer */
 	void			*cpu_addr;	/* virtual address of buffer */
 	struct sg_table		sgt[SMC_LINKS_PER_LGR_MAX];/* virtual buffer */
+	struct ib_mr		*mr_rx[SMC_LINKS_PER_LGR_MAX];
+						/* for rmb only: memory region
+						 * incl. rkey provided to peer
+						 */
 	u32			order;		/* allocation order */
 	u32			used;		/* currently used / unused */
+	bool			reused;		/* new created / reused */
 };
 
 struct smc_rtoken {				/* address/key of remote RMB */
@@ -175,5 +180,4 @@ int smc_sndbuf_create(struct smc_sock *smc);
 int smc_rmb_create(struct smc_sock *smc);
 int smc_rmb_rtoken_handling(struct smc_connection *conn,
 			    struct smc_clc_msg_accept_confirm *clc);
-
 #endif
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index fcfeb89b05d9..7c36b8938be5 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -192,8 +192,7 @@ int smc_ib_create_protection_domain(struct smc_link *lnk)
 {
 	int rc;
 
-	lnk->roce_pd = ib_alloc_pd(lnk->smcibdev->ibdev,
-				   IB_PD_UNSAFE_GLOBAL_RKEY);
+	lnk->roce_pd = ib_alloc_pd(lnk->smcibdev->ibdev, 0);
 	rc = PTR_ERR_OR_ZERO(lnk->roce_pd);
 	if (IS_ERR(lnk->roce_pd))
 		lnk->roce_pd = NULL;
@@ -254,6 +253,45 @@ int smc_ib_create_queue_pair(struct smc_link *lnk)
 	return rc;
 }
 
+void smc_ib_put_memory_region(struct ib_mr *mr)
+{
+	ib_dereg_mr(mr);
+}
+
+static int smc_ib_map_mr_sg(struct smc_buf_desc *buf_slot)
+{
+	unsigned int offset = 0;
+	int sg_num;
+
+	/* map the largest prefix of a dma mapped SG list */
+	sg_num = ib_map_mr_sg(buf_slot->mr_rx[SMC_SINGLE_LINK],
+			      buf_slot->sgt[SMC_SINGLE_LINK].sgl,
+			      buf_slot->sgt[SMC_SINGLE_LINK].orig_nents,
+			      &offset, PAGE_SIZE);
+
+	return sg_num;
+}
+
+/* Allocate a memory region and map the dma mapped SG list of buf_slot */
+int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
+			     struct smc_buf_desc *buf_slot)
+{
+	if (buf_slot->mr_rx[SMC_SINGLE_LINK])
+		return 0; /* already done */
+
+	buf_slot->mr_rx[SMC_SINGLE_LINK] =
+		ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, 1 << buf_slot->order);
+	if (IS_ERR(buf_slot->mr_rx[SMC_SINGLE_LINK])) {
+		buf_slot->mr_rx[SMC_SINGLE_LINK] = NULL;
+		return PTR_ERR(buf_slot->mr_rx[SMC_SINGLE_LINK]);
+	}
+
+	if (smc_ib_map_mr_sg(buf_slot) != 1)
+		return -EINVAL;
+
+	return 0;
+}
+
 /* map a new TX or RX buffer to DMA */
 int smc_ib_buf_map(struct smc_ib_device *smcibdev, int buf_size,
 		   struct smc_buf_desc *buf_slot,
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index b30e387854b6..b57d29f29042 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -71,6 +71,7 @@ int smc_ib_ready_link(struct smc_link *lnk);
 int smc_ib_modify_qp_rts(struct smc_link *lnk);
 int smc_ib_modify_qp_reset(struct smc_link *lnk);
 long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev);
-
-
+int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
+			     struct smc_buf_desc *buf_slot);
+void smc_ib_put_memory_region(struct ib_mr *mr);
 #endif
-- 
2.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
