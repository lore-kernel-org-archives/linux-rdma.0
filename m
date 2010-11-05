From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 12/49] drivers/infiniband: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:36 -0700
Message-ID: <2a6dc4ae9321aef16372b34fc65ceda93190af0a.1288925424.git.joe@perches.com>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
In-Reply-To: <cover.1288925424.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
References: <cover.1288925424.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Ralph Campbell <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/amso1100/c2_rnic.c      |    5 ++---
 drivers/infiniband/hw/ehca/ipz_pt_fn.c        |    5 ++---
 drivers/infiniband/hw/ipath/ipath_driver.c    |    3 +--
 drivers/infiniband/hw/ipath/ipath_file_ops.c  |   11 +++--------
 drivers/infiniband/hw/ipath/ipath_init_chip.c |    5 +----
 drivers/infiniband/hw/qib/qib_init.c          |    7 ++-----
 drivers/infiniband/ulp/ipoib/ipoib_cm.c       |   10 +++-------
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |    3 +--
 8 files changed, 15 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
index 85cfae4..8c81992 100644
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -459,13 +459,12 @@ int __devinit c2_rnic_init(struct c2_dev *c2dev)
 	     IB_DEVICE_MEM_WINDOW);
 
 	/* Allocate the qptr_array */
-	c2dev->qptr_array = vmalloc(C2_MAX_CQS * sizeof(void *));
+	c2dev->qptr_array = vzalloc(C2_MAX_CQS * sizeof(void *));
 	if (!c2dev->qptr_array) {
 		return -ENOMEM;
 	}
 
