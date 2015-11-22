From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 11/11] IB: provide better access flags for fast registrations
Date: Sun, 22 Nov 2015 18:46:49 +0100
Message-ID: <1448214409-7729-12-git-send-email-hch@lst.de>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448214409-7729-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead of the confusing IB spec values provide a flags argument that
describes:

  a) the operation we perform the memory registration for, and
  b) if we want to access it for read or write purposes.

This helps to abstract out the IB vs iWarp differences as well.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |  3 +-
 drivers/infiniband/hw/cxgb4/qp.c            |  3 +-
 drivers/infiniband/hw/mlx4/qp.c             |  2 +-
 drivers/infiniband/hw/mlx5/qp.c             |  2 +-
 drivers/infiniband/hw/nes/nes_verbs.c       |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  7 ++--
 drivers/infiniband/hw/qib/qib_keys.c        |  2 +-
 drivers/infiniband/ulp/iser/iser_memory.c   |  5 +--
 drivers/infiniband/ulp/isert/ib_isert.c     |  4 +-
 drivers/infiniband/ulp/srp/ib_srp.c         |  5 +--
 include/rdma/ib_verbs.h                     | 60 ++++++++++++++++++++++++++++-
 net/rds/iw_rdma.c                           |  5 +--
 net/rds/iw_send.c                           |  2 +-
 net/sunrpc/xprtrdma/frwr_ops.c              |  7 ++--
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c     |  3 +-
 15 files changed, 86 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 87be4be..47b3d0c 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -165,7 +165,8 @@ static int build_memreg(union t3_wr *wqe, struct ib_reg_wr *wr,
 		V_FR_PAGE_COUNT(mhp->npages) |
 		V_FR_PAGE_SIZE(ilog2(wr->mr->page_size) - 12) |
 		V_FR_TYPE(TPT_VATO) |
-		V_FR_PERMS(iwch_ib_to_tpt_access(wr->access)));
+		V_FR_PERMS(iwch_ib_to_tpt_access(
+				iwarp_scope_to_access(wr->scope))));
 	p = &wqe->fastreg.pbl_addrs[0];
 	for (i = 0; i < mhp->npages; i++, p++) {
 
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index cb8031b..d28a5a3 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -621,7 +621,8 @@ static int build_memreg(struct t4_sq *sq, union t4_wr *wqe,
 	wqe->fr.qpbinde_to_dcacpu = 0;
 	wqe->fr.pgsz_shift = ilog2(wr->mr->page_size) - 12;
 	wqe->fr.addr_type = FW_RI_VA_BASED_TO;
-	wqe->fr.mem_perms = c4iw_ib_to_tpt_access(wr->access);
+	wqe->fr.mem_perms =
+		c4iw_ib_to_tpt_access(iwarp_scope_to_access(wr->scope));
 	wqe->fr.len_hi = 0;
 	wqe->fr.len_lo = cpu_to_be32(mhp->ibmr.length);
 	wqe->fr.stag = cpu_to_be32(wr->mr->key);
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index afba1a9..0e0d4e4 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2509,7 +2509,7 @@ static void set_reg_seg(struct mlx4_wqe_fmr_seg *fseg,
 {
 	struct mlx4_ib_mr *mr = to_mmr(wr->mr);
 
-	fseg->flags		= convert_access(wr->access);
+	fseg->flags		= convert_access(ib_scope_to_access(wr->scope));
 	fseg->mem_key		= cpu_to_be32(wr->mr->key);
 	fseg->buf_list		= cpu_to_be64(mr->page_map);
 	fseg->start_addr	= cpu_to_be64(mr->ibmr.iova);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ba39045..6eef2cb 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2449,7 +2449,7 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 	if (unlikely((*seg == qp->sq.qend)))
 		*seg = mlx5_get_send_wqe(qp, 0);
 
-	set_reg_mkey_seg(*seg, mr, wr->mr->key, wr->access);
+	set_reg_mkey_seg(*seg, mr, wr->mr->key, ib_scope_to_access(wr->scope));
 	*seg += sizeof(struct mlx5_mkey_seg);
 	*size += sizeof(struct mlx5_mkey_seg) / 16;
 	if (unlikely((*seg == qp->sq.qend)))
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index f7f1f78..93c1231 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3196,7 +3196,7 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 		{
 			struct nes_mr *mr = to_nesmr(reg_wr(ib_wr)->mr);
 			int page_shift = ilog2(reg_wr(ib_wr)->mr->page_size);
-			int flags = reg_wr(ib_wr)->access;
+			int flags = iwarp_scope_to_access(reg_wr(ib_wr)->scope);
 
 			if (mr->npages > (NES_4K_PBL_CHUNK_SIZE / sizeof(u64))) {
 				nes_debug(NES_DBG_IW_TX, "SQ_FMR: bad page_list_len\n");
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 6d09634..43a0d24 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2100,6 +2100,7 @@ static int ocrdma_build_reg(struct ocrdma_qp *qp,
 	struct ocrdma_pbl *pbl_tbl = mr->hwmr.pbl_table;
 	struct ocrdma_pbe *pbe;
 	u32 wqe_size = sizeof(*fast_reg) + sizeof(*hdr);
+	int access = ib_scope_to_access(wr->scope);
 	int num_pbes = 0, i;
 
 	wqe_size = roundup(wqe_size, OCRDMA_WQE_ALIGN_BYTES);
@@ -2107,11 +2108,11 @@ static int ocrdma_build_reg(struct ocrdma_qp *qp,
 	hdr->cw |= (OCRDMA_FR_MR << OCRDMA_WQE_OPCODE_SHIFT);
 	hdr->cw |= ((wqe_size / OCRDMA_WQE_STRIDE) << OCRDMA_WQE_SIZE_SHIFT);
 
-	if (wr->access & IB_ACCESS_LOCAL_WRITE)
+	if (access & IB_ACCESS_LOCAL_WRITE)
 		hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_LOCAL_WR;
-	if (wr->access & IB_ACCESS_REMOTE_WRITE)
+	if (access & IB_ACCESS_REMOTE_WRITE)
 		hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_REMOTE_WR;
-	if (wr->access & IB_ACCESS_REMOTE_READ)
+	if (access & IB_ACCESS_REMOTE_READ)
 		hdr->rsvd_lkey_flags |= OCRDMA_LKEY_FLAG_REMOTE_RD;
 	hdr->lkey = wr->mr->key;
 	hdr->total_len = mr->ibmr.length;
diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 1be4807..8620d22 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -372,7 +372,7 @@ int qib_reg_mr(struct qib_qp *qp, struct ib_reg_wr *wr)
 	mrg->iova = mr->ibmr.iova;
 	mrg->lkey = key;
 	mrg->length = mr->ibmr.length;
-	mrg->access_flags = wr->access;
+	mrg->access_flags = ib_scope_to_access(wr->scope);
 	page_list = mr->pages;
 	m = 0;
 	n = 0;
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index fb4ca76..6767fc6 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -501,9 +501,8 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	wr->wr.send_flags = 0;
 	wr->wr.num_sge = 0;
 	wr->mr = mr;
-	wr->access = IB_ACCESS_LOCAL_WRITE  |
-		     IB_ACCESS_REMOTE_WRITE |
-		     IB_ACCESS_REMOTE_READ;
+	/* XXX: pass read vs write flag */
+	wr->scope = IB_REG_RKEY | IB_REG_OP_RDMA_READ | IB_REG_OP_RDMA_WRITE;
 
 	rsc->mr_valid = 0;
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index d38a1e7..de94ce7 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2548,7 +2548,9 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	reg_wr.wr.send_flags = 0;
 	reg_wr.wr.num_sge = 0;
 	reg_wr.mr = mr;
-	reg_wr.access = IB_ACCESS_LOCAL_WRITE;
+	/* XXX: pass read vs write flag */
+	reg_wr.scope = IB_REG_LKEY | IB_REG_OP_RDMA_READ | IB_REG_OP_RDMA_WRITE;
+
 
 	if (!wr)
 		wr = &reg_wr.wr;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6a8ef10..f67aa2a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1350,9 +1350,8 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	wr.wr.num_sge = 0;
 	wr.wr.send_flags = 0;
 	wr.mr = desc->mr;
-	wr.access = (IB_ACCESS_LOCAL_WRITE |
-		     IB_ACCESS_REMOTE_READ |
-		     IB_ACCESS_REMOTE_WRITE);
+	/* XXX: pass read vs write flag */
+	wr.scope = IB_REG_RKEY | IB_REG_OP_RDMA_READ | IB_REG_OP_RDMA_WRITE;
 
 	*state->fr.next++ = desc;
 	state->nmdesc++;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 51dd3a7..ca2aedc 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1086,10 +1086,12 @@ static inline struct ib_ud_wr *ud_wr(struct ib_send_wr *wr)
 	return container_of(wr, struct ib_ud_wr, wr);
 }
 
+typedef unsigned __bitwise__ ib_reg_scope_t;
+
 struct ib_reg_wr {
 	struct ib_send_wr	wr;
 	struct ib_mr		*mr;
-	int			access;
+	ib_reg_scope_t		scope;
 };
 
 static inline struct ib_reg_wr *reg_wr(struct ib_send_wr *wr)
@@ -1128,6 +1130,62 @@ enum ib_access_flags {
 };
 
 /*
+ * Decide if this a target of remote operations (rkey),
+ * or a source of local data (lkey).  Only one of these
+ * must be used at a given time.
+ */
+#define IB_REG_LKEY		(ib_reg_scope_t)0x0000
+#define IB_REG_RKEY		(ib_reg_scope_t)0x0001
+
+/*
+ * Operation we're registering for.  Multiple operations
+ * can be be used if absolutely needed.
+ */
+#define IB_REG_OP_SEND		(ib_reg_scope_t)0x0010
+#define IB_REG_OP_RDMA_READ	(ib_reg_scope_t)0x0020
+#define IB_REG_OP_RDMA_WRITE	(ib_reg_scope_t)0x0040
+/* add IB_REG_OP_ATOMIC when needed */
+
+static inline int ib_scope_to_access(ib_reg_scope_t scope)
+{
+	unsigned int acc = 0;
+
+	if (scope & IB_REG_RKEY) {
+		WARN_ON(scope & IB_REG_OP_SEND);
+
+		if (scope & IB_REG_OP_RDMA_READ)
+			acc |= IB_ACCESS_REMOTE_READ;
+		if (scope & IB_REG_OP_RDMA_WRITE)
+			acc |= IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE;
+	} else {
+		if (scope & IB_REG_OP_RDMA_READ)
+			acc |= IB_ACCESS_LOCAL_WRITE;
+	}
+
+	return acc;
+}
+
+static inline int iwarp_scope_to_access(ib_reg_scope_t scope)
+{
+	unsigned int acc = 0;
+
+	if (scope & IB_REG_RKEY) {
+		WARN_ON(scope & IB_REG_OP_SEND);
+
+		if (scope & IB_REG_OP_RDMA_READ)
+			acc |= IB_ACCESS_REMOTE_READ;
+		if (scope & IB_REG_OP_RDMA_WRITE)
+			acc |= IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE;
+	} else {
+		if (scope & IB_REG_OP_RDMA_READ)
+			acc |= IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE;
+	}
+
+	return acc;
+}
+
+
+/*
  * XXX: these are apparently used for ->rereg_user_mr, no idea why they
  * are hidden here instead of a uapi header!
  */
diff --git a/net/rds/iw_rdma.c b/net/rds/iw_rdma.c
index 3e683a9..205ed6b 100644
--- a/net/rds/iw_rdma.c
+++ b/net/rds/iw_rdma.c
@@ -675,9 +675,8 @@ static int rds_iw_rdma_reg_mr(struct rds_iw_mapping *mapping)
 	reg_wr.wr.wr_id = RDS_IW_REG_WR_ID;
 	reg_wr.wr.num_sge = 0;
 	reg_wr.mr = ibmr->mr;
-	reg_wr.access = IB_ACCESS_LOCAL_WRITE |
-			IB_ACCESS_REMOTE_READ |
-			IB_ACCESS_REMOTE_WRITE;
+	/* XXX: pass read vs write flag */
+	reg_wr.scope = IB_REG_RKEY | IB_REG_OP_RDMA_READ | IB_REG_OP_RDMA_WRITE;
 
 	/*
 	 * Perform a WR for the reg_mr. Each individual page
diff --git a/net/rds/iw_send.c b/net/rds/iw_send.c
index acfe38a..b83233f 100644
--- a/net/rds/iw_send.c
+++ b/net/rds/iw_send.c
@@ -775,7 +775,7 @@ static int rds_iw_build_send_reg(struct rds_iw_send_work *send,
 	send->s_reg_wr.wr.wr_id = 0;
 	send->s_reg_wr.wr.num_sge = 0;
 	send->s_reg_wr.mr = send->s_mr;
-	send->s_reg_wr.access = IB_ACCESS_REMOTE_WRITE;
+	send->s_reg_wr.scope = IB_REG_LKEY | IB_REG_OP_RDMA_READ;
 
 	ib_update_fast_reg_key(send->s_mr, send->s_remap_count++);
 
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 0b1b89b..52f99eb 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -386,9 +386,10 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 	reg_wr.wr.num_sge = 0;
 	reg_wr.wr.send_flags = 0;
 	reg_wr.mr = mr;
-	reg_wr.access = writing ?
-			IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
-			IB_ACCESS_REMOTE_READ;
+	if (writing)
+		reg_wr.scope = IB_REG_RKEY | IB_REG_OP_RDMA_WRITE;
+	else
+		reg_wr.scope = IB_REG_RKEY | IB_REG_OP_RDMA_READ;
 
 	DECR_CQCOUNT(&r_xprt->rx_ep);
 	rc = ib_post_send(ia->ri_id->qp, &reg_wr.wr, &bad_wr);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index b1d7528..9bd9709 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -239,7 +239,6 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	read = min_t(int, (nents << PAGE_SHIFT) - *page_offset, rs_length);
 
 	frmr->direction = DMA_FROM_DEVICE;
-	frmr->access_flags = (IB_ACCESS_LOCAL_WRITE|IB_ACCESS_REMOTE_WRITE);
 	frmr->sg_nents = nents;
 
 	for (pno = 0; pno < nents; pno++) {
@@ -304,7 +303,7 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	reg_wr.wr.send_flags = IB_SEND_SIGNALED;
 	reg_wr.wr.num_sge = 0;
 	reg_wr.mr = frmr->mr;
-	reg_wr.access = frmr->access_flags;
+	reg_wr.scope = IB_REG_LKEY | IB_REG_OP_RDMA_READ;
 	reg_wr.wr.next = &read_wr.wr;
 
 	/* Prepare RDMA_READ */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
