From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 14/15] IB/rxe: Remove a pointless indirection layer
Date: Tue, 10 Jan 2017 11:08:21 -0800
Message-ID: <20170110190822.16953-15-bart.vanassche@sandisk.com>
References: <20170110190822.16953-1-bart.vanassche@sandisk.com>
 <20170110190822.16953-2-bart.vanassche@sandisk.com>
 <20170110190822.16953-3-bart.vanassche@sandisk.com>
 <20170110190822.16953-4-bart.vanassche@sandisk.com>
 <20170110190822.16953-5-bart.vanassche@sandisk.com>
 <20170110190822.16953-6-bart.vanassche@sandisk.com>
 <20170110190822.16953-7-bart.vanassche@sandisk.com>
 <20170110190822.16953-8-bart.vanassche@sandisk.com>
 <20170110190822.16953-9-bart.vanassche@sandisk.com>
 <20170110190822.16953-10-bart.vanassche@sandisk.com>
 <20170110190822.16953-11-bart.vanassche@sandisk.com>
 <20170110190822.16953-12-bart.vanassche@sandisk.com>
 <20170110190822.16953-13-bart.vanassche@sandisk.com>
 <20170110190822.16953-14-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110190822.16953-14-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Neither rxe->ifc_ops nor any of the function pointers in struct
struct rxe_ifc_ops ever change. Hence remove the rxe->ifc_ops
indirection mechanism.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe.c       |  2 +-
 drivers/infiniband/sw/rxe/rxe_loc.h   | 20 ++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_mcast.c |  4 ++--
 drivers/infiniband/sw/rxe/rxe_net.c   | 43 +++++++++++------------------------
 drivers/infiniband/sw/rxe/rxe_req.c   |  4 ++--
 drivers/infiniband/sw/rxe/rxe_resp.c  |  4 ++--
 drivers/infiniband/sw/rxe/rxe_verbs.c | 10 ++++----
 drivers/infiniband/sw/rxe/rxe_verbs.h | 22 ------------------
 8 files changed, 42 insertions(+), 67 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index ab6c3c25d7ff..b12dd9b5a89d 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -178,7 +178,7 @@ static int rxe_init_ports(struct rxe_dev *rxe)
 		return -ENOMEM;
 
 	port->pkey_tbl[0] = 0xffff;
-	port->port_guid = rxe->ifc_ops->port_guid(rxe);
+	port->port_guid = rxe_port_guid(rxe);
 
 	spin_lock_init(&port->port_lock);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index bdec460f1fce..272337e5e948 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -141,6 +141,22 @@ void rxe_mem_cleanup(struct rxe_pool_entry *arg);
 
 int advance_dma_data(struct rxe_dma_info *dma, unsigned int length);
 
+/* rxe_net.c */
+int rxe_loopback(struct sk_buff *skb);
+int rxe_send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
+	     struct sk_buff *skb);
+__be64 rxe_port_guid(struct rxe_dev *rxe);
+struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
+				int paylen, struct rxe_pkt_info *pkt);
+int rxe_prepare(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
+		struct sk_buff *skb, u32 *crc);
+enum rdma_link_layer rxe_link_layer(struct rxe_dev *rxe, unsigned int port_num);
+const char *rxe_parent_name(struct rxe_dev *rxe, unsigned int port_num);
+struct device *rxe_dma_device(struct rxe_dev *rxe);
+__be64 rxe_node_guid(struct rxe_dev *rxe);
+int rxe_mcast_add(struct rxe_dev *rxe, union ib_gid *mgid);
+int rxe_mcast_delete(struct rxe_dev *rxe, union ib_gid *mgid);
+
 /* rxe_qp.c */
 int rxe_qp_chk_init(struct rxe_dev *rxe, struct ib_qp_init_attr *init);
 
