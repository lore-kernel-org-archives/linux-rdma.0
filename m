From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH rfc 4/5] IB/cq: add adaptive moderation support
Date: Tue,  6 Feb 2018 00:03:15 +0200
Message-ID: <20180205220316.30236-5-sagi@grimberg.me>
References: <20180205220316.30236-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205220316.30236-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently activated via modparam, obviously we will want to
find a more generic way to control this.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/core/cq.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index f2ae75fa3128..270801d28f9d 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -25,6 +25,51 @@
 #define IB_POLL_FLAGS \
 	(IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS)
 
+#define IB_CQ_AM_NR_LEVELS	8
+#define IB_CQ_AM_NR_EVENTS	64
+
+struct ib_cq_moder {
+	u16 usec;
+	u16 comps;
+};
+
+/* XXX: magic adaptive moderation profiles */
+static const struct ib_cq_moder am_prof[IB_CQ_AM_NR_LEVELS] = {
+	{1,  1},
+	{1,  2},
+	{2,  4},
+	{4,  8},
+	{8, 16},
+	{16, 32},
+	{32, 48},
+	{32, 64},
+};
+
+static bool use_am = true;
+module_param(use_am, bool, 0444);
+MODULE_PARM_DESC(use_am, "Use cq adaptive moderation");
+
+static int ib_cq_am(struct ib_cq *cq, unsigned short level)
+{
+	u16 usec;
+	u16 comps;
+
+	if (!use_am)
+		return 0;
+
+	usec = am_prof[level].usec;
+	comps = am_prof[level].comps;
+
+	return cq->device->modify_cq(cq, comps, usec);
+}
+
+static int ib_cq_irqpoll_am(struct irq_poll *iop, unsigned short level)
+{
+	struct ib_cq *cq = container_of(iop, struct ib_cq, iop);
+
+	return ib_cq_am(cq, level);
+}
+
 static int __ib_process_cq(struct ib_cq *cq, int budget)
 {
 	int i, n, completed = 0;
@@ -162,6 +207,9 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 		cq->comp_handler = ib_cq_completion_softirq;
 
 		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
+		if (cq->device->modify_cq)
+			irq_poll_init_am(&cq->iop, IB_CQ_AM_NR_EVENTS,
+				IB_CQ_AM_NR_LEVELS, 0, ib_cq_irqpoll_am);
 		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 		break;
 	case IB_POLL_WORKQUEUE:
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
