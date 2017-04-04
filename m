From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/6] IB/IPoIB: Formatting before adding accelerator to driver
Date: Tue,  4 Apr 2017 22:17:31 +0300
Message-ID: <20170404191732.31895-6-leon@kernel.org>
References: <20170404191732.31895-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404191732.31895-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Make ipoib_priv point to netdev_priv where the code calls netdev_priv.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           | 11 +++--
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        | 66 ++++++++++++-------------
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |  6 +--
 drivers/infiniband/ulp/ipoib/ipoib_fs.c        |  4 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 42 ++++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 68 +++++++++++++-------------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 18 +++----
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c   | 10 ++--
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  4 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |  4 +-
 10 files changed, 118 insertions(+), 115 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index d94a7a953338..055adacd6d06 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -153,6 +153,9 @@ static inline void skb_add_pseudo_hdr(struct sk_buff *skb)
 	skb_pull(skb, IPOIB_HARD_LEN);
 }
 
+/* Keep the refactoring compile able */
+#define ipoib_priv netdev_priv
+
 /* Used for all multicast joins (broadcast, IPv4 mcast and IPv6 mcast) */
 struct ipoib_mcast {
 	struct ib_sa_mcmember_rec mcmember;
@@ -606,14 +609,14 @@ extern int ipoib_max_conn_qp;
 
 static inline int ipoib_cm_admin_enabled(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	return IPOIB_CM_SUPPORTED(dev->dev_addr) &&
 		test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
 }
 
 static inline int ipoib_cm_enabled(struct net_device *dev, u8 *hwaddr)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	return IPOIB_CM_SUPPORTED(hwaddr) &&
 		test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
 }
