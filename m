From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: don't declare wr_wait objects on the stack.
Date: Fri, 13 May 2011 13:37:27 -0500
Message-ID: <20110513183727.32157.8873.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There exists a race condition when using c4iw_wr_wait objects that are
declared on the stack.  This was being done in a few places where we are
sending work requests to the FW and awaiting replies, but we don't have
an endpoint structure with an embedded c4iw_wr_wait struct.  So the code
was allocating it locally on the stack.  Bad design. The race is this:

thread on cpuX declares the wait object on the stack, then posts
a firmware WR with that wait object ptr as the cookie to be returned
in the WR reply.  This thread will proceed to block in wait_event_timeout()
but before it does:

An interrupt runs on cpuY with the WR reply.  fw6_msg() handles this
and calls c4iw_wake_up().  c4iw_wake_up() sets the condition variable in
the c4iw_wr_wait object to TRUE and will call wake_up(), but before it
calls wake_up():

The thread on cpuX calls c4iw_wait_for_reply(), which calls
wait_event_timeout().  The wait_event_timeout() macro checks the condition
variable and returns immediately since it is TRUE.  So this thread
never blocks/sleeps. The function then returns effectively deallocating
the c4iw_wr_wait object that was on the stack.

So at this point cpuY has a pointer to the c4iw_wr_wait object that is no
longer valid.  Further its pointing to a stack frame that might now be in
use by some other context/thread.  So cpuY continues execution and calls
wake_up() on a ptr to a wait object that as been effectively deallocated.

This race, when it hits, can cause a crash in wake_up(), which I've seen
under heavy stress. It can also corrupt the referenced stack which can
cause any number of failures.

The fix:

Allocate temporary c4iw_wr_wait objects and keep references on them so that it
is never freed until both execution paths are done using it.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c       |   12 +++++++++++-
 drivers/infiniband/hw/cxgb4/cq.c       |   33 ++++++++++++++++++++++----------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   29 +++++++++++++++++++++++++++-
 drivers/infiniband/hw/cxgb4/mem.c      |   10 ++++++----
 drivers/infiniband/hw/cxgb4/qp.c       |   16 +++++++++++-----
 5 files changed, 79 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index d7ee70f..fcbc803 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -255,6 +255,13 @@ static void *alloc_ep(int size, gfp_t gfp)
 	return epc;
 }
 
+void _c4iw_free_tmp_wr_wait(struct kref *kref)
+{
+	struct c4iw_wr_wait *wr_waitp;
+	wr_waitp = container_of(kref, struct c4iw_wr_wait, kref);
+	kfree(wr_waitp);
+}
+
 void _c4iw_free_ep(struct kref *kref)
 {
 	struct c4iw_ep *ep;
@@ -2284,8 +2291,11 @@ static int fw6_msg(struct c4iw_dev *dev, struct sk_buff *skb)
 		ret = (int)((be64_to_cpu(rpl->data[0]) >> 8) & 0xff);
 		wr_waitp = (struct c4iw_wr_wait *)(__force unsigned long) rpl->data[1];
 		PDBG("%s wr_waitp %p ret %u\n", __func__, wr_waitp, ret);
-		if (wr_waitp)
+		if (wr_waitp) {
 			c4iw_wake_up(wr_waitp, ret ? -ret : 0);
+			if (wr_waitp->tmp)
+				c4iw_put_tmp_wr_wait(wr_waitp);
+		}
 		kfree_skb(skb);
 		break;
 	case 2:
diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 8d8f8ad..4fbe82e 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -38,7 +38,7 @@ static int destroy_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	struct fw_ri_res_wr *res_wr;
 	struct fw_ri_res *res;
 	int wr_len;
-	struct c4iw_wr_wait wr_wait;
+	struct c4iw_wr_wait *wr_waitp;
 	struct sk_buff *skb;
 	int ret;
 
@@ -46,6 +46,13 @@ static int destroy_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	skb = alloc_skb(wr_len, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
+
+	wr_waitp = c4iw_get_tmp_wr_wait();
+	if (!wr_waitp) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+		
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 	res_wr = (struct fw_ri_res_wr *)__skb_put(skb, wr_len);
@@ -55,16 +62,15 @@ static int destroy_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 			V_FW_RI_RES_WR_NRES(1) |
 			FW_WR_COMPL(1));
 	res_wr->len16_pkd = cpu_to_be32(DIV_ROUND_UP(wr_len, 16));
-	res_wr->cookie = (unsigned long) &wr_wait;
+	res_wr->cookie = (unsigned long) wr_waitp;
 	res = res_wr->res;
 	res->u.cq.restype = FW_RI_RES_TYPE_CQ;
 	res->u.cq.op = FW_RI_RES_OP_RESET;
 	res->u.cq.iqid = cpu_to_be32(cq->cqid);
 
-	c4iw_init_wr_wait(&wr_wait);
 	ret = c4iw_ofld_send(rdev, skb);
 	if (!ret) {
-		ret = c4iw_wait_for_reply(rdev, &wr_wait, 0, 0, __func__);
+		ret = c4iw_wait_for_reply(rdev, wr_waitp, 0, 0, __func__);
 	}
 
 	kfree(cq->sw_queue);
@@ -82,7 +88,7 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	struct fw_ri_res *res;
 	int wr_len;
 	int user = (uctx != &rdev->uctx);
-	struct c4iw_wr_wait wr_wait;
+	struct c4iw_wr_wait *wr_waitp;
 	int ret;
 	struct sk_buff *skb;
 
@@ -116,6 +122,13 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 		ret = -ENOMEM;
 		goto err4;
 	}
