From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v2 rdma-core 3/8] mlx4: Add sparse annotations
Date: Thu, 20 Jul 2017 11:00:59 -0600
Message-ID: <1500570064-11712-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500570064-11712-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500570064-11712-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt          |  4 +--
 providers/mlx4/cq.c     |  9 ++++--
 providers/mlx4/dbrec.c  |  7 +++--
 providers/mlx4/mlx4.h   | 17 +++++-----
 providers/mlx4/mlx4dv.h | 84 ++++++++++++++++++++++++-------------------------
 providers/mlx4/qp.c     |  4 +--
 providers/mlx4/verbs.c  | 11 ++-----
 7 files changed, 67 insertions(+), 69 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 16196205035f61..1f319390f2e05c 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -414,8 +414,8 @@ add_subdirectory(providers/cxgb3) # NO SPARSE
 add_subdirectory(providers/cxgb4) # NO SPARSE
 add_subdirectory(providers/hns) # NO SPARSE
 add_subdirectory(providers/i40iw) # NO SPARSE
-add_subdirectory(providers/mlx4) # NO SPARSE
-add_subdirectory(providers/mlx4/man) # NO SPARSE
+add_subdirectory(providers/mlx4)
+add_subdirectory(providers/mlx4/man)
 add_subdirectory(providers/mlx5) # NO SPARSE
 add_subdirectory(providers/mlx5/man) # NO SPARSE
 add_subdirectory(providers/mthca) # NO SPARSE
diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 50adebb82237f2..5c7723b43fd855 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -287,7 +287,7 @@ static inline int mlx4_parse_cqe(struct mlx4_cq *cq,
 		case MLX4_RECV_OPCODE_SEND_INVAL:
 			wc->opcode   = IBV_WC_RECV;
 			wc->wc_flags |= IBV_WC_WITH_INV;
-			wc->imm_data = be32toh(cqe->immed_rss_invalid);
+			wc->invalidated_rkey = be32toh(cqe->immed_rss_invalid);
 			break;
 		case MLX4_RECV_OPCODE_SEND:
 			wc->opcode   = IBV_WC_RECV;
@@ -550,13 +550,16 @@ static uint32_t mlx4_cq_read_wc_vendor_err(struct ibv_cq_ex *ibcq)
 	return ecqe->vendor_err;
 }
 
