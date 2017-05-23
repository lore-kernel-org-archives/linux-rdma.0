From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/4] IB/{rdmavt, qib}: Remove gfp flags argument
Date: Tue, 23 May 2017 11:39:51 +0300
Message-ID: <20170523083953.14892-3-leon@kernel.org>
References: <20170523083953.14892-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523083953.14892-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The caller to the driver marks GFP_NOIO allocations with help
of memalloc_noio-* calls now. This makes redundant to pass down
to the driver gfp flags, which can be GFP_KERNEL only.

The patch removes the gfp flags argument and updates all driver paths.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c    | 15 +++++------
 drivers/infiniband/hw/qib/qib_verbs.h |  4 +--
 drivers/infiniband/sw/rdmavt/qp.c     | 48 ++++++++++-------------------------
 include/rdma/rdma_vt.h                |  5 ++--
 4 files changed, 24 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 5984981e7dd4..a343e3b5d4cb 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -104,10 +104,9 @@ const struct rvt_operation_params qib_post_parms[RVT_OPERATION_MAX] = {

 };

-static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map,
-			 gfp_t gfp)
+static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map)
 {
-	unsigned long page = get_zeroed_page(gfp);
+	unsigned long page = get_zeroed_page(GFP_KERNEL);

 	/*
 	 * Free the page if someone raced with us installing it.
@@ -126,7 +125,7 @@ static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map,
  * zero/one for QP type IB_QPT_SMI/IB_QPT_GSI.
  */
 int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-		  enum ib_qp_type type, u8 port, gfp_t gfp)
+		  enum ib_qp_type type, u8 port)
 {
 	u32 i, offset, max_scan, qpn;
 	struct rvt_qpn_map *map;
@@ -160,7 +159,7 @@ int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 	max_scan = qpt->nmaps - !offset;
 	for (i = 0;;) {
 		if (unlikely(!map->page)) {
-			get_map_page(qpt, map, gfp);
+			get_map_page(qpt, map);
 			if (unlikely(!map->page))
 				break;
 		}
@@ -317,16 +316,16 @@ u32 qib_mtu_from_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp, u32 pmtu)
 	return ib_mtu_enum_to_int(pmtu);
 }

-void *qib_qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp, gfp_t gfp)
+void *qib_qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv;

-	priv = kzalloc(sizeof(*priv), gfp);
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return ERR_PTR(-ENOMEM);
 	priv->owner = qp;

-	priv->s_hdr = kzalloc(sizeof(*priv->s_hdr), gfp);
+	priv->s_hdr = kzalloc(sizeof(*priv->s_hdr), GFP_KERNEL);
 	if (!priv->s_hdr) {
 		kfree(priv);
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index da0db5485ddc..a52fc67b40d7 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -274,11 +274,11 @@ int qib_get_counters(struct qib_pportdata *ppd,
  * Functions provided by qib driver for rdmavt to use
  */
 unsigned qib_free_all_qps(struct rvt_dev_info *rdi);
-void *qib_qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp, gfp_t gfp);
+void *qib_qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp);
 void qib_qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp);
 void qib_notify_qp_reset(struct rvt_qp *qp);
 int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-		  enum ib_qp_type type, u8 port, gfp_t gfp);
+		  enum ib_qp_type type, u8 port);
 void qib_restart_rc(struct rvt_qp *qp, u32 psn, int wait);
 #ifdef CONFIG_DEBUG_FS

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 727e81cc2c8f..459865439a0b 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -118,10 +118,9 @@ const int ib_rvt_state_ops[IB_QPS_ERR + 1] = {
 EXPORT_SYMBOL(ib_rvt_state_ops);

 static void get_map_page(struct rvt_qpn_table *qpt,
-			 struct rvt_qpn_map *map,
-			 gfp_t gfp)
+			 struct rvt_qpn_map *map)
 {
-	unsigned long page = get_zeroed_page(gfp);
+	unsigned long page = get_zeroed_page(GFP_KERNEL);

 	/*
 	 * Free the page if someone raced with us installing it.
@@ -173,7 +172,7 @@ static int init_qpn_table(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt)
 		    rdi->dparms.qpn_res_start, rdi->dparms.qpn_res_end);
 	for (i = rdi->dparms.qpn_res_start; i <= rdi->dparms.qpn_res_end; i++) {
 		if (!map->page) {
-			get_map_page(qpt, map, GFP_KERNEL);
+			get_map_page(qpt, map);
 			if (!map->page) {
 				ret = -ENOMEM;
 				break;
@@ -342,14 +341,14 @@ static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
  * Return: The queue pair number
  */
 static int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-		     enum ib_qp_type type, u8 port_num, gfp_t gfp)
