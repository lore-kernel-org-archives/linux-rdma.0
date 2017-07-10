From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH rfc] RDMA: unite max_mr_page_list_len for FRWR and FMRs
Date: Mon, 10 Jul 2017 15:50:02 +0300
Message-ID: <1499691002-5224-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently FMRs don't even expose maximum supported page list length,
which makes it impossible for to know what it actually is.

Thus, rename max_fast_reg_page_list_len to max_reg_page_list_len
so it is the same capability regardless of registration method is
used. Drivers that support both methods should expose the minimum
between the two.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/core/rw.c                 |  2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c     |  2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  2 +-
 drivers/infiniband/hw/cxgb4/provider.c       |  2 +-
 drivers/infiniband/hw/hfi1/verbs.c           |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |  2 +-
 drivers/infiniband/hw/mlx4/main.c            |  2 +-
 drivers/infiniband/hw/mlx5/main.c            |  2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |  5 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  2 +-
 drivers/infiniband/hw/qedr/verbs.c           |  2 +-
 drivers/infiniband/hw/qib/qib_verbs.c        |  1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  2 +-
 drivers/infiniband/sw/rxe/rxe.c              |  2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c          | 21 +++------------------
 drivers/infiniband/ulp/srp/ib_srp.h          |  2 --
 drivers/nvme/host/rdma.c                     |  2 +-
 include/rdma/ib_verbs.h                      |  2 +-
 net/sunrpc/xprtrdma/fmr_ops.c                | 10 ++++++++--
 net/sunrpc/xprtrdma/frwr_ops.c               |  4 ++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c     |  2 +-
 22 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index dbfd854c32c9..cd4adb24a077 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -61,7 +61,7 @@ static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
 static inline u32 rdma_rw_fr_page_list_len(struct ib_device *dev)
 {
 	/* arbitrary limit to avoid allocating gigantic resources */
-	return min_t(u32, dev->attrs.max_fast_reg_page_list_len, 256);
+	return min_t(u32, dev->attrs.max_reg_page_list_len, 256);
 }
 
 /* Caller must have zero-initialized *reg. */
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index c7bd68311d0c..2c9a8eed6183 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -198,7 +198,7 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 	ib_attr->max_srq_wr = dev_attr->max_srq_wqes;
 	ib_attr->max_srq_sge = dev_attr->max_srq_sges;
 
