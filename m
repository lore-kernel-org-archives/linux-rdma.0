From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 3/5] IB/ipoib: Move to multi-queue device
Date: Sun, 24 Mar 2013 14:43:30 +0200
Message-ID: <1364129012-12198-4-git-send-email-ogerlitz@mellanox.com>
References: <1364129012-12198-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364129012-12198-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch is a restructuring step needed to implement RSS (Receive Side
Scaling) and TSS (multi-queue transmit) for IPoIB.

The following structures and flows are changed:

- Addition of struct ipoib_recv_ring and struct ipoib_send_ring which hold
the per RX / TX ring fields respectively. These fields are the plural of
the receive and send fields previously present in struct ipoib_dev_priv.

- Add per send/receive ring stats counters. These counters are accessible
through ethtool. Net device stats are no longer accumulated, instead
ndo_get_stats is implemented.

- Use the multi queue APIs for TX and RX: alloc_netdev_mqs, netif_xxx_subqueue,
netif_subqueue_yyy, use per TX queue timer and NAPI instance per RX queue.

- Put a work request structure and scatter/gather list in the RX ring
structure for the CM code to use, and remove them from ipoib_cm_dev_priv

With this patch being an intermediate step, the number of RX and TX rings
is fixed to one. Where the single TX ring and RX ring QP/CQs are currently
taken from the "priv" structure.

The Address Handles Garbage Collection mechanism was changed such
that the data path uses ref count (inc on post send, dec on send completion),
and the AH GC thread code tests for zero value of the ref count instead of
comparing tx_head to last_send. Some change was a must here, since the SAME
AH can be used by multiple TX rings as the skb hashing can possible map the
same IPoIB daddr to multiple TX rings in parallel (uses L3/L4 headers).

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |  102 ++++--
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  208 ++++++----
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   92 ++++-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  538 +++++++++++++++++-------
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  265 ++++++++++--
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   44 ++-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |   63 ++-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |    2 +-
 8 files changed, 974 insertions(+), 340 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index eb71aaa..9bf96db 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -160,6 +160,7 @@ struct ipoib_rx_buf {
 
 struct ipoib_tx_buf {
 	struct sk_buff *skb;
+	struct ipoib_ah *ah;
 	u64		mapping[MAX_SKB_FRAGS + 1];
 };
 
@@ -217,6 +218,7 @@ struct ipoib_cm_rx {
 	unsigned long		jiffies;
 	enum ipoib_cm_state	state;
 	int			recv_count;
+	int index; /* For ring counters */
 };
 
 struct ipoib_cm_tx {
@@ -256,11 +258,10 @@ struct ipoib_cm_dev_priv {
 	struct list_head	start_list;
 	struct list_head	reap_list;
 	struct ib_wc		ibwc[IPOIB_NUM_WC];
-	struct ib_sge		rx_sge[IPOIB_CM_RX_SG];
-	struct ib_recv_wr       rx_wr;
 	int			nonsrq_conn_qp;
 	int			max_cm_mtu;
 	int			num_frags;
+	u32			rx_cq_ind;
 };
 
 struct ipoib_ethtool_st {
@@ -286,6 +287,65 @@ struct ipoib_neigh_table {
 };
 
 /*
+ * Per QP stats
+ */
+
+struct ipoib_tx_ring_stats {
+	unsigned long tx_packets;
+	unsigned long tx_bytes;
+	unsigned long tx_errors;
+	unsigned long tx_dropped;
+};
+
+struct ipoib_rx_ring_stats {
+	unsigned long rx_packets;
+	unsigned long rx_bytes;
+	unsigned long rx_errors;
+	unsigned long rx_dropped;
+};
+
+/*
+ * Encapsulates the per send QP information
+ */
+struct ipoib_send_ring {
+	struct net_device	*dev;
+	struct ib_cq		*send_cq;
+	struct ib_qp		*send_qp;
+	struct ipoib_tx_buf	*tx_ring;
+	unsigned		tx_head;
+	unsigned		tx_tail;
+	struct ib_sge		tx_sge[MAX_SKB_FRAGS + 1];
+	struct ib_send_wr	tx_wr;
+	unsigned		tx_outstanding;
+	struct ib_wc		tx_wc[MAX_SEND_CQE];
+	struct timer_list	poll_timer;
+	struct ipoib_tx_ring_stats stats;
+	unsigned		index;
+};
+
+struct ipoib_rx_cm_info {
+	struct ib_sge		rx_sge[IPOIB_CM_RX_SG];
+	struct ib_recv_wr       rx_wr;
+};
+
+/*
+ * Encapsulates the per recv QP information
+ */
+struct ipoib_recv_ring {
+	struct net_device	*dev;
+	struct ib_qp		*recv_qp;
+	struct ib_cq		*recv_cq;
+	struct ib_wc		ibwc[IPOIB_NUM_WC];
+	struct napi_struct	napi;
+	struct ipoib_rx_buf	*rx_ring;
+	struct ib_recv_wr	rx_wr;
+	struct ib_sge		rx_sge[IPOIB_UD_RX_SG];
+	struct ipoib_rx_cm_info	cm;
+	struct ipoib_rx_ring_stats stats;
+	unsigned		index;
+};
+
+/*
  * Device private locking: network stack tx_lock protects members used
  * in TX fast path, lock protects everything else.  lock nests inside
  * of tx_lock (ie tx_lock must be acquired first if needed).
@@ -295,8 +355,6 @@ struct ipoib_dev_priv {
 
 	struct net_device *dev;
 
-	struct napi_struct napi;
-
 	unsigned long flags;
 
 	struct mutex vlan_mutex;
@@ -337,21 +395,6 @@ struct ipoib_dev_priv {
 	unsigned int mcast_mtu;
 	unsigned int max_ib_mtu;
 
-	struct ipoib_rx_buf *rx_ring;
-
-	struct ipoib_tx_buf *tx_ring;
-	unsigned	     tx_head;
-	unsigned	     tx_tail;
-	struct ib_sge	     tx_sge[MAX_SKB_FRAGS + 1];
-	struct ib_send_wr    tx_wr;
-	unsigned	     tx_outstanding;
-	struct ib_wc	     send_wc[MAX_SEND_CQE];
-
-	struct ib_recv_wr    rx_wr;
-	struct ib_sge	     rx_sge[IPOIB_UD_RX_SG];
-
-	struct ib_wc ibwc[IPOIB_NUM_WC];
-
 	struct list_head dead_ahs;
 
 	struct ib_event_handler event_handler;
@@ -373,6 +416,10 @@ struct ipoib_dev_priv {
 	int	hca_caps;
 	struct ipoib_ethtool_st ethtool;
 	struct timer_list poll_timer;
+	struct ipoib_recv_ring *recv_ring;
+	struct ipoib_send_ring *send_ring;
+	unsigned int num_rx_queues;
+	unsigned int num_tx_queues;
 };
 
 struct ipoib_ah {
@@ -380,7 +427,7 @@ struct ipoib_ah {
 	struct ib_ah	  *ah;
 	struct list_head   list;
 	struct kref	   ref;
-	unsigned	   last_send;
+	atomic_t	   refcnt;
 };
 
 struct ipoib_path {
@@ -442,8 +489,8 @@ extern struct workqueue_struct *ipoib_workqueue;
 /* functions */
 
 int ipoib_poll(struct napi_struct *napi, int budget);
-void ipoib_ib_completion(struct ib_cq *cq, void *dev_ptr);
-void ipoib_send_comp_handler(struct ib_cq *cq, void *dev_ptr);
+void ipoib_ib_completion(struct ib_cq *cq, void *recv_ring_ptr);
+void ipoib_send_comp_handler(struct ib_cq *cq, void *send_ring_ptr);
 
 struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
 				 struct ib_pd *pd, struct ib_ah_attr *attr);
@@ -462,7 +509,8 @@ void ipoib_reap_ah(struct work_struct *work);
 
 void ipoib_mark_paths_invalid(struct net_device *dev);
 void ipoib_flush_paths(struct net_device *dev);
-struct ipoib_dev_priv *ipoib_intf_alloc(const char *format);
+struct ipoib_dev_priv *ipoib_intf_alloc(const char *format,
+					struct ipoib_dev_priv *temp_priv);
 
 int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port);
 void ipoib_ib_dev_flush_light(struct work_struct *work);
@@ -600,7 +648,9 @@ struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path
 void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx);
 void ipoib_cm_skb_too_long(struct net_device *dev, struct sk_buff *skb,
 			   unsigned int mtu);
-void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc);
+void ipoib_cm_handle_rx_wc(struct net_device *dev,
+			   struct ipoib_recv_ring *recv_ring,
+			   struct ib_wc *wc);
 void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc);
 #else
 
@@ -698,7 +748,9 @@ static inline void ipoib_cm_skb_too_long(struct net_device *dev, struct sk_buff
 	dev_kfree_skb_any(skb);
 }
 
-static inline void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
+static inline void ipoib_cm_handle_rx_wc(struct net_device *dev,
+					 struct ipoib_recv_ring *recv_ring,
+					 struct ib_wc *wc)
 {
 }
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 1ef880d..f73b4b7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/moduleparam.h>
+#include <linux/jhash.h>
 
 #include "ipoib.h"
 
@@ -88,18 +89,24 @@ static void ipoib_cm_dma_unmap_rx(struct ipoib_dev_priv *priv, int frags,
 		ib_dma_unmap_page(priv->ca, mapping[i + 1], PAGE_SIZE, DMA_FROM_DEVICE);
 }
 
-static int ipoib_cm_post_receive_srq(struct net_device *dev, int id)
+static int ipoib_cm_post_receive_srq(struct net_device *dev,
+				     struct ipoib_recv_ring *recv_ring, int id)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ib_sge *sge;
+	struct ib_recv_wr *wr;
 	struct ib_recv_wr *bad_wr;
 	int i, ret;
 
-	priv->cm.rx_wr.wr_id = id | IPOIB_OP_CM | IPOIB_OP_RECV;
+	sge = recv_ring->cm.rx_sge;
+	wr = &recv_ring->cm.rx_wr;
+
+	wr->wr_id = id | IPOIB_OP_CM | IPOIB_OP_RECV;
 
 	for (i = 0; i < priv->cm.num_frags; ++i)
-		priv->cm.rx_sge[i].addr = priv->cm.srq_ring[id].mapping[i];
+		sge[i].addr = priv->cm.srq_ring[id].mapping[i];
 
-	ret = ib_post_srq_recv(priv->cm.srq, &priv->cm.rx_wr, &bad_wr);
+	ret = ib_post_srq_recv(priv->cm.srq, wr, &bad_wr);
 	if (unlikely(ret)) {
 		ipoib_warn(priv, "post srq failed for buf %d (%d)\n", id, ret);
 		ipoib_cm_dma_unmap_rx(priv, priv->cm.num_frags - 1,
@@ -112,14 +119,18 @@ static int ipoib_cm_post_receive_srq(struct net_device *dev, int id)
 }
 
 static int ipoib_cm_post_receive_nonsrq(struct net_device *dev,
-					struct ipoib_cm_rx *rx,
-					struct ib_recv_wr *wr,
-					struct ib_sge *sge, int id)
+					struct ipoib_cm_rx *rx, int id)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_recv_ring *recv_ring = priv->recv_ring + rx->index;
+	struct ib_sge *sge;
+	struct ib_recv_wr *wr;
 	struct ib_recv_wr *bad_wr;
 	int i, ret;
 
+	sge = recv_ring->cm.rx_sge;
+	wr = &recv_ring->cm.rx_wr;
+
 	wr->wr_id = id | IPOIB_OP_CM | IPOIB_OP_RECV;
 
 	for (i = 0; i < IPOIB_CM_RX_SG; ++i)