+		     enum ib_qp_type type, u8 port_num)
 {
 	u32 i, offset, max_scan, qpn;
 	struct rvt_qpn_map *map;
 	u32 ret;

 	if (rdi->driver_f.alloc_qpn)
-		return rdi->driver_f.alloc_qpn(rdi, qpt, type, port_num, gfp);
+		return rdi->driver_f.alloc_qpn(rdi, qpt, type, port_num);

 	if (type == IB_QPT_SMI || type == IB_QPT_GSI) {
 		unsigned n;
@@ -374,7 +373,7 @@ static int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 	max_scan = qpt->nmaps - !offset;
 	for (i = 0;;) {
 		if (unlikely(!map->page)) {
-			get_map_page(qpt, map, gfp);
+			get_map_page(qpt, map);
 			if (unlikely(!map->page))
 				break;
 		}
@@ -672,7 +671,6 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 	struct ib_qp *ret = ERR_PTR(-ENOMEM);
 	struct rvt_dev_info *rdi = ib_to_rvt(ibpd->device);
 	void *priv = NULL;
-	gfp_t gfp;
 	size_t sqsize;

 	if (!rdi)
@@ -680,18 +678,9 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,

 	if (init_attr->cap.max_send_sge > rdi->dparms.props.max_sge ||
 	    init_attr->cap.max_send_wr > rdi->dparms.props.max_qp_wr ||
-	    init_attr->create_flags & ~(IB_QP_CREATE_USE_GFP_NOIO))
+	    init_attr->create_flags)
 		return ERR_PTR(-EINVAL);

-	/* GFP_NOIO is applicable to RC QP's only */
-
-	if (init_attr->create_flags & IB_QP_CREATE_USE_GFP_NOIO &&
-	    init_attr->qp_type != IB_QPT_RC)
-		return ERR_PTR(-EINVAL);
-
-	gfp = init_attr->create_flags & IB_QP_CREATE_USE_GFP_NOIO ?
-						GFP_NOIO : GFP_KERNEL;
-
 	/* Check receive queue parameters if no SRQ is specified. */
 	if (!init_attr->srq) {
 		if (init_attr->cap.max_recv_sge > rdi->dparms.props.max_sge ||
@@ -719,14 +708,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		sz = sizeof(struct rvt_sge) *
 			init_attr->cap.max_send_sge +
 			sizeof(struct rvt_swqe);
-		if (gfp == GFP_NOIO)
-			swq = __vmalloc(
-				sqsize * sz,
-				gfp | __GFP_ZERO, PAGE_KERNEL);
-		else
-			swq = vzalloc_node(
-				sqsize * sz,
-				rdi->dparms.node);
+		swq = vzalloc_node(sqsize * sz, rdi->dparms.node);
 		if (!swq)
 			return ERR_PTR(-ENOMEM);

@@ -741,7 +723,8 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		} else if (init_attr->cap.max_recv_sge > 1)
 			sg_list_sz = sizeof(*qp->r_sg_list) *
 				(init_attr->cap.max_recv_sge - 1);
-		qp = kzalloc_node(sz + sg_list_sz, gfp, rdi->dparms.node);
+		qp = kzalloc_node(sz + sg_list_sz, GFP_KERNEL,
+				  rdi->dparms.node);
 		if (!qp)
 			goto bail_swq;

@@ -751,7 +734,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 				kzalloc_node(
 					sizeof(*qp->s_ack_queue) *
 					 rvt_max_atomic(rdi),
-					gfp,
+					GFP_KERNEL,
 					rdi->dparms.node);
 			if (!qp->s_ack_queue)
 				goto bail_qp;
@@ -766,7 +749,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		 * Driver needs to set up it's private QP structure and do any
 		 * initialization that is needed.
 		 */
-		priv = rdi->driver_f.qp_priv_alloc(rdi, qp, gfp);
+		priv = rdi->driver_f.qp_priv_alloc(rdi, qp);
 		if (IS_ERR(priv)) {
 			ret = priv;
 			goto bail_qp;
@@ -786,11 +769,6 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 				qp->r_rq.wq = vmalloc_user(
 						sizeof(struct rvt_rwq) +
 						qp->r_rq.size * sz);
-			else if (gfp == GFP_NOIO)
-				qp->r_rq.wq = __vmalloc(
-						sizeof(struct rvt_rwq) +
-						qp->r_rq.size * sz,
-						gfp | __GFP_ZERO, PAGE_KERNEL);
 			else
 				qp->r_rq.wq = vzalloc_node(
 						sizeof(struct rvt_rwq) +
@@ -824,7 +802,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,

 		err = alloc_qpn(rdi, &rdi->qp_dev->qpn_table,
 				init_attr->qp_type,
-				init_attr->port_num, gfp);
+				init_attr->port_num);
 		if (err < 0) {
 			ret = ERR_PTR(err);
 			goto bail_rq_wq;
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 4878aaf7bdff..55af69271053 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -229,8 +229,7 @@ struct rvt_driver_provided {
 	 * ERR_PTR(err).  The driver is free to return NULL or a valid
 	 * pointer.
 	 */
-	void * (*qp_priv_alloc)(struct rvt_dev_info *rdi, struct rvt_qp *qp,
-				gfp_t gfp);
+	void * (*qp_priv_alloc)(struct rvt_dev_info *rdi, struct rvt_qp *qp);

 	/*
 	 * Free the driver's private qp structure.
@@ -319,7 +318,7 @@ struct rvt_driver_provided {

 	/* Let the driver pick the next queue pair number*/
 	int (*alloc_qpn)(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-			 enum ib_qp_type type, u8 port_num, gfp_t gfp);
+			 enum ib_qp_type type, u8 port_num);

 	/* Determine if its safe or allowed to modify the qp */
 	int (*check_modify_qp)(struct rvt_qp *qp, struct ib_qp_attr *attr,
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