@@ -636,13 +639,13 @@ static inline void ipoib_cm_set(struct ipoib_neigh *neigh, struct ipoib_cm_tx *t
 
 static inline int ipoib_cm_has_srq(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	return !!priv->cm.srq;
 }
 
 static inline unsigned int ipoib_cm_max_mtu(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	return priv->cm.max_cm_mtu;
 }
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 0cdf2b7f272f..052a60494f9b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -92,7 +92,7 @@ static void ipoib_cm_dma_unmap_rx(struct ipoib_dev_priv *priv, int frags,
 
 static int ipoib_cm_post_receive_srq(struct net_device *dev, int id)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_recv_wr *bad_wr;
 	int i, ret;
 
@@ -118,7 +118,7 @@ static int ipoib_cm_post_receive_nonsrq(struct net_device *dev,
 					struct ib_recv_wr *wr,
 					struct ib_sge *sge, int id)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_recv_wr *bad_wr;
 	int i, ret;
 
@@ -145,7 +145,7 @@ static struct sk_buff *ipoib_cm_alloc_rx_skb(struct net_device *dev,
 					     u64 mapping[IPOIB_CM_RX_SG],
 					     gfp_t gfp)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct sk_buff *skb;
 	int i;
 
@@ -196,7 +196,7 @@ static struct sk_buff *ipoib_cm_alloc_rx_skb(struct net_device *dev,
 static void ipoib_cm_free_rx_ring(struct net_device *dev,
 				  struct ipoib_cm_rx_buf *rx_ring)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int i;
 
 	for (i = 0; i < ipoib_recvq_size; ++i)
@@ -235,7 +235,7 @@ static void ipoib_cm_start_rx_drain(struct ipoib_dev_priv *priv)
 static void ipoib_cm_rx_event_handler(struct ib_event *event, void *ctx)
 {
 	struct ipoib_cm_rx *p = ctx;
-	struct ipoib_dev_priv *priv = netdev_priv(p->dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(p->dev);
 	unsigned long flags;
 
 	if (event->event != IB_EVENT_QP_LAST_WQE_REACHED)
@@ -251,7 +251,7 @@ static void ipoib_cm_rx_event_handler(struct ib_event *event, void *ctx)
 static struct ib_qp *ipoib_cm_create_rx_qp(struct net_device *dev,
 					   struct ipoib_cm_rx *p)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_qp_init_attr attr = {
 		.event_handler = ipoib_cm_rx_event_handler,
 		.send_cq = priv->recv_cq, /* For drain WR */
@@ -276,7 +276,7 @@ static int ipoib_cm_modify_rx_qp(struct net_device *dev,
 				 struct ib_cm_id *cm_id, struct ib_qp *qp,
 				 unsigned psn)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_qp_attr qp_attr;
 	int qp_attr_mask, ret;
 
@@ -331,7 +331,7 @@ static void ipoib_cm_init_rx_wr(struct net_device *dev,
 				struct ib_recv_wr *wr,
 				struct ib_sge *sge)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int i;
 
 	for (i = 0; i < priv->cm.num_frags; ++i)
@@ -349,7 +349,7 @@ static void ipoib_cm_init_rx_wr(struct net_device *dev,
 static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_id,
 				   struct ipoib_cm_rx *rx)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct {
 		struct ib_recv_wr wr;
 		struct ib_sge sge[IPOIB_CM_RX_SG];
@@ -422,7 +422,7 @@ static int ipoib_cm_send_rep(struct net_device *dev, struct ib_cm_id *cm_id,
 			     struct ib_qp *qp, struct ib_cm_req_event_param *req,
 			     unsigned psn)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_cm_data data = {};
 	struct ib_cm_rep_param rep = {};
 
@@ -442,7 +442,7 @@ static int ipoib_cm_send_rep(struct net_device *dev, struct ib_cm_id *cm_id,
 static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 {
 	struct net_device *dev = cm_id->context;
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_cm_rx *p;
 	unsigned psn;
 	int ret;
@@ -515,7 +515,7 @@ static int ipoib_cm_rx_handler(struct ib_cm_id *cm_id,
 		/* Fall through */
 	case IB_CM_REJ_RECEIVED:
 		p = cm_id->context;
-		priv = netdev_priv(p->dev);
+		priv = ipoib_priv(p->dev);
 		if (ib_modify_qp(p->qp, &ipoib_cm_err_attr, IB_QP_STATE))
 			ipoib_warn(priv, "unable to move qp to error state\n");
 		/* Fall through */
@@ -559,7 +559,7 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 
 void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_cm_rx_buf *rx_ring;
 	unsigned int wr_id = wc->wr_id & ~(IPOIB_OP_CM | IPOIB_OP_RECV);
 	struct sk_buff *skb, *newskb;
@@ -708,7 +708,7 @@ static inline int post_send(struct ipoib_dev_priv *priv,
 
 void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_tx *tx)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_tx_buf *tx_req;
 	int rc;
 	unsigned usable_sge = tx->max_send_sge - !!skb_headlen(skb);
@@ -786,7 +786,7 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 
 void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_cm_tx *tx = wc->qp->qp_context;
 	unsigned int wr_id = wc->wr_id & ~IPOIB_OP_CM;
 	struct ipoib_tx_buf *tx_req;
@@ -855,7 +855,7 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 
 int ipoib_cm_dev_open(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int ret;
 
 	if (!IPOIB_CM_SUPPORTED(dev->dev_addr))
@@ -887,7 +887,7 @@ int ipoib_cm_dev_open(struct net_device *dev)
 
 static void ipoib_cm_free_rx_reap_list(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_cm_rx *rx, *n;
 	LIST_HEAD(list);
 
@@ -910,7 +910,7 @@ static void ipoib_cm_free_rx_reap_list(struct net_device *dev)
 
 void ipoib_cm_dev_stop(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_cm_rx *p;
 	unsigned long begin;
 	int ret;
@@ -969,7 +969,7 @@ void ipoib_cm_dev_stop(struct net_device *dev)
 static int ipoib_cm_rep_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 {
 	struct ipoib_cm_tx *p = cm_id->context;
-	struct ipoib_dev_priv *priv = netdev_priv(p->dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(p->dev);
 	struct ipoib_cm_data *data = event->private_data;
 	struct sk_buff_head skqueue;
 	struct ib_qp_attr qp_attr;
@@ -1037,7 +1037,7 @@ static int ipoib_cm_rep_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
 
 static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_cm_tx *tx)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_qp_init_attr attr = {
 		.send_cq		= priv->recv_cq,
 		.recv_cq		= priv->recv_cq,
@@ -1070,7 +1070,7 @@ static int ipoib_cm_send_req(struct net_device *dev,
 			     u32 qpn,
 			     struct ib_sa_path_rec *pathrec)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_cm_data data = {};
 	struct ib_cm_req_param req = {};
 
@@ -1105,7 +1105,7 @@ static int ipoib_cm_send_req(struct net_device *dev,
 static int ipoib_cm_modify_tx_init(struct net_device *dev,
 				  struct ib_cm_id *cm_id, struct ib_qp *qp)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_qp_attr qp_attr;
 	int qp_attr_mask, ret;
 	ret = ib_find_pkey(priv->ca, priv->port, priv->pkey, &qp_attr.pkey_index);
@@ -1130,7 +1130,7 @@ static int ipoib_cm_modify_tx_init(struct net_device *dev,
 static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
 			    struct ib_sa_path_rec *pathrec)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(p->dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(p->dev);
 	int ret;
 
 	p->tx_ring = __vmalloc(ipoib_sendq_size * sizeof *p->tx_ring,
@@ -1186,7 +1186,7 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
 
 static void ipoib_cm_tx_destroy(struct ipoib_cm_tx *p)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(p->dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(p->dev);
 	struct ipoib_tx_buf *tx_req;
 	unsigned long begin;
 
@@ -1236,7 +1236,7 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
 			       struct ib_cm_event *event)
 {
 	struct ipoib_cm_tx *tx = cm_id->context;
-	struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(tx->dev);
 	struct net_device *dev = priv->dev;
 	struct ipoib_neigh *neigh;
 	unsigned long flags;
@@ -1287,7 +1287,7 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
 struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path *path,
 				       struct ipoib_neigh *neigh)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_cm_tx *tx;
 
 	tx = kzalloc(sizeof *tx, GFP_ATOMIC);
@@ -1306,7 +1306,7 @@ struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path
 
 void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(tx->dev);
 	unsigned long flags;
 	if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
 		spin_lock_irqsave(&priv->lock, flags);
@@ -1441,7 +1441,7 @@ static void ipoib_cm_skb_reap(struct work_struct *work)
 void ipoib_cm_skb_too_long(struct net_device *dev, struct sk_buff *skb,
 			   unsigned int mtu)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int e = skb_queue_empty(&priv->cm.skb_queue);
 
 	if (skb_dst(skb))
@@ -1490,7 +1490,7 @@ static void ipoib_cm_stale_task(struct work_struct *work)
 static ssize_t show_mode(struct device *d, struct device_attribute *attr,
 			 char *buf)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(to_net_dev(d));
+	struct ipoib_dev_priv *priv = ipoib_priv(to_net_dev(d));
 
 	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
 		return sprintf(buf, "connected\n");
@@ -1503,7 +1503,7 @@ static ssize_t set_mode(struct device *d, struct device_attribute *attr,
 {
 	struct net_device *dev = to_net_dev(d);
 	int ret;
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if (test_bit(IPOIB_FLAG_GOING_DOWN, &priv->flags))
 		return -EPERM;
@@ -1532,7 +1532,7 @@ int ipoib_cm_add_mode_attr(struct net_device *dev)
 
 static void ipoib_cm_create_srq(struct net_device *dev, int max_sge)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_srq_init_attr srq_init_attr = {
 		.srq_type = IB_SRQT_BASIC,
 		.attr = {
@@ -1561,7 +1561,7 @@ static void ipoib_cm_create_srq(struct net_device *dev, int max_sge)
 
 int ipoib_cm_dev_init(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int max_srq_sge, i;
 
 	INIT_LIST_HEAD(&priv->cm.passive_ids);
@@ -1622,7 +1622,7 @@ int ipoib_cm_dev_init(struct net_device *dev)
 
 void ipoib_cm_dev_cleanup(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int ret;
 
 	if (!priv->cm.srq)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index bac455a1942d..379c02fb4181 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -60,7 +60,7 @@ static const struct ipoib_stats ipoib_gstrings_stats[] = {
 static void ipoib_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *drvinfo)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(netdev);
+	struct ipoib_dev_priv *priv = ipoib_priv(netdev);
 
 	ib_get_device_fw_str(priv->ca, drvinfo->fw_version,
 			     sizeof(drvinfo->fw_version));
@@ -77,7 +77,7 @@ static void ipoib_get_drvinfo(struct net_device *netdev,
 static int ipoib_get_coalesce(struct net_device *dev,
 			      struct ethtool_coalesce *coal)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	coal->rx_coalesce_usecs = priv->ethtool.coalesce_usecs;
 	coal->rx_max_coalesced_frames = priv->ethtool.max_coalesced_frames;
@@ -88,7 +88,7 @@ static int ipoib_get_coalesce(struct net_device *dev,
 static int ipoib_set_coalesce(struct net_device *dev,
 			      struct ethtool_coalesce *coal)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int ret;
 
 	/*
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_fs.c b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
index 6bd5740e2691..6e73450241bf 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
@@ -261,7 +261,7 @@ static const struct file_operations ipoib_path_fops = {
 
 void ipoib_create_debug_files(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	char name[IFNAMSIZ + sizeof "_path"];
 
 	snprintf(name, sizeof name, "%s_mcg", dev->name);
@@ -279,7 +279,7 @@ void ipoib_create_debug_files(struct net_device *dev)
 
 void ipoib_delete_debug_files(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	debugfs_remove(priv->mcg_dentry);
 	debugfs_remove(priv->path_dentry);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 688688c21ef7..374533ce82fd 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -71,7 +71,7 @@ struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
 		ah = (struct ipoib_ah *)vah;
 	} else {
 		ah->ah = vah;
-		ipoib_dbg(netdev_priv(dev), "Created ah %p\n", ah->ah);
+		ipoib_dbg(ipoib_priv(dev), "Created ah %p\n", ah->ah);
 	}
 
 	return ah;
@@ -80,7 +80,7 @@ struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
 void ipoib_free_ah(struct kref *kref)
 {
 	struct ipoib_ah *ah = container_of(kref, struct ipoib_ah, ref);
-	struct ipoib_dev_priv *priv = netdev_priv(ah->dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(ah->dev);
 
 	unsigned long flags;
 
@@ -99,7 +99,7 @@ static void ipoib_ud_dma_unmap_rx(struct ipoib_dev_priv *priv,
 
 static int ipoib_ib_post_receive(struct net_device *dev, int id)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_recv_wr *bad_wr;
 	int ret;
 
@@ -121,7 +121,7 @@ static int ipoib_ib_post_receive(struct net_device *dev, int id)
 
 static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct sk_buff *skb;
 	int buf_size;
 	u64 *mapping;
@@ -153,7 +153,7 @@ static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
 
 static int ipoib_ib_post_receives(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int i;
 
 	for (i = 0; i < ipoib_recvq_size; ++i) {
@@ -172,7 +172,7 @@ static int ipoib_ib_post_receives(struct net_device *dev)
 
 static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	unsigned int wr_id = wc->wr_id & ~IPOIB_OP_RECV;
 	struct sk_buff *skb;
 	u64 mapping[IPOIB_UD_RX_SG];
@@ -381,7 +381,7 @@ static void ipoib_qp_state_validate_work(struct work_struct *work)
 
 static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	unsigned int wr_id = wc->wr_id;
 	struct ipoib_tx_buf *tx_req;
 
@@ -485,14 +485,14 @@ int ipoib_poll(struct napi_struct *napi, int budget)
 void ipoib_ib_completion(struct ib_cq *cq, void *dev_ptr)
 {
 	struct net_device *dev = dev_ptr;
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	napi_schedule(&priv->napi);
 }
 
 static void drain_tx_cq(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	netif_tx_lock(dev);
 	while (poll_tx(priv))
@@ -506,7 +506,7 @@ static void drain_tx_cq(struct net_device *dev)
 
 void ipoib_send_comp_handler(struct ib_cq *cq, void *dev_ptr)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev_ptr);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev_ptr);
 
 	mod_timer(&priv->poll_timer, jiffies);
 }
@@ -677,7 +677,7 @@ void ipoib_reap_ah(struct work_struct *work)
 
 static void ipoib_flush_ah(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	cancel_delayed_work(&priv->ah_reap_task);
 	flush_workqueue(priv->wq);
@@ -686,7 +686,7 @@ static void ipoib_flush_ah(struct net_device *dev)
 
 static void ipoib_stop_ah(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	set_bit(IPOIB_STOP_REAPER, &priv->flags);
 	ipoib_flush_ah(dev);
@@ -694,7 +694,7 @@ static void ipoib_stop_ah(struct net_device *dev)
 
 static int recvs_pending(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int pending = 0;
 	int i;
 
@@ -707,7 +707,7 @@ static int recvs_pending(struct net_device *dev)
 
 int ipoib_ib_dev_stop_default(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_qp_attr qp_attr;
 	unsigned long begin;
 	struct ipoib_tx_buf *tx_req;
@@ -796,7 +796,7 @@ void ipoib_ib_tx_timer_func(unsigned long ctx)
 
 int ipoib_ib_dev_open_default(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int ret;
 
 	ret = ipoib_init_qp(dev);
@@ -830,7 +830,7 @@ int ipoib_ib_dev_open_default(struct net_device *dev)
 
 int ipoib_ib_dev_open(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	ipoib_pkey_dev_check_presence(dev);
 
@@ -859,7 +859,7 @@ int ipoib_ib_dev_open(struct net_device *dev)
 
 void ipoib_pkey_dev_check_presence(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if (!(priv->pkey & 0x7fff) ||
 	    ib_find_pkey(priv->ca, priv->port, priv->pkey,
@@ -871,7 +871,7 @@ void ipoib_pkey_dev_check_presence(struct net_device *dev)
 
 void ipoib_ib_dev_up(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	ipoib_pkey_dev_check_presence(dev);
 
@@ -887,7 +887,7 @@ void ipoib_ib_dev_up(struct net_device *dev)
 
 void ipoib_ib_dev_down(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	ipoib_dbg(priv, "downing ib_dev\n");
 
@@ -902,7 +902,7 @@ void ipoib_ib_dev_down(struct net_device *dev)
 
 void ipoib_drain_cq(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int i, n;
 
 	/*
@@ -1216,7 +1216,7 @@ void ipoib_ib_dev_flush_heavy(struct work_struct *work)
 
 void ipoib_ib_dev_cleanup(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	ipoib_dbg(priv, "cleaning up ib_dev\n");
 	/*
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 08c85084d8f5..a88df83677b1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -110,7 +110,7 @@ static struct ib_client ipoib_client = {
 
 int ipoib_open(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	ipoib_dbg(priv, "bringing up interface\n");
 
@@ -157,7 +157,7 @@ int ipoib_open(struct net_device *dev)
 
 static int ipoib_stop(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	ipoib_dbg(priv, "stopping interface\n");
 
@@ -195,7 +195,7 @@ static void ipoib_uninit(struct net_device *dev)
 
 static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_features_t features)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
 		features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
@@ -205,7 +205,7 @@ static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_featu
 
 static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	/* dev->mtu > 2K ==> connected mode */
 	if (ipoib_cm_admin_enabled(dev)) {
@@ -468,7 +468,7 @@ static struct net_device *ipoib_get_net_dev_by_params(
 
 int ipoib_set_mode(struct net_device *dev, const char *buf)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if ((test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags) &&
 	     !strcmp(buf, "connected\n")) ||
@@ -505,7 +505,7 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
 
 struct ipoib_path *__path_find(struct net_device *dev, void *gid)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct rb_node *n = priv->path_tree.rb_node;
 	struct ipoib_path *path;
 	int ret;
@@ -529,7 +529,7 @@ struct ipoib_path *__path_find(struct net_device *dev, void *gid)
 
 static int __path_add(struct net_device *dev, struct ipoib_path *path)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct rb_node **n = &priv->path_tree.rb_node;
 	struct rb_node *pn = NULL;
 	struct ipoib_path *tpath;
@@ -564,7 +564,7 @@ static void path_free(struct net_device *dev, struct ipoib_path *path)
 	while ((skb = __skb_dequeue(&path->queue)))
 		dev_kfree_skb_irq(skb);
 
-	ipoib_dbg(netdev_priv(dev), "path_free\n");
+	ipoib_dbg(ipoib_priv(dev), "path_free\n");
 
 	/* remove all neigh connected to this path */
 	ipoib_del_neighs_by_gid(dev, path->pathrec.dgid.raw);
@@ -598,7 +598,7 @@ struct ipoib_path_iter *ipoib_path_iter_init(struct net_device *dev)
 
 int ipoib_path_iter_next(struct ipoib_path_iter *iter)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(iter->dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(iter->dev);
 	struct rb_node *n;
 	struct ipoib_path *path;
 	int ret = 1;
@@ -635,7 +635,7 @@ void ipoib_path_iter_read(struct ipoib_path_iter *iter,
 
 void ipoib_mark_paths_invalid(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_path *path, *tp;
 
 	spin_lock_irq(&priv->lock);
@@ -731,7 +731,7 @@ static void push_pseudo_header(struct sk_buff *skb, const char *daddr)
 
 void ipoib_flush_paths(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_path *path, *tp;
 	LIST_HEAD(remove_list);
 	unsigned long flags;
@@ -765,7 +765,7 @@ static void path_rec_completion(int status,
 {
 	struct ipoib_path *path = path_ptr;
 	struct net_device *dev = path->dev;
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_ah *ah = NULL;
 	struct ipoib_ah *old_ah = NULL;
 	struct ipoib_neigh *neigh, *tn;
@@ -858,7 +858,7 @@ static void path_rec_completion(int status,
 
 static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_path *path;
 
 	if (!priv->broadcast)
@@ -886,7 +886,7 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 static int path_rec_start(struct net_device *dev,
 			  struct ipoib_path *path)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	ipoib_dbg(priv, "Start path record lookup for %pI6\n",
 		  path->pathrec.dgid.raw);
@@ -1144,7 +1144,7 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static void ipoib_timeout(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	ipoib_warn(priv, "transmit timeout: latency %d msecs\n",
 		   jiffies_to_msecs(jiffies - dev_trans_start(dev)));
@@ -1178,7 +1178,7 @@ static int ipoib_hard_header(struct sk_buff *skb,
 
 static void ipoib_set_mcast_list(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)) {
 		ipoib_dbg(priv, "IPOIB_FLAG_OPER_UP not set");
@@ -1190,7 +1190,7 @@ static void ipoib_set_mcast_list(struct net_device *dev)
 
 static int ipoib_get_iflink(const struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	/* parent interface */
 	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags))
@@ -1218,7 +1218,7 @@ static u32 ipoib_addr_hash(struct ipoib_neigh_hash *htbl, u8 *daddr)
 
 struct ipoib_neigh *ipoib_neigh_get(struct net_device *dev, u8 *daddr)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_neigh_table *ntbl = &priv->ntbl;
 	struct ipoib_neigh_hash *htbl;
 	struct ipoib_neigh *neigh = NULL;
@@ -1347,7 +1347,7 @@ static struct ipoib_neigh *ipoib_neigh_ctor(u8 *daddr,
 struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
 				      struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_neigh_table *ntbl = &priv->ntbl;
 	struct ipoib_neigh_hash *htbl;
 	struct ipoib_neigh *neigh;
@@ -1404,7 +1404,7 @@ void ipoib_neigh_dtor(struct ipoib_neigh *neigh)
 {
 	/* neigh reference count was dropprd to zero */
 	struct net_device *dev = neigh->dev;
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct sk_buff *skb;
 	if (neigh->ah)
 		ipoib_put_ah(neigh->ah);
@@ -1414,7 +1414,7 @@ void ipoib_neigh_dtor(struct ipoib_neigh *neigh)
 	}
 	if (ipoib_cm_get(neigh))
 		ipoib_cm_destroy_tx(ipoib_cm_get(neigh));
-	ipoib_dbg(netdev_priv(dev),
+	ipoib_dbg(ipoib_priv(dev),
 		  "neigh free for %06x %pI6\n",
 		  IPOIB_QPN(neigh->daddr),
 		  neigh->daddr + 4);
@@ -1436,7 +1436,7 @@ static void ipoib_neigh_reclaim(struct rcu_head *rp)
 void ipoib_neigh_free(struct ipoib_neigh *neigh)
 {
 	struct net_device *dev = neigh->dev;
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_neigh_table *ntbl = &priv->ntbl;
 	struct ipoib_neigh_hash *htbl;
 	struct ipoib_neigh __rcu **np;
@@ -1519,7 +1519,7 @@ static void neigh_hash_free_rcu(struct rcu_head *head)
 
 void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_neigh_table *ntbl = &priv->ntbl;
 	struct ipoib_neigh_hash *htbl;
 	unsigned long flags;
@@ -1605,7 +1605,7 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
 
 static void ipoib_neigh_hash_uninit(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int stopped;
 
 	ipoib_dbg(priv, "ipoib_neigh_hash_uninit\n");
@@ -1624,7 +1624,7 @@ static void ipoib_neigh_hash_uninit(struct net_device *dev)
 
 void ipoib_dev_uninit_default(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	ipoib_transport_dev_cleanup(dev);
 
@@ -1750,7 +1750,7 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 
 void ipoib_dev_cleanup(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev), *cpriv, *tcpriv;
+	struct ipoib_dev_priv *priv = ipoib_priv(dev), *cpriv, *tcpriv;
 	LIST_HEAD(head);
 
 	ASSERT_RTNL();
@@ -1780,7 +1780,7 @@ void ipoib_dev_cleanup(struct net_device *dev)
 
 static int ipoib_set_vf_link_state(struct net_device *dev, int vf, int link_state)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	return ib_set_vf_link_state(priv->ca, vf, priv->port, link_state);
 }
@@ -1788,7 +1788,7 @@ static int ipoib_set_vf_link_state(struct net_device *dev, int vf, int link_stat
 static int ipoib_get_vf_config(struct net_device *dev, int vf,
 			       struct ifla_vf_info *ivf)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int err;
 
 	err = ib_get_vf_config(priv->ca, vf, priv->port, ivf);
@@ -1802,7 +1802,7 @@ static int ipoib_get_vf_config(struct net_device *dev, int vf,
 
 static int ipoib_set_vf_guid(struct net_device *dev, int vf, u64 guid, int type)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if (type != IFLA_VF_IB_NODE_GUID && type != IFLA_VF_IB_PORT_GUID)
 		return -EINVAL;
@@ -1813,7 +1813,7 @@ static int ipoib_set_vf_guid(struct net_device *dev, int vf, u64 guid, int type)
 static int ipoib_get_vf_stats(struct net_device *dev, int vf,
 			      struct ifla_vf_stats *vf_stats)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	return ib_get_vf_stats(priv->ca, vf, priv->port, vf_stats);
 }
@@ -1925,14 +1925,14 @@ static DEVICE_ATTR(pkey, S_IRUGO, show_pkey, NULL);
 static ssize_t show_umcast(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(to_net_dev(dev));
+	struct ipoib_dev_priv *priv = ipoib_priv(to_net_dev(dev));
 
 	return sprintf(buf, "%d\n", test_bit(IPOIB_FLAG_UMCAST, &priv->flags));
 }
 
 void ipoib_set_umcast(struct net_device *ndev, int umcast_val)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(ndev);
+	struct ipoib_dev_priv *priv = ipoib_priv(ndev);
 
 	if (umcast_val > 0) {
 		set_bit(IPOIB_FLAG_UMCAST, &priv->flags);
@@ -2005,7 +2005,7 @@ static int ipoib_check_lladdr(struct net_device *dev,
 
 static int ipoib_set_mac(struct net_device *dev, void *addr)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct sockaddr_storage *ss = addr;
 	int ret;
 
@@ -2224,7 +2224,7 @@ static void ipoib_add_one(struct ib_device *device)
 			continue;
 		dev = ipoib_add_port("ib%d", device, p);
 		if (!IS_ERR(dev)) {
-			priv = netdev_priv(dev);
+			priv = ipoib_priv(dev);
 			list_add_tail(&priv->list, dev_list);
 			count++;
 		}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 69e146cdc306..6707fd703dca 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -114,7 +114,7 @@ static void ipoib_mcast_free(struct ipoib_mcast *mcast)
 	struct net_device *dev = mcast->dev;
 	int tx_dropped = 0;
 
-	ipoib_dbg_mcast(netdev_priv(dev), "deleting multicast group %pI6\n",
+	ipoib_dbg_mcast(ipoib_priv(dev), "deleting multicast group %pI6\n",
 			mcast->mcmember.mgid.raw);
 
 	/* remove all neigh connected to this mcast */
@@ -158,7 +158,7 @@ static struct ipoib_mcast *ipoib_mcast_alloc(struct net_device *dev,
 
 static struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct rb_node *n = priv->multicast_tree.rb_node;
 
 	while (n) {
@@ -182,7 +182,7 @@ static struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid
 
 static int __ipoib_mcast_add(struct net_device *dev, struct ipoib_mcast *mcast)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct rb_node **n = &priv->multicast_tree.rb_node, *pn = NULL;
 
 	while (*n) {
@@ -375,7 +375,7 @@ static int ipoib_mcast_join_complete(int status,
 {
 	struct ipoib_mcast *mcast = multicast->context;
 	struct net_device *dev = mcast->dev;
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	ipoib_dbg_mcast(priv, "%sjoin completion for %pI6 (status %d)\n",
 			test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ?
@@ -477,7 +477,7 @@ static int ipoib_mcast_join_complete(int status,
  */
 static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_sa_multicast *multicast;
 	struct ib_sa_mcmember_rec rec = {
 		.join_state = 1
@@ -678,7 +678,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 
 void ipoib_mcast_start_thread(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	unsigned long flags;
 
 	ipoib_dbg_mcast(priv, "starting multicast thread\n");
@@ -690,7 +690,7 @@ void ipoib_mcast_start_thread(struct net_device *dev)
 
 int ipoib_mcast_stop_thread(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	unsigned long flags;
 
 	ipoib_dbg_mcast(priv, "stopping multicast thread\n");
@@ -837,7 +837,7 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 
 void ipoib_mcast_dev_flush(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	LIST_HEAD(remove_list);
 	struct ipoib_mcast *mcast, *tmcast;
 	unsigned long flags;
@@ -1029,7 +1029,7 @@ struct ipoib_mcast_iter *ipoib_mcast_iter_init(struct net_device *dev)
 
 int ipoib_mcast_iter_next(struct ipoib_mcast_iter *iter)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(iter->dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(iter->dev);
 	struct rb_node *n;
 	struct ipoib_mcast *mcast;
 	int ret = 1;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index cdc7df4fdb8a..406e7b039b79 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -44,7 +44,7 @@ static const struct nla_policy ipoib_policy[IFLA_IPOIB_MAX + 1] = {
 
 static int ipoib_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	u16 val;
 
 	if (nla_put_u16(skb, IFLA_IPOIB_PKEY, priv->pkey))
@@ -107,7 +107,7 @@ static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
 	if (!pdev || pdev->type != ARPHRD_INFINIBAND)
 		return -ENODEV;
 
-	ppriv = netdev_priv(pdev);
+	ppriv = ipoib_priv(pdev);
 
 	if (test_bit(IPOIB_FLAG_SUBINTERFACE, &ppriv->flags)) {
 		ipoib_warn(ppriv, "child creation disallowed for child devices\n");
@@ -129,7 +129,7 @@ static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
 	 */
 	child_pkey |= 0x8000;
 
-	err = __ipoib_vlan_add(ppriv, netdev_priv(dev), child_pkey, IPOIB_RTNL_CHILD);
+	err = __ipoib_vlan_add(ppriv, ipoib_priv(dev), child_pkey, IPOIB_RTNL_CHILD);
 
 	if (!err && data)
 		err = ipoib_changelink(dev, tb, data);
@@ -140,8 +140,8 @@ static void ipoib_unregister_child_dev(struct net_device *dev, struct list_head
 {
 	struct ipoib_dev_priv *priv, *ppriv;
 
-	priv = netdev_priv(dev);
-	ppriv = netdev_priv(priv->parent);
+	priv = ipoib_priv(dev);
+	ppriv = ipoib_priv(priv->parent);
 
 	down_write(&ppriv->vlan_rwsem);
 	unregister_netdevice_queue(dev, head);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 529b9509a2c4..e66e7081644d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -130,7 +130,7 @@ int ipoib_init_qp(struct net_device *dev)
 
 int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ib_qp_init_attr init_attr = {
 		.cap = {
 			.max_send_wr  = ipoib_sendq_size,
@@ -232,7 +232,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 
 void ipoib_transport_dev_cleanup(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if (priv->qp) {
 		if (ib_destroy_qp(priv->qp))
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 3e10e3dac2e7..b4de1737986d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -44,7 +44,7 @@ static ssize_t show_parent(struct device *d, struct device_attribute *attr,
 			   char *buf)
 {
 	struct net_device *dev = to_net_dev(d);
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	return sprintf(buf, "%s\n", priv->parent->name);
 }
@@ -183,7 +183,7 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	ppriv = netdev_priv(pdev);
+	ppriv = ipoib_priv(pdev);
 
 	if (test_bit(IPOIB_FLAG_GOING_DOWN, &ppriv->flags))
 		return -EPERM;
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