@@ -225,7 +236,15 @@ static void ipoib_cm_start_rx_drain(struct ipoib_dev_priv *priv)
 	if (ib_post_send(p->qp, &ipoib_cm_rx_drain_wr, &bad_wr))
 		ipoib_warn(priv, "failed to post drain wr\n");
 
-	list_splice_init(&priv->cm.rx_flush_list, &priv->cm.rx_drain_list);
+	/*
+	 * Under the multi ring scheme, different CM QPs are bounded to
+	 * different CQs and hence to diferent NAPI contextes. With that in
+	 * mind, we must make sure that the NAPI context that invokes the reap
+	 * (deletion) of a certain QP is the same context that handles the
+	 * normal RX WC handling. To achieve that, move only one QP at a time to
+	 * the drain list, this will enforce posting the drain WR on each QP.
+	 */
+	list_move(&p->list, &priv->cm.rx_drain_list);
 }
 
 static void ipoib_cm_rx_event_handler(struct ib_event *event, void *ctx)
@@ -250,8 +269,6 @@ static struct ib_qp *ipoib_cm_create_rx_qp(struct net_device *dev,
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_qp_init_attr attr = {
 		.event_handler = ipoib_cm_rx_event_handler,
-		.send_cq = priv->recv_cq, /* For drain WR */
-		.recv_cq = priv->recv_cq,
 		.srq = priv->cm.srq,
 		.cap.max_send_wr = 1, /* For drain WR */
 		.cap.max_send_sge = 1, /* FIXME: 0 Seems not to work */
@@ -259,12 +276,23 @@ static struct ib_qp *ipoib_cm_create_rx_qp(struct net_device *dev,
 		.qp_type = IB_QPT_RC,
 		.qp_context = p,
 	};
+	int index;
 
 	if (!ipoib_cm_has_srq(dev)) {
 		attr.cap.max_recv_wr  = ipoib_recvq_size;
 		attr.cap.max_recv_sge = IPOIB_CM_RX_SG;
 	}
 
+	index = priv->cm.rx_cq_ind;
+	if (index >= priv->num_rx_queues)
+		index = 0;
+
+	priv->cm.rx_cq_ind = index + 1;
+	/* send_cp for drain WR */
+	attr.recv_cq = priv->recv_ring[index].recv_cq;
+	attr.send_cq = attr.recv_cq;
+	p->index = index;
+
 	return ib_create_qp(priv->pd, &attr);
 }
 
@@ -323,33 +351,34 @@ static int ipoib_cm_modify_rx_qp(struct net_device *dev,
 	return 0;
 }
 
-static void ipoib_cm_init_rx_wr(struct net_device *dev,
-				struct ib_recv_wr *wr,
-				struct ib_sge *sge)
+static void ipoib_cm_init_rx_wr(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	int i;
-
-	for (i = 0; i < priv->cm.num_frags; ++i)
-		sge[i].lkey = priv->mr->lkey;
-
-	sge[0].length = IPOIB_CM_HEAD_SIZE;
-	for (i = 1; i < priv->cm.num_frags; ++i)
-		sge[i].length = PAGE_SIZE;
-
-	wr->next    = NULL;
-	wr->sg_list = sge;
-	wr->num_sge = priv->cm.num_frags;
+	struct ipoib_recv_ring *recv_ring = priv->recv_ring;
+	struct ib_sge *sge;
+	struct ib_recv_wr *wr;
+	int i, j;
+
+	for (j = 0; j < priv->num_rx_queues; j++, recv_ring++) {
+		sge = recv_ring->cm.rx_sge;
+		wr = &recv_ring->cm.rx_wr;
+		for (i = 0; i < priv->cm.num_frags; ++i)
+			sge[i].lkey = priv->mr->lkey;
+
+		sge[0].length = IPOIB_CM_HEAD_SIZE;
+		for (i = 1; i < priv->cm.num_frags; ++i)
+			sge[i].length = PAGE_SIZE;
+
+		wr->next    = NULL;
+		wr->sg_list = sge;
+		wr->num_sge = priv->cm.num_frags;
+	}
 }
 
 static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_id,
 				   struct ipoib_cm_rx *rx)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	struct {
-		struct ib_recv_wr wr;
-		struct ib_sge sge[IPOIB_CM_RX_SG];
-	} *t;
 	int ret;
 	int i;
 
@@ -360,14 +389,6 @@ static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_i
 		return -ENOMEM;
 	}
 
-	t = kmalloc(sizeof *t, GFP_KERNEL);
-	if (!t) {
-		ret = -ENOMEM;
-		goto err_free;
-	}
-
-	ipoib_cm_init_rx_wr(dev, &t->wr, t->sge);
-
 	spin_lock_irq(&priv->lock);
 
 	if (priv->cm.nonsrq_conn_qp >= ipoib_max_conn_qp) {
@@ -387,7 +408,7 @@ static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_i
 				ret = -ENOMEM;
 				goto err_count;
 		}
-		ret = ipoib_cm_post_receive_nonsrq(dev, rx, &t->wr, t->sge, i);
+		ret = ipoib_cm_post_receive_nonsrq(dev, rx, i);
 		if (ret) {
 			ipoib_warn(priv, "ipoib_cm_post_receive_nonsrq "
 				   "failed for buf %d\n", i);
@@ -398,8 +419,6 @@ static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_i
 
 	rx->recv_count = ipoib_recvq_size;
 
-	kfree(t);
-
 	return 0;
 
 err_count:
@@ -408,7 +427,6 @@ err_count:
 	spin_unlock_irq(&priv->lock);
 
 err_free:
-	kfree(t);
 	ipoib_cm_free_rx_ring(dev, rx->rx_ring);
 
 	return ret;
@@ -553,7 +571,9 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 	}
 }
 
-void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
+void ipoib_cm_handle_rx_wc(struct net_device *dev,
+			   struct ipoib_recv_ring *recv_ring,
+			   struct ib_wc *wc)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_cm_rx_buf *rx_ring;
@@ -593,7 +613,7 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		ipoib_dbg(priv, "cm recv error "
 			   "(status=%d, wrid=%d vend_err %x)\n",
 			   wc->status, wr_id, wc->vendor_err);
-		++dev->stats.rx_dropped;
+		++recv_ring->stats.rx_dropped;
 		if (has_srq)
 			goto repost;
 		else {
@@ -646,7 +666,7 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		 * this packet and reuse the old buffer.
 		 */
 		ipoib_dbg(priv, "failed to allocate receive buffer %d\n", wr_id);
-		++dev->stats.rx_dropped;
+		++recv_ring->stats.rx_dropped;
 		goto repost;
 	}
 
@@ -663,8 +683,8 @@ copied:
 	skb_reset_mac_header(skb);
 	skb_pull(skb, IPOIB_ENCAP_LEN);
 
-	++dev->stats.rx_packets;
-	dev->stats.rx_bytes += skb->len;
+	++recv_ring->stats.rx_packets;
+	recv_ring->stats.rx_bytes += skb->len;
 
 	skb->dev = dev;
 	/* XXX get correct PACKET_ type here */
@@ -673,13 +693,13 @@ copied:
 
 repost:
 	if (has_srq) {
-		if (unlikely(ipoib_cm_post_receive_srq(dev, wr_id)))
+		if (unlikely(ipoib_cm_post_receive_srq(dev,
+						       recv_ring,
+						       wr_id)))
 			ipoib_warn(priv, "ipoib_cm_post_receive_srq failed "
 				   "for buf %d\n", wr_id);
 	} else {
 		if (unlikely(ipoib_cm_post_receive_nonsrq(dev, p,
-							  &priv->cm.rx_wr,
-							  priv->cm.rx_sge,
 							  wr_id))) {
 			--p->recv_count;
 			ipoib_warn(priv, "ipoib_cm_post_receive_nonsrq failed "
@@ -691,17 +711,18 @@ repost:
 static inline int post_send(struct ipoib_dev_priv *priv,
 			    struct ipoib_cm_tx *tx,
 			    unsigned int wr_id,
-			    u64 addr, int len)
+			    u64 addr, int len,
+				struct ipoib_send_ring *send_ring)
 {
 	struct ib_send_wr *bad_wr;
 
-	priv->tx_sge[0].addr          = addr;
-	priv->tx_sge[0].length        = len;
+	send_ring->tx_sge[0].addr          = addr;
+	send_ring->tx_sge[0].length        = len;
 
-	priv->tx_wr.num_sge	= 1;
-	priv->tx_wr.wr_id	= wr_id | IPOIB_OP_CM;
+	send_ring->tx_wr.num_sge	= 1;
+	send_ring->tx_wr.wr_id	= wr_id | IPOIB_OP_CM;
 
-	return ib_post_send(tx->qp, &priv->tx_wr, &bad_wr);
+	return ib_post_send(tx->qp, &send_ring->tx_wr, &bad_wr);
 }
 
 void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_tx *tx)
@@ -710,12 +731,17 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 	struct ipoib_cm_tx_buf *tx_req;
 	u64 addr;
 	int rc;
+	struct ipoib_send_ring *send_ring;
+	u16 queue_index;
+
+	queue_index = skb_get_queue_mapping(skb);
+	send_ring = priv->send_ring + queue_index;
 
 	if (unlikely(skb->len > tx->mtu)) {
 		ipoib_warn(priv, "packet len %d (> %d) too long to send, dropping\n",
 			   skb->len, tx->mtu);
-		++dev->stats.tx_dropped;
-		++dev->stats.tx_errors;
+		++send_ring->stats.tx_dropped;
+		++send_ring->stats.tx_errors;
 		ipoib_cm_skb_too_long(dev, skb, tx->mtu - IPOIB_ENCAP_LEN);
 		return;
 	}
@@ -734,7 +760,7 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 	tx_req->skb = skb;
 	addr = ib_dma_map_single(priv->ca, skb->data, skb->len, DMA_TO_DEVICE);
 	if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
-		++dev->stats.tx_errors;
+		++send_ring->stats.tx_errors;
 		dev_kfree_skb_any(skb);
 		return;
 	}
@@ -745,26 +771,27 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 	skb_dst_drop(skb);
 
 	rc = post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
