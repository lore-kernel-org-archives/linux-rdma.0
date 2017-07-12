From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/8] mlx5: Add sparse annotations
Date: Wed, 12 Jul 2017 15:17:39 -0600
Message-ID: <1499894262-10761-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499894262-10761-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt          |  4 +--
 providers/mlx5/cq.c     | 10 +++++---
 providers/mlx5/dbrec.c  |  6 ++---
 providers/mlx5/mlx5.h   | 14 +++++-----
 providers/mlx5/mlx5dv.h | 68 ++++++++++++++++++++++++-------------------------
 providers/mlx5/qp.c     | 10 ++++----
 providers/mlx5/verbs.c  |  4 +--
 providers/mlx5/wqe.h    | 34 ++++++++++++-------------
 8 files changed, 76 insertions(+), 74 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 1f319390f2e05c..e57285ae07c9d1 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -416,8 +416,8 @@ add_subdirectory(providers/hns) # NO SPARSE
 add_subdirectory(providers/i40iw) # NO SPARSE
 add_subdirectory(providers/mlx4)
 add_subdirectory(providers/mlx4/man)
-add_subdirectory(providers/mlx5) # NO SPARSE
-add_subdirectory(providers/mlx5/man) # NO SPARSE
+add_subdirectory(providers/mlx5)
+add_subdirectory(providers/mlx5/man)
 add_subdirectory(providers/mthca) # NO SPARSE
 add_subdirectory(providers/nes) # NO SPARSE
 add_subdirectory(providers/ocrdma)
diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 9a8d958a9ced68..b845127de937d0 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -246,7 +246,7 @@ static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 	case MLX5_CQE_RESP_SEND_INV:
 		wc->opcode = IBV_WC_RECV;
 		wc->wc_flags |= IBV_WC_WITH_INV;
-		wc->imm_data = be32toh(cqe->imm_inval_pkey);
+		wc->invalidated_rkey = be32toh(cqe->imm_inval_pkey);
 		break;
 	}
 	wc->slid	   = be16toh(cqe->slid);
@@ -262,7 +262,7 @@ static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 
 static void dump_cqe(FILE *fp, void *buf)
 {
-	uint32_t *p = buf;
+	__be32 *p = buf;
 	int i;
 
 	for (i = 0; i < 16; i += 4)
@@ -1141,13 +1141,15 @@ static inline uint32_t mlx5_cq_read_wc_vendor_err(struct ibv_cq_ex *ibcq)
 	return ecqe->vendor_err_synd;
 }
 
-static inline uint32_t mlx5_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
+static inline __be32 mlx5_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
 {
 	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
 
 	switch (mlx5dv_get_cqe_opcode(cq->cqe64)) {
 	case MLX5_CQE_RESP_SEND_INV:
-		return be32toh(cq->cqe64->imm_inval_pkey);
+		/* This is returning invalidate_rkey which is in host order, see
+		 * ibv_wc_read_invalidated_rkey */
+		return (__force __be32)be32toh(cq->cqe64->imm_inval_pkey);
 	default:
 		return cq->cqe64->imm_inval_pkey;
 	}
diff --git a/providers/mlx5/dbrec.c b/providers/mlx5/dbrec.c
index f346939a8edf2b..4e51857f31bdd6 100644
--- a/providers/mlx5/dbrec.c
+++ b/providers/mlx5/dbrec.c
@@ -80,7 +80,7 @@ static struct mlx5_db_page *__add_page(struct mlx5_context *context)
 	return page;
 }
 
-uint32_t *mlx5_alloc_dbrec(struct mlx5_context *context)
+__be32 *mlx5_alloc_dbrec(struct mlx5_context *context)
 {
 	struct mlx5_db_page *page;
 	uint32_t *db = NULL;
@@ -110,10 +110,10 @@ found:
 out:
 	pthread_mutex_unlock(&context->db_list_mutex);
 
-	return db;
+	return (__force __be32 *)db;
 }
 
