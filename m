From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] libmlx4: fix possible inline size
Date: Wed, 29 Sep 2010 12:08:45 +0200
Message-ID: <20100929100845.GA4960@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current driver checks required inline size by making sure it does not
exceed 1024. This is wrong since the whole WQE is limited to 1008 bytes.
Moreover, a more careful claculation is required to avoid cases where the
application requests inline support in a certain size that when used later
could cause connections to stall due to bad WQEs. This patch takes into account
the size of the WQE, the segements used to create a WQE and the overhead
incured by the inline segments themselves.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
Changes from previous version:
Use the existing num_inline_segs() function in clacualting the max
possible inline size in verify_sizes()
Use a macro to define the max WQE size.

There is a complementary patch following this one that fixes yet
another problem related to inline cacluation.

 src/mlx4.h  |    5 +++++
 src/qp.c    |    2 +-
 src/verbs.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/src/mlx4.h b/src/mlx4.h
index 4445998..5223697 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -130,6 +130,10 @@ enum {
 	MLX4_CQE_OPCODE_RESIZE		= 0x16,
 };
 
+enum {
+	MLX4_MAX_WQE_SIZE = 1008
+};
+
 struct mlx4_device {
 	struct ibv_device		ibv_dev;
 	int				page_size;
@@ -349,6 +353,7 @@ int mlx4_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 			  struct ibv_recv_wr **bad_wr);
 void mlx4_calc_sq_wqe_size(struct ibv_qp_cap *cap, enum ibv_qp_type type,
 			   struct mlx4_qp *qp);
+int num_inline_segs(int data, enum ibv_qp_type type);
 int mlx4_alloc_qp_buf(struct ibv_pd *pd, struct ibv_qp_cap *cap,
 		       enum ibv_qp_type type, struct mlx4_qp *qp);
 void mlx4_set_sq_sizes(struct mlx4_qp *qp, struct ibv_qp_cap *cap,
diff --git a/src/qp.c b/src/qp.c
index d194ae3..6ceb3ef 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -495,7 +495,7 @@ out:
 	return ret;
 }
 
-static int num_inline_segs(int data, enum ibv_qp_type type)
+int num_inline_segs(int data, enum ibv_qp_type type)
 {
 	/*
 	 * Inline data segments are not allowed to cross 64 byte
diff --git a/src/verbs.c b/src/verbs.c
index 1ac1362..5ab20e5 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -384,6 +384,49 @@ int mlx4_destroy_srq(struct ibv_srq *srq)
 	return 0;
 }
 
+static int verify_sizes(struct ibv_qp_init_attr *attr)
+{
+	int size;
+	int nsegs;
+
+	if (attr->cap.max_send_wr     > 65536 ||
+	    attr->cap.max_recv_wr     > 65536 ||
+	    attr->cap.max_send_sge    > 64    ||
+	    attr->cap.max_recv_sge    > 64)
+		return -1;
+
+	/*
+	 * basic numbers needed to understand the calculation
+	 * 1008 is max size of a WQE.
+	 * 64 is a cache line
+	 * 4 bytes for inline header
+	 */
+	if (attr->cap.max_inline_data) {
+		nsegs = num_inline_segs(attr->cap.max_inline_data, attr->qp_type);
+		size = MLX4_MAX_WQE_SIZE - nsegs * sizeof(struct mlx4_wqe_inline_seg);
+		switch (attr->qp_type) {
+		case IBV_QPT_UD:
+			size -= (sizeof(struct mlx4_wqe_ctrl_seg) +
+				 sizeof(struct mlx4_wqe_datagram_seg));
+			break;
+
+		case IBV_QPT_RC:
+		case IBV_QPT_UC:
+			size -= (sizeof(struct mlx4_wqe_ctrl_seg) +
+				 sizeof(struct mlx4_wqe_raddr_seg));
+			break;
+
+		default:
+			return 0;
+		}
+
+		if (attr->cap.max_inline_data > size)
+			return -1;
+	}
+
+	return 0;
+}
+
 struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 {
 	struct mlx4_create_qp     cmd;
@@ -392,11 +435,7 @@ struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 	int			  ret;
 
 	/* Sanity check QP size before proceeding */
-	if (attr->cap.max_send_wr     > 65536 ||
-	    attr->cap.max_recv_wr     > 65536 ||
-	    attr->cap.max_send_sge    > 64    ||
-	    attr->cap.max_recv_sge    > 64    ||
-	    attr->cap.max_inline_data > 1024)
+	if (verify_sizes(attr))
 		return NULL;
 
 	qp = malloc(sizeof *qp);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