-		       addr, skb->len);
+		       addr, skb->len, send_ring);
 	if (unlikely(rc)) {
 		ipoib_warn(priv, "post_send failed, error %d\n", rc);
-		++dev->stats.tx_errors;
+		++send_ring->stats.tx_errors;
 		ib_dma_unmap_single(priv->ca, addr, skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 	} else {
-		dev->trans_start = jiffies;
+		netdev_get_tx_queue(dev, queue_index)->trans_start = jiffies;
 		++tx->tx_head;
 
-		if (++priv->tx_outstanding == ipoib_sendq_size) {
+		if (++send_ring->tx_outstanding == ipoib_sendq_size) {
 			ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
 				  tx->qp->qp_num);
-			netif_stop_queue(dev);
-			rc = ib_req_notify_cq(priv->send_cq,
+			netif_stop_subqueue(dev, queue_index);
+			rc = ib_req_notify_cq(send_ring->send_cq,
 				IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
 			if (rc < 0)
 				ipoib_warn(priv, "request notify on send CQ failed\n");
 			else if (rc)
-				ipoib_send_comp_handler(priv->send_cq, dev);
+				ipoib_send_comp_handler(send_ring->send_cq,
+							send_ring);
 		}
 	}
 }
@@ -776,6 +803,8 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 	unsigned int wr_id = wc->wr_id & ~IPOIB_OP_CM;
 	struct ipoib_cm_tx_buf *tx_req;
 	unsigned long flags;
+	struct ipoib_send_ring *send_ring;
+	u16 queue_index;
 
 	ipoib_dbg_data(priv, "cm send completion: id %d, status: %d\n",
 		       wr_id, wc->status);
@@ -787,22 +816,24 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 	}
 
 	tx_req = &tx->tx_ring[wr_id];
+	queue_index = skb_get_queue_mapping(tx_req->skb);
+	send_ring = priv->send_ring + queue_index;
 
 	ib_dma_unmap_single(priv->ca, tx_req->mapping, tx_req->skb->len, DMA_TO_DEVICE);
 
 	/* FIXME: is this right? Shouldn't we only increment on success? */
-	++dev->stats.tx_packets;
-	dev->stats.tx_bytes += tx_req->skb->len;
+	++send_ring->stats.tx_packets;
+	send_ring->stats.tx_bytes += tx_req->skb->len;
 
 	dev_kfree_skb_any(tx_req->skb);
 
-	netif_tx_lock(dev);
+	netif_tx_lock_bh(dev);
 
 	++tx->tx_tail;
-	if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
-	    netif_queue_stopped(dev) &&
+	if (unlikely(--send_ring->tx_outstanding == ipoib_sendq_size >> 1) &&
+	    __netif_subqueue_stopped(dev, queue_index) &&
 	    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
-		netif_wake_queue(dev);
+		netif_wake_subqueue(dev, queue_index);
 
 	if (wc->status != IB_WC_SUCCESS &&
 	    wc->status != IB_WC_WR_FLUSH_ERR) {
@@ -833,7 +864,7 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
-	netif_tx_unlock(dev);
+	netif_tx_unlock_bh(dev);
 }
 
 int ipoib_cm_dev_open(struct net_device *dev)
@@ -1021,8 +1052,6 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_qp_init_attr attr = {
-		.send_cq		= priv->recv_cq,
-		.recv_cq		= priv->recv_cq,
 		.srq			= priv->cm.srq,
 		.cap.max_send_wr	= ipoib_sendq_size,
 		.cap.max_send_sge	= 1,
@@ -1030,6 +1059,21 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
 		.qp_type		= IB_QPT_RC,
 		.qp_context		= tx
 	};
+	u32 index;
+
+	/* CM uses ipoib_ib_completion for TX completion which makes use of the
+	 * RX NAPI mechanism. spread context among RX CQ based on address hash.
+	 */
+	if (priv->num_rx_queues > 1) {
+		u32 *daddr_32 = (u32 *)tx->neigh->daddr;
+		u32 hv = jhash_1word(*daddr_32 & IPOIB_QPN_MASK, 0);
+		index = hv % priv->num_rx_queues;
+	} else {
+		index = 0;
+	}
+
+	attr.recv_cq = priv->recv_ring[index].recv_cq;
+	attr.send_cq = attr.recv_cq;
 
 	return ib_create_qp(priv->pd, &attr);
 }
@@ -1182,16 +1226,21 @@ static void ipoib_cm_tx_destroy(struct ipoib_cm_tx *p)
 timeout:
 
 	while ((int) p->tx_tail - (int) p->tx_head < 0) {
+		struct ipoib_send_ring *send_ring;
+		u16 queue_index;
 		tx_req = &p->tx_ring[p->tx_tail & (ipoib_sendq_size - 1)];
 		ib_dma_unmap_single(priv->ca, tx_req->mapping, tx_req->skb->len,
 				    DMA_TO_DEVICE);
 		dev_kfree_skb_any(tx_req->skb);
 		++p->tx_tail;
+		queue_index = skb_get_queue_mapping(tx_req->skb);
+		send_ring = priv->send_ring + queue_index;
 		netif_tx_lock_bh(p->dev);
-		if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
-		    netif_queue_stopped(p->dev) &&
+		if (unlikely(--send_ring->tx_outstanding ==
+				(ipoib_sendq_size >> 1)) &&
+		    __netif_subqueue_stopped(p->dev, queue_index) &&
 		    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
-			netif_wake_queue(p->dev);
+			netif_wake_subqueue(p->dev, queue_index);
 		netif_tx_unlock_bh(p->dev);
 	}
 
@@ -1553,7 +1602,7 @@ int ipoib_cm_dev_init(struct net_device *dev)
 		priv->cm.num_frags  = IPOIB_CM_RX_SG;
 	}
 
-	ipoib_cm_init_rx_wr(dev, &priv->cm.rx_wr, priv->cm.rx_sge);
+	ipoib_cm_init_rx_wr(dev);
 
 	if (ipoib_cm_has_srq(dev)) {
 		for (i = 0; i < ipoib_recvq_size; ++i) {
@@ -1566,7 +1615,8 @@ int ipoib_cm_dev_init(struct net_device *dev)
 				return -ENOMEM;
 			}
 
-			if (ipoib_cm_post_receive_srq(dev, i)) {
+			if (ipoib_cm_post_receive_srq(dev, priv->recv_ring,
+						      i)) {
 				ipoib_warn(priv, "ipoib_cm_post_receive_srq "
 					   "failed for buf %d\n", i);
 				ipoib_cm_dev_cleanup(dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index c4b3940..7c56341 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -74,7 +74,8 @@ static int ipoib_set_coalesce(struct net_device *dev,
 			      struct ethtool_coalesce *coal)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	int ret;
+	int ret, i;
+
 
 	/*
 	 * These values are saved in the private data and returned
@@ -84,23 +85,100 @@ static int ipoib_set_coalesce(struct net_device *dev,
 	    coal->rx_max_coalesced_frames > 0xffff)
 		return -EINVAL;
 
-	ret = ib_modify_cq(priv->recv_cq, coal->rx_max_coalesced_frames,
-			   coal->rx_coalesce_usecs);
-	if (ret && ret != -ENOSYS) {
-		ipoib_warn(priv, "failed modifying CQ (%d)\n", ret);
-		return ret;
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		ret = ib_modify_cq(priv->recv_ring[i].recv_cq,
+					coal->rx_max_coalesced_frames,
+					coal->rx_coalesce_usecs);
+		if (ret && ret != -ENOSYS) {
+			ipoib_warn(priv, "failed modifying CQ (%d)\n", ret);
+			return ret;
+		}
 	}
-
 	priv->ethtool.coalesce_usecs       = coal->rx_coalesce_usecs;
 	priv->ethtool.max_coalesced_frames = coal->rx_max_coalesced_frames;
 
 	return 0;
 }
 
+static void ipoib_get_strings(struct net_device *dev, u32 stringset, u8 *data)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	int i, index = 0;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < priv->num_rx_queues; i++) {
+			sprintf(data + (index++) * ETH_GSTRING_LEN,
+				"rx%d_packets", i);
+			sprintf(data + (index++) * ETH_GSTRING_LEN,
+				"rx%d_bytes", i);
+			sprintf(data + (index++) * ETH_GSTRING_LEN,
+				"rx%d_errors", i);
+			sprintf(data + (index++) * ETH_GSTRING_LEN,
+				"rx%d_dropped", i);
+		}
+		for (i = 0; i < priv->num_tx_queues; i++) {
+			sprintf(data + (index++) * ETH_GSTRING_LEN,
+				"tx%d_packets", i);
+			sprintf(data + (index++) * ETH_GSTRING_LEN,
+				"tx%d_bytes", i);
+			sprintf(data + (index++) * ETH_GSTRING_LEN,
+				"tx%d_errors", i);
+			sprintf(data + (index++) * ETH_GSTRING_LEN,
+				"tx%d_dropped", i);
+		}
+		break;
+	}
+}
+
+static int ipoib_get_sset_count(struct net_device *dev, int sset)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	switch (sset) {
+	case ETH_SS_STATS:
+		return (priv->num_rx_queues + priv->num_tx_queues) * 4;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void ipoib_get_ethtool_stats(struct net_device *dev,
+				struct ethtool_stats *stats, uint64_t *data)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_recv_ring *recv_ring;
+	struct ipoib_send_ring *send_ring;
+	int index = 0;
+	int i;
+
+	/* Get per QP stats */
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		struct ipoib_rx_ring_stats *rx_stats = &recv_ring->stats;
+		data[index++] = rx_stats->rx_packets;
+		data[index++] = rx_stats->rx_bytes;
+		data[index++] = rx_stats->rx_errors;
+		data[index++] = rx_stats->rx_dropped;
+		recv_ring++;
+	}
+	send_ring = priv->send_ring;
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		struct ipoib_tx_ring_stats *tx_stats = &send_ring->stats;
+		data[index++] = tx_stats->tx_packets;
+		data[index++] = tx_stats->tx_bytes;
+		data[index++] = tx_stats->tx_errors;
+		data[index++] = tx_stats->tx_dropped;
+		send_ring++;
+	}
+}
+
 static const struct ethtool_ops ipoib_ethtool_ops = {
 	.get_drvinfo		= ipoib_get_drvinfo,
 	.get_coalesce		= ipoib_get_coalesce,
 	.set_coalesce		= ipoib_set_coalesce,
+	.get_strings		= ipoib_get_strings,
+	.get_sset_count		= ipoib_get_sset_count,
+	.get_ethtool_stats	= ipoib_get_ethtool_stats,
 };
 
 void ipoib_set_ethtool_ops(struct net_device *dev)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 2cfa76f..4871dc9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -64,7 +64,6 @@ struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	ah->dev       = dev;
-	ah->last_send = 0;
 	kref_init(&ah->ref);
 
 	vah = ib_create_ah(pd, attr);
@@ -72,6 +71,7 @@ struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
 		kfree(ah);
 		ah = (struct ipoib_ah *)vah;
 	} else {
+		atomic_set(&ah->refcnt, 0);
 		ah->ah = vah;
 		ipoib_dbg(netdev_priv(dev), "Created ah %p\n", ah->ah);
 	}
@@ -129,29 +129,32 @@ static void ipoib_ud_skb_put_frags(struct ipoib_dev_priv *priv,
 
 }
 
-static int ipoib_ib_post_receive(struct net_device *dev, int id)
+static int ipoib_ib_post_receive(struct net_device *dev,
+			struct ipoib_recv_ring *recv_ring, int id)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_recv_wr *bad_wr;
 	int ret;
 
-	priv->rx_wr.wr_id   = id | IPOIB_OP_RECV;
-	priv->rx_sge[0].addr = priv->rx_ring[id].mapping[0];
-	priv->rx_sge[1].addr = priv->rx_ring[id].mapping[1];
+	recv_ring->rx_wr.wr_id   = id | IPOIB_OP_RECV;
+	recv_ring->rx_sge[0].addr = recv_ring->rx_ring[id].mapping[0];
+	recv_ring->rx_sge[1].addr = recv_ring->rx_ring[id].mapping[1];
 
 
-	ret = ib_post_recv(priv->qp, &priv->rx_wr, &bad_wr);
+	ret = ib_post_recv(recv_ring->recv_qp, &recv_ring->rx_wr, &bad_wr);
 	if (unlikely(ret)) {
 		ipoib_warn(priv, "receive failed for buf %d (%d)\n", id, ret);
-		ipoib_ud_dma_unmap_rx(priv, priv->rx_ring[id].mapping);
-		dev_kfree_skb_any(priv->rx_ring[id].skb);
-		priv->rx_ring[id].skb = NULL;
+		ipoib_ud_dma_unmap_rx(priv, recv_ring->rx_ring[id].mapping);
+		dev_kfree_skb_any(recv_ring->rx_ring[id].skb);
+		recv_ring->rx_ring[id].skb = NULL;
 	}
 
 	return ret;
 }
 
-static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
+static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev,
+					  struct ipoib_recv_ring *recv_ring,
+					  int id)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct sk_buff *skb;
@@ -178,7 +181,7 @@ static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
 	 */
 	skb_reserve(skb, 4);
 
-	mapping = priv->rx_ring[id].mapping;
+	mapping = recv_ring->rx_ring[id].mapping;
 	mapping[0] = ib_dma_map_single(priv->ca, skb->data, buf_size,
 				       DMA_FROM_DEVICE);
 	if (unlikely(ib_dma_mapping_error(priv->ca, mapping[0])))
