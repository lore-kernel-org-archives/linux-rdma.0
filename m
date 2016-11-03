From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 17/17] IB/ipoib: Remove and fix debug prints after allocation failure
Date: Thu,  3 Nov 2016 07:02:33 +0200
Message-ID: <1478149353-12125-18-git-send-email-leon@kernel.org>
References: <1478149353-12125-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478149353-12125-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The prints after [k|v][m|z|c]alloc() functions are not needed,
because in case of failure, allocator will print their internal
error prints anyway.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   | 12 +++---------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |  5 +----
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  5 +----
 3 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 4ad297d..375af25 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -355,11 +355,8 @@ static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_i
 	int i;
 
 	rx->rx_ring = vzalloc(ipoib_recvq_size * sizeof *rx->rx_ring);
-	if (!rx->rx_ring) {
-		printk(KERN_WARNING "%s: failed to allocate CM non-SRQ ring (%d entries)\n",
-		       priv->ca->name, ipoib_recvq_size);
+	if (!rx->rx_ring)
 		return -ENOMEM;
-	}
 
 	t = kmalloc(sizeof *t, GFP_KERNEL);
 	if (!t) {
@@ -1132,11 +1129,10 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
 
 	p->tx_ring = __vmalloc(ipoib_sendq_size * sizeof *p->tx_ring,
 			       GFP_NOIO, PAGE_KERNEL);
-	if (!p->tx_ring) {
-		ipoib_warn(priv, "failed to allocate tx ring\n");
+	if (!p->tx_ring)
 		ret = -ENOMEM;
 		goto err_tx;
-	}
+
 	memset(p->tx_ring, 0, ipoib_sendq_size * sizeof *p->tx_ring);
 
 	p->qp = ipoib_cm_create_tx_qp(p->dev, p);
@@ -1549,8 +1545,6 @@ static void ipoib_cm_create_srq(struct net_device *dev, int max_sge)
 
 	priv->cm.srq_ring = vzalloc(ipoib_recvq_size * sizeof *priv->cm.srq_ring);
 	if (!priv->cm.srq_ring) {
-		printk(KERN_WARNING "%s: failed to allocate CM SRQ ring (%d entries)\n",
-		       priv->ca->name, ipoib_recvq_size);
 		ib_destroy_srq(priv->cm.srq);
 		priv->cm.srq = NULL;
 		return;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index be11d5d..43cf8b8a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -418,11 +418,8 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 			   "(status=%d, wrid=%d vend_err %x)\n",
 			   wc->status, wr_id, wc->vendor_err);
 		qp_work = kzalloc(sizeof(*qp_work), GFP_ATOMIC);
-		if (!qp_work) {
-			ipoib_warn(priv, "%s Failed alloc ipoib_qp_state_validate for qp: 0x%x\n",
-				   __func__, priv->qp->qp_num);
+		if (!qp_work)
 			return;
-		}
 
 		INIT_WORK(&qp_work->work, ipoib_qp_state_validate_work);
 		qp_work->priv = priv;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 5636fc3..423b30d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1594,11 +1594,8 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 	/* Allocate RX/TX "rings" to hold queued skbs */
 	priv->rx_ring =	kzalloc(ipoib_recvq_size * sizeof *priv->rx_ring,
 				GFP_KERNEL);
-	if (!priv->rx_ring) {
-		printk(KERN_WARNING "%s: failed to allocate RX ring (%d entries)\n",
-		       ca->name, ipoib_recvq_size);
+	if (!priv->rx_ring)
 		goto out;
-	}
 
 	priv->tx_ring = vzalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
 	if (!priv->tx_ring) {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
