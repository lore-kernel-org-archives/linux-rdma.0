From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libmlx4: fix possible inline size
Date: Thu, 16 Sep 2010 14:57:14 +0200
Message-ID: <20100916125714.GA10857@mtldesk30>
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
 src/verbs.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/src/verbs.c b/src/verbs.c
index 1ac1362..69f5c63 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -384,6 +384,51 @@ int mlx4_destroy_srq(struct ibv_srq *srq)
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
+		switch (attr->qp_type) {
+		case IBV_QPT_UD:
+			size = 1008 - sizeof(struct mlx4_wqe_ctrl_seg) -
+				sizeof(struct mlx4_wqe_datagram_seg);
+			nsegs = (attr->cap.max_inline_data + 59) / 60;
+			break;
+
+		case IBV_QPT_RC:
+		case IBV_QPT_UC:
+		case IBV_QPT_XRC:
+			size = 1008 - sizeof(struct mlx4_wqe_ctrl_seg) -
+				sizeof(struct mlx4_wqe_raddr_seg) - 4;
+			nsegs = (attr->cap.max_inline_data - 28 + 59) / 60;
+			break;
+
+		default:
+			return 0;
+		}
+
+		size -= nsegs * 4;
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
@@ -392,11 +437,7 @@ struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
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
1.7.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