@@ -196,7 +199,7 @@ static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
 			goto partial_error;
 	}
 
-	priv->rx_ring[id].skb = skb;
+	recv_ring->rx_ring[id].skb = skb;
 	return skb;
 
 partial_error:
@@ -206,18 +209,23 @@ error:
 	return NULL;
 }
 
-static int ipoib_ib_post_receives(struct net_device *dev)
+static int ipoib_ib_post_ring_receives(struct net_device *dev,
+				      struct ipoib_recv_ring *recv_ring)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	int i;
 
 	for (i = 0; i < ipoib_recvq_size; ++i) {
-		if (!ipoib_alloc_rx_skb(dev, i)) {
-			ipoib_warn(priv, "failed to allocate receive buffer %d\n", i);
+		if (!ipoib_alloc_rx_skb(dev, recv_ring, i)) {
+			ipoib_warn(priv,
+				   "failed to alloc receive buffer (%d,%d)\n",
+				   recv_ring->index, i);
 			return -ENOMEM;
 		}
-		if (ipoib_ib_post_receive(dev, i)) {
-			ipoib_warn(priv, "ipoib_ib_post_receive failed for buf %d\n", i);
+		if (ipoib_ib_post_receive(dev, recv_ring, i)) {
+			ipoib_warn(priv,
+				   "ipoib_ib_post_receive failed buf (%d,%d)\n",
+				   recv_ring->index, i);
 			return -EIO;
 		}
 	}
@@ -225,7 +233,27 @@ static int ipoib_ib_post_receives(struct net_device *dev)
 	return 0;
 }
 
-static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
+static int ipoib_ib_post_receives(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_recv_ring *recv_ring;
+	int err;
+	int i;
+
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->num_rx_queues; ++i) {
+		err = ipoib_ib_post_ring_receives(dev, recv_ring);
+		if (err)
+			return err;
+		recv_ring++;
+	}
+
+	return 0;
+}
+
+static void ipoib_ib_handle_rx_wc(struct net_device *dev,
+				  struct ipoib_recv_ring *recv_ring,
+				  struct ib_wc *wc)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	unsigned int wr_id = wc->wr_id & ~IPOIB_OP_RECV;
@@ -242,16 +270,16 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		return;
 	}
 
-	skb  = priv->rx_ring[wr_id].skb;
+	skb  = recv_ring->rx_ring[wr_id].skb;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
 			ipoib_warn(priv, "failed recv event "
 				   "(status=%d, wrid=%d vend_err %x)\n",
 				   wc->status, wr_id, wc->vendor_err);
-		ipoib_ud_dma_unmap_rx(priv, priv->rx_ring[wr_id].mapping);
+		ipoib_ud_dma_unmap_rx(priv, recv_ring->rx_ring[wr_id].mapping);
 		dev_kfree_skb_any(skb);
-		priv->rx_ring[wr_id].skb = NULL;
+		recv_ring->rx_ring[wr_id].skb = NULL;
 		return;
 	}
 
@@ -262,18 +290,20 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	if (wc->slid == priv->local_lid && wc->src_qp == priv->qp->qp_num)
 		goto repost;
 
-	memcpy(mapping, priv->rx_ring[wr_id].mapping,
+	memcpy(mapping, recv_ring->rx_ring[wr_id].mapping,
 	       IPOIB_UD_RX_SG * sizeof *mapping);
 
 	/*
 	 * If we can't allocate a new RX buffer, dump
 	 * this packet and reuse the old buffer.
 	 */
-	if (unlikely(!ipoib_alloc_rx_skb(dev, wr_id))) {
-		++dev->stats.rx_dropped;
+	if (unlikely(!ipoib_alloc_rx_skb(dev, recv_ring, wr_id))) {
+		++recv_ring->stats.rx_dropped;
 		goto repost;
 	}
 
+	skb_record_rx_queue(skb, recv_ring->index);
+
 	ipoib_dbg_data(priv, "received %d bytes, SLID 0x%04x\n",
 		       wc->byte_len, wc->slid);
 
@@ -296,18 +326,18 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	skb_reset_mac_header(skb);
 	skb_pull(skb, IPOIB_ENCAP_LEN);
 
-	++dev->stats.rx_packets;
-	dev->stats.rx_bytes += skb->len;
+	++recv_ring->stats.rx_packets;
+	recv_ring->stats.rx_bytes += skb->len;
 
 	skb->dev = dev;
 	if ((dev->features & NETIF_F_RXCSUM) &&
 			likely(wc->wc_flags & IB_WC_IP_CSUM_OK))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
-	napi_gro_receive(&priv->napi, skb);
+	napi_gro_receive(&recv_ring->napi, skb);
 
 repost:
-	if (unlikely(ipoib_ib_post_receive(dev, wr_id)))
+	if (unlikely(ipoib_ib_post_receive(dev, recv_ring, wr_id)))
 		ipoib_warn(priv, "ipoib_ib_post_receive failed "
 			   "for buf %d\n", wr_id);
 }
@@ -376,11 +406,14 @@ static void ipoib_dma_unmap_tx(struct ib_device *ca,
 	}
 }
 
-static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
+static void ipoib_ib_handle_tx_wc(struct ipoib_send_ring *send_ring,
+				struct ib_wc *wc)
 {
+	struct net_device *dev = send_ring->dev;
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	unsigned int wr_id = wc->wr_id;
 	struct ipoib_tx_buf *tx_req;
+	struct ipoib_ah *ah;
 
 	ipoib_dbg_data(priv, "send completion: id %d, status: %d\n",
 		       wr_id, wc->status);
@@ -391,20 +424,23 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 		return;
 	}
 
-	tx_req = &priv->tx_ring[wr_id];
+	tx_req = &send_ring->tx_ring[wr_id];
+
+	ah = tx_req->ah;
+	atomic_dec(&ah->refcnt);
 
 	ipoib_dma_unmap_tx(priv->ca, tx_req);
 
-	++dev->stats.tx_packets;
-	dev->stats.tx_bytes += tx_req->skb->len;
+	++send_ring->stats.tx_packets;
+	send_ring->stats.tx_bytes += tx_req->skb->len;
 
 	dev_kfree_skb_any(tx_req->skb);
 
-	++priv->tx_tail;
-	if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
-	    netif_queue_stopped(dev) &&
+	++send_ring->tx_tail;
+	if (unlikely(--send_ring->tx_outstanding == ipoib_sendq_size >> 1) &&
+	    __netif_subqueue_stopped(dev, send_ring->index) &&
 	    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
-		netif_wake_queue(dev);
+		netif_wake_subqueue(dev, send_ring->index);
 
 	if (wc->status != IB_WC_SUCCESS &&
 	    wc->status != IB_WC_WR_FLUSH_ERR)
@@ -413,45 +449,47 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 			   wc->status, wr_id, wc->vendor_err);
 }
 