@@ -257,9 +273,9 @@ static inline int rxe_xmit_packet(struct rxe_dev *rxe, struct rxe_qp *qp,
 
 	if (pkt->mask & RXE_LOOPBACK_MASK) {
 		memcpy(SKB_TO_PKT(skb), pkt, sizeof(*pkt));
-		err = rxe->ifc_ops->loopback(skb);
+		err = rxe_loopback(skb);
 	} else {
-		err = rxe->ifc_ops->send(rxe, pkt, skb);
+		err = rxe_send(rxe, pkt, skb);
 	}
 
 	if (err) {
diff --git a/drivers/infiniband/sw/rxe/rxe_mcast.c b/drivers/infiniband/sw/rxe/rxe_mcast.c
index e0fb6752f90e..522a7942c56c 100644
--- a/drivers/infiniband/sw/rxe/rxe_mcast.c
+++ b/drivers/infiniband/sw/rxe/rxe_mcast.c
@@ -61,7 +61,7 @@ int rxe_mcast_get_grp(struct rxe_dev *rxe, union ib_gid *mgid,
 
 	rxe_add_key(grp, mgid);
 
-	err = rxe->ifc_ops->mcast_add(rxe, mgid);
+	err = rxe_mcast_add(rxe, mgid);
 	if (err)
 		goto err2;
 
@@ -186,5 +186,5 @@ void rxe_mc_cleanup(struct rxe_pool_entry *arg)
 	struct rxe_dev *rxe = grp->rxe;
 
 	rxe_drop_key(grp);
-	rxe->ifc_ops->mcast_delete(rxe, &grp->mgid);
+	rxe_mcast_delete(rxe, &grp->mgid);
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 151f639abebf..50144c307eb4 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -102,17 +102,17 @@ static __be64 rxe_mac_to_eui64(struct net_device *ndev)
 	return eui64;
 }
 
-static __be64 node_guid(struct rxe_dev *rxe)
+__be64 rxe_node_guid(struct rxe_dev *rxe)
 {
 	return rxe_mac_to_eui64(rxe->ndev);
 }
 
-static __be64 port_guid(struct rxe_dev *rxe)
+__be64 rxe_port_guid(struct rxe_dev *rxe)
 {
 	return rxe_mac_to_eui64(rxe->ndev);
 }
 
-static struct device *dma_device(struct rxe_dev *rxe)
+struct device *rxe_dma_device(struct rxe_dev *rxe)
 {
 	struct net_device *ndev;
 
@@ -124,7 +124,7 @@ static struct device *dma_device(struct rxe_dev *rxe)
 	return ndev->dev.parent;
 }
 
-static int mcast_add(struct rxe_dev *rxe, union ib_gid *mgid)
+int rxe_mcast_add(struct rxe_dev *rxe, union ib_gid *mgid)
 {
 	int err;
 	unsigned char ll_addr[ETH_ALEN];
@@ -135,7 +135,7 @@ static int mcast_add(struct rxe_dev *rxe, union ib_gid *mgid)
 	return err;
 }
 
-static int mcast_delete(struct rxe_dev *rxe, union ib_gid *mgid)
+int rxe_mcast_delete(struct rxe_dev *rxe, union ib_gid *mgid)
 {
 	int err;
 	unsigned char ll_addr[ETH_ALEN];
@@ -397,8 +397,8 @@ static int prepare6(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 	return 0;
 }
 
-static int prepare(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
-		   struct sk_buff *skb, u32 *crc)
+int rxe_prepare(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
+		struct sk_buff *skb, u32 *crc)
 {
 	int err = 0;
 	struct rxe_av *av = rxe_get_av(pkt);
@@ -424,8 +424,7 @@ static void rxe_skb_tx_dtor(struct sk_buff *skb)
 		rxe_run_task(&qp->req.task, 1);
 }
 
-static int send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
-		struct sk_buff *skb)
+int rxe_send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt, struct sk_buff *skb)
 {
 	struct sk_buff *nskb;
 	struct rxe_av *av;
@@ -461,7 +460,7 @@ static int send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 	return 0;
 }
 
-static int loopback(struct sk_buff *skb)
+int rxe_loopback(struct sk_buff *skb)
 {
 	return rxe_rcv(skb);
 }
@@ -471,8 +470,8 @@ static inline int addr_same(struct rxe_dev *rxe, struct rxe_av *av)
 	return rxe->port.port_guid == av->grh.dgid.global.interface_id;
 }
 
