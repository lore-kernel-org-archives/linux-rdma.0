From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V2 4/6] IB/IPoIB: Rename qpn to be dqpn in ipoib_send and post_send functions
Date: Mon, 10 Apr 2017 11:22:28 +0300
Message-ID: <20170410082230.10662-5-leonro@mellanox.com>
References: <20170410082230.10662-1-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170410082230.10662-1-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Change of function parameter name from qpn to be dqpn.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h    |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 596c73d01add..353e34353b9f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -483,7 +483,7 @@ int ipoib_add_pkey_attr(struct net_device *dev);
 int ipoib_add_umcast_attr(struct net_device *dev);

 void ipoib_send(struct net_device *dev, struct sk_buff *skb,
-		struct ipoib_ah *address, u32 qpn);
+		struct ipoib_ah *address, u32 dqpn);
 void ipoib_reap_ah(struct work_struct *work);

 struct ipoib_path *__path_find(struct net_device *dev, void *gid);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 9d4f1b456ec4..b70a96cade9a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -513,7 +513,7 @@ void ipoib_send_comp_handler(struct ib_cq *cq, void *dev_ptr)

 static inline int post_send(struct ipoib_dev_priv *priv,
 			    unsigned int wr_id,
-			    struct ib_ah *address, u32 qpn,
+			    struct ib_ah *address, u32 dqpn,
 			    struct ipoib_tx_buf *tx_req,
 			    void *head, int hlen)
 {
@@ -523,7 +523,7 @@ static inline int post_send(struct ipoib_dev_priv *priv,
 	ipoib_build_sge(priv, tx_req);

 	priv->tx_wr.wr.wr_id	= wr_id;
-	priv->tx_wr.remote_qpn	= qpn;
+	priv->tx_wr.remote_qpn	= dqpn;
 	priv->tx_wr.ah		= address;

 	if (head) {
@@ -538,7 +538,7 @@ static inline int post_send(struct ipoib_dev_priv *priv,
 }

 void ipoib_send(struct net_device *dev, struct sk_buff *skb,
-		struct ipoib_ah *address, u32 qpn)
+		struct ipoib_ah *address, u32 dqpn)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_tx_buf *tx_req;
@@ -586,8 +586,9 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 		}
 	}

-	ipoib_dbg_data(priv, "sending packet, length=%d address=%p qpn=0x%06x\n",
-		       skb->len, address, qpn);
+	ipoib_dbg_data(priv,
+		       "sending packet, length=%d address=%p dqpn=0x%06x\n",
+		       skb->len, address, dqpn);

 	/*
 	 * We put the skb into the tx_ring _before_ we call post_send()
@@ -620,7 +621,7 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	skb_dst_drop(skb);

 	rc = post_send(priv, priv->tx_head & (ipoib_sendq_size - 1),
-		       address->ah, qpn, tx_req, phead, hlen);
+		       address->ah, dqpn, tx_req, phead, hlen);
 	if (unlikely(rc)) {
 		ipoib_warn(priv, "post_send failed, error %d\n", rc);
 		++dev->stats.tx_errors;
--
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