-static int poll_tx(struct ipoib_dev_priv *priv)
+static int poll_tx_ring(struct ipoib_send_ring *send_ring)
 {
 	int n, i;
 
-	n = ib_poll_cq(priv->send_cq, MAX_SEND_CQE, priv->send_wc);
+	n = ib_poll_cq(send_ring->send_cq, MAX_SEND_CQE, send_ring->tx_wc);
 	for (i = 0; i < n; ++i)
-		ipoib_ib_handle_tx_wc(priv->dev, priv->send_wc + i);
+		ipoib_ib_handle_tx_wc(send_ring, send_ring->tx_wc + i);
 
 	return n == MAX_SEND_CQE;
 }
 
 int ipoib_poll(struct napi_struct *napi, int budget)
 {
-	struct ipoib_dev_priv *priv = container_of(napi, struct ipoib_dev_priv, napi);
-	struct net_device *dev = priv->dev;
+	struct ipoib_recv_ring *rx_ring;
+	struct net_device *dev;
 	int done;
 	int t;
 	int n, i;
 
 	done  = 0;
+	rx_ring = container_of(napi, struct ipoib_recv_ring, napi);
+	dev = rx_ring->dev;
 
 poll_more:
 	while (done < budget) {
 		int max = (budget - done);
 
 		t = min(IPOIB_NUM_WC, max);
-		n = ib_poll_cq(priv->recv_cq, t, priv->ibwc);
+		n = ib_poll_cq(rx_ring->recv_cq, t, rx_ring->ibwc);
 
 		for (i = 0; i < n; i++) {
-			struct ib_wc *wc = priv->ibwc + i;
+			struct ib_wc *wc = rx_ring->ibwc + i;
 
 			if (wc->wr_id & IPOIB_OP_RECV) {
 				++done;
 				if (wc->wr_id & IPOIB_OP_CM)
-					ipoib_cm_handle_rx_wc(dev, wc);
+					ipoib_cm_handle_rx_wc(dev, rx_ring, wc);
 				else
-					ipoib_ib_handle_rx_wc(dev, wc);
+					ipoib_ib_handle_rx_wc(dev, rx_ring, wc);
 			} else
-				ipoib_cm_handle_tx_wc(priv->dev, wc);
+				ipoib_cm_handle_tx_wc(dev, wc);
 		}
 
 		if (n != t)
@@ -460,7 +498,7 @@ poll_more:
 
 	if (done < budget) {
 		napi_complete(napi);
-		if (unlikely(ib_req_notify_cq(priv->recv_cq,
+		if (unlikely(ib_req_notify_cq(rx_ring->recv_cq,
 					      IB_CQ_NEXT_COMP |
 					      IB_CQ_REPORT_MISSED_EVENTS)) &&
 		    napi_reschedule(napi))
@@ -470,36 +508,34 @@ poll_more:
 	return done;
 }
 
-void ipoib_ib_completion(struct ib_cq *cq, void *dev_ptr)
+void ipoib_ib_completion(struct ib_cq *cq, void *ctx_ptr)
 {
-	struct net_device *dev = dev_ptr;
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_recv_ring *recv_ring = (struct ipoib_recv_ring *)ctx_ptr;
 
-	napi_schedule(&priv->napi);
+	napi_schedule(&recv_ring->napi);
 }
 
-static void drain_tx_cq(struct net_device *dev)
+static void drain_tx_cq(struct ipoib_send_ring *send_ring)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	netif_tx_lock_bh(send_ring->dev);
 
-	netif_tx_lock(dev);
-	while (poll_tx(priv))
+	while (poll_tx_ring(send_ring))
 		; /* nothing */
 
-	if (netif_queue_stopped(dev))
-		mod_timer(&priv->poll_timer, jiffies + 1);
+	if (__netif_subqueue_stopped(send_ring->dev, send_ring->index))
+		mod_timer(&send_ring->poll_timer, jiffies + 1);
 
-	netif_tx_unlock(dev);
+	netif_tx_unlock_bh(send_ring->dev);
 }
 
-void ipoib_send_comp_handler(struct ib_cq *cq, void *dev_ptr)
+void ipoib_send_comp_handler(struct ib_cq *cq, void *ctx_ptr)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev_ptr);
+	struct ipoib_send_ring *send_ring = (struct ipoib_send_ring *)ctx_ptr;
 
-	mod_timer(&priv->poll_timer, jiffies);
+	mod_timer(&send_ring->poll_timer, jiffies);
 }
 
-static inline int post_send(struct ipoib_dev_priv *priv,
+static inline int post_send(struct ipoib_send_ring *send_ring,
 			    unsigned int wr_id,
 			    struct ib_ah *address, u32 qpn,
 			    struct ipoib_tx_buf *tx_req,
@@ -513,30 +549,30 @@ static inline int post_send(struct ipoib_dev_priv *priv,
 	u64 *mapping = tx_req->mapping;
 
 	if (skb_headlen(skb)) {
-		priv->tx_sge[0].addr         = mapping[0];
-		priv->tx_sge[0].length       = skb_headlen(skb);
+		send_ring->tx_sge[0].addr         = mapping[0];
+		send_ring->tx_sge[0].length       = skb_headlen(skb);
 		off = 1;
 	} else
 		off = 0;
 
 	for (i = 0; i < nr_frags; ++i) {
-		priv->tx_sge[i + off].addr = mapping[i + off];
-		priv->tx_sge[i + off].length = skb_frag_size(&frags[i]);
+		send_ring->tx_sge[i + off].addr = mapping[i + off];
+		send_ring->tx_sge[i + off].length = skb_frag_size(&frags[i]);
 	}
-	priv->tx_wr.num_sge	     = nr_frags + off;
-	priv->tx_wr.wr_id 	     = wr_id;
-	priv->tx_wr.wr.ud.remote_qpn = qpn;
-	priv->tx_wr.wr.ud.ah 	     = address;
+	send_ring->tx_wr.num_sge	 = nr_frags + off;
+	send_ring->tx_wr.wr_id		 = wr_id;
+	send_ring->tx_wr.wr.ud.remote_qpn = qpn;
+	send_ring->tx_wr.wr.ud.ah	 = address;
 
 	if (head) {
-		priv->tx_wr.wr.ud.mss	 = skb_shinfo(skb)->gso_size;
-		priv->tx_wr.wr.ud.header = head;
-		priv->tx_wr.wr.ud.hlen	 = hlen;
-		priv->tx_wr.opcode	 = IB_WR_LSO;
+		send_ring->tx_wr.wr.ud.mss	 = skb_shinfo(skb)->gso_size;
+		send_ring->tx_wr.wr.ud.header = head;
+		send_ring->tx_wr.wr.ud.hlen	 = hlen;
+		send_ring->tx_wr.opcode	 = IB_WR_LSO;
 	} else
-		priv->tx_wr.opcode	 = IB_WR_SEND;
+		send_ring->tx_wr.opcode	 = IB_WR_SEND;
 
-	return ib_post_send(priv->qp, &priv->tx_wr, &bad_wr);
+	return ib_post_send(send_ring->send_qp, &send_ring->tx_wr, &bad_wr);
 }
 
 void ipoib_send(struct net_device *dev, struct sk_buff *skb,
@@ -544,16 +580,23 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_tx_buf *tx_req;
+	struct ipoib_send_ring *send_ring;
+	u16 queue_index;
 	int hlen, rc;
 	void *phead;
+	int req_index;
+
+	/* Find the correct QP to submit the IO to */
+	queue_index = skb_get_queue_mapping(skb);
+	send_ring = priv->send_ring + queue_index;
 
 	if (skb_is_gso(skb)) {
 		hlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
 		phead = skb->data;
 		if (unlikely(!skb_pull(skb, hlen))) {
 			ipoib_warn(priv, "linear data too small\n");
-			++dev->stats.tx_dropped;
-			++dev->stats.tx_errors;
+			++send_ring->stats.tx_dropped;
+			++send_ring->stats.tx_errors;
 			dev_kfree_skb_any(skb);
 			return;
 		}
@@ -561,8 +604,8 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 		if (unlikely(skb->len > priv->mcast_mtu + IPOIB_ENCAP_LEN)) {
 			ipoib_warn(priv, "packet len %d (> %d) too long to send, dropping\n",
 				   skb->len, priv->mcast_mtu + IPOIB_ENCAP_LEN);
-			++dev->stats.tx_dropped;
-			++dev->stats.tx_errors;
+			++send_ring->stats.tx_dropped;
+			++send_ring->stats.tx_errors;
 			ipoib_cm_skb_too_long(dev, skb, priv->mcast_mtu);
 			return;
 		}
@@ -580,48 +623,56 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	 * means we have to make sure everything is properly recorded and
 	 * our state is consistent before we call post_send().
 	 */
-	tx_req = &priv->tx_ring[priv->tx_head & (ipoib_sendq_size - 1)];
+	req_index = send_ring->tx_head & (ipoib_sendq_size - 1);
+	tx_req = &send_ring->tx_ring[req_index];
 	tx_req->skb = skb;
+	tx_req->ah = address;
 	if (unlikely(ipoib_dma_map_tx(priv->ca, tx_req))) {
-		++dev->stats.tx_errors;
+		++send_ring->stats.tx_errors;
 		dev_kfree_skb_any(skb);
 		return;
 	}
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		priv->tx_wr.send_flags |= IB_SEND_IP_CSUM;
+		send_ring->tx_wr.send_flags |= IB_SEND_IP_CSUM;
 	else
-		priv->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
+		send_ring->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
 
-	if (++priv->tx_outstanding == ipoib_sendq_size) {
+	if (++send_ring->tx_outstanding == ipoib_sendq_size) {
 		ipoib_dbg(priv, "TX ring full, stopping kernel net queue\n");
-		if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP))
+		if (ib_req_notify_cq(send_ring->send_cq, IB_CQ_NEXT_COMP))
 			ipoib_warn(priv, "request notify on send CQ failed\n");
-		netif_stop_queue(dev);
+		netif_stop_subqueue(dev, queue_index);
 	}
 
 	skb_orphan(skb);
 	skb_dst_drop(skb);
 
-	rc = post_send(priv, priv->tx_head & (ipoib_sendq_size - 1),
+	/*
+	 * Incrementing the reference count after submitting
+	 * may create race condition
+	 * It is better to increment before and decrement in case of error
+	 */
+	atomic_inc(&address->refcnt);
+	rc = post_send(send_ring, req_index,
 		       address->ah, qpn, tx_req, phead, hlen);
 	if (unlikely(rc)) {
 		ipoib_warn(priv, "post_send failed, error %d\n", rc);
-		++dev->stats.tx_errors;
-		--priv->tx_outstanding;
+		++send_ring->stats.tx_errors;
+		--send_ring->tx_outstanding;
 		ipoib_dma_unmap_tx(priv->ca, tx_req);
 		dev_kfree_skb_any(skb);
-		if (netif_queue_stopped(dev))
-			netif_wake_queue(dev);
+		atomic_dec(&address->refcnt);
+		if (__netif_subqueue_stopped(dev, queue_index))
+			netif_wake_subqueue(dev, queue_index);
 	} else {
-		dev->trans_start = jiffies;
+		netdev_get_tx_queue(dev, queue_index)->trans_start = jiffies;
 
-		address->last_send = priv->tx_head;
-		++priv->tx_head;
+		++send_ring->tx_head;
 	}
 
-	if (unlikely(priv->tx_outstanding > MAX_SEND_CQE))
-		while (poll_tx(priv))
+	if (unlikely(send_ring->tx_outstanding > MAX_SEND_CQE))
+		while (poll_tx_ring(send_ring))
 			; /* nothing */
 }
 
@@ -636,7 +687,7 @@ static void __ipoib_reap_ah(struct net_device *dev)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	list_for_each_entry_safe(ah, tah, &priv->dead_ahs, list)
-		if ((int) priv->tx_tail - (int) ah->last_send >= 0) {
+		if (atomic_read(&ah->refcnt) == 0) {
 			list_del(&ah->list);
 			ib_destroy_ah(ah->ah);
 			kfree(ah);
@@ -661,7 +712,31 @@ void ipoib_reap_ah(struct work_struct *work)
 
 static void ipoib_ib_tx_timer_func(unsigned long ctx)
 {
-	drain_tx_cq((struct net_device *)ctx);
+	drain_tx_cq((struct ipoib_send_ring *)ctx);
+}
+
+static void ipoib_napi_enable(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_recv_ring *recv_ring;
+	int i;
+
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		netif_napi_add(dev, &recv_ring->napi,
+			       ipoib_poll, 100);
+		napi_enable(&recv_ring->napi);
+		recv_ring++;
+	}
+}
+
+static void ipoib_napi_disable(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	int i;
+
+	for (i = 0; i < priv->num_rx_queues; i++)
+		napi_disable(&priv->recv_ring[i].napi);
 }
 
 int ipoib_ib_dev_open(struct net_device *dev)
@@ -701,7 +776,7 @@ int ipoib_ib_dev_open(struct net_device *dev)
 			   round_jiffies_relative(HZ));
 
 	if (!test_and_set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
-		napi_enable(&priv->napi);
+		ipoib_napi_enable(dev);
 
 	return 0;
 }
@@ -763,19 +838,47 @@ int ipoib_ib_dev_down(struct net_device *dev, int flush)
 static int recvs_pending(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_recv_ring *recv_ring;
 	int pending = 0;
-	int i;
+	int i, j;
 
-	for (i = 0; i < ipoib_recvq_size; ++i)
-		if (priv->rx_ring[i].skb)
-			++pending;
+	recv_ring = priv->recv_ring;
+	for (j = 0; j < priv->num_rx_queues; j++) {
+		for (i = 0; i < ipoib_recvq_size; ++i) {
+			if (recv_ring->rx_ring[i].skb)
+				++pending;
+		}
+		recv_ring++;
+	}
 
 	return pending;
 }
 
-void ipoib_drain_cq(struct net_device *dev)
+static int sends_pending(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_send_ring *send_ring;
+	int pending = 0;
+	int i;
+
+	send_ring = priv->send_ring;
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		/*
+		* Note that since head and tails are unsigned then
+		* the result of the substruction is correct even when
+		* the counters wrap around
+		*/
+		pending += send_ring->tx_head - send_ring->tx_tail;
+		send_ring++;
+	}
+
+	return pending;
+}
+
+static void ipoib_drain_rx_ring(struct ipoib_dev_priv *priv,
+				struct ipoib_recv_ring *rx_ring)
+{
+	struct net_device *dev = priv->dev;
 	int i, n;
 
 	/*
@@ -786,42 +889,191 @@ void ipoib_drain_cq(struct net_device *dev)
 	local_bh_disable();
 
 	do {
-		n = ib_poll_cq(priv->recv_cq, IPOIB_NUM_WC, priv->ibwc);
+		n = ib_poll_cq(rx_ring->recv_cq, IPOIB_NUM_WC, rx_ring->ibwc);
 		for (i = 0; i < n; ++i) {
+			struct ib_wc *wc = rx_ring->ibwc + i;
 			/*
 			 * Convert any successful completions to flush
 			 * errors to avoid passing packets up the
 			 * stack after bringing the device down.
 			 */
-			if (priv->ibwc[i].status == IB_WC_SUCCESS)
-				priv->ibwc[i].status = IB_WC_WR_FLUSH_ERR;
+			if (wc->status == IB_WC_SUCCESS)
+				wc->status = IB_WC_WR_FLUSH_ERR;
 
-			if (priv->ibwc[i].wr_id & IPOIB_OP_RECV) {
-				if (priv->ibwc[i].wr_id & IPOIB_OP_CM)
-					ipoib_cm_handle_rx_wc(dev, priv->ibwc + i);
+			if (wc->wr_id & IPOIB_OP_RECV) {
+				if (wc->wr_id & IPOIB_OP_CM)
+					ipoib_cm_handle_rx_wc(dev, rx_ring, wc);
 				else
-					ipoib_ib_handle_rx_wc(dev, priv->ibwc + i);
-			} else
-				ipoib_cm_handle_tx_wc(dev, priv->ibwc + i);
+					ipoib_ib_handle_rx_wc(dev, rx_ring, wc);
+			} else {
+				ipoib_cm_handle_tx_wc(dev, wc);
+			}
 		}
 	} while (n == IPOIB_NUM_WC);
 
-	while (poll_tx(priv))
-		; /* nothing */
-
 	local_bh_enable();
 }
 
-int ipoib_ib_dev_stop(struct net_device *dev, int flush)
+static void drain_rx_rings(struct ipoib_dev_priv *priv)
+{
+	struct ipoib_recv_ring *recv_ring;
+	int i;
+
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		ipoib_drain_rx_ring(priv, recv_ring);
+		recv_ring++;
+	}
+}
+
+
+static void drain_tx_rings(struct ipoib_dev_priv *priv)
+{
+	struct ipoib_send_ring *send_ring;
+	int bool_value = 0;
+	int i;
+
+	do {
+		bool_value = 0;
+		send_ring = priv->send_ring;
+		for (i = 0; i < priv->num_tx_queues; i++) {
+			local_bh_disable();
+			bool_value |= poll_tx_ring(send_ring);
+			local_bh_enable();
+			send_ring++;
+		}
+	} while (bool_value);
+}
+
+void ipoib_drain_cq(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	drain_rx_rings(priv);
+
+	drain_tx_rings(priv);
+}
+
+static void ipoib_ib_send_ring_stop(struct ipoib_dev_priv *priv)
+{
+	struct ipoib_send_ring *tx_ring;
+	struct ipoib_tx_buf *tx_req;
+	int i;
+
+	tx_ring = priv->send_ring;
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		while ((int) tx_ring->tx_tail - (int) tx_ring->tx_head < 0) {
+			tx_req = &tx_ring->tx_ring[tx_ring->tx_tail &
+				  (ipoib_sendq_size - 1)];
+			ipoib_dma_unmap_tx(priv->ca, tx_req);
+			dev_kfree_skb_any(tx_req->skb);
+			++tx_ring->tx_tail;
+			--tx_ring->tx_outstanding;
+		}
+		tx_ring++;
+	}
+}
+
+static void ipoib_ib_recv_ring_stop(struct ipoib_dev_priv *priv)
+{
+	struct ipoib_recv_ring *recv_ring;
+	int i, j;
+
+	recv_ring = priv->recv_ring;
+	for (j = 0; j < priv->num_rx_queues; ++j) {
+		for (i = 0; i < ipoib_recvq_size; ++i) {
+			struct ipoib_rx_buf *rx_req;
+
+			rx_req = &recv_ring->rx_ring[i];
+			if (!rx_req->skb)
+				continue;
+			ipoib_ud_dma_unmap_rx(priv,
+					      recv_ring->rx_ring[i].mapping);
+			dev_kfree_skb_any(rx_req->skb);
+			rx_req->skb = NULL;
+		}
+		recv_ring++;
+	}
+}
+
+static void set_tx_poll_timers(struct ipoib_dev_priv *priv)
+{
+	struct ipoib_send_ring *send_ring;
+	int i;
+	/* Init a timer per queue */
+	send_ring = priv->send_ring;
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		setup_timer(&send_ring->poll_timer, ipoib_ib_tx_timer_func,
+			    (unsigned long)send_ring);
+		send_ring++;
+	}
+}
+
+static void del_tx_poll_timers(struct ipoib_dev_priv *priv)
+{
+	struct ipoib_send_ring *send_ring;
+	int i;
+
+	send_ring = priv->send_ring;
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		del_timer_sync(&send_ring->poll_timer);
+		send_ring++;
+	}
+}
+
+static void set_tx_rings_qp_state(struct ipoib_dev_priv *priv,
+					enum ib_qp_state new_state)
+{
+	struct ipoib_send_ring *send_ring;
+	struct ib_qp_attr qp_attr;
+	int i;
+
+	send_ring = priv->send_ring;
+	for (i = 0; i <  priv->num_tx_queues; i++) {
+		qp_attr.qp_state = new_state;
+		if (ib_modify_qp(send_ring->send_qp, &qp_attr, IB_QP_STATE))
+			ipoib_warn(priv, "Failed to modify QP to state(%d)\n",
+				   new_state);
+		send_ring++;
+	}
+}
+
+static void set_rx_rings_qp_state(struct ipoib_dev_priv *priv,
+					enum ib_qp_state new_state)
+{
+	struct ipoib_recv_ring *recv_ring;
 	struct ib_qp_attr qp_attr;
+	int i;
+
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		qp_attr.qp_state = new_state;
+		if (ib_modify_qp(recv_ring->recv_qp, &qp_attr, IB_QP_STATE))
+			ipoib_warn(priv, "Failed to modify QP to state(%d)\n",
+				   new_state);
+		recv_ring++;
+	}
+}
+
+static void set_rings_qp_state(struct ipoib_dev_priv *priv,
+				enum ib_qp_state new_state)
+{
+	set_tx_rings_qp_state(priv, new_state);
+
+	if (priv->num_rx_queues > 1)
+		set_rx_rings_qp_state(priv, new_state);
+}
+
+
+int ipoib_ib_dev_stop(struct net_device *dev, int flush)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	unsigned long begin;
-	struct ipoib_tx_buf *tx_req;
+	struct ipoib_recv_ring *recv_ring;
 	int i;
 
 	if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
