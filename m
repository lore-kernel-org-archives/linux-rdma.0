From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Correct values for max_recv_sge, max_send_sge
Date: Wed,  9 Nov 2016 21:26:39 -0600
Message-ID: <20161110032639.7460-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When creating QPs, ensure init_attr->cap.max_recv_sge
is clipped to MAX_FRAG_COUNT.

Expose MAX_FRAG_COUNT for max_recv_sge and max_send_sge in
i40iw_query_qp().

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 6329c97..d06fe593 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -610,6 +610,9 @@ static struct ib_qp *i40iw_create_qp(struct ib_pd *ibpd,
 	if (init_attr->cap.max_send_sge > I40IW_MAX_WQ_FRAGMENT_COUNT)
 		init_attr->cap.max_send_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
 
+	if (init_attr->cap.max_recv_sge > I40IW_MAX_WQ_FRAGMENT_COUNT)
+		init_attr->cap.max_recv_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
+
 	memset(&init_info, 0, sizeof(init_info));
 
 	sq_size = init_attr->cap.max_send_wr;
@@ -815,8 +818,9 @@ static int i40iw_query_qp(struct ib_qp *ibqp,
 	attr->qp_access_flags = 0;
 	attr->cap.max_send_wr = qp->qp_uk.sq_size;
 	attr->cap.max_recv_wr = qp->qp_uk.rq_size;
-	attr->cap.max_recv_sge = 1;
 	attr->cap.max_inline_data = I40IW_MAX_INLINE_DATA_SIZE;
+	attr->cap.max_send_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
+	attr->cap.max_recv_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
 	init_attr->event_handler = iwqp->ibqp.event_handler;
 	init_attr->qp_context = iwqp->ibqp.qp_context;
 	init_attr->send_cq = iwqp->ibqp.send_cq;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