+
+	wr_waitp = c4iw_get_tmp_wr_wait();
+	if (!wr_waitp) {
+		ret = -ENOMEM;
+		goto err5;
+	}
+
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 	res_wr = (struct fw_ri_res_wr *)__skb_put(skb, wr_len);
@@ -125,7 +138,7 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 			V_FW_RI_RES_WR_NRES(1) |
 			FW_WR_COMPL(1));
 	res_wr->len16_pkd = cpu_to_be32(DIV_ROUND_UP(wr_len, 16));
-	res_wr->cookie = (unsigned long) &wr_wait;
+	res_wr->cookie = (unsigned long) wr_waitp;
 	res = res_wr->res;
 	res->u.cq.restype = FW_RI_RES_TYPE_CQ;
 	res->u.cq.op = FW_RI_RES_OP_WRITE;
@@ -144,13 +157,11 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	res->u.cq.iqsize = cpu_to_be16(cq->size);
 	res->u.cq.iqaddr = cpu_to_be64(cq->dma_addr);
 
-	c4iw_init_wr_wait(&wr_wait);
-
 	ret = c4iw_ofld_send(rdev, skb);
 	if (ret)
 		goto err4;
-	PDBG("%s wait_event wr_wait %p\n", __func__, &wr_wait);
-	ret = c4iw_wait_for_reply(rdev, &wr_wait, 0, 0, __func__);
+	PDBG("%s wait_event wr_wait %p\n", __func__, wr_waitp);
+	ret = c4iw_wait_for_reply(rdev, wr_waitp, 0, 0, __func__);
 	if (ret)
 		goto err4;
 
@@ -163,6 +174,8 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 		cq->ugts &= PAGE_MASK;
 	}
 	return 0;
+err5:
+	kfree_skb(skb);
 err4:
 	dma_free_coherent(&rdev->lldi.pdev->dev, cq->memsize, cq->queue,
 			  dma_unmap_addr(cq, mapping));
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 35d2a5d..63d9ca8 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -139,15 +139,39 @@ struct c4iw_wr_wait {
 	wait_queue_head_t wait;
 	unsigned long status;
 	int ret;
+	struct kref kref;
+	int tmp;
 };
 
 static inline void c4iw_init_wr_wait(struct c4iw_wr_wait *wr_waitp)
 {
+	wr_waitp->tmp = 0;
 	wr_waitp->ret = 0;
 	wr_waitp->status = 0;
 	init_waitqueue_head(&wr_waitp->wait);
 }
 