-		napi_disable(&priv->napi);
+		ipoib_napi_disable(dev);
 
 	ipoib_cm_dev_stop(dev);
 
@@ -829,42 +1081,24 @@ int ipoib_ib_dev_stop(struct net_device *dev, int flush)
 	 * Move our QP to the error state and then reinitialize in
 	 * when all work requests have completed or have been flushed.
 	 */
-	qp_attr.qp_state = IB_QPS_ERR;
-	if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
-		ipoib_warn(priv, "Failed to modify QP to ERROR state\n");
+	set_rings_qp_state(priv, IB_QPS_ERR);
+
 
 	/* Wait for all sends and receives to complete */
 	begin = jiffies;
 
-	while (priv->tx_head != priv->tx_tail || recvs_pending(dev)) {
+	while (sends_pending(dev) || recvs_pending(dev)) {
 		if (time_after(jiffies, begin + 5 * HZ)) {
 			ipoib_warn(priv, "timing out; %d sends %d receives not completed\n",
-				   priv->tx_head - priv->tx_tail, recvs_pending(dev));
+				   sends_pending(dev), recvs_pending(dev));
 
 			/*
 			 * assume the HW is wedged and just free up
 			 * all our pending work requests.
 			 */
-			while ((int) priv->tx_tail - (int) priv->tx_head < 0) {
-				tx_req = &priv->tx_ring[priv->tx_tail &
-							(ipoib_sendq_size - 1)];
-				ipoib_dma_unmap_tx(priv->ca, tx_req);
-				dev_kfree_skb_any(tx_req->skb);
-				++priv->tx_tail;
-				--priv->tx_outstanding;
-			}
+			ipoib_ib_send_ring_stop(priv);
 
-			for (i = 0; i < ipoib_recvq_size; ++i) {
-				struct ipoib_rx_buf *rx_req;
-
-				rx_req = &priv->rx_ring[i];
-				if (!rx_req->skb)
-					continue;
-				ipoib_ud_dma_unmap_rx(priv,
-						      priv->rx_ring[i].mapping);
-				dev_kfree_skb_any(rx_req->skb);
-				rx_req->skb = NULL;
-			}
+			ipoib_ib_recv_ring_stop(priv);
 
 			goto timeout;
 		}
@@ -877,10 +1111,9 @@ int ipoib_ib_dev_stop(struct net_device *dev, int flush)
 	ipoib_dbg(priv, "All sends and receives done.\n");
 
 timeout:
-	del_timer_sync(&priv->poll_timer);
-	qp_attr.qp_state = IB_QPS_RESET;
-	if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
-		ipoib_warn(priv, "Failed to modify QP to RESET state\n");
+	del_tx_poll_timers(priv);
+
+	set_rings_qp_state(priv, IB_QPS_RESET);
 
 	/* Wait for all AHs to be reaped */
 	set_bit(IPOIB_STOP_REAPER, &priv->flags);
@@ -901,7 +1134,11 @@ timeout:
 		msleep(1);
 	}
 
-	ib_req_notify_cq(priv->recv_cq, IB_CQ_NEXT_COMP);
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->num_rx_queues; ++i) {
+		ib_req_notify_cq(recv_ring->recv_cq, IB_CQ_NEXT_COMP);
+		recv_ring++;
+	}
 
 	return 0;
 }
@@ -919,8 +1156,7 @@ int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 		return -ENODEV;
 	}
 
-	setup_timer(&priv->poll_timer, ipoib_ib_tx_timer_func,
-		    (unsigned long) dev);
+	set_tx_poll_timers(priv);
 
 	if (dev->flags & IFF_UP) {
 		if (ipoib_ib_dev_open(dev)) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 8534afd..51bebca 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -132,7 +132,7 @@ int ipoib_open(struct net_device *dev)
 		mutex_unlock(&priv->vlan_mutex);
 	}
 
-	netif_start_queue(dev);
+	netif_tx_start_all_queues(dev);
 
 	return 0;
 
@@ -153,7 +153,7 @@ static int ipoib_stop(struct net_device *dev)
 
 	clear_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
 
-	netif_stop_queue(dev);
+	netif_tx_stop_all_queues(dev);
 
 	ipoib_ib_dev_down(dev, 1);
 	ipoib_ib_dev_stop(dev, 0);
@@ -223,6 +223,8 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 int ipoib_set_mode(struct net_device *dev, const char *buf)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_send_ring *send_ring;
+	int i;
 
 	/* flush paths if we switch modes so that connections are restarted */
 	if (IPOIB_CM_SUPPORTED(dev->dev_addr) && !strcmp(buf, "connected\n")) {
@@ -231,7 +233,12 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
 			   "will cause multicast packet drops\n");
 		netdev_update_features(dev);
 		rtnl_unlock();
-		priv->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
+
+		send_ring = priv->send_ring;
+		for (i = 0; i < priv->num_tx_queues; i++) {
+			send_ring->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
+			send_ring++;
+		}
 
 		ipoib_flush_paths(dev);
 		rtnl_lock();
@@ -582,21 +589,35 @@ static int path_rec_start(struct net_device *dev,
 	return 0;
 }
 
-static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
-			   struct net_device *dev)
+static struct ipoib_neigh *neigh_add_path(struct sk_buff *skb, u8 *daddr,
+					  struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_path *path;
 	struct ipoib_neigh *neigh;
 	unsigned long flags;
+	int index;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	neigh = ipoib_neigh_alloc(daddr, dev);
 	if (!neigh) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		++dev->stats.tx_dropped;
+		index = skb_get_queue_mapping(skb);
+		priv->send_ring[index].stats.tx_dropped++;
 		dev_kfree_skb_any(skb);
-		return;
+		return NULL;
+	}
+
+	/* With TX MQ it is possible that more than one skb transmission
+	 * triggered the creation of the neigh. But only one actually created
+	 * the neigh struct, all the others found it in the hash. We must make
+	 * sure that the neigh will be added only once to the path list.
+	 * Note that double insertion will lead to an infinite loop in the
+	 * path_rec_completion routine.
+	 */
+	if (unlikely(!list_empty(&neigh->list))) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return neigh;
 	}
 
 	path = __path_find(dev, daddr + 4);
@@ -633,7 +654,7 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
 			spin_unlock_irqrestore(&priv->lock, flags);
 			ipoib_send(dev, skb, path->ah, IPOIB_QPN(daddr));
 			ipoib_neigh_put(neigh);
-			return;
+			return NULL;
 		}
 	} else {
 		neigh->ah  = NULL;
@@ -646,7 +667,7 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 	ipoib_neigh_put(neigh);
-	return;
+	return NULL;
 
 err_list:
 	list_del(&neigh->list);
@@ -654,11 +675,14 @@ err_list:
 err_path:
 	ipoib_neigh_free(neigh);
 err_drop:
-	++dev->stats.tx_dropped;
+	index = skb_get_queue_mapping(skb);
+	priv->send_ring[index].stats.tx_dropped++;
 	dev_kfree_skb_any(skb);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 	ipoib_neigh_put(neigh);
+
+	return NULL;
 }
 
 static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
@@ -667,6 +691,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_path *path;
 	unsigned long flags;