-void mlx5_free_db(struct mlx5_context *context, uint32_t *db)
+void mlx5_free_db(struct mlx5_context *context, __be32 *db)
 {
 	struct mlx5_db_page *page;
 	uintptr_t ps = to_mdev(context->ibv_ctx.device)->page_size;
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 615dea38e4fedd..4c494dda2727f2 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -324,7 +324,7 @@ struct mlx5_cq {
 	struct mlx5_spinlock		lock;
 	uint32_t			cqn;
 	uint32_t			cons_index;
-	uint32_t		       *dbrec;
+	__be32			       *dbrec;
 	int				arm_sn;
 	int				cqe_sz;
 	int				resize_cqe_sz;
@@ -352,7 +352,7 @@ struct mlx5_srq {
 	int				wqe_shift;
 	int				head;
 	int				tail;
-	uint32_t		       *db;
+	__be32			       *db;
 	uint16_t			counter;
 	int				wq_sig;
 };
@@ -410,7 +410,7 @@ struct mlx5_qp {
 	uint8_t	                        sq_signal_bits;
 	struct mlx5_wq                  sq;
 
-	uint32_t                       *db;
+	__be32                         *db;
 	struct mlx5_wq                  rq;
 	int                             wq_sig;
 	uint32_t			qp_cap_cache;
@@ -432,9 +432,9 @@ struct mlx5_rwq {
 	struct mlx5_buf buf;
 	int buf_size;
 	struct mlx5_wq rq;
-	uint32_t *db;
+	__be32  *db;
 	void	*pbuff;
-	uint32_t	*recv_db;
+	__be32	*recv_db;
 	int wq_sig;
 };
 
@@ -561,8 +561,8 @@ void mlx5_get_alloc_type(const char *component,
 			 enum mlx5_alloc_type default_alloc_type);
 int mlx5_use_huge(const char *key);
 
-uint32_t *mlx5_alloc_dbrec(struct mlx5_context *context);
-void mlx5_free_db(struct mlx5_context *context, uint32_t *db);
+__be32 *mlx5_alloc_dbrec(struct mlx5_context *context);
+void mlx5_free_db(struct mlx5_context *context, __be32 *db);
 
 int mlx5_query_device(struct ibv_context *context,
 		       struct ibv_device_attr *attr);
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index a03b1d73ccb544..cff3a10457300f 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -106,7 +106,7 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 			struct mlx5dv_context *attrs_out);
 
 struct mlx5dv_qp {
-	uint32_t		*dbrec;
+	__be32			*dbrec;
 	struct {
 		void		*buf;
 		uint32_t	wqe_cnt;
@@ -126,7 +126,7 @@ struct mlx5dv_qp {
 
 struct mlx5dv_cq {
 	void			*buf;
-	uint32_t		*dbrec;
+	__be32			*dbrec;
 	uint32_t		cqe_cnt;
 	uint32_t		cqe_size;
 	void			*uar;
@@ -136,7 +136,7 @@ struct mlx5dv_cq {
 
 struct mlx5dv_srq {
 	void			*buf;
-	uint32_t		*dbrec;
+	__be32			*dbrec;
 	uint32_t		stride;
 	uint32_t		head;
 	uint32_t		tail;
@@ -145,7 +145,7 @@ struct mlx5dv_srq {
 
 struct mlx5dv_rwq {
 	void		*buf;
-	uint32_t	*dbrec;
+	__be32		*dbrec;
 	uint32_t	wqe_cnt;
 	uint32_t	stride;
 	uint64_t	comp_mask;
@@ -285,18 +285,18 @@ struct mlx5_cqe64 {
 	uint8_t		rsvd0[17];
 	uint8_t		ml_path;
 	uint8_t		rsvd20[4];
-	uint16_t	slid;
-	uint32_t	flags_rqpn;
+	__be16		slid;
+	__be32		flags_rqpn;
 	uint8_t		hds_ip_ext;
 	uint8_t		l4_hdr_type_etc;
-	uint16_t	vlan_info;
-	uint32_t	srqn_uidx;
-	uint32_t	imm_inval_pkey;
+	__be16		vlan_info;
+	__be32		srqn_uidx;
+	__be32		imm_inval_pkey;
 	uint8_t		rsvd40[4];
-	uint32_t	byte_cnt;
+	__be32		byte_cnt;
 	__be64		timestamp;
-	uint32_t	sop_drop_qpn;
-	uint16_t	wqe_counter;
+	__be32		sop_drop_qpn;
+	__be16		wqe_counter;
 	uint8_t		signature;
 	uint8_t		op_own;
 };
@@ -372,43 +372,43 @@ enum {
 
 struct mlx5_wqe_srq_next_seg {
 	uint8_t			rsvd0[2];
-	uint16_t		next_wqe_index;
+	__be16			next_wqe_index;
 	uint8_t			signature;
 	uint8_t			rsvd1[11];
 };
 
 struct mlx5_wqe_data_seg {
-	uint32_t		byte_count;
-	uint32_t		lkey;
-	uint64_t		addr;
+	__be32			byte_count;
+	__be32			lkey;
+	__be64			addr;
 };
 
 struct mlx5_wqe_ctrl_seg {
-	uint32_t	opmod_idx_opcode;
-	uint32_t	qpn_ds;
+	__be32		opmod_idx_opcode;
+	__be32		qpn_ds;
 	uint8_t		signature;
 	uint8_t		rsvd[2];
 	uint8_t		fm_ce_se;
-	uint32_t	imm;
+	__be32		imm;
 };
 
 struct mlx5_wqe_av {
 	union {
 		struct {
-			uint32_t	qkey;
-			uint32_t	reserved;
+			__be32		qkey;
+			__be32		reserved;
 		} qkey;
-		uint64_t	dc_key;
+		__be64		dc_key;
 	} key;
-	uint32_t	dqp_dct;
+	__be32		dqp_dct;
 	uint8_t		stat_rate_sl;
 	uint8_t		fl_mlid;
-	uint16_t	rlid;
+	__be16		rlid;
 	uint8_t		reserved0[4];
 	uint8_t		rmac[6];
 	uint8_t		tclass;
 	uint8_t		hop_limit;
-	uint32_t	grh_gid_fl;
+	__be32		grh_gid_fl;
 	uint8_t		rgid[16];
 };
 
@@ -417,14 +417,14 @@ struct mlx5_wqe_datagram_seg {
 };
 
 struct mlx5_wqe_raddr_seg {
-	uint64_t	raddr;
-	uint32_t	rkey;
-	uint32_t	reserved;
+	__be64		raddr;
+	__be32		rkey;
+	__be32		reserved;
 };
 
 struct mlx5_wqe_atomic_seg {
-	uint64_t	swap_add;
-	uint64_t	compare;
+	__be64		swap_add;
+	__be64		compare;
 };
 
 struct mlx5_wqe_inl_data_seg {
@@ -432,12 +432,12 @@ struct mlx5_wqe_inl_data_seg {
 };
 
 struct mlx5_wqe_eth_seg {
-	uint32_t	rsvd0;
+	__be32		rsvd0;
 	uint8_t		cs_flags;
 	uint8_t		rsvd1;
-	uint16_t	mss;
-	uint32_t	rsvd2;
-	uint16_t	inline_hdr_sz;
+	__be16		mss;
+	__be32		rsvd2;
+	__be16		inline_hdr_sz;
 	uint8_t		inline_hdr_start[2];
 	uint8_t		inline_hdr[16];
 };
diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index e71284e191de00..52da8c15ab28db 100644
--- a/providers/mlx5/qp.c
+++ b/providers/mlx5/qp.c
@@ -249,14 +249,14 @@ static void mlx5_bf_copy(uint64_t *dst, const uint64_t *src, unsigned bytecnt,
 	} while (bytecnt > 0);
 }
 
-static uint32_t send_ieth(struct ibv_send_wr *wr)
+static __be32 send_ieth(struct ibv_send_wr *wr)
 {
 	switch (wr->opcode) {
 	case IBV_WR_SEND_WITH_IMM:
 	case IBV_WR_RDMA_WRITE_WITH_IMM:
 		return wr->imm_data;
 	case IBV_WR_SEND_WITH_INV:
-		return htobe32(wr->imm_data);
+		return htobe32(wr->invalidate_rkey);
 	default:
 		return 0;
 	}
@@ -408,7 +408,7 @@ static inline int copy_eth_inline_headers(struct ibv_qp *ibqp,
 
 #define ALIGN(x, log_a) ((((x) + (1 << (log_a)) - 1)) & ~((1 << (log_a)) - 1))
 
-static inline uint16_t get_klm_octo(int nentries)
+static inline __be16 get_klm_octo(int nentries)
 {
 	return htobe16(ALIGN(nentries, 3) / 2);
 }
@@ -737,7 +737,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				struct ibv_mw_bind_info	bind_info = {};
 
 				next_fence = MLX5_WQE_CTRL_INITIATOR_SMALL_FENCE;
-				ctrl->imm = htobe32(wr->imm_data);
+				ctrl->imm = htobe32(wr->invalidate_rkey);
 				err = set_bind_wr(qp, IBV_MW_TYPE_2, 0,
 						  &bind_info, ibqp->qp_num,
 						  &seg, &size);
@@ -782,7 +782,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				struct ibv_mw_bind_info	bind_info = {};
 
 				next_fence = MLX5_WQE_CTRL_INITIATOR_SMALL_FENCE;
-				ctrl->imm = htobe32(wr->imm_data);
+				ctrl->imm = htobe32(wr->invalidate_rkey);
 				err = set_bind_wr(qp, IBV_MW_TYPE_2, 0,
 						  &bind_info, ibqp->qp_num,
 						  &seg, &size);
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index c95a4d49f29614..c18adf91ac7563 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1555,7 +1555,7 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	struct mlx5_qp *mqp = to_mqp(qp);
 	struct mlx5_context *context = to_mctx(qp->context);
 	int ret;
-	uint32_t *db;
+	__be32 *db;
 
 	if (mqp->rss_qp)
 		return ENOSYS;
@@ -1638,7 +1638,7 @@ struct ibv_ah *mlx5_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 	struct ibv_port_attr port_attr;
 	struct mlx5_ah *ah;
 	uint32_t gid_type;
-	uint32_t tmp;
+	__be32 tmp;
 	uint8_t grh;
 	int is_eth;
 
diff --git a/providers/mlx5/wqe.h b/providers/mlx5/wqe.h
index cbe05d3d673867..063dc9ab9a03f4 100644
--- a/providers/mlx5/wqe.h
+++ b/providers/mlx5/wqe.h
@@ -51,7 +51,7 @@ struct mlx5_eqe_qp_srq {
 };
 
 struct mlx5_wqe_xrc_seg {
-	uint32_t	xrc_srqn;
+	__be32		xrc_srqn;
 	uint8_t		rsvd[12];
 };
 
@@ -89,17 +89,17 @@ enum {
 struct mlx5_wqe_umr_ctrl_seg {
 	uint8_t		flags;
 	uint8_t		rsvd0[3];
-	uint16_t	klm_octowords;
-	uint16_t	translation_offset;
-	uint64_t	mkey_mask;
+	__be16		klm_octowords;
+	__be16		translation_offset;
+	__be64		mkey_mask;
 	uint8_t		rsvd1[32];
 };
 
 struct mlx5_wqe_umr_klm_seg {
 	/* up to 2GB */
-	uint32_t	byte_count;
-	uint32_t	mkey;
-	uint64_t	address;
+	__be32		byte_count;
+	__be32		mkey;
+	__be64		address;
 };
 
 union mlx5_wqe_umr_inline_seg {
@@ -123,17 +123,17 @@ struct mlx5_wqe_mkey_context_seg {
 	uint8_t		reserved1;
 	uint8_t		access_flags;
 	uint8_t		sf;
-	uint32_t	qpn_mkey;
-	uint32_t	reserved2;
-	uint32_t	flags_pd;
-	uint64_t	start_addr;
-	uint64_t	len;
-	uint32_t	bsf_octword_size;
-	uint32_t	reserved3[4];
-	uint32_t	translations_octword_size;
+	__be32		qpn_mkey;
+	__be32		reserved2;
+	__be32		flags_pd;
+	__be64		start_addr;
+	__be64		len;
+	__be32		bsf_octword_size;
+	__be32		reserved3[4];
+	__be32		translations_octword_size;
 	uint8_t		reserved4[3];
 	uint8_t		log_page_size;
-	uint32_t	reserved;
+	__be32		reserved;
 	union mlx5_wqe_umr_inline_seg inseg[0];
 };
 
@@ -183,7 +183,7 @@ struct mlx5_wqe_signature_seg {
 };
 
 struct mlx5_wqe_inline_seg {
-	uint32_t	byte_count;
+	__be32		byte_count;
 };
 
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