-	ib_attr->max_fast_reg_page_list_len = MAX_PBL_LVL_1_PGS;
+	ib_attr->max_reg_page_list_len = MAX_PBL_LVL_1_PGS;
 
 	ib_attr->max_pkeys = 1;
 	ib_attr->local_ca_ack_delay = 0;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 29d30744d6c9..bcda349eaefd 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1112,7 +1112,7 @@ static int iwch_query_device(struct ib_device *ibdev, struct ib_device_attr *pro
 	props->max_mr = dev->attr.max_mem_regs;
 	props->max_pd = dev->attr.max_pds;
 	props->local_ca_ack_delay = 0;
-	props->max_fast_reg_page_list_len = T3_MAX_FASTREG_DEPTH;
+	props->max_reg_page_list_len = T3_MAX_FASTREG_DEPTH;
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 0771e9a4d061..7d2f9136deb7 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -351,7 +351,7 @@ static int c4iw_query_device(struct ib_device *ibdev, struct ib_device_attr *pro
 	props->max_mr = c4iw_num_stags(&dev->rdev);
 	props->max_pd = T4_MAX_NUM_PD;
 	props->local_ca_ack_delay = 0;
-	props->max_fast_reg_page_list_len =
+	props->max_reg_page_list_len =
 		t4_max_fr_depth(dev->rdev.lldi.ulptx_memwrite_dsgl && use_dsgl);
 
 	return 0;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 5b53faf47042..2b15ee143e45 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1284,7 +1284,7 @@ static void hfi1_fill_device_attr(struct hfi1_devdata *dd)
 	rdi->dparms.props.hw_ver = dd->minrev;
 	rdi->dparms.props.sys_image_guid = ib_hfi1_sys_image_guid;
 	rdi->dparms.props.max_mr_size = U64_MAX;
-	rdi->dparms.props.max_fast_reg_page_list_len = UINT_MAX;
+	rdi->dparms.props.max_reg_page_list_len = UINT_MAX;
 	rdi->dparms.props.max_qp = hfi1_max_qps;
 	rdi->dparms.props.max_qp_wr = hfi1_max_qp_wrs;
 	rdi->dparms.props.max_sge = hfi1_max_sges;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 4dbe61ec7a77..77bc44ae7ce6 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -80,7 +80,7 @@ static int i40iw_query_device(struct ib_device *ibdev,
 	props->max_qp_init_rd_atom = props->max_qp_rd_atom;
 	props->atomic_cap = IB_ATOMIC_NONE;
 	props->max_map_per_fmr = 1;
-	props->max_fast_reg_page_list_len = I40IW_MAX_PAGES_PER_FMR;
+	props->max_reg_page_list_len = I40IW_MAX_PAGES_PER_FMR;
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 75b2f7d4cd95..10e203a2fd4c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -537,7 +537,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_srq		   = dev->dev->quotas.srq;
 	props->max_srq_wr	   = dev->dev->caps.max_srq_wqes - 1;
 	props->max_srq_sge	   = dev->dev->caps.max_srq_sge;
-	props->max_fast_reg_page_list_len = MLX4_MAX_FAST_REG_PAGES;
+	props->max_reg_page_list_len = MLX4_MAX_FAST_REG_PAGES;
 	props->local_ca_ack_delay  = dev->dev->caps.local_ca_ack_delay;
 	props->atomic_cap	   = dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_ATOMIC ?
 		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2a55372b7da2..0452c9f9d432 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -728,7 +728,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->local_ca_ack_delay  = MLX5_CAP_GEN(mdev, local_ca_ack_delay);
 	props->max_res_rd_atom	   = props->max_qp_rd_atom * props->max_qp;
 	props->max_srq_sge	   = max_rq_sg - 1;
-	props->max_fast_reg_page_list_len =
+	props->max_reg_page_list_len =
 		1 << MLX5_CAP_GEN(mdev, log_max_klm_list_size);
 	get_atomic_caps(dev, props);
 	props->masked_atomic_cap   = IB_ATOMIC_NONE;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index c197cd9b193f..93a7a72f7c36 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -116,6 +116,11 @@ static int mthca_query_device(struct ib_device *ibdev, struct ib_device_attr *pr
 	props->max_mcast_qp_attach = MTHCA_QP_PER_MGM;
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
+	if (mthca_is_memfree(mdev))
+		/* For Arbel, all MTTs must fit in the same page. */
+		props->max_reg_page_list_len = PAGE_SIZE / sizeof(u64);
+	else
+		props->max_reg_page_list_len = INT_MAX;
 	/*
 	 * If Sinai memory key optimization is being used, then only
 	 * the 8-bit key portion will change.  For other HCAs, the
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 2f30bda8457a..d0ac9af99ac7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -142,7 +142,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr,
 	attr->max_srq_sge = dev->attr.max_srq_sge;
 	attr->max_srq_wr = dev->attr.max_rqe;
 	attr->local_ca_ack_delay = dev->attr.local_ca_ack_delay;
-	attr->max_fast_reg_page_list_len = dev->attr.max_pages_per_frmr;
+	attr->max_reg_page_list_len = dev->attr.max_pages_per_frmr;
 	attr->max_pkeys = 1;
 	return 0;
 }
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index d6723c365c7f..35691df9cdf2 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -163,7 +163,7 @@ int qedr_query_device(struct ib_device *ibdev,
 	attr->max_srq_wr = qattr->max_srq_wr;
 
 	attr->local_ca_ack_delay = qattr->dev_ack_delay;
-	attr->max_fast_reg_page_list_len = qattr->max_mr / 8;
+	attr->max_reg_page_list_len = qattr->max_mr / 8;
 	attr->max_pkeys = QEDR_ROCE_PKEY_MAX;
 	attr->max_ah = qattr->max_ah;
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index ac42dce7e281..ff92c44083f7 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1501,6 +1501,7 @@ static void qib_fill_device_attr(struct qib_devdata *dd)
 	rdi->dparms.props.max_total_mcast_qp_attach =
 					rdi->dparms.props.max_mcast_qp_attach *
 					rdi->dparms.props.max_mcast_grp;
+	rdi->dparms.props.max_reg_page_list_len = UINT_MAX;
 	/* post send table */
 	dd->verbs_dev.rdi.post_parms = qib_post_parms;
 }
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 4996984885c2..a173de1761ca 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -310,7 +310,7 @@ int usnic_ib_query_device(struct ib_device *ibdev,
 	props->max_srq = 0;
 	props->max_srq_wr = 0;
 	props->max_srq_sge = 0;
-	props->max_fast_reg_page_list_len = 0;
+	props->max_reg_page_list_len = 0;
 	props->max_mcast_grp = 0;
 	props->max_mcast_qp_attach = 0;
 	props->max_total_mcast_qp_attach = 0;
diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index c21c913f911a..e30fd9694902 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -124,7 +124,7 @@ static int rxe_init_device_param(struct rxe_dev *rxe)
 	rxe->attr.max_srq			= RXE_MAX_SRQ;
 	rxe->attr.max_srq_wr			= RXE_MAX_SRQ_WR;
 	rxe->attr.max_srq_sge			= RXE_MAX_SRQ_SGE;
-	rxe->attr.max_fast_reg_page_list_len	= RXE_MAX_FMR_PAGE_LIST_LEN;
+	rxe->attr.max_reg_page_list_len		= RXE_MAX_FMR_PAGE_LIST_LEN;
 	rxe->attr.max_pkeys			= RXE_MAX_PKEYS;
 	rxe->attr.local_ca_ack_delay		= RXE_LOCAL_CA_ACK_DELAY;
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index c538a38c91ce..28f26ab4585d 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -709,7 +709,7 @@ iser_calc_scsi_params(struct iser_conn *iser_conn,
 
 	sg_tablesize = DIV_ROUND_UP(max_sectors * 512, SIZE_4K);
 	sup_sg_tablesize = min_t(unsigned, ISCSI_ISER_MAX_SG_TABLESIZE,
-				 device->ib_device->attrs.max_fast_reg_page_list_len);
+				 device->ib_device->attrs.max_reg_page_list_len);
 
 	iser_conn->scsi_sg_tablesize = min(sg_tablesize, sup_sg_tablesize);
 }
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2354c742caa1..d752100286f9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3580,7 +3580,6 @@ static void srp_add_one(struct ib_device *device)
 	struct ib_device_attr *attr = &device->attrs;
 	struct srp_host *host;
 	int mr_page_shift, p;
-	u64 max_pages_per_mr;
 	unsigned int flags = 0;
 
 	srp_dev = kzalloc(sizeof(*srp_dev), GFP_KERNEL);
@@ -3595,13 +3594,8 @@ static void srp_add_one(struct ib_device *device)
 	mr_page_shift		= max(12, ffs(attr->page_size_cap) - 1);
 	srp_dev->mr_page_size	= 1 << mr_page_shift;
 	srp_dev->mr_page_mask	= ~((u64) srp_dev->mr_page_size - 1);
-	max_pages_per_mr	= attr->max_mr_size;
-	do_div(max_pages_per_mr, srp_dev->mr_page_size);
-	pr_debug("%s: %llu / %u = %llu <> %u\n", __func__,
-		 attr->max_mr_size, srp_dev->mr_page_size,
-		 max_pages_per_mr, SRP_MAX_PAGES_PER_MR);
 	srp_dev->max_pages_per_mr = min_t(u64, SRP_MAX_PAGES_PER_MR,
-					  max_pages_per_mr);
+					  attr->max_reg_page_list_len);
 
 	srp_dev->has_fmr = (device->alloc_fmr && device->dealloc_fmr &&
 			    device->map_phys_fmr && device->unmap_fmr);
@@ -3620,17 +3614,8 @@ static void srp_add_one(struct ib_device *device)
 	    (!srp_dev->has_fmr && !srp_dev->has_fr))
 		flags |= IB_PD_UNSAFE_GLOBAL_RKEY;
 
-	if (srp_dev->use_fast_reg) {
-		srp_dev->max_pages_per_mr =
-			min_t(u32, srp_dev->max_pages_per_mr,
-			      attr->max_fast_reg_page_list_len);
-	}
-	srp_dev->mr_max_size	= srp_dev->mr_page_size *
-				   srp_dev->max_pages_per_mr;
-	pr_debug("%s: mr_page_shift = %d, device->max_mr_size = %#llx, device->max_fast_reg_page_list_len = %u, max_pages_per_mr = %d, mr_max_size = %#x\n",
-		 device->name, mr_page_shift, attr->max_mr_size,
-		 attr->max_fast_reg_page_list_len,
-		 srp_dev->max_pages_per_mr, srp_dev->mr_max_size);
+	pr_debug("%s: mr_page_shift = %d, max_pages_per_mr = %d\n",
+		 device->name, mr_page_shift, srp_dev->max_pages_per_mr);
 
 	INIT_LIST_HEAD(&srp_dev->dev_list);
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index ab9077b81d5a..9f2ada3855a5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -83,7 +83,6 @@ enum srp_iu_type {
 /*
  * @mr_page_mask: HCA memory registration page mask.
  * @mr_page_size: HCA memory registration page size.
- * @mr_max_size: Maximum size in bytes of a single FMR / FR registration
  *   request.
  */
 struct srp_device {
@@ -92,7 +91,6 @@ struct srp_device {
 	struct ib_pd	       *pd;
 	u64			mr_page_mask;
 	int			mr_page_size;
-	int			mr_max_size;
 	int			max_pages_per_mr;
 	bool			has_fmr;
 	bool			has_fr;
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 24397d306d53..22882783bf71 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1586,7 +1586,7 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl)
 		goto out_free_queue;
 
 	ctrl->max_fr_pages = min_t(u32, NVME_RDMA_MAX_SEGMENTS,
-		ctrl->device->dev->attrs.max_fast_reg_page_list_len);
+		ctrl->device->dev->attrs.max_reg_page_list_len);
 
 	memset(&ctrl->admin_tag_set, 0, sizeof(ctrl->admin_tag_set));
 	ctrl->admin_tag_set.ops = &nvme_rdma_admin_mq_ops;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9d4d2a74c95e..91359e5c3961 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -327,7 +327,7 @@ struct ib_device_attr {
 	int			max_srq;
 	int			max_srq_wr;
 	int			max_srq_sge;
-	unsigned int		max_fast_reg_page_list_len;
+	unsigned int		max_reg_page_list_len;
 	u16			max_pkeys;
 	u8			local_ca_ack_delay;
 	int			sig_prot_cap;
diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index 59e64025ed96..6000302eede7 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -160,8 +160,12 @@ static int
 fmr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
 	    struct rpcrdma_create_data_internal *cdata)
 {
+	struct ib_device_attr *attrs = &ia->ri_device->attrs;
+
+	ia->ri_max_frmr_depth = min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
+			      attrs->max_reg_page_list_len);
 	ia->ri_max_segs = max_t(unsigned int, 1, RPCRDMA_MAX_DATA_SEGS /
-				RPCRDMA_MAX_FMR_SGES);
+				ia->ri_max_frmr_depth);
 	return 0;
 }
 