+	int index = skb_get_queue_mapping(skb);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -689,7 +714,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 			} else
 				__path_add(dev, path);
 		} else {
-			++dev->stats.tx_dropped;
+			priv->send_ring[index].stats.tx_dropped++;
 			dev_kfree_skb_any(skb);
 		}
 
@@ -708,7 +733,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 		   skb_queue_len(&path->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
 		__skb_queue_tail(&path->queue, skb);
 	} else {
-		++dev->stats.tx_dropped;
+		priv->send_ring[index].stats.tx_dropped++;
 		dev_kfree_skb_any(skb);
 	}
 
@@ -753,8 +778,14 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	case htons(ETH_P_IPV6):
 		neigh = ipoib_neigh_get(dev, cb->hwaddr);
 		if (unlikely(!neigh)) {
-			neigh_add_path(skb, cb->hwaddr, dev);
-			return NETDEV_TX_OK;
+			/* If more than one thread of execution tried to
+			 * create the neigh then only one succeeded, all the
+			 * others got the neigh from the hash and should
+			 * continue as usual.
+			 */
+			neigh = neigh_add_path(skb, cb->hwaddr, dev);
+			if (likely(!neigh))
+				return NETDEV_TX_OK;
 		}
 		break;
 	case htons(ETH_P_ARP):
@@ -796,18 +827,70 @@ unref:
 	return NETDEV_TX_OK;
 }
 
+static u16 ipoib_select_queue_null(struct net_device *dev, struct sk_buff *skb)
+{
+	return 0;
+}
+
 static void ipoib_timeout(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_send_ring *send_ring;
+	u16 index;
 
 	ipoib_warn(priv, "transmit timeout: latency %d msecs\n",
 		   jiffies_to_msecs(jiffies - dev->trans_start));
-	ipoib_warn(priv, "queue stopped %d, tx_head %u, tx_tail %u\n",
-		   netif_queue_stopped(dev),
-		   priv->tx_head, priv->tx_tail);
+
+	for (index = 0; index < priv->num_tx_queues; index++) {
+		if (__netif_subqueue_stopped(dev, index)) {
+			send_ring = priv->send_ring + index;
+			ipoib_warn(priv,
+				   "queue (%d) stopped, head %u, tail %u\n",
+				   index,
+				   send_ring->tx_head, send_ring->tx_tail);
+		}
+	}
 	/* XXX reset QP, etc. */
 }
 
+static struct net_device_stats *ipoib_get_stats(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct net_device_stats *stats = &dev->stats;
+	struct net_device_stats local_stats;
+	int i;
+
+	memset(&local_stats, 0, sizeof(struct net_device_stats));
+
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		struct ipoib_rx_ring_stats *rstats = &priv->recv_ring[i].stats;
+		local_stats.rx_packets += rstats->rx_packets;
+		local_stats.rx_bytes   += rstats->rx_bytes;
+		local_stats.rx_errors  += rstats->rx_errors;
+		local_stats.rx_dropped += rstats->rx_dropped;
+	}
+
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		struct ipoib_tx_ring_stats *tstats = &priv->send_ring[i].stats;
+		local_stats.tx_packets += tstats->tx_packets;
+		local_stats.tx_bytes   += tstats->tx_bytes;
+		local_stats.tx_errors  += tstats->tx_errors;
+		local_stats.tx_dropped += tstats->tx_dropped;
+	}
+
+	stats->rx_packets = local_stats.rx_packets;
+	stats->rx_bytes   = local_stats.rx_bytes;
+	stats->rx_errors  = local_stats.rx_errors;
+	stats->rx_dropped = local_stats.rx_dropped;
+
+	stats->tx_packets = local_stats.tx_packets;
+	stats->tx_bytes   = local_stats.tx_bytes;
+	stats->tx_errors  = local_stats.tx_errors;
+	stats->tx_dropped = local_stats.tx_dropped;
+
+	return stats;
+}
+
 static int ipoib_hard_header(struct sk_buff *skb,
 			     struct net_device *dev,
 			     unsigned short type,
@@ -1260,47 +1343,93 @@ static void ipoib_neigh_hash_uninit(struct net_device *dev)
 int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_send_ring *send_ring;
+	struct ipoib_recv_ring *recv_ring;
+	int i, rx_allocated, tx_allocated;
+	unsigned long alloc_size;
 
 	if (ipoib_neigh_hash_init(priv) < 0)
 		goto out;
 	/* Allocate RX/TX "rings" to hold queued skbs */
-	priv->rx_ring =	kzalloc(ipoib_recvq_size * sizeof *priv->rx_ring,
+	/* Multi queue initialization */
+	priv->recv_ring = kzalloc(priv->num_rx_queues * sizeof(*recv_ring),
 				GFP_KERNEL);
-	if (!priv->rx_ring) {
-		printk(KERN_WARNING "%s: failed to allocate RX ring (%d entries)\n",
-		       ca->name, ipoib_recvq_size);
+	if (!priv->recv_ring) {
+		pr_warn("%s: failed to allocate RECV ring (%d entries)\n",
+			ca->name, priv->num_rx_queues);
 		goto out_neigh_hash_cleanup;
 	}
 
-	priv->tx_ring = vzalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
-	if (!priv->tx_ring) {
-		printk(KERN_WARNING "%s: failed to allocate TX ring (%d entries)\n",
-		       ca->name, ipoib_sendq_size);
-		goto out_rx_ring_cleanup;
+	alloc_size = ipoib_recvq_size * sizeof(*recv_ring->rx_ring);
+	rx_allocated = 0;
+	recv_ring = priv->recv_ring;
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		recv_ring->rx_ring = kzalloc(alloc_size, GFP_KERNEL);
+		if (!recv_ring->rx_ring) {
+			pr_warn("%s: failed to allocate RX ring (%d entries)\n",
+				ca->name, ipoib_recvq_size);
+			goto out_recv_ring_cleanup;
+		}
+		recv_ring->dev = dev;
+		recv_ring->index = i;
+		recv_ring++;
+		rx_allocated++;
+	}
+
+	priv->send_ring = kzalloc(priv->num_tx_queues * sizeof(*send_ring),
+			GFP_KERNEL);
+	if (!priv->send_ring) {
+		pr_warn("%s: failed to allocate SEND ring (%d entries)\n",
+			ca->name, priv->num_tx_queues);
+		goto out_recv_ring_cleanup;
+	}
+
+	alloc_size = ipoib_sendq_size * sizeof(*send_ring->tx_ring);
+	tx_allocated = 0;
+	send_ring = priv->send_ring;
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		send_ring->tx_ring = vzalloc(alloc_size);
+		if (!send_ring->tx_ring) {
+			pr_warn(
+				"%s: failed to allocate TX ring (%d entries)\n",
+				ca->name, ipoib_sendq_size);
+			goto out_send_ring_cleanup;
+		}
+		send_ring->dev = dev;
+		send_ring->index = i;
+		send_ring++;
+		tx_allocated++;
 	}
 
 	/* priv->tx_head, tx_tail & tx_outstanding are already 0 */
 
 	if (ipoib_ib_dev_init(dev, ca, port))
-		goto out_tx_ring_cleanup;
+		goto out_send_ring_cleanup;
+
 
 	return 0;
 
-out_tx_ring_cleanup:
-	vfree(priv->tx_ring);
+out_send_ring_cleanup:
+	for (i = 0; i < tx_allocated; i++)
+		vfree(priv->send_ring[i].tx_ring);
 
-out_rx_ring_cleanup:
-	kfree(priv->rx_ring);
+out_recv_ring_cleanup:
+	for (i = 0; i < rx_allocated; i++)
+		kfree(priv->recv_ring[i].rx_ring);
 
 out_neigh_hash_cleanup:
 	ipoib_neigh_hash_uninit(dev);
 out:
+	priv->send_ring = NULL;
+	priv->recv_ring = NULL;
+
 	return -ENOMEM;
 }
 
 void ipoib_dev_cleanup(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev), *cpriv, *tcpriv;
+	int i;
 	LIST_HEAD(head);
 
 	ASSERT_RTNL();
@@ -1318,11 +1447,17 @@ void ipoib_dev_cleanup(struct net_device *dev)
 
 	ipoib_ib_dev_cleanup(dev);
 
-	kfree(priv->rx_ring);
-	vfree(priv->tx_ring);
 
-	priv->rx_ring = NULL;
-	priv->tx_ring = NULL;
+	for (i = 0; i < priv->num_tx_queues; i++)
+		vfree(priv->send_ring[i].tx_ring);
+	kfree(priv->send_ring);
+
+	for (i = 0; i < priv->num_rx_queues; i++)
+		kfree(priv->recv_ring[i].rx_ring);
+	kfree(priv->recv_ring);
+
+	priv->recv_ring = NULL;
+	priv->send_ring = NULL;
 
 	ipoib_neigh_hash_uninit(dev);
 }
@@ -1338,7 +1473,9 @@ static const struct net_device_ops ipoib_netdev_ops = {
 	.ndo_change_mtu		 = ipoib_change_mtu,
 	.ndo_fix_features	 = ipoib_fix_features,
 	.ndo_start_xmit	 	 = ipoib_start_xmit,
+	.ndo_select_queue	 = ipoib_select_queue_null,
 	.ndo_tx_timeout		 = ipoib_timeout,
+	.ndo_get_stats		 = ipoib_get_stats,
 	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
 };
 
@@ -1346,13 +1483,12 @@ void ipoib_setup(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
+	/* Use correct ops (ndo_select_queue) */
 	dev->netdev_ops		 = &ipoib_netdev_ops;
 	dev->header_ops		 = &ipoib_header_ops;
 
 	ipoib_set_ethtool_ops(dev);
 
-	netif_napi_add(dev, &priv->napi, ipoib_poll, 100);
-
 	dev->watchdog_timeo	 = HZ;
 
 	dev->flags		|= IFF_BROADCAST | IFF_MULTICAST;
@@ -1391,15 +1527,21 @@ void ipoib_setup(struct net_device *dev)
 	INIT_DELAYED_WORK(&priv->neigh_reap_task, ipoib_reap_neigh);
 }
 
-struct ipoib_dev_priv *ipoib_intf_alloc(const char *name)
+struct ipoib_dev_priv *ipoib_intf_alloc(const char *name,
+					struct ipoib_dev_priv *template_priv)
 {
 	struct net_device *dev;
 
-	dev = alloc_netdev((int) sizeof (struct ipoib_dev_priv), name,
-			   ipoib_setup);
+	dev = alloc_netdev_mqs((int) sizeof(struct ipoib_dev_priv), name,
+			   ipoib_setup,
+			   template_priv->num_tx_queues,
+			   template_priv->num_rx_queues);
 	if (!dev)
 		return NULL;
 
+	netif_set_real_num_tx_queues(dev, template_priv->num_tx_queues);
+	netif_set_real_num_rx_queues(dev, template_priv->num_rx_queues);
+
 	return netdev_priv(dev);
 }
 
@@ -1499,7 +1641,8 @@ int ipoib_add_pkey_attr(struct net_device *dev)
 	return device_create_file(&dev->dev, &dev_attr_pkey);
 }
 
