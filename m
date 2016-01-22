From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 7/7] IB/rdmavt: Support creating qps with GFP_NOIO flag
Date: Fri, 22 Jan 2016 12:50:43 -0800
Message-ID: <20160122205041.4351.411.stgit@scvm10.sc.intel.com>
References: <20160122204807.4351.24569.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122204807.4351.24569.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The current code is problematic when the QP creation and ipoib is
used to support NFS and NFS desires to do IO for paging purposes.
In that case, the GFP_KERNEL allocation within create_qp causes
a deadlock in tight memory situations.

This fix adds support to create queue pair with GFP_NOIO flag for
connected mode only to cleanly fail the create queue pair in those
situations.

This was previously fixed in qib but needed to get ported to hfi1.
This patch handles that for both hardwares in the new rdmavt common
layer.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   56 ++++++++++++++++++++++++++++---------
 include/rdma/rdma_vt.h            |    5 ++-
 2 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index ee19eae..43346a7 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -53,9 +53,11 @@
 #include "qp.h"
 #include "vt.h"
 
-static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map)
+static void get_map_page(struct rvt_qpn_table *qpt,
+			 struct rvt_qpn_map *map,
+			 gfp_t gfp)
 {
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	unsigned long page = get_zeroed_page(gfp);
 
 	/*
 	 * Free the page if someone raced with us installing it.
@@ -107,7 +109,7 @@ static int init_qpn_table(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt)
 		    rdi->dparms.qpn_res_start, rdi->dparms.qpn_res_end);
 	for (i = rdi->dparms.qpn_res_start; i <= rdi->dparms.qpn_res_end; i++) {
 		if (!map->page) {
-			get_map_page(qpt, map);
+			get_map_page(qpt, map, GFP_KERNEL);
 			if (!map->page) {
 				ret = -ENOMEM;
 				break;
@@ -263,14 +265,15 @@ static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
  * zero/one for QP type IB_QPT_SMI/IB_QPT_GSI.
  */
 static int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-		     enum ib_qp_type type, u8 port)
