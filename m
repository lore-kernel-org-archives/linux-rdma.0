From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 08/11] RDMA/cxgb4: Centralize the wait logic.
Date: Fri, 10 Sep 2010 11:15:25 -0500
Message-ID: <20100910161525.6829.67384.stgit@build.ogc.int>
References: <20100910161442.6829.91594.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910161442.6829.91594.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c       |   64 +++++++++++++-------------------
 drivers/infiniband/hw/cxgb4/cq.c       |   18 +--------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   57 ++++++++++++++++++++---------
 drivers/infiniband/hw/cxgb4/mem.c      |    9 +----
 drivers/infiniband/hw/cxgb4/qp.c       |   35 +++---------------
 5 files changed, 72 insertions(+), 111 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 0227c13..5547b49 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -252,7 +252,7 @@ static void *alloc_ep(int size, gfp_t gfp)
 	if (epc) {
 		kref_init(&epc->kref);
 		spin_lock_init(&epc->lock);
-		init_waitqueue_head(&epc->waitq);
+		c4iw_init_wr_wait(&epc->wr_wait);
 	}
 	PDBG("%s alloc ep %p\n", __func__, epc);
 	return epc;
@@ -1213,9 +1213,9 @@ static int pass_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	}
 	PDBG("%s ep %p status %d error %d\n", __func__, ep,
 	     rpl->status, status2errno(rpl->status));
-	ep->com.rpl_err = status2errno(rpl->status);
-	ep->com.rpl_done = 1;
-	wake_up(&ep->com.waitq);
+	ep->com.wr_wait.ret = status2errno(rpl->status);
+	ep->com.wr_wait.done = 1;
+	wake_up(&ep->com.wr_wait.wait);
 
 	return 0;
 }
@@ -1249,9 +1249,9 @@ static int close_listsrv_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	struct c4iw_listen_ep *ep = lookup_stid(t, stid);
 
 	PDBG("%s ep %p\n", __func__, ep);
-	ep->com.rpl_err = status2errno(rpl->status);
-	ep->com.rpl_done = 1;
-	wake_up(&ep->com.waitq);
+	ep->com.wr_wait.ret = status2errno(rpl->status);
+	ep->com.wr_wait.done = 1;
+	wake_up(&ep->com.wr_wait.wait);
 	return 0;
 }
 
@@ -1507,17 +1507,17 @@ static int peer_close(struct c4iw_dev *dev, struct sk_buff *skb)
 		 * in rdma connection migration (see c4iw_accept_cr()).
 		 */
 		__state_set(&ep->com, CLOSING);
-		ep->com.rpl_done = 1;
-		ep->com.rpl_err = -ECONNRESET;
+		ep->com.wr_wait.done = 1;
+		ep->com.wr_wait.ret = -ECONNRESET;
 		PDBG("waking up ep %p tid %u\n", ep, ep->hwtid);
-		wake_up(&ep->com.waitq);
+		wake_up(&ep->com.wr_wait.wait);
 		break;
 	case MPA_REP_SENT:
 		__state_set(&ep->com, CLOSING);
-		ep->com.rpl_done = 1;
-		ep->com.rpl_err = -ECONNRESET;
+		ep->com.wr_wait.done = 1;
+		ep->com.wr_wait.ret = -ECONNRESET;
 		PDBG("waking up ep %p tid %u\n", ep, ep->hwtid);
-		wake_up(&ep->com.waitq);
+		wake_up(&ep->com.wr_wait.wait);
 		break;
 	case FPDU_MODE:
 		start_ep_timer(ep);
@@ -1605,10 +1605,10 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 		connect_reply_upcall(ep, -ECONNRESET);
 		break;
 	case MPA_REP_SENT:
-		ep->com.rpl_done = 1;
-		ep->com.rpl_err = -ECONNRESET;
+		ep->com.wr_wait.done = 1;
+		ep->com.wr_wait.ret = -ECONNRESET;
 		PDBG("waking up ep %p\n", ep);
-		wake_up(&ep->com.waitq);
+		wake_up(&ep->com.wr_wait.wait);
 		break;
 	case MPA_REQ_RCVD:
 
@@ -1618,10 +1618,10 @@ static int peer_abort(struct c4iw_dev *dev, struct sk_buff *skb)
 		 * rejects the CR. Also wake up anyone waiting
 		 * in rdma connection migration (see c4iw_accept_cr()).
 		 */
-		ep->com.rpl_done = 1;
-		ep->com.rpl_err = -ECONNRESET;
+		ep->com.wr_wait.done = 1;
+		ep->com.wr_wait.ret = -ECONNRESET;
 		PDBG("waking up ep %p tid %u\n", ep, ep->hwtid);
-		wake_up(&ep->com.waitq);
+		wake_up(&ep->com.wr_wait.wait);
 		break;
 	case MORIBUND:
 	case CLOSING:
@@ -2043,6 +2043,7 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 	}
 
 	state_set(&ep->com, LISTEN);