-int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
+static int ipoib_get_hca_features(struct ipoib_dev_priv *priv,
+				  struct ib_device *hca)
 {
 	struct ib_device_attr *device_attr;
 	int result = -ENOMEM;
@@ -1522,6 +1665,20 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 
 	kfree(device_attr);
 
+	priv->num_rx_queues = 1;
+	priv->num_tx_queues = 1;
+
+	return 0;
+}
+
+int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
+{
+	int result;
+
+	result = ipoib_get_hca_features(priv, hca);
+	if (result)
+		return result;
+
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
 		priv->dev->hw_features = NETIF_F_SG |
 			NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
@@ -1538,13 +1695,23 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 static struct net_device *ipoib_add_port(const char *format,
 					 struct ib_device *hca, u8 port)
 {
-	struct ipoib_dev_priv *priv;
+	struct ipoib_dev_priv *priv, *template_priv;
 	struct ib_port_attr attr;
 	int result = -ENOMEM;
 
-	priv = ipoib_intf_alloc(format);
-	if (!priv)
-		goto alloc_mem_failed;
+	template_priv = kmalloc(sizeof(*template_priv), GFP_KERNEL);
+	if (!template_priv)
+		goto alloc_mem_failed1;
+
+	if (ipoib_get_hca_features(template_priv, hca))
+		goto device_query_failed;
+
+	priv = ipoib_intf_alloc(format, template_priv);
+	if (!priv) {
+		kfree(template_priv);
+		goto alloc_mem_failed2;
+	}
+	kfree(template_priv);
 
 	SET_NETDEV_DEV(priv->dev, hca->dma_device);
 	priv->dev->dev_id = port - 1;
@@ -1646,7 +1813,13 @@ event_failed:
 device_init_failed:
 	free_netdev(priv->dev);
 
-alloc_mem_failed:
+alloc_mem_failed2:
+	return ERR_PTR(result);
+
+device_query_failed:
+	kfree(template_priv);
+
+alloc_mem_failed1:
 	return ERR_PTR(result);
 }
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index cecb98a..5c383d9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -69,7 +69,7 @@ struct ipoib_mcast_iter {
 static void ipoib_mcast_free(struct ipoib_mcast *mcast)
 {
 	struct net_device *dev = mcast->dev;
-	int tx_dropped = 0;
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
 	ipoib_dbg_mcast(netdev_priv(dev), "deleting multicast group %pI6\n",
 			mcast->mcmember.mgid.raw);
@@ -81,14 +81,15 @@ static void ipoib_mcast_free(struct ipoib_mcast *mcast)
 		ipoib_put_ah(mcast->ah);
 
 	while (!skb_queue_empty(&mcast->pkt_queue)) {
-		++tx_dropped;
-		dev_kfree_skb_any(skb_dequeue(&mcast->pkt_queue));
+		struct sk_buff *skb = skb_dequeue(&mcast->pkt_queue);
+		int index = skb_get_queue_mapping(skb);
+		/* Modify to lock queue */
+		netif_tx_lock_bh(dev);
+		priv->send_ring[index].stats.tx_dropped++;
+		netif_tx_unlock_bh(dev);
+		dev_kfree_skb_any(skb);
 	}
 
-	netif_tx_lock_bh(dev);
-	dev->stats.tx_dropped += tx_dropped;
-	netif_tx_unlock_bh(dev);
-
 	kfree(mcast);
 }
 
@@ -172,6 +173,7 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 	struct ipoib_ah *ah;
 	int ret;
 	int set_qkey = 0;
+	int i;
 
 	mcast->mcmember = *mcmember;
 
@@ -188,7 +190,8 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 		priv->mcast_mtu = IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));
 		priv->qkey = be32_to_cpu(priv->broadcast->mcmember.qkey);
 		spin_unlock_irq(&priv->lock);
-		priv->tx_wr.wr.ud.remote_qkey = priv->qkey;
+		for (i = 0; i < priv->num_tx_queues; i++)
+			priv->send_ring[i].tx_wr.wr.ud.remote_qkey = priv->qkey;
 		set_qkey = 1;
 
 		if (!ipoib_cm_admin_enabled(dev)) {
@@ -276,6 +279,7 @@ ipoib_mcast_sendonly_join_complete(int status,
 {
 	struct ipoib_mcast *mcast = multicast->context;
 	struct net_device *dev = mcast->dev;
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
 	/* We trap for port events ourselves. */
 	if (status == -ENETRESET)
@@ -292,8 +296,10 @@ ipoib_mcast_sendonly_join_complete(int status,
 		/* Flush out any queued packets */
 		netif_tx_lock_bh(dev);
 		while (!skb_queue_empty(&mcast->pkt_queue)) {
-			++dev->stats.tx_dropped;
-			dev_kfree_skb_any(skb_dequeue(&mcast->pkt_queue));
+			struct sk_buff *skb = skb_dequeue(&mcast->pkt_queue);
+			int index = skb_get_queue_mapping(skb);
+			priv->send_ring[index].stats.tx_dropped++;
+			dev_kfree_skb_any(skb);
 		}
 		netif_tx_unlock_bh(dev);
 
@@ -653,7 +659,8 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)		||
 	    !priv->broadcast					||
 	    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &priv->broadcast->flags)) {
-		++dev->stats.tx_dropped;
+		int index = skb_get_queue_mapping(skb);
+		priv->send_ring[index].stats.tx_dropped++;
 		dev_kfree_skb_any(skb);
 		goto unlock;
 	}
@@ -666,9 +673,10 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 
 		mcast = ipoib_mcast_alloc(dev, 0);
 		if (!mcast) {
+			int index = skb_get_queue_mapping(skb);
+			priv->send_ring[index].stats.tx_dropped++;
 			ipoib_warn(priv, "unable to allocate memory for "
 				   "multicast structure\n");
-			++dev->stats.tx_dropped;
 			dev_kfree_skb_any(skb);
 			goto out;
 		}
@@ -683,7 +691,8 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 		if (skb_queue_len(&mcast->pkt_queue) < IPOIB_MAX_MCAST_QUEUE)
 			skb_queue_tail(&mcast->pkt_queue, skb);
 		else {
-			++dev->stats.tx_dropped;
+			int index = skb_get_queue_mapping(skb);
+			priv->send_ring[index].stats.tx_dropped++;
 			dev_kfree_skb_any(skb);
 		}
 
@@ -709,7 +718,14 @@ out:
 		spin_lock_irqsave(&priv->lock, flags);
 		if (!neigh) {
 			neigh = ipoib_neigh_alloc(daddr, dev);
-			if (neigh) {
+			/* With TX MQ it is possible that more than one skb
+			 * transmission triggered the creation of the neigh.
+			 * But only one actually created the neigh struct,
+			 * all the others found it in the hash. We must make
+			 * sure that the neigh will be added only once to the
+			 * mcast list.
+			 */
+			if (neigh && list_empty(&neigh->list)) {
 				kref_get(&mcast->ah->ref);
 				neigh->ah	= mcast->ah;
 				list_add_tail(&neigh->list, &mcast->neigh_list);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 049a997..4be626f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -118,6 +118,10 @@ int ipoib_init_qp(struct net_device *dev)
 		goto out_fail;
 	}
 
+	/* Only one ring currently */
+	priv->recv_ring[0].recv_qp = priv->qp;
+	priv->send_ring[0].send_qp = priv->qp;
+
 	return 0;
 
 out_fail:
@@ -142,8 +146,10 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 		.qp_type     = IB_QPT_UD
 	};
 
+	struct ipoib_send_ring *send_ring;
+	struct ipoib_recv_ring *recv_ring, *first_recv_ring;
 	int ret, size;
-	int i;
+	int i, j;
 
 	priv->pd = ib_alloc_pd(priv->ca);
 	if (IS_ERR(priv->pd)) {
@@ -167,19 +173,24 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 			size += ipoib_recvq_size * ipoib_max_conn_qp;
 	}
 
-	priv->recv_cq = ib_create_cq(priv->ca, ipoib_ib_completion, NULL, dev, size, 0);
+	priv->recv_cq = ib_create_cq(priv->ca, ipoib_ib_completion, NULL,
+				     priv->recv_ring, size, 0);
 	if (IS_ERR(priv->recv_cq)) {
 		printk(KERN_WARNING "%s: failed to create receive CQ\n", ca->name);
 		goto out_free_mr;
 	}
 
 	priv->send_cq = ib_create_cq(priv->ca, ipoib_send_comp_handler, NULL,
-				     dev, ipoib_sendq_size, 0);
+				     priv->send_ring, ipoib_sendq_size, 0);
 	if (IS_ERR(priv->send_cq)) {
 		printk(KERN_WARNING "%s: failed to create send CQ\n", ca->name);
 		goto out_free_recv_cq;
 	}
 
+	/* Only one ring */
+	priv->recv_ring[0].recv_cq = priv->recv_cq;
+	priv->send_ring[0].send_cq = priv->send_cq;
+
 	if (ib_req_notify_cq(priv->recv_cq, IB_CQ_NEXT_COMP))
 		goto out_free_send_cq;
 
@@ -205,25 +216,43 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	priv->dev->dev_addr[2] = (priv->qp->qp_num >>  8) & 0xff;
 	priv->dev->dev_addr[3] = (priv->qp->qp_num      ) & 0xff;
 
-	for (i = 0; i < MAX_SKB_FRAGS + 1; ++i)
-		priv->tx_sge[i].lkey = priv->mr->lkey;
+	send_ring = priv->send_ring;
+	for (j = 0; j < priv->num_tx_queues; j++) {
+		for (i = 0; i < MAX_SKB_FRAGS + 1; ++i)
+			send_ring->tx_sge[i].lkey = priv->mr->lkey;
 
-	priv->tx_wr.opcode	= IB_WR_SEND;
-	priv->tx_wr.sg_list	= priv->tx_sge;
-	priv->tx_wr.send_flags	= IB_SEND_SIGNALED;
+		send_ring->tx_wr.opcode	= IB_WR_SEND;
+		send_ring->tx_wr.sg_list	= send_ring->tx_sge;
+		send_ring->tx_wr.send_flags	= IB_SEND_SIGNALED;
+		send_ring++;
+	}
 
-	priv->rx_sge[0].lkey = priv->mr->lkey;
+	recv_ring = priv->recv_ring;
+	recv_ring->rx_sge[0].lkey = priv->mr->lkey;
 	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
-		priv->rx_sge[0].length = IPOIB_UD_HEAD_SIZE;
-		priv->rx_sge[1].length = PAGE_SIZE;
-		priv->rx_sge[1].lkey = priv->mr->lkey;
-		priv->rx_wr.num_sge = IPOIB_UD_RX_SG;
+		recv_ring->rx_sge[0].length = IPOIB_UD_HEAD_SIZE;
+		recv_ring->rx_sge[1].length = PAGE_SIZE;
+		recv_ring->rx_sge[1].lkey = priv->mr->lkey;
+		recv_ring->rx_wr.num_sge = IPOIB_UD_RX_SG;
 	} else {
-		priv->rx_sge[0].length = IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
-		priv->rx_wr.num_sge = 1;
+		recv_ring->rx_sge[0].length =
+				IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
+		recv_ring->rx_wr.num_sge = 1;
+	}
+	recv_ring->rx_wr.next = NULL;
+	recv_ring->rx_wr.sg_list = recv_ring->rx_sge;
+
+	/* Copy first RX ring sge and wr parameters to the rest RX ring */
+	first_recv_ring = recv_ring;
+	recv_ring++;
+	for (i = 1; i < priv->num_rx_queues; i++) {
+		recv_ring->rx_sge[0] = first_recv_ring->rx_sge[0];
+		recv_ring->rx_sge[1] = first_recv_ring->rx_sge[1];
+		recv_ring->rx_wr = first_recv_ring->rx_wr;
+		/* This field in per ring */
+		recv_ring->rx_wr.sg_list = recv_ring->rx_sge;
+		recv_ring++;
 	}
-	priv->rx_wr.next = NULL;
-	priv->rx_wr.sg_list = priv->rx_sge;
 
 	return 0;
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 8292554..ba633c2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -133,7 +133,7 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 
 	snprintf(intf_name, sizeof intf_name, "%s.%04x",
 		 ppriv->dev->name, pkey);
-	priv = ipoib_intf_alloc(intf_name);
+	priv = ipoib_intf_alloc(intf_name, ppriv);
 	if (!priv)
 		return -ENOMEM;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
