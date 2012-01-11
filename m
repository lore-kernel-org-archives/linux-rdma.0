From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 5/6] IB: change CQ TCP/IP checksum offload mark to use bit
 flag indication instead of integer
Date: Wed, 11 Jan 2012 19:03:51 +0200
Message-ID: <alpine.LRH.2.00.1201111903140.10264@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111850330.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use a bit in wc_flags rather then a whole integer, this change for itself
doesn't reduce the size of struct ib_wc on 64bit machines, so it stays on 56
bytes as of padding. However, it will allow to add more fields in the future w.o
enlarging that structure. Also, it will serve to have unified approach with
future libibverbs checksum offload reporting towards applications, where
adding a bit flag doesn't break the library ABI. This patch was during
conversation with Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c         |    3 ++-
 drivers/infiniband/hw/mthca/mthca_cq.c  |    3 ++-
 drivers/infiniband/hw/qib/qib_rc.c      |    1 -
 drivers/infiniband/hw/qib/qib_uc.c      |    1 -
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    3 ++-
 include/rdma/ib_verbs.h                 |    2 +-
 6 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 5ecf38d..09eb1d1 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -720,7 +720,8 @@ repoll:
 		wc->dlid_path_bits = (g_mlpath_rqpn >> 24) & 0x7f;
 		wc->wc_flags	  |= g_mlpath_rqpn & 0x80000000 ? IB_WC_GRH : 0;
 		wc->pkey_index     = be32_to_cpu(cqe->immed_rss_invalid) & 0x7f;
-		wc->csum_ok	   = mlx4_ib_ipoib_csum_ok(cqe->status, cqe->checksum);
+		wc->wc_flags	  |= mlx4_ib_ipoib_csum_ok(cqe->status,
+					cqe->checksum) ? IB_WC_IP_CSUM_OK : 0;
 		if (rdma_port_get_link_layer(wc->qp->device,
 				(*cur_qp)->port) == IB_LINK_LAYER_ETHERNET)
 			wc->sl  = be16_to_cpu(cqe->sl_vid) >> 13;
diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index 53157b8..40ba833 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -643,7 +643,8 @@ static inline int mthca_poll_one(struct mthca_dev *dev,
 		entry->wc_flags   |= cqe->g_mlpath & 0x80 ? IB_WC_GRH : 0;
 		checksum = (be32_to_cpu(cqe->rqpn) >> 24) |
 				((be32_to_cpu(cqe->my_ee) >> 16) & 0xff00);
-		entry->csum_ok = (cqe->sl_ipok & 1 && checksum == 0xffff);
+		entry->wc_flags	  |=  (cqe->sl_ipok & 1 && checksum == 0xffff) ?
+							IB_WC_IP_CSUM_OK : 0;
 	}

 	entry->status = IB_WC_SUCCESS;
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 894afac..765b4cb 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -2048,7 +2048,6 @@ send_last:
 		wc.pkey_index = 0;
 		wc.dlid_path_bits = 0;
 		wc.port_num = 0;
-		wc.csum_ok = 0;
 		/* Signal completion event if the solicited bit is set. */
 		qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
 			     (ohdr->bth[0] &
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 847e7af..7ce2ac2 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -422,7 +422,6 @@ last_imm:
 		wc.pkey_index = 0;
 		wc.dlid_path_bits = 0;
 		wc.port_num = 0;
-		wc.csum_ok = 0;
 		/* Signal completion event if the solicited bit is set. */
 		qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
 			     (ohdr->bth[0] &
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 4115be5..5c1bc99 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -296,7 +296,8 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	dev->stats.rx_bytes += skb->len;

 	skb->dev = dev;
-	if ((dev->features & NETIF_F_RXCSUM) && likely(wc->csum_ok))
+	if ((dev->features & NETIF_F_RXCSUM) &&
+			likely(wc->wc_flags & IB_WC_IP_CSUM_OK))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;

 	napi_gro_receive(&priv->napi, skb);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 01179b0..31996e3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -518,6 +518,7 @@ enum ib_wc_flags {
 	IB_WC_GRH		= 1,
 	IB_WC_WITH_IMM		= (1<<1),
 	IB_WC_WITH_INVALIDATE	= (1<<2),
+	IB_WC_IP_CSUM_OK	= (1<<3),
 };

 struct ib_wc {
@@ -538,7 +539,6 @@ struct ib_wc {
 	u8			sl;
 	u8			dlid_path_bits;
 	u8			port_num;	/* valid only for DR SMPs on switches */
-	int			csum_ok;
 };

 enum ib_cq_notify_flags {
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
