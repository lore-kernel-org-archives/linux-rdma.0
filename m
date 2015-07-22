From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 03/10] IB/ipoib: Remove ib_get_dma_mr calls
Date: Wed, 22 Jul 2015 17:34:36 -0600
Message-ID: <1437608083-22898-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437608083-22898-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Zach Brown <zach.brown-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The pd now has a local_dma_lkey member which completely replaces
ib_get_dma_mr, use it instead.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h       |  1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c | 18 +++---------------
 3 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index bd94b0a6e9e5..731e540a37df 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -342,7 +342,6 @@ struct ipoib_dev_priv {
 	u16		  pkey;
 	u16		  pkey_index;
 	struct ib_pd	 *pd;
-	struct ib_mr	 *mr;
 	struct ib_cq	 *recv_cq;
 	struct ib_cq	 *send_cq;
 	struct ib_qp	 *qp;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index cf32a778e7d0..d1c217403c6d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -332,7 +332,7 @@ static void ipoib_cm_init_rx_wr(struct net_device *dev,
 	int i;
 
 	for (i = 0; i < priv->cm.num_frags; ++i)
-		sge[i].lkey = priv->mr->lkey;
+		sge[i].lkey = priv->pd->local_dma_lkey;
 
 	sge[0].length = IPOIB_CM_HEAD_SIZE;
 	for (i = 1; i < priv->cm.num_frags; ++i)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 851c8219d501..8c451983d8a5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -152,12 +152,6 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 		return -ENODEV;
 	}
 
-	priv->mr = ib_get_dma_mr(priv->pd, IB_ACCESS_LOCAL_WRITE);
-	if (IS_ERR(priv->mr)) {
-		printk(KERN_WARNING "%s: ib_get_dma_mr failed\n", ca->name);
-		goto out_free_pd;
-	}
-
 	/*
 	 * the various IPoIB tasks assume they will never race against
 	 * themselves, so always use a single thread workqueue
@@ -165,7 +159,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	priv->wq = create_singlethread_workqueue("ipoib_wq");
 	if (!priv->wq) {
 		printk(KERN_WARNING "ipoib: failed to allocate device WQ\n");
-		goto out_free_mr;
+		goto out_free_pd;
 	}
 
 	size = ipoib_recvq_size + 1;
@@ -225,13 +219,13 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	priv->dev->dev_addr[3] = (priv->qp->qp_num      ) & 0xff;
 
 	for (i = 0; i < MAX_SKB_FRAGS + 1; ++i)
-		priv->tx_sge[i].lkey = priv->mr->lkey;
+		priv->tx_sge[i].lkey = priv->pd->local_dma_lkey;
 
 	priv->tx_wr.opcode	= IB_WR_SEND;
 	priv->tx_wr.sg_list	= priv->tx_sge;
 	priv->tx_wr.send_flags	= IB_SEND_SIGNALED;
 
-	priv->rx_sge[0].lkey = priv->mr->lkey;
+	priv->rx_sge[0].lkey = priv->pd->local_dma_lkey;
 
 	priv->rx_sge[0].length = IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
 	priv->rx_wr.num_sge = 1;
@@ -254,9 +248,6 @@ out_free_wq:
 	destroy_workqueue(priv->wq);
 	priv->wq = NULL;
 
-out_free_mr:
-	ib_dereg_mr(priv->mr);
-
 out_free_pd:
 	ib_dealloc_pd(priv->pd);
 
@@ -289,9 +280,6 @@ void ipoib_transport_dev_cleanup(struct net_device *dev)
 		priv->wq = NULL;
 	}
 
-	if (ib_dereg_mr(priv->mr))
-		ipoib_warn(priv, "ib_dereg_mr failed\n");
-
 	if (ib_dealloc_pd(priv->pd))
 		ipoib_warn(priv, "ib_dealloc_pd failed\n");
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