+static inline struct c4iw_wr_wait *c4iw_get_tmp_wr_wait(void)
+{
+	struct c4iw_wr_wait *wr_waitp;
+
+	wr_waitp = kmalloc(sizeof *wr_waitp, GFP_KERNEL);
+	if (wr_waitp) {
+		c4iw_init_wr_wait(wr_waitp);
+		kref_init(&wr_waitp->kref);
+		kref_get(&wr_waitp->kref);
+		wr_waitp->tmp = 1;
+	}
+	return wr_waitp;
+}
+
+void _c4iw_free_tmp_wr_wait(struct kref *kref);
+
+static inline void c4iw_put_tmp_wr_wait(struct c4iw_wr_wait *wr_waitp)
+{
+	kref_put(&wr_waitp->kref, _c4iw_free_tmp_wr_wait);
+}
+
 static inline void c4iw_wake_up(struct c4iw_wr_wait *wr_waitp, int ret)
 {
 	wr_waitp->ret = ret;
@@ -180,7 +204,10 @@ static inline int c4iw_wait_for_reply(struct c4iw_rdev *rdev,
 	if (wr_waitp->ret)
 		PDBG("%s: FW reply %d tid %u qpid %u\n",
 		     pci_name(rdev->lldi.pdev), wr_waitp->ret, hwtid, qpid);
-	return wr_waitp->ret;
+	ret = wr_waitp->ret;
+	if (wr_waitp->tmp)
+		c4iw_put_tmp_wr_wait(wr_waitp);
+	return ret;
 }
 
 struct c4iw_dev {
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 273ffe4..685928d 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -46,12 +46,14 @@ static int write_adapter_mem(struct c4iw_rdev *rdev, u32 addr, u32 len,
 	struct ulptx_idata *sc;
 	u8 wr_len, *to_dp, *from_dp;
 	int copy_len, num_wqe, i, ret = 0;
-	struct c4iw_wr_wait wr_wait;
+	struct c4iw_wr_wait *wr_waitp;
 
 	addr &= 0x7FFFFFF;
 	PDBG("%s addr 0x%x len %u\n", __func__, addr, len);
 	num_wqe = DIV_ROUND_UP(len, C4IW_MAX_INLINE_SIZE);
-	c4iw_init_wr_wait(&wr_wait);
+	wr_waitp = c4iw_get_tmp_wr_wait();
+	if (!wr_waitp)
+		return -ENOMEM;
 	for (i = 0; i < num_wqe; i++) {
 
 		copy_len = len > C4IW_MAX_INLINE_SIZE ? C4IW_MAX_INLINE_SIZE :
@@ -71,7 +73,7 @@ static int write_adapter_mem(struct c4iw_rdev *rdev, u32 addr, u32 len,
 		if (i == (num_wqe-1)) {
 			req->wr.wr_hi = cpu_to_be32(FW_WR_OP(FW_ULPTX_WR) |
 						    FW_WR_COMPL(1));
-			req->wr.wr_lo = (__force __be64)(unsigned long) &wr_wait;
+			req->wr.wr_lo = (__force __be64)(unsigned long) wr_waitp;
 		} else
 			req->wr.wr_hi = cpu_to_be32(FW_WR_OP(FW_ULPTX_WR));
 		req->wr.wr_mid = cpu_to_be32(
@@ -103,7 +105,7 @@ static int write_adapter_mem(struct c4iw_rdev *rdev, u32 addr, u32 len,
 		len -= C4IW_MAX_INLINE_SIZE;
 	}
 
-	ret = c4iw_wait_for_reply(rdev, &wr_wait, 0, 0, __func__);
+	ret = c4iw_wait_for_reply(rdev, wr_waitp, 0, 0, __func__);
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index a1824a5..d295a20 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -115,7 +115,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	struct fw_ri_res_wr *res_wr;
 	struct fw_ri_res *res;
 	int wr_len;
-	struct c4iw_wr_wait wr_wait;
+	struct c4iw_wr_wait *wr_waitp;
 	struct sk_buff *skb;
 	int ret;
 	int eqsize;
@@ -191,6 +191,12 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		ret = -ENOMEM;
 		goto err7;
 	}
+	wr_waitp = c4iw_get_tmp_wr_wait();
+	if (!wr_waitp) {
+		ret = -ENOMEM;
+		goto err8;
+	}
+		
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 	res_wr = (struct fw_ri_res_wr *)__skb_put(skb, wr_len);
@@ -200,7 +206,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 			V_FW_RI_RES_WR_NRES(2) |
 			FW_WR_COMPL(1));
 	res_wr->len16_pkd = cpu_to_be32(DIV_ROUND_UP(wr_len, 16));
-	res_wr->cookie = (unsigned long) &wr_wait;
+	res_wr->cookie = (unsigned long) wr_waitp;
 	res = res_wr->res;
 	res->u.sqrq.restype = FW_RI_RES_TYPE_SQ;
 	res->u.sqrq.op = FW_RI_RES_OP_WRITE;
@@ -250,12 +256,10 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	res->u.sqrq.eqid = cpu_to_be32(wq->rq.qid);
 	res->u.sqrq.eqaddr = cpu_to_be64(wq->rq.dma_addr);
 
-	c4iw_init_wr_wait(&wr_wait);
-
 	ret = c4iw_ofld_send(rdev, skb);
 	if (ret)
 		goto err7;
-	ret = c4iw_wait_for_reply(rdev, &wr_wait, 0, wq->sq.qid, __func__);
+	ret = c4iw_wait_for_reply(rdev, wr_waitp, 0, wq->sq.qid, __func__);
 	if (ret)
 		goto err7;
 
@@ -264,6 +268,8 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	     (unsigned long long)wq->sq.udb, (unsigned long long)wq->rq.udb);
 
 	return 0;
+err8:
+	kfree_skb(skb);
 err7:
 	dma_free_coherent(&(rdev->lldi.pdev->dev),
 			  wq->rq.memsize, wq->rq.queue,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