-static struct sk_buff *init_packet(struct rxe_dev *rxe, struct rxe_av *av,
-				   int paylen, struct rxe_pkt_info *pkt)
+struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
+				int paylen, struct rxe_pkt_info *pkt)
 {
 	unsigned int hdr_len;
 	struct sk_buff *skb;
@@ -511,31 +510,16 @@ static struct sk_buff *init_packet(struct rxe_dev *rxe, struct rxe_av *av,
  * this is required by rxe_cfg to match rxe devices in
  * /sys/class/infiniband up with their underlying ethernet devices
  */
-static char *parent_name(struct rxe_dev *rxe, unsigned int port_num)
+const char *rxe_parent_name(struct rxe_dev *rxe, unsigned int port_num)
 {
 	return rxe->ndev->name;
 }
 
-static enum rdma_link_layer link_layer(struct rxe_dev *rxe,
-				       unsigned int port_num)
+enum rdma_link_layer rxe_link_layer(struct rxe_dev *rxe, unsigned int port_num)
 {
 	return IB_LINK_LAYER_ETHERNET;
 }
 
-static struct rxe_ifc_ops ifc_ops = {
-	.node_guid	= node_guid,
-	.port_guid	= port_guid,
-	.dma_device	= dma_device,
-	.mcast_add	= mcast_add,
-	.mcast_delete	= mcast_delete,
-	.prepare	= prepare,
-	.send		= send,
-	.loopback	= loopback,
-	.init_packet	= init_packet,
-	.parent_name	= parent_name,
-	.link_layer	= link_layer,
-};
-
 struct rxe_dev *rxe_net_add(struct net_device *ndev)
 {
 	int err;
@@ -545,7 +529,6 @@ struct rxe_dev *rxe_net_add(struct net_device *ndev)
 	if (!rxe)
 		return NULL;
 
-	rxe->ifc_ops = &ifc_ops;
 	rxe->ndev = ndev;
 
 	err = rxe_add(rxe, ndev->mtu);
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 512e74326b16..dbfde0dc6ff7 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -404,7 +404,7 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 
 	/* init skb */
 	av = rxe_get_av(pkt);
-	skb = rxe->ifc_ops->init_packet(rxe, av, paylen, pkt);
+	skb = rxe_init_packet(rxe, av, paylen, pkt);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -475,7 +475,7 @@ static int fill_packet(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 	u32 *p;
 	int err;
 
-	err = rxe->ifc_ops->prepare(rxe, pkt, skb, &crc);
+	err = rxe_prepare(rxe, pkt, skb, &crc);
 	if (err)
 		return err;
 
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 05f374986cea..7bf20ced2078 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -608,7 +608,7 @@ static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
 	pad = (-payload) & 0x3;
 	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
 
-	skb = rxe->ifc_ops->init_packet(rxe, &qp->pri_av, paylen, ack);
+	skb = rxe_init_packet(rxe, &qp->pri_av, paylen, ack);
 	if (!skb)
 		return NULL;
 
@@ -637,7 +637,7 @@ static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
 	if (ack->mask & RXE_ATMACK_MASK)
 		atmack_set_orig(ack, qp->resp.atomic_orig);
 
-	err = rxe->ifc_ops->prepare(rxe, ack, skb, &crc);
+	err = rxe_prepare(rxe, ack, skb, &crc);
 	if (err) {
 		kfree_skb(skb);
 		return NULL;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index beb7021ff18a..e4de37fb9aab 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -234,7 +234,7 @@ static enum rdma_link_layer rxe_get_link_layer(struct ib_device *dev,
 {
 	struct rxe_dev *rxe = to_rdev(dev);
 
-	return rxe->ifc_ops->link_layer(rxe, port_num);
+	return rxe_link_layer(rxe, port_num);
 }
 
 static struct ib_ucontext *rxe_alloc_ucontext(struct ib_device *dev,
@@ -1209,10 +1209,8 @@ static ssize_t rxe_show_parent(struct device *device,
 {
 	struct rxe_dev *rxe = container_of(device, struct rxe_dev,
 					   ib_dev.dev);
-	char *name;
 
-	name = rxe->ifc_ops->parent_name(rxe, 1);
-	return snprintf(buf, 16, "%s\n", name);
+	return snprintf(buf, 16, "%s\n", rxe_parent_name(rxe, 1));
 }
 
 static DEVICE_ATTR(parent, S_IRUGO, rxe_show_parent, NULL);
@@ -1234,9 +1232,9 @@ int rxe_register_device(struct rxe_dev *rxe)
 	dev->node_type = RDMA_NODE_IB_CA;
 	dev->phys_port_cnt = 1;
 	dev->num_comp_vectors = RXE_NUM_COMP_VECTORS;
-	dev->dma_device = rxe->ifc_ops->dma_device(rxe);
+	dev->dma_device = rxe_dma_device(rxe);
 	dev->local_dma_lkey = 0;
-	dev->node_guid = rxe->ifc_ops->node_guid(rxe);
+	dev->node_guid = rxe_node_guid(rxe);
 	dev->dma_ops = &rxe_dma_mapping_ops;
 
 	dev->uverbs_abi_ver = RXE_UVERBS_ABI_VERSION;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 536974b69ed9..e100c500ae85 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -372,26 +372,6 @@ struct rxe_port {
 	u32			qp_gsi_index;
 };
 
-/* callbacks from rdma_rxe to network interface layer */
-struct rxe_ifc_ops {
-	void (*release)(struct rxe_dev *rxe);
-	__be64 (*node_guid)(struct rxe_dev *rxe);
-	__be64 (*port_guid)(struct rxe_dev *rxe);
-	struct device *(*dma_device)(struct rxe_dev *rxe);
-	int (*mcast_add)(struct rxe_dev *rxe, union ib_gid *mgid);
-	int (*mcast_delete)(struct rxe_dev *rxe, union ib_gid *mgid);
-	int (*prepare)(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
-		       struct sk_buff *skb, u32 *crc);
-	int (*send)(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
-		    struct sk_buff *skb);
-	int (*loopback)(struct sk_buff *skb);
-	struct sk_buff *(*init_packet)(struct rxe_dev *rxe, struct rxe_av *av,
-				       int paylen, struct rxe_pkt_info *pkt);
-	char *(*parent_name)(struct rxe_dev *rxe, unsigned int port_num);
-	enum rdma_link_layer (*link_layer)(struct rxe_dev *rxe,
-					   unsigned int port_num);
-};
-
 struct rxe_dev {
 	struct ib_device	ib_dev;
 	struct ib_device_attr	attr;
@@ -400,8 +380,6 @@ struct rxe_dev {
 	struct kref		ref_cnt;
 	struct mutex	usdev_lock;
 
-	struct rxe_ifc_ops	*ifc_ops;
-
 	struct net_device	*ndev;
 
 	int			xmit_errors;
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
