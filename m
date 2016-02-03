From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/7] IB/rdmavt: Add Mem affinity support
Date: Wed, 03 Feb 2016 14:14:54 -0800
Message-ID: <20160203221450.1765.8312.stgit@scvm10.sc.intel.com>
References: <20160203221136.1765.8947.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203221136.1765.8947.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change verbs memory allocations to the device numa node.  This keeps memory
close to the device for optimal performance.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mmap.c |    2 +-
 drivers/infiniband/sw/rdmavt/mr.c   |    2 +-
 drivers/infiniband/sw/rdmavt/qp.c   |   21 ++++++++++++---------
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
index d6330d7..49180c4 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.c
+++ b/drivers/infiniband/sw/rdmavt/mmap.c
@@ -157,7 +157,7 @@ struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
 {
 	struct rvt_mmap_info *ip;
 
-	ip = kmalloc(sizeof(*ip), GFP_KERNEL);
+	ip = kmalloc_node(sizeof(*ip), GFP_KERNEL, rdi->dparms.node);
 	if (!ip)
 		return ip;
 
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index ee36be3..8bff6bb 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -87,7 +87,7 @@ int rvt_driver_mr_init(struct rvt_dev_info *rdi)
 	}
 	lk_tab_size = rdi->lkey_table.max * sizeof(*rdi->lkey_table.table);
 	rdi->lkey_table.table = (struct rvt_mregion __rcu **)
-			       vmalloc(lk_tab_size);
+			       vmalloc_node(lk_tab_size, rdi->dparms.node);
 	if (!rdi->lkey_table.table)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 34c92c0..a2fed05 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -186,7 +186,8 @@ int rvt_driver_qp_init(struct rvt_dev_info *rdi)
 		return -EINVAL;
 
 	/* allocate parent object */
-	rdi->qp_dev = kzalloc(sizeof(*rdi->qp_dev), GFP_KERNEL);
+	rdi->qp_dev = kzalloc_node(sizeof(*rdi->qp_dev), GFP_KERNEL,
+				   rdi->dparms.node);
 	if (!rdi->qp_dev)
 		return -ENOMEM;
 
@@ -194,9 +195,9 @@ int rvt_driver_qp_init(struct rvt_dev_info *rdi)
 	rdi->qp_dev->qp_table_size = rdi->dparms.qp_table_size;
 	rdi->qp_dev->qp_table_bits = ilog2(rdi->dparms.qp_table_size);
 	rdi->qp_dev->qp_table =
-		kmalloc(rdi->qp_dev->qp_table_size *
-			sizeof(*rdi->qp_dev->qp_table),
-			GFP_KERNEL);
+		kmalloc_node(rdi->qp_dev->qp_table_size *
+			     sizeof(*rdi->qp_dev->qp_table),
+			     GFP_KERNEL, rdi->dparms.node);
 	if (!rdi->qp_dev->qp_table)
 		goto no_qp_table;
 
@@ -542,8 +543,9 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 				(init_attr->cap.max_send_wr + 1) * sz,
 				gfp, PAGE_KERNEL);
 		else
-			swq = vmalloc(
-				(init_attr->cap.max_send_wr + 1) * sz);
+			swq = vmalloc_node(
+				(init_attr->cap.max_send_wr + 1) * sz,
+				rdi->dparms.node);
 		if (!swq)
 			return ERR_PTR(-ENOMEM);
 
@@ -558,7 +560,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		} else if (init_attr->cap.max_recv_sge > 1)
 			sg_list_sz = sizeof(*qp->r_sg_list) *
 				(init_attr->cap.max_recv_sge - 1);
-		qp = kzalloc(sz + sg_list_sz, gfp);
+		qp = kzalloc_node(sz + sg_list_sz, gfp, rdi->dparms.node);
 		if (!qp)
 			goto bail_swq;
 
@@ -592,9 +594,10 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 						qp->r_rq.size * sz,
 						gfp, PAGE_KERNEL);
 			else
-				qp->r_rq.wq = vmalloc(
+				qp->r_rq.wq = vmalloc_node(
 						sizeof(struct rvt_rwq) +
-						qp->r_rq.size * sz);
+						qp->r_rq.size * sz,
+						rdi->dparms.node);
 			if (!qp->r_rq.wq)
 				goto bail_driver_priv;
 		}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