+		     enum ib_qp_type type, u8 port, gfp_t gfp)
 {
 	u32 i, offset, max_scan, qpn;
 	struct rvt_qpn_map *map;
 	u32 ret;
 
 	if (rdi->driver_f.alloc_qpn)
-		return rdi->driver_f.alloc_qpn(rdi, qpt, type, port);
+		return rdi->driver_f.alloc_qpn(rdi, qpt, type, port,
+					       GFP_KERNEL);
 
 	if (type == IB_QPT_SMI || type == IB_QPT_GSI) {
 		unsigned n;
@@ -295,7 +298,7 @@ static int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 	max_scan = qpt->nmaps - !offset;
 	for (i = 0;;) {
 		if (unlikely(!map->page)) {
-			get_map_page(qpt, map);
+			get_map_page(qpt, map, gfp);
 			if (unlikely(!map->page))
 				break;
 		}
@@ -437,15 +440,25 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 	struct ib_qp *ret = ERR_PTR(-ENOMEM);
 	struct rvt_dev_info *rdi = ib_to_rvt(ibpd->device);
 	void *priv = NULL;
+	gfp_t gfp;
 
 	if (!rdi)
 		return ERR_PTR(-EINVAL);
 
 	if (init_attr->cap.max_send_sge > rdi->dparms.props.max_sge ||
 	    init_attr->cap.max_send_wr > rdi->dparms.props.max_qp_wr ||
-	    init_attr->create_flags)
+	    init_attr->create_flags & ~(IB_QP_CREATE_USE_GFP_NOIO))
 		return ERR_PTR(-EINVAL);
 
+	/* GFP_NOIO is applicable to RC QP's only */
+
+	if (init_attr->create_flags & IB_QP_CREATE_USE_GFP_NOIO &&
+	    init_attr->qp_type != IB_QPT_RC)
+		return ERR_PTR(-EINVAL);
+
+	gfp = init_attr->create_flags & IB_QP_CREATE_USE_GFP_NOIO ?
+						GFP_NOIO : GFP_KERNEL;
+
 	/* Check receive queue parameters if no SRQ is specified. */
 	if (!init_attr->srq) {
 		if (init_attr->cap.max_recv_sge > rdi->dparms.props.max_sge ||
@@ -471,7 +484,13 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		sz = sizeof(struct rvt_sge) *
 			init_attr->cap.max_send_sge +
 			sizeof(struct rvt_swqe);
-		swq = vmalloc((init_attr->cap.max_send_wr + 1) * sz);
+		if (gfp == GFP_NOIO)
+			swq = __vmalloc(
+				(init_attr->cap.max_send_wr + 1) * sz,
+				gfp, PAGE_KERNEL);
+		else
+			swq = vmalloc(
+				(init_attr->cap.max_send_wr + 1) * sz);
 		if (!swq)
 			return ERR_PTR(-ENOMEM);
 
@@ -486,7 +505,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		} else if (init_attr->cap.max_recv_sge > 1)
 			sg_list_sz = sizeof(*qp->r_sg_list) *
 				(init_attr->cap.max_recv_sge - 1);
-		qp = kzalloc(sz + sg_list_sz, GFP_KERNEL);
+		qp = kzalloc(sz + sg_list_sz, gfp);
 		if (!qp)
 			goto bail_swq;
 
@@ -496,7 +515,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		 * Driver needs to set up it's private QP structure and do any
 		 * initialization that is needed.
 		 */
-		priv = rdi->driver_f.qp_priv_alloc(rdi, qp);
+		priv = rdi->driver_f.qp_priv_alloc(rdi, qp, gfp);
 		if (!priv)
 			goto bail_qp;
 		qp->priv = priv;
@@ -510,8 +529,19 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 			qp->r_rq.max_sge = init_attr->cap.max_recv_sge;
 			sz = (sizeof(struct ib_sge) * qp->r_rq.max_sge) +
 				sizeof(struct rvt_rwqe);
-			qp->r_rq.wq = vmalloc_user(sizeof(struct rvt_rwq) +
-						   qp->r_rq.size * sz);
+			if (udata)
+				qp->r_rq.wq = vmalloc_user(
+						sizeof(struct rvt_rwq) +
+						qp->r_rq.size * sz);
+			else if (gfp == GFP_NOIO)
+				qp->r_rq.wq = __vmalloc(
+						sizeof(struct rvt_rwq) +
+						qp->r_rq.size * sz,
+						gfp, PAGE_KERNEL);
+			else
+				qp->r_rq.wq = vmalloc(
+						sizeof(struct rvt_rwq) +
+						qp->r_rq.size * sz);
 			if (!qp->r_rq.wq)
 				goto bail_driver_priv;
 		}
@@ -537,7 +567,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 
 		err = alloc_qpn(rdi, &rdi->qp_dev->qpn_table,
 				init_attr->qp_type,
-				init_attr->port_num);
+				init_attr->port_num, gfp);
 		if (err < 0) {
 			ret = ERR_PTR(err);
 			goto bail_rq_wq;
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 725778a..70a9596 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -223,7 +223,8 @@ struct rvt_driver_provided {
 	const char * (*get_card_name)(struct rvt_dev_info *rdi);
 	struct pci_dev * (*get_pci_dev)(struct rvt_dev_info *rdi);
 	unsigned (*free_all_qps)(struct rvt_dev_info *rdi);
-	void * (*qp_priv_alloc)(struct rvt_dev_info *rdi, struct rvt_qp *qp);
+	void * (*qp_priv_alloc)(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+				gfp_t gfp);
 	void (*qp_priv_free)(struct rvt_dev_info *rdi, struct rvt_qp *qp);
 	void (*notify_qp_reset)(struct rvt_qp *qp);
 
@@ -234,7 +235,7 @@ struct rvt_driver_provided {
 	void (*notify_new_ah)(struct ib_device *, struct ib_ah_attr *,
 			      struct rvt_ah *);
 	int (*alloc_qpn)(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-			 enum ib_qp_type type, u8 port);
+			 enum ib_qp_type type, u8 port, gfp_t gfp);
 };
 
 struct rvt_dev_info {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