@@ -170,8 +174,10 @@ fmr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
 static size_t
 fmr_op_maxpages(struct rpcrdma_xprt *r_xprt)
 {
+	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
+
 	return min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
-		     RPCRDMA_MAX_HDR_SEGS * RPCRDMA_MAX_FMR_SGES);
+		     RPCRDMA_MAX_HDR_SEGS * ia->ri_max_frmr_depth);
 }
 
 /* Use the ib_map_phys_fmr() verb to register a memory region
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index f81dd93176c0..11effcca0519 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -84,7 +84,7 @@ frwr_is_supported(struct rpcrdma_ia *ia)
 
 	if (!(attrs->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS))
 		goto out_not_supported;
-	if (attrs->max_fast_reg_page_list_len == 0)
+	if (attrs->max_reg_page_list_len == 0)
 		goto out_not_supported;
 	return true;
 
@@ -215,7 +215,7 @@ frwr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
 
 	ia->ri_max_frmr_depth =
 			min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
-			      attrs->max_fast_reg_page_list_len);
+			      attrs->max_reg_page_list_len);
 	dprintk("RPC:       %s: device's max FR page list len = %u\n",
 		__func__, ia->ri_max_frmr_depth);
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index a9d9cb1ba4c6..5725abf739ee 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -1001,7 +1001,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_reader = rdma_read_chunk_lcl;
 	if (dev->attrs.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
 		newxprt->sc_frmr_pg_list_len =
-			dev->attrs.max_fast_reg_page_list_len;
+			dev->attrs.max_reg_page_list_len;
 		newxprt->sc_dev_caps |= SVCRDMA_DEVCAP_FAST_REG;
 		newxprt->sc_reader = rdma_read_chunk_frmr;
 	} else
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