+	c4iw_init_wr_wait(&ep->com.wr_wait);
 	err = cxgb4_create_server(ep->com.dev->rdev.lldi.ports[0], ep->stid,
 				  ep->com.local_addr.sin_addr.s_addr,
 				  ep->com.local_addr.sin_port,
@@ -2051,15 +2052,8 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 		goto fail3;
 
 	/* wait for pass_open_rpl */
-	wait_event_timeout(ep->com.waitq, ep->com.rpl_done, C4IW_WR_TO);
-	if (ep->com.rpl_done)
-		err = ep->com.rpl_err;
-	else {
-		printk(KERN_ERR MOD "Device %s not responding!\n",
-		       pci_name(ep->com.dev->rdev.lldi.pdev));
-		ep->com.dev->rdev.flags = T4_FATAL_ERROR;
-		err = -EIO;
-	}
+	err = c4iw_wait_for_reply(&ep->com.dev->rdev, &ep->com.wr_wait, 0, 0,
+				  __func__);
 	if (!err) {
 		cm_id->provider_data = ep;
 		goto out;
@@ -2083,20 +2077,12 @@ int c4iw_destroy_listen(struct iw_cm_id *cm_id)
 
 	might_sleep();
 	state_set(&ep->com, DEAD);
-	ep->com.rpl_done = 0;
-	ep->com.rpl_err = 0;
+	c4iw_init_wr_wait(&ep->com.wr_wait);
 	err = listen_stop(ep);
 	if (err)
 		goto done;
-	wait_event_timeout(ep->com.waitq, ep->com.rpl_done, C4IW_WR_TO);
-	if (ep->com.rpl_done)
-		err = ep->com.rpl_err;
-	else {
-		printk(KERN_ERR MOD "Device %s not responding!\n",
-		       pci_name(ep->com.dev->rdev.lldi.pdev));
-		ep->com.dev->rdev.flags = T4_FATAL_ERROR;
-		err = -EIO;
-	}
+	err = c4iw_wait_for_reply(&ep->com.dev->rdev, &ep->com.wr_wait, 0, 0,
+				  __func__);
 	cxgb4_free_stid(ep->com.dev->rdev.lldi.tids, ep->stid, PF_INET);
 done:
 	cm_id->rem_ref(cm_id);
diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index d902ed7..1da710e 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -64,14 +64,7 @@ static int destroy_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	c4iw_init_wr_wait(&wr_wait);
 	ret = c4iw_ofld_send(rdev, skb);
 	if (!ret) {
-		wait_event_timeout(wr_wait.wait, wr_wait.done, C4IW_WR_TO);
-		if (!wr_wait.done) {
-			printk(KERN_ERR MOD "Device %s not responding!\n",
-			       pci_name(rdev->lldi.pdev));
-			rdev->flags = T4_FATAL_ERROR;
-			ret = -EIO;
-		} else
-			ret = wr_wait.ret;
+		ret = c4iw_wait_for_reply(rdev, &wr_wait, 0, 0, __func__);
 	}
 
 	kfree(cq->sw_queue);
@@ -157,14 +150,7 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	if (ret)
 		goto err4;
 	PDBG("%s wait_event wr_wait %p\n", __func__, &wr_wait);
-	wait_event_timeout(wr_wait.wait, wr_wait.done, C4IW_WR_TO);
-	if (!wr_wait.done) {
-		printk(KERN_ERR MOD "Device %s not responding!\n",
-		       pci_name(rdev->lldi.pdev));
-		rdev->flags = T4_FATAL_ERROR;
-		ret = -EIO;
-	} else
-		ret = wr_wait.ret;
+	ret = c4iw_wait_for_reply(rdev, &wr_wait, 0, 0, __func__);
 	if (ret)
 		goto err4;
 
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index ed459b8..7780116 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -79,21 +79,6 @@ static inline void *cplhdr(struct sk_buff *skb)
 	return skb->data;
 }
 
-#define C4IW_WR_TO (10*HZ)
-
-struct c4iw_wr_wait {
-	wait_queue_head_t wait;
-	int done;
-	int ret;
-};
-
-static inline void c4iw_init_wr_wait(struct c4iw_wr_wait *wr_waitp)
-{
-	wr_waitp->ret = 0;
-	wr_waitp->done = 0;
-	init_waitqueue_head(&wr_waitp->wait);
-}
-
 struct c4iw_resource {
 	struct kfifo tpt_fifo;
 	spinlock_t tpt_fifo_lock;
@@ -141,6 +126,44 @@ static inline int c4iw_num_stags(struct c4iw_rdev *rdev)
 	return min((int)T4_MAX_NUM_STAG, (int)(rdev->lldi.vr->stag.size >> 5));
 }
 
+#define C4IW_WR_TO (10*HZ)
+
+struct c4iw_wr_wait {
+	wait_queue_head_t wait;
+	int done;
+	int ret;
+};
+
+static inline void c4iw_init_wr_wait(struct c4iw_wr_wait *wr_waitp)
+{
+	wr_waitp->ret = 0;
+	wr_waitp->done = 0;
+	init_waitqueue_head(&wr_waitp->wait);
+}
+
+static inline int c4iw_wait_for_reply(struct c4iw_rdev *rdev,
+				 struct c4iw_wr_wait *wr_waitp,
+				 u32 hwtid, u32 qpid,
+				 const char *func)
+{
+	unsigned to = C4IW_WR_TO;
+	do {
+
+		wait_event_timeout(wr_waitp->wait, wr_waitp->done, to);
+		if (!wr_waitp->done) {
+			printk(KERN_ERR MOD "%s - Device %s not responding - "
+			       "tid %u qpid %u\n", func,
+			       pci_name(rdev->lldi.pdev), hwtid, qpid);
+			to = to << 2;
+		}
+	} while (!wr_waitp->done);
+	if (wr_waitp->ret)
+		printk(KERN_WARNING MOD "%s: FW reply %d tid %u qpid %u\n",
+		       pci_name(rdev->lldi.pdev), wr_waitp->ret, hwtid, qpid);
+	return wr_waitp->ret;
+}
+
+
 struct c4iw_dev {
 	struct ib_device ibdev;
 	struct c4iw_rdev rdev;
@@ -582,9 +605,7 @@ struct c4iw_ep_common {
 	spinlock_t lock;
 	struct sockaddr_in local_addr;
 	struct sockaddr_in remote_addr;
-	wait_queue_head_t waitq;
-	int rpl_done;
-	int rpl_err;
+	struct c4iw_wr_wait wr_wait;
 	unsigned long flags;
 };
 
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 269373a..1cbc56f 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -103,14 +103,7 @@ static int write_adapter_mem(struct c4iw_rdev *rdev, u32 addr, u32 len,
 		len -= C4IW_MAX_INLINE_SIZE;
 	}
 
-	wait_event_timeout(wr_wait.wait, wr_wait.done, C4IW_WR_TO);
-	if (!wr_wait.done) {
-		printk(KERN_ERR MOD "Device %s not responding!\n",
-		       pci_name(rdev->lldi.pdev));
-		rdev->flags = T4_FATAL_ERROR;
-		ret = -EIO;
-	} else
-		ret = wr_wait.ret;
+	ret = c4iw_wait_for_reply(rdev, &wr_wait, 0, 0, __func__);
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 7756d44..ee785e2 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -198,14 +198,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	ret = c4iw_ofld_send(rdev, skb);
 	if (ret)
 		goto err7;
-	wait_event_timeout(wr_wait.wait, wr_wait.done, C4IW_WR_TO);
-	if (!wr_wait.done) {
-		printk(KERN_ERR MOD "Device %s not responding!\n",
-		       pci_name(rdev->lldi.pdev));
-		rdev->flags = T4_FATAL_ERROR;
-		ret = -EIO;
-	} else
-		ret = wr_wait.ret;
+	ret = c4iw_wait_for_reply(rdev, &wr_wait, 0, wq->sq.qid, __func__);
 	if (ret)
 		goto err7;
 
@@ -997,20 +990,8 @@ static int rdma_fini(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 	if (ret)
 		goto out;
 
-	wait_event_timeout(wr_wait.wait, wr_wait.done, C4IW_WR_TO);
-	if (!wr_wait.done) {
-		printk(KERN_ERR MOD "Device %s not responding!\n",
-		       pci_name(rhp->rdev.lldi.pdev));
-		rhp->rdev.flags = T4_FATAL_ERROR;
-		ret = -EIO;
-	} else {
-		ret = wr_wait.ret;
-		if (ret)
-			printk(KERN_WARNING MOD
-			       "%s: Abnormal close qpid %d ret %u\n",
-			       pci_name(rhp->rdev.lldi.pdev), qhp->wq.sq.qid,
-			       ret);
-	}
+	ret = c4iw_wait_for_reply(&rhp->rdev, &wr_wait, qhp->ep->hwtid,
+			     qhp->wq.sq.qid, __func__);
 out:
 	PDBG("%s ret %d\n", __func__, ret);
 	return ret;
@@ -1106,14 +1087,8 @@ static int rdma_init(struct c4iw_dev *rhp, struct c4iw_qp *qhp)
 	if (ret)
 		goto out;
 
-	wait_event_timeout(wr_wait.wait, wr_wait.done, C4IW_WR_TO);
-	if (!wr_wait.done) {
-		printk(KERN_ERR MOD "Device %s not responding!\n",
-		       pci_name(rhp->rdev.lldi.pdev));
-		rhp->rdev.flags = T4_FATAL_ERROR;
-		ret = -EIO;
-	} else
-		ret = wr_wait.ret;
+	ret = c4iw_wait_for_reply(&rhp->rdev, &wr_wait, qhp->ep->hwtid,
+			     qhp->wq.sq.qid, __func__);
 out:
 	PDBG("%s ret %d\n", __func__, ret);
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
