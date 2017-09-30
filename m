From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/5] i40iw: Fix port number for query QP
Date: Fri, 29 Sep 2017 20:29:42 -0500
Message-ID: <20170930012942.9128-6-shiraz.saleem@intel.com>
References: <20170930012942.9128-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170930012942.9128-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Port number 0 is an invalid port number. Set it to 1
as there is one port per i40iw device.

Fixes: d37498417947 ("i40iw: add files for iwarp interface")
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 58d815f..5c60de6 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -826,12 +826,14 @@ static int i40iw_query_qp(struct ib_qp *ibqp,
 	attr->cap.max_inline_data = I40IW_MAX_INLINE_DATA_SIZE;
 	attr->cap.max_send_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
 	attr->cap.max_recv_sge = I40IW_MAX_WQ_FRAGMENT_COUNT;
+	attr->port_num = 1;
 	init_attr->event_handler = iwqp->ibqp.event_handler;
 	init_attr->qp_context = iwqp->ibqp.qp_context;
 	init_attr->send_cq = iwqp->ibqp.send_cq;
 	init_attr->recv_cq = iwqp->ibqp.recv_cq;
 	init_attr->srq = iwqp->ibqp.srq;
 	init_attr->cap = attr->cap;
+	init_attr->port_num = 1;
 	return 0;
 }
 
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