-	/* Inialize the qptr_array */
-	memset(c2dev->qptr_array, 0, C2_MAX_CQS * sizeof(void *));
+	/* Initialize the qptr_array */
 	c2dev->qptr_array[0] = (void *) &c2dev->req_vq;
 	c2dev->qptr_array[1] = (void *) &c2dev->rep_vq;
 	c2dev->qptr_array[2] = (void *) &c2dev->aeq;
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.c b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
index 1596e30..1898d6e 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
@@ -222,15 +222,14 @@ int ipz_queue_ctor(struct ehca_pd *pd, struct ipz_queue *queue,
 	queue->small_page = NULL;
 
 	/* allocate queue page pointers */
-	queue->queue_pages = kmalloc(nr_of_pages * sizeof(void *), GFP_KERNEL);
+	queue->queue_pages = kzalloc(nr_of_pages * sizeof(void *), GFP_KERNEL);
 	if (!queue->queue_pages) {
-		queue->queue_pages = vmalloc(nr_of_pages * sizeof(void *));
+		queue->queue_pages = vzalloc(nr_of_pages * sizeof(void *));
 		if (!queue->queue_pages) {
 			ehca_gen_err("Couldn't allocate queue page list");
 			return 0;
 		}
 	}
-	memset(queue->queue_pages, 0, nr_of_pages * sizeof(void *));
 
 	/* allocate actual queue pages */
 	if (is_small) {
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 765f0fc..6572b8c 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -199,12 +199,11 @@ static struct ipath_devdata *ipath_alloc_devdata(struct pci_dev *pdev)
 		goto bail;
 	}
 
-	dd = vmalloc(sizeof(*dd));
+	dd = vzalloc(sizeof(*dd));
 	if (!dd) {
 		dd = ERR_PTR(-ENOMEM);
 		goto bail;
 	}
-	memset(dd, 0, sizeof(*dd));
 	dd->ipath_unit = -1;
 
 	spin_lock_irqsave(&ipath_devs_lock, flags);
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 6078992..ff5c6fa 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1531,7 +1531,7 @@ static int init_subports(struct ipath_devdata *dd,
 	}
 
 	num_subports = uinfo->spu_subport_cnt;
-	pd->subport_uregbase = vmalloc(PAGE_SIZE * num_subports);
+	pd->subport_uregbase = vzalloc(PAGE_SIZE * num_subports);
 	if (!pd->subport_uregbase) {
 		ret = -ENOMEM;
 		goto bail;
@@ -1539,13 +1539,13 @@ static int init_subports(struct ipath_devdata *dd,
 	/* Note: pd->port_rcvhdrq_size isn't initialized yet. */
 	size = ALIGN(dd->ipath_rcvhdrcnt * dd->ipath_rcvhdrentsize *
 		     sizeof(u32), PAGE_SIZE) * num_subports;
-	pd->subport_rcvhdr_base = vmalloc(size);
+	pd->subport_rcvhdr_base = vzalloc(size);
 	if (!pd->subport_rcvhdr_base) {
 		ret = -ENOMEM;
 		goto bail_ureg;
 	}
 
-	pd->subport_rcvegrbuf = vmalloc(pd->port_rcvegrbuf_chunks *
+	pd->subport_rcvegrbuf = vzalloc(pd->port_rcvegrbuf_chunks *
 					pd->port_rcvegrbuf_size *
 					num_subports);
 	if (!pd->subport_rcvegrbuf) {
@@ -1557,11 +1557,6 @@ static int init_subports(struct ipath_devdata *dd,
 	pd->port_subport_id = uinfo->spu_subport_id;
 	pd->active_slaves = 1;
 	set_bit(IPATH_PORT_MASTER_UNINIT, &pd->port_flag);
-	memset(pd->subport_uregbase, 0, PAGE_SIZE * num_subports);
-	memset(pd->subport_rcvhdr_base, 0, size);
-	memset(pd->subport_rcvegrbuf, 0, pd->port_rcvegrbuf_chunks *
-				         pd->port_rcvegrbuf_size *
-				         num_subports);
 	goto bail;
 
 bail_rhdr:
diff --git a/drivers/infiniband/hw/ipath/ipath_init_chip.c b/drivers/infiniband/hw/ipath/ipath_init_chip.c
index 7769382..fef0f42 100644
--- a/drivers/infiniband/hw/ipath/ipath_init_chip.c
+++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c
@@ -442,7 +442,7 @@ static void init_shadow_tids(struct ipath_devdata *dd)
 	struct page **pages;
 	dma_addr_t *addrs;
 
-	pages = vmalloc(dd->ipath_cfgports * dd->ipath_rcvtidcnt *
+	pages = vzalloc(dd->ipath_cfgports * dd->ipath_rcvtidcnt *
 			sizeof(struct page *));
 	if (!pages) {
 		ipath_dev_err(dd, "failed to allocate shadow page * "
@@ -461,9 +461,6 @@ static void init_shadow_tids(struct ipath_devdata *dd)
 		return;
 	}
 
-	memset(pages, 0, dd->ipath_cfgports * dd->ipath_rcvtidcnt *
-	       sizeof(struct page *));
-
 	dd->ipath_pageshadow = pages;
 	dd->ipath_physshadow = addrs;
 }
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index f3b5039..953d285 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -268,23 +268,20 @@ static void init_shadow_tids(struct qib_devdata *dd)
 	struct page **pages;
 	dma_addr_t *addrs;
 
-	pages = vmalloc(dd->cfgctxts * dd->rcvtidcnt * sizeof(struct page *));
+	pages = vzalloc(dd->cfgctxts * dd->rcvtidcnt * sizeof(struct page *));
 	if (!pages) {
 		qib_dev_err(dd, "failed to allocate shadow page * "
 			    "array, no expected sends!\n");
 		goto bail;
 	}
 
-	addrs = vmalloc(dd->cfgctxts * dd->rcvtidcnt * sizeof(dma_addr_t));
+	addrs = vzalloc(dd->cfgctxts * dd->rcvtidcnt * sizeof(dma_addr_t));
 	if (!addrs) {
 		qib_dev_err(dd, "failed to allocate shadow dma handle "
 			    "array, no expected sends!\n");
 		goto bail_free;
 	}
 
-	memset(pages, 0, dd->cfgctxts * dd->rcvtidcnt * sizeof(struct page *));
-	memset(addrs, 0, dd->cfgctxts * dd->rcvtidcnt * sizeof(dma_addr_t));
-
 	dd->pageshadow = pages;
 	dd->physshadow = addrs;
 	return;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index bb10041..1e61104 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -352,15 +352,13 @@ static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_i
 	int ret;
 	int i;
 
-	rx->rx_ring = vmalloc(ipoib_recvq_size * sizeof *rx->rx_ring);
+	rx->rx_ring = vzalloc(ipoib_recvq_size * sizeof *rx->rx_ring);
 	if (!rx->rx_ring) {
 		printk(KERN_WARNING "%s: failed to allocate CM non-SRQ ring (%d entries)\n",
 		       priv->ca->name, ipoib_recvq_size);
 		return -ENOMEM;
 	}
 
-	memset(rx->rx_ring, 0, ipoib_recvq_size * sizeof *rx->rx_ring);
-
 	t = kmalloc(sizeof *t, GFP_KERNEL);
 	if (!t) {
 		ret = -ENOMEM;
@@ -1097,13 +1095,12 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
 	struct ipoib_dev_priv *priv = netdev_priv(p->dev);
 	int ret;
 
-	p->tx_ring = vmalloc(ipoib_sendq_size * sizeof *p->tx_ring);
+	p->tx_ring = vzalloc(ipoib_sendq_size * sizeof *p->tx_ring);
 	if (!p->tx_ring) {
 		ipoib_warn(priv, "failed to allocate tx ring\n");
 		ret = -ENOMEM;
 		goto err_tx;
 	}
-	memset(p->tx_ring, 0, ipoib_sendq_size * sizeof *p->tx_ring);
 
 	p->qp = ipoib_cm_create_tx_qp(p->dev, p);
 	if (IS_ERR(p->qp)) {
@@ -1520,7 +1517,7 @@ static void ipoib_cm_create_srq(struct net_device *dev, int max_sge)
 		return;
 	}
 
-	priv->cm.srq_ring = vmalloc(ipoib_recvq_size * sizeof *priv->cm.srq_ring);
+	priv->cm.srq_ring = vzalloc(ipoib_recvq_size * sizeof *priv->cm.srq_ring);
 	if (!priv->cm.srq_ring) {
 		printk(KERN_WARNING "%s: failed to allocate CM SRQ ring (%d entries)\n",
 		       priv->ca->name, ipoib_recvq_size);
@@ -1529,7 +1526,6 @@ static void ipoib_cm_create_srq(struct net_device *dev, int max_sge)
 		return;
 	}
 
-	memset(priv->cm.srq_ring, 0, ipoib_recvq_size * sizeof *priv->cm.srq_ring);
 }
 
 int ipoib_cm_dev_init(struct net_device *dev)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9ff7bc7..65e4e98 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -925,13 +925,12 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 		goto out;
 	}
 
-	priv->tx_ring = vmalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
+	priv->tx_ring = vzalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
 	if (!priv->tx_ring) {
 		printk(KERN_WARNING "%s: failed to allocate TX ring (%d entries)\n",
 		       ca->name, ipoib_sendq_size);
 		goto out_rx_ring_cleanup;
 	}
-	memset(priv->tx_ring, 0, ipoib_sendq_size * sizeof *priv->tx_ring);
 
 	/* priv->tx_head, tx_tail & tx_outstanding are already 0 */
 
-- 
1.7.3.1.g432b3.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
