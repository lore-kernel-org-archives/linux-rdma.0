From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Use ib_drain_qp instead of ib_drain_rq in ib_srp
Date: Tue, 6 Dec 2016 17:04:34 -0800
Message-ID: <67507993-487f-d1fd-8a1d-76d8faa7cb96@sandisk.com>
References: <fa2d38be-bc59-5120-6dfd-f24ab01d6d8f@mellanox.com>
 <b2a1ed73-fb4c-07a5-c343-389bdc29501c@sandisk.com>
 <7ec8b32c-f813-5a86-b7e9-b1272bc28b2c@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------E09BB04A1063AF619CDB561D"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7ec8b32c-f813-5a86-b7e9-b1272bc28b2c-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--------------E09BB04A1063AF619CDB561D
Content-Type: text/plain; charset="windows-1255"
Content-Transfer-Encoding: 7bit

On 12/06/2016 02:01 AM, Max Gurtovoy wrote:
> I understand why the beacon/drain is needed but I'm wondering if it's
> enough draining only the recv_q/send_q of the qp.
> These are 2 separate queues in the qp so receiving the beacon on the
> recv_q, In theory doesn't ensure the all the send_q elements flushed.
> Moreover if the cq is different for recv/send queues.
> I can't prove it currently but I think I saw these happens when
> developing iSER over FreeBSD (It was long time ago so it might have
> happend because we posted stuff after posting the beacon).
> In the current implementation we can't drain with IB_POLL_DIRECT ctx
> (like srp send_cq) but we might think of implementation that can enable
> it if needed.

Hello Max,

Do you agree with the approach of the attached two patches?

Thanks,

Bart.

--------------E09BB04A1063AF619CDB561D
Content-Type: text/x-patch;
	name="0001-IB-Introduce-ib_set_cq_poll_context.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-IB-Introduce-ib_set_cq_poll_context.patch"

>From c2d548d4c0bddafe38a3d75da16e3ac5789356b2 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Date: Tue, 6 Dec 2016 08:49:01 -0800
Subject: [PATCH 1/2] IB: Introduce ib_set_cq_poll_context()

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/core/cq.c | 66 +++++++++++++++++++++++++++++++-------------
 include/rdma/ib_verbs.h      |  1 +
 2 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index a754fc727de5..89ec5af63c5f 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -111,6 +111,50 @@ static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
 }
 
 /**
+ * ib_set_cq_poll_context() - set CQ polling context
+ * @cq:		completion queue pointer.
+ * @poll_ctx:	context to poll the CQ from.
+ *
+ * Notes:
+ * - Changing the polling context is only allowed if the current context
+ *   is %IB_POLL_DIRECT.
+ * - The caller must ensure that no other context is concurrently calling
+ *   ib_poll_cq().
+ */
+int ib_set_cq_poll_context(struct ib_cq *cq, enum ib_poll_context poll_ctx)
+{
+	int ret = -EINVAL;
+
+	if (cq->poll_ctx != IB_POLL_DIRECT)
+		goto out;
+
+	cq->poll_ctx = poll_ctx;
+	switch (cq->poll_ctx) {
+	case IB_POLL_DIRECT:
+		cq->comp_handler = ib_cq_completion_direct;
+		break;
+	case IB_POLL_SOFTIRQ:
+		cq->comp_handler = ib_cq_completion_softirq;
+		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
+		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+		break;
+	case IB_POLL_WORKQUEUE:
+		cq->comp_handler = ib_cq_completion_workqueue;
+		INIT_WORK(&cq->work, ib_cq_poll_work);
+		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+		break;
+	default:
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL(ib_set_cq_poll_context);
+
+/**
  * ib_alloc_cq - allocate a completion queue
  * @dev:		device to allocate the CQ for
  * @private:		driver private data, accessible from cq->cq_context
@@ -141,32 +185,16 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 	cq->uobject = NULL;
 	cq->event_handler = NULL;
 	cq->cq_context = private;
-	cq->poll_ctx = poll_ctx;
+	cq->poll_ctx = IB_POLL_DIRECT;
 	atomic_set(&cq->usecnt, 0);
 
 	cq->wc = kmalloc_array(IB_POLL_BATCH, sizeof(*cq->wc), GFP_KERNEL);
 	if (!cq->wc)
 		goto out_destroy_cq;
 
-	switch (cq->poll_ctx) {
-	case IB_POLL_DIRECT:
-		cq->comp_handler = ib_cq_completion_direct;
-		break;
-	case IB_POLL_SOFTIRQ:
-		cq->comp_handler = ib_cq_completion_softirq;
-
-		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
-		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-		break;
-	case IB_POLL_WORKQUEUE:
-		cq->comp_handler = ib_cq_completion_workqueue;
-		INIT_WORK(&cq->work, ib_cq_poll_work);
-		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-		break;
-	default:
-		ret = -EINVAL;
+	ret = ib_set_cq_poll_context(cq, poll_ctx);
+	if (ret)
 		goto out_free_wc;
-	}
 
 	return cq;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index de7e13e31b57..e45263ca7f92 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2751,6 +2751,7 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 		int nr_cqe, int comp_vector, enum ib_poll_context poll_ctx);
 void ib_free_cq(struct ib_cq *cq);
 int ib_process_cq_direct(struct ib_cq *cq, int budget);
+int ib_set_cq_poll_context(struct ib_cq *cq, enum ib_poll_context poll_ctx);
 
 /**
  * ib_create_cq - Creates a CQ on the specified device.
-- 
2.11.0


--------------E09BB04A1063AF619CDB561D--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
