From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 5/5] i40iw: Free IEQ resources
Date: Thu, 11 Jan 2018 18:10:54 -0600
Message-ID: <20180112001054.15572-6-shiraz.saleem@intel.com>
References: <20180112001054.15572-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112001054.15572-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The iWARP Exception Queue (IEQ) resources are not freed when a
QP is destroyed. Fix this by freeing IEQ resources when
freeing QP resources.

Fixes: d37498417947 ("i40iw: add files for iwarp interface")
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_puda.c  | 3 +--
 drivers/infiniband/hw/i40iw/i40iw_puda.h  | 1 +
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index f64b670..4c21197 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -48,7 +48,6 @@ static void i40iw_ieq_tx_compl(struct i40iw_sc_vsi *vsi, void *sqwrid);
 static void i40iw_ilq_putback_rcvbuf(struct i40iw_sc_qp *qp, u32 wqe_idx);
 static enum i40iw_status_code i40iw_puda_replenish_rq(struct i40iw_puda_rsrc
 						      *rsrc, bool initial);
-static void i40iw_ieq_cleanup_qp(struct i40iw_puda_rsrc *ieq, struct i40iw_sc_qp *qp);
 /**
  * i40iw_puda_get_listbuf - get buffer from puda list
  * @list: list to use for buffers (ILQ or IEQ)
@@ -1483,7 +1482,7 @@ static void i40iw_ieq_tx_compl(struct i40iw_sc_vsi *vsi, void *sqwrid)
  * @ieq: ieq resource
  * @qp: all pending fpdu buffers
  */
-static void i40iw_ieq_cleanup_qp(struct i40iw_puda_rsrc *ieq, struct i40iw_sc_qp *qp)
+void i40iw_ieq_cleanup_qp(struct i40iw_puda_rsrc *ieq, struct i40iw_sc_qp *qp)
 {
 	struct i40iw_puda_buf *buf;
 	struct i40iw_pfpdu *pfpdu = &qp->pfpdu;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.h b/drivers/infiniband/hw/i40iw/i40iw_puda.h
index 660aa3e..53a7d58c 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.h
@@ -184,4 +184,5 @@ enum i40iw_status_code i40iw_cqp_qp_create_cmd(struct i40iw_sc_dev *dev, struct
 enum i40iw_status_code i40iw_cqp_cq_create_cmd(struct i40iw_sc_dev *dev, struct i40iw_sc_cq *cq);
 void i40iw_cqp_qp_destroy_cmd(struct i40iw_sc_dev *dev, struct i40iw_sc_qp *qp);
 void i40iw_cqp_cq_destroy_cmd(struct i40iw_sc_dev *dev, struct i40iw_sc_cq *cq);
+void i40iw_ieq_cleanup_qp(struct i40iw_puda_rsrc *ieq, struct i40iw_sc_qp *qp);
 #endif
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index fdc1a38..70024e8 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -412,6 +412,7 @@ void i40iw_free_qp_resources(struct i40iw_device *iwdev,
 {
 	struct i40iw_pbl *iwpbl = &iwqp->iwpbl;
 
+	i40iw_ieq_cleanup_qp(iwdev->vsi.ieq, &iwqp->sc_qp);
 	i40iw_dealloc_push_page(iwdev, &iwqp->sc_qp);
 	if (qp_num)
 		i40iw_free_resource(iwdev, iwdev->allocated_qps, qp_num);
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