-static uint32_t mlx4_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
+static __be32 mlx4_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
 {
 	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
 
 	switch (mlx4dv_get_cqe_opcode(cq->cqe)) {
 	case MLX4_RECV_OPCODE_SEND_INVAL:
-		return be32toh(cq->cqe->immed_rss_invalid);
+		/* This is returning invalidate_rkey which is in host order, see
+		 * ibv_wc_read_invalidated_rkey
+		 */
+		return (__force __be32)be32toh(cq->cqe->immed_rss_invalid);
 	default:
 		return cq->cqe->immed_rss_invalid;
 	}
diff --git a/providers/mlx4/dbrec.c b/providers/mlx4/dbrec.c
index 3e875738fa61d8..e6d45fcff05a5b 100644
--- a/providers/mlx4/dbrec.c
+++ b/providers/mlx4/dbrec.c
@@ -84,10 +84,10 @@ static struct mlx4_db_page *__add_page(struct mlx4_context *context,
 	return page;
 }
 
-uint32_t *mlx4_alloc_db(struct mlx4_context *context, enum mlx4_db_type type)
+__be32 *mlx4_alloc_db(struct mlx4_context *context, enum mlx4_db_type type)
 {
 	struct mlx4_db_page *page;
-	uint32_t *db = NULL;
+	__be32 *db = NULL;
 	int i, j;
 
 	pthread_mutex_lock(&context->db_list_mutex);
@@ -116,7 +116,8 @@ out:
 	return db;
 }
 
-void mlx4_free_db(struct mlx4_context *context, enum mlx4_db_type type, uint32_t *db)
+void mlx4_free_db(struct mlx4_context *context, enum mlx4_db_type type,
+		  __be32 *db)
 {
 	struct mlx4_db_page *page;
 	uintptr_t ps = to_mdev(context->ibv_ctx.device)->page_size;
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index f38feedddf4705..87a24ccdc580b9 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -159,8 +159,8 @@ struct mlx4_cq {
 	pthread_spinlock_t		lock;
 	uint32_t			cqn;
 	uint32_t			cons_index;
-	uint32_t		       *set_ci_db;
-	uint32_t		       *arm_db;
+	__be32			       *set_ci_db;
+	__be32			       *arm_db;
 	int				arm_sn;
 	int				cqe_size;
 	struct mlx4_qp			*cur_qp;
@@ -179,7 +179,7 @@ struct mlx4_srq {
 	int				wqe_shift;
 	int				head;
 	int				tail;
-	uint32_t		       *db;
+	__be32			       *db;
 	uint16_t			counter;
 	uint8_t				ext_srq;
 };
@@ -202,12 +202,12 @@ struct mlx4_qp {
 	int				max_inline_data;
 	int				buf_size;
 
-	uint32_t			doorbell_qpn;
-	uint32_t			sq_signal_bits;
+	__be32				doorbell_qpn;
+	__be32				sq_signal_bits;
 	int				sq_spare_wqes;
 	struct mlx4_wq			sq;
 
-	uint32_t		       *db;
+	__be32			       *db;
 	struct mlx4_wq			rq;
 
 	uint8_t				link_layer;
@@ -292,8 +292,9 @@ static inline int cleanup_on_fatal(int ret)
 int mlx4_alloc_buf(struct mlx4_buf *buf, size_t size, int page_size);
 void mlx4_free_buf(struct mlx4_buf *buf);
 
-uint32_t *mlx4_alloc_db(struct mlx4_context *context, enum mlx4_db_type type);
-void mlx4_free_db(struct mlx4_context *context, enum mlx4_db_type type, uint32_t *db);
+__be32 *mlx4_alloc_db(struct mlx4_context *context, enum mlx4_db_type type);
+void mlx4_free_db(struct mlx4_context *context, enum mlx4_db_type type,
+		  __be32 *db);
 
 int mlx4_query_device(struct ibv_context *context,
 		       struct ibv_device_attr *attr);
diff --git a/providers/mlx4/mlx4dv.h b/providers/mlx4/mlx4dv.h
index ea16ce8c85dcd4..16045ef223e746 100644
--- a/providers/mlx4/mlx4dv.h
+++ b/providers/mlx4/mlx4dv.h
@@ -125,20 +125,20 @@ enum mlx4_cqe_status {
 };
 
 struct mlx4_cqe {
-	uint32_t	vlan_my_qpn;
-	uint32_t	immed_rss_invalid;
-	uint32_t	g_mlpath_rqpn;
+	__be32		vlan_my_qpn;
+	__be32		immed_rss_invalid;
+	__be32		g_mlpath_rqpn;
 	union {
 		struct {
-			uint16_t	sl_vid;
-			uint16_t	rlid;
+			__be16	sl_vid;
+			__be16	rlid;
 		};
-		uint32_t ts_47_16;
+		__be32	ts_47_16;
 	};
-	uint32_t	status;
-	uint32_t	byte_cnt;
-	uint16_t	wqe_index;
-	uint16_t	checksum;
+	__be32		status;
+	__be32		byte_cnt;
+	__be16		wqe_index;
+	__be16		checksum;
 	uint8_t		reserved3;
 	uint8_t		ts_15_8;
 	uint8_t		ts_7_0;
@@ -146,9 +146,9 @@ struct mlx4_cqe {
 };
 
 struct mlx4dv_qp {
-	uint32_t		*rdb;
+	__be32		       *rdb;
 	uint32_t		*sdb;
-	uint32_t		doorbell_qpn;
+	__be32			doorbell_qpn;
 	struct {
 		uint32_t	wqe_cnt;
 		int		wqe_shift;
@@ -173,8 +173,8 @@ struct mlx4dv_cq {
 	} buf;
 	uint32_t			cqe_cnt;
 	uint32_t			cqn;
-	uint32_t		       *set_ci_db;
-	uint32_t		       *arm_db;
+	__be32			       *set_ci_db;
+	__be32			       *arm_db;
 	int				arm_sn;
 	int				cqe_size;
 	uint64_t			comp_mask;
@@ -187,7 +187,7 @@ struct mlx4dv_srq {
 	int				wqe_shift;
 	int				head;
 	int				tail;
-	uint32_t		       *db;
+	__be32			       *db;
 	uint64_t			comp_mask;
 };
 
@@ -284,28 +284,28 @@ enum {
 
 struct mlx4_wqe_local_inval_seg {
 	uint64_t		reserved1;
-	uint32_t		mem_key;
+	__be32			mem_key;
 	uint32_t		reserved2;
 	uint64_t		reserved3[2];
 };
 
 struct mlx4_wqe_bind_seg {
-	uint32_t		flags1;
-	uint32_t		flags2;
-	uint32_t		new_rkey;
-	uint32_t		lkey;
-	uint64_t		addr;
-	uint64_t		length;
+	__be32			flags1;
+	__be32			flags2;
+	__be32			new_rkey;
+	__be32			lkey;
+	__be64			addr;
+	__be64			length;
 };
 
 struct mlx4_wqe_ctrl_seg {
-	uint32_t		owner_opcode;
+	__be32			owner_opcode;
 	union {
 		struct {
 			uint8_t			reserved[3];
 			uint8_t			fence_size;
 		};
-		uint32_t	bf_qpn;
+		__be32		bf_qpn;
 	};
 	/*
 	 * High 24 bits are SRC remote buffer; low 8 bits are flags:
@@ -316,61 +316,61 @@ struct mlx4_wqe_ctrl_seg {
 	 * [1]   SE (solicited event)
 	 * [0]   FL (force loopback)
 	 */
-	uint32_t		srcrb_flags;
+	__be32			srcrb_flags;
 	/*
 	 * imm is immediate data for send/RDMA write w/ immediate;
 	 * also invalidation key for send with invalidate; input
 	 * modifier for WQEs on CCQs.
 	 */
-	uint32_t		imm;
+	__be32			imm;
 };
 
 struct mlx4_av {
-	uint32_t			port_pd;
+	__be32				port_pd;
 	uint8_t				reserved1;
 	uint8_t				g_slid;
-	uint16_t			dlid;
+	__be16				dlid;
 	uint8_t				reserved2;
 	uint8_t				gid_index;
 	uint8_t				stat_rate;
 	uint8_t				hop_limit;
-	uint32_t			sl_tclass_flowlabel;
+	__be32				sl_tclass_flowlabel;
 	uint8_t				dgid[16];
 };
 
 struct mlx4_wqe_datagram_seg {
 	struct mlx4_av		av;
-	uint32_t		dqpn;
-	uint32_t		qkey;
-	uint16_t		vlan;
+	__be32			dqpn;
+	__be32			qkey;
+	__be16			vlan;
 	uint8_t			mac[6];
 };
 
 struct mlx4_wqe_data_seg {
-	uint32_t		byte_count;
-	uint32_t		lkey;
-	uint64_t		addr;
+	__be32			byte_count;
+	__be32			lkey;
+	__be64			addr;
 };
 
 struct mlx4_wqe_inline_seg {
-	uint32_t		byte_count;
+	__be32			byte_count;
 };
 
 struct mlx4_wqe_srq_next_seg {
 	uint16_t		reserved1;
-	uint16_t		next_wqe_index;
+	__be16			next_wqe_index;
 	uint32_t		reserved2[3];
 };
 
 struct mlx4_wqe_raddr_seg {
-	uint64_t		raddr;
-	uint32_t		rkey;
-	uint32_t		reserved;
+	__be64			raddr;
+	__be32			rkey;
+	__be32			reserved;
 };
 
 struct mlx4_wqe_atomic_seg {
-	uint64_t		swap_add;
-	uint64_t		compare;
+	__be64			swap_add;
+	__be64			compare;
 };
 
 /*
diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index 1be100b9c2abf7..6d5986ec1c2958 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -304,7 +304,7 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			case IBV_WR_LOCAL_INV:
 				ctrl->srcrb_flags |=
 					htobe32(MLX4_WQE_CTRL_STRONG_ORDER);
-				set_local_inv_seg(wqe, wr->imm_data);
+				set_local_inv_seg(wqe, wr->invalidate_rkey);
 				wqe  += sizeof
 					(struct mlx4_wqe_local_inval_seg);
 				size += sizeof
@@ -320,7 +320,7 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 					(struct mlx4_wqe_bind_seg) / 16;
 				break;
 			case IBV_WR_SEND_WITH_INV:
-				ctrl->imm = htobe32(wr->imm_data);
+				ctrl->imm = htobe32(wr->invalidate_rkey);
 				break;
 
 			default:
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 548ac2ac2864f0..6a240c5146092f 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -104,7 +104,7 @@ int mlx4_query_device_ex(struct ibv_context *context,
 
 static int mlx4_read_clock(struct ibv_context *context, uint64_t *cycles)
 {
-	unsigned int clockhi, clocklo, clockhi1;
+	uint32_t clockhi, clocklo, clockhi1;
 	int i;
 	struct mlx4_context *ctx = to_mctx(context);
 
@@ -1123,14 +1123,7 @@ int mlx4_destroy_qp(struct ibv_qp *ibqp)
 
 static int link_local_gid(const union ibv_gid *gid)
 {
-	uint32_t *tmp = (uint32_t *)gid->raw;
-	uint32_t hi = tmp[0];
-	uint32_t lo = tmp[1];
-
-	if (hi == htobe32(0xfe800000) && lo == 0)
-		return 1;
-
-	return 0;
+	return gid->global.subnet_prefix == htobe64(0xfe80000000000000ULL);
 }
 
 static int is_multicast_gid(const union ibv_gid *gid)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
