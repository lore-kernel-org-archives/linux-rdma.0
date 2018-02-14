From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 12/14] RDMA/verbs: Return proper error code for not supported system call
Date: Wed, 14 Feb 2018 14:38:42 +0200
Message-ID: <20180214123844.30321-13-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The proper return error is -EOPNOTSUPP and not -ENOSYS, so update
all places in verbs.c to match this semantics.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 46 ++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 16ebc6372c31..95965033cc64 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -655,7 +655,7 @@ int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
 
 	return ah->device->modify_ah ?
 		ah->device->modify_ah(ah, ah_attr) :
-		-ENOSYS;
+		-EOPNOTSUPP;
 }
 EXPORT_SYMBOL(rdma_modify_ah);
 
@@ -663,7 +663,7 @@ int rdma_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
 {
 	return ah->device->query_ah ?
 		ah->device->query_ah(ah, ah_attr) :
-		-ENOSYS;
+		-EOPNOTSUPP;
 }
 EXPORT_SYMBOL(rdma_query_ah);
 
@@ -689,7 +689,7 @@ struct ib_srq *ib_create_srq(struct ib_pd *pd,
 	struct ib_srq *srq;
 
 	if (!pd->device->create_srq)
-		return ERR_PTR(-ENOSYS);
+		return ERR_PTR(-EOPNOTSUPP);
 
 	srq = pd->device->create_srq(pd, srq_init_attr, NULL);
 
@@ -722,7 +722,7 @@ int ib_modify_srq(struct ib_srq *srq,
 {
 	return srq->device->modify_srq ?
 		srq->device->modify_srq(srq, srq_attr, srq_attr_mask, NULL) :
-		-ENOSYS;
+		-EOPNOTSUPP;
 }
 EXPORT_SYMBOL(ib_modify_srq);
 
@@ -730,7 +730,7 @@ int ib_query_srq(struct ib_srq *srq,
 		 struct ib_srq_attr *srq_attr)
 {
 	return srq->device->query_srq ?
-		srq->device->query_srq(srq, srq_attr) : -ENOSYS;
+		srq->device->query_srq(srq, srq_attr) : -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(ib_query_srq);
 
@@ -1458,7 +1458,7 @@ int ib_query_qp(struct ib_qp *qp,
 {
 	return qp->device->query_qp ?
 		qp->device->query_qp(qp->real_qp, qp_attr, qp_attr_mask, qp_init_attr) :
-		-ENOSYS;
+		-EOPNOTSUPP;
 }
 EXPORT_SYMBOL(ib_query_qp);
 
@@ -1595,7 +1595,7 @@ EXPORT_SYMBOL(ib_create_cq);
 int rdma_set_cq_moderation(struct ib_cq *cq, u16 cq_count, u16 cq_period)
 {
 	return cq->device->modify_cq ?
-		cq->device->modify_cq(cq, cq_count, cq_period) : -ENOSYS;
+		cq->device->modify_cq(cq, cq_count, cq_period) : -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(rdma_set_cq_moderation);
 
@@ -1612,7 +1612,7 @@ EXPORT_SYMBOL(ib_destroy_cq);
 int ib_resize_cq(struct ib_cq *cq, int cqe)
 {
 	return cq->device->resize_cq ?
-		cq->device->resize_cq(cq, cqe, NULL) : -ENOSYS;
+		cq->device->resize_cq(cq, cqe, NULL) : -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(ib_resize_cq);
 
@@ -1650,7 +1650,7 @@ struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
 	struct ib_mr *mr;
 
 	if (!pd->device->alloc_mr)
-		return ERR_PTR(-ENOSYS);
+		return ERR_PTR(-EOPNOTSUPP);
 
 	mr = pd->device->alloc_mr(pd, mr_type, max_num_sg);
 	if (!IS_ERR(mr)) {
@@ -1674,7 +1674,7 @@ struct ib_fmr *ib_alloc_fmr(struct ib_pd *pd,
 	struct ib_fmr *fmr;
 
 	if (!pd->device->alloc_fmr)
-		return ERR_PTR(-ENOSYS);
+		return ERR_PTR(-EOPNOTSUPP);
 
 	fmr = pd->device->alloc_fmr(pd, mr_access_flags, fmr_attr);
 	if (!IS_ERR(fmr)) {
@@ -1758,7 +1758,7 @@ int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 	int ret;
 
 	if (!qp->device->attach_mcast)
-		return -ENOSYS;
+		return -EOPNOTSUPP;
 
 	if (!rdma_is_multicast_addr((struct in6_addr *)gid->raw) ||
 	    qp->qp_type != IB_QPT_UD || !is_valid_mcast_lid(qp, lid))
@@ -1776,7 +1776,7 @@ int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 	int ret;
 
 	if (!qp->device->detach_mcast)
-		return -ENOSYS;
+		return -EOPNOTSUPP;
 
 	if (!rdma_is_multicast_addr((struct in6_addr *)gid->raw) ||
 	    qp->qp_type != IB_QPT_UD || !is_valid_mcast_lid(qp, lid))
@@ -1794,7 +1794,7 @@ struct ib_xrcd *__ib_alloc_xrcd(struct ib_device *device, const char *caller)
 	struct ib_xrcd *xrcd;
 
 	if (!device->alloc_xrcd)
-		return ERR_PTR(-ENOSYS);
+		return ERR_PTR(-EOPNOTSUPP);
 
 	xrcd = device->alloc_xrcd(device, NULL, NULL);
 	if (!IS_ERR(xrcd)) {
@@ -1848,7 +1848,7 @@ struct ib_wq *ib_create_wq(struct ib_pd *pd,
 	struct ib_wq *wq;
 
 	if (!pd->device->create_wq)
-		return ERR_PTR(-ENOSYS);
+		return ERR_PTR(-EOPNOTSUPP);
 
 	wq = pd->device->create_wq(pd, wq_attr, NULL);
 	if (!IS_ERR(wq)) {
@@ -1903,7 +1903,7 @@ int ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 	int err;
 
 	if (!wq->device->modify_wq)
-		return -ENOSYS;
+		return -EOPNOTSUPP;
 
 	err = wq->device->modify_wq(wq, wq_attr, wq_attr_mask, NULL);
 	return err;
@@ -1928,7 +1928,7 @@ struct ib_rwq_ind_table *ib_create_rwq_ind_table(struct ib_device *device,
 	u32 table_size;
 
 	if (!device->create_rwq_ind_table)
-		return ERR_PTR(-ENOSYS);
+		return ERR_PTR(-EOPNOTSUPP);
 
 	table_size = (1 << init_attr->log_ind_tbl_size);
 	rwq_ind_table = device->create_rwq_ind_table(device,
@@ -1978,7 +1978,7 @@ struct ib_flow *ib_create_flow(struct ib_qp *qp,
 {
 	struct ib_flow *flow_id;
 	if (!qp->device->create_flow)
-		return ERR_PTR(-ENOSYS);
+		return ERR_PTR(-EOPNOTSUPP);
 
 	flow_id = qp->device->create_flow(qp, flow_attr, domain);
 	if (!IS_ERR(flow_id)) {
@@ -2005,7 +2005,7 @@ int ib_check_mr_status(struct ib_mr *mr, u32 check_mask,
 		       struct ib_mr_status *mr_status)
 {
 	return mr->device->check_mr_status ?
-		mr->device->check_mr_status(mr, check_mask, mr_status) : -ENOSYS;
+		mr->device->check_mr_status(mr, check_mask, mr_status) : -EOPNOTSUPP;
 }
 EXPORT_SYMBOL(ib_check_mr_status);
 
@@ -2013,7 +2013,7 @@ int ib_set_vf_link_state(struct ib_device *device, int vf, u8 port,
 			 int state)
 {
 	if (!device->set_vf_link_state)
-		return -ENOSYS;
+		return -EOPNOTSUPP;
 
 	return device->set_vf_link_state(device, vf, port, state);
 }
@@ -2023,7 +2023,7 @@ int ib_get_vf_config(struct ib_device *device, int vf, u8 port,
 		     struct ifla_vf_info *info)
 {
 	if (!device->get_vf_config)
-		return -ENOSYS;
+		return -EOPNOTSUPP;
 
 	return device->get_vf_config(device, vf, port, info);
 }
@@ -2033,7 +2033,7 @@ int ib_get_vf_stats(struct ib_device *device, int vf, u8 port,
 		    struct ifla_vf_stats *stats)
 {
 	if (!device->get_vf_stats)
-		return -ENOSYS;
+		return -EOPNOTSUPP;
 
 	return device->get_vf_stats(device, vf, port, stats);
 }
@@ -2043,7 +2043,7 @@ int ib_set_vf_guid(struct ib_device *device, int vf, u8 port, u64 guid,
 		   int type)
 {
 	if (!device->set_vf_guid)
-		return -ENOSYS;
+		return -EOPNOTSUPP;
 
 	return device->set_vf_guid(device, vf, port, guid, type);
 }
@@ -2078,7 +2078,7 @@ int ib_map_mr_sg(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
 		 unsigned int *sg_offset, unsigned int page_size)
 {
 	if (unlikely(!mr->device->map_mr_sg))
-		return -ENOSYS;
+		return -EOPNOTSUPP;
 
 	mr->page_size = page_size;
 
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
