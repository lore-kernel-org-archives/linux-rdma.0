From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 06/11] IB/rdmavt: Use correct numa node for SRQ
 allocation
Date: Mon, 18 Dec 2017 19:56:52 -0800
Message-ID: <20171219035649.2126.1625.stgit@scvm10.sc.intel.com>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219034753.2126.78386.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Normal receive queue allocation ensures that kernel receive queues
are allocated on the local numa node. Shared receive queues
do not behave the same way.

Ensure that kernel shared receive queues are allocated on the device
local node.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/srq.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/srq.c b/drivers/infiniband/sw/rdmavt/srq.c
index f7c48e9..3707952 100644
--- a/drivers/infiniband/sw/rdmavt/srq.c
+++ b/drivers/infiniband/sw/rdmavt/srq.c
@@ -90,7 +90,7 @@ struct ib_srq *rvt_create_srq(struct ib_pd *ibpd,
 	    srq_init_attr->attr.max_wr > dev->dparms.props.max_srq_wr)
 		return ERR_PTR(-EINVAL);
 
-	srq = kmalloc(sizeof(*srq), GFP_KERNEL);
+	srq = kzalloc_node(sizeof(*srq), GFP_KERNEL, dev->dparms.node);
 	if (!srq)
 		return ERR_PTR(-ENOMEM);
 
@@ -101,7 +101,10 @@ struct ib_srq *rvt_create_srq(struct ib_pd *ibpd,
 	srq->rq.max_sge = srq_init_attr->attr.max_sge;
 	sz = sizeof(struct ib_sge) * srq->rq.max_sge +
 		sizeof(struct rvt_rwqe);
-	srq->rq.wq = vmalloc_user(sizeof(struct rvt_rwq) + srq->rq.size * sz);
+	srq->rq.wq = udata ?
+		vmalloc_user(sizeof(struct rvt_rwq) + srq->rq.size * sz) :
+		vzalloc_node(sizeof(struct rvt_rwq) + srq->rq.size * sz,
+			     dev->dparms.node);
 	if (!srq->rq.wq) {
 		ret = ERR_PTR(-ENOMEM);
 		goto bail_srq;
@@ -129,16 +132,12 @@ struct ib_srq *rvt_create_srq(struct ib_pd *ibpd,
 			ret = ERR_PTR(err);
 			goto bail_ip;
 		}
-	} else {
-		srq->ip = NULL;
 	}
 
 	/*
 	 * ib_create_srq() will initialize srq->ibsrq.
 	 */
 	spin_lock_init(&srq->rq.lock);
-	srq->rq.wq->head = 0;
-	srq->rq.wq->tail = 0;
 	srq->limit = srq_init_attr->attr.srq_limit;
 
 	spin_lock(&dev->n_srqs_lock);
@@ -200,7 +199,10 @@ int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		sz = sizeof(struct rvt_rwqe) +
 			srq->rq.max_sge * sizeof(struct ib_sge);
 		size = attr->max_wr + 1;
-		wq = vmalloc_user(sizeof(struct rvt_rwq) + size * sz);
+		wq = udata ?
+			vmalloc_user(sizeof(struct rvt_rwq) + size * sz) :
+			vzalloc_node(sizeof(struct rvt_rwq) + size * sz,
+				     dev->dparms.node);
 		if (!wq)
 			return -ENOMEM;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
