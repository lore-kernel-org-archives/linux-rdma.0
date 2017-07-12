From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 6/8] mthca: Add sparse annotations
Date: Wed, 12 Jul 2017 15:17:40 -0600
Message-ID: <1499894262-10761-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499894262-10761-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt            |  2 +-
 providers/mthca/cq.c      | 32 ++++++++++++-------------
 providers/mthca/memfree.c |  4 ++--
 providers/mthca/mthca.h   | 24 +++++++++----------
 providers/mthca/qp.c      |  4 ++--
 providers/mthca/wqe.h     | 60 +++++++++++++++++++++++------------------------
 6 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index e57285ae07c9d1..c2d6618ebd4601 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -418,7 +418,7 @@ add_subdirectory(providers/mlx4)
 add_subdirectory(providers/mlx4/man)
 add_subdirectory(providers/mlx5)
 add_subdirectory(providers/mlx5/man)
-add_subdirectory(providers/mthca) # NO SPARSE
+add_subdirectory(providers/mthca)
 add_subdirectory(providers/nes) # NO SPARSE
 add_subdirectory(providers/ocrdma)
 add_subdirectory(providers/qedr)
diff --git a/providers/mthca/cq.c b/providers/mthca/cq.c
index 68550410f349af..dd8baca198c3a3 100644
--- a/providers/mthca/cq.c
+++ b/providers/mthca/cq.c
@@ -93,14 +93,14 @@ enum {
 };
 
 struct mthca_cqe {
-	uint32_t	my_qpn;
-	uint32_t	my_ee;
-	uint32_t	rqpn;
-	uint16_t	sl_g_mlpath;
-	uint16_t	rlid;
-	uint32_t	imm_etype_pkey_eec;
-	uint32_t	byte_cnt;
-	uint32_t	wqe;
+	__be32		my_qpn;
+	__be32		my_ee;
+	__be32		rqpn;
+	__be16		sl_g_mlpath;
+	__be16		rlid;
+	__be32		imm_etype_pkey_eec;
+	__be32		byte_cnt;
+	__be32		wqe;
 	uint8_t		opcode;
 	uint8_t		is_send;
 	uint8_t		reserved;
@@ -108,13 +108,13 @@ struct mthca_cqe {
 };
 
 struct mthca_err_cqe {
-	uint32_t	my_qpn;
-	uint32_t	reserved1[3];
+	__be32		my_qpn;
+	__be32		reserved1[3];
 	uint8_t		syndrome;
 	uint8_t		vendor_err;
-	uint16_t	db_cnt;
-	uint32_t	reserved2;
-	uint32_t	wqe;
+	__be16		db_cnt;
+	__be32		reserved2;
+	__be32		wqe;
 	uint8_t		opcode;
 	uint8_t		reserved3[2];
 	uint8_t		owner;
@@ -163,11 +163,11 @@ static inline void update_cons_index(struct mthca_cq *cq, int incr)
 
 static void dump_cqe(void *cqe_ptr)
 {
-	uint32_t *cqe = cqe_ptr;
+	__be32 *cqe = cqe_ptr;
 	int i;
 
 	for (i = 0; i < 8; ++i)
-		printf("  [%2x] %08x\n", i * 4, be32toh(((uint32_t *) cqe)[i]));
+		printf("  [%2x] %08x\n", i * 4, be32toh(cqe[i]));
 }
 
 static int handle_error_cqe(struct mthca_cq *cq,
@@ -177,7 +177,7 @@ static int handle_error_cqe(struct mthca_cq *cq,
 {
 	int err;
 	int dbd;
-	uint32_t new_wqe;
+	__be32 new_wqe;
 
 	if (cqe->syndrome == SYNDROME_LOCAL_QP_OP_ERR) {
 		printf("local QP operation err "
diff --git a/providers/mthca/memfree.c b/providers/mthca/memfree.c
index 25855429b302f0..14edb00afefd3a 100644
--- a/providers/mthca/memfree.c
+++ b/providers/mthca/memfree.c
@@ -56,7 +56,7 @@ struct mthca_db_table {
 };
 
 int mthca_alloc_db(struct mthca_db_table *db_tab, enum mthca_db_type type,
-		   uint32_t **db)
+		   __be32 **db)
 {
 	int i, j, k;
 	int group, start, end, dir;
@@ -140,7 +140,7 @@ out:
 	return ret;
 }
 
-void mthca_set_db_qn(uint32_t *db, enum mthca_db_type type, uint32_t qn)
+void mthca_set_db_qn(__be32 *db, enum mthca_db_type type, uint32_t qn)
 {
 	db[1] = htobe32((qn << 8) | (type << 5));
 }
diff --git a/providers/mthca/mthca.h b/providers/mthca/mthca.h
index d456e6a50c889f..648ed4a25f1ade 100644
--- a/providers/mthca/mthca.h
+++ b/providers/mthca/mthca.h
@@ -134,9 +134,9 @@ struct mthca_cq {
 
 	/* Next fields are mem-free only */
 	int                set_ci_db_index;
-	uint32_t          *set_ci_db;
+	__be32            *set_ci_db;
 	int                arm_db_index;
-	uint32_t          *arm_db;
+	__be32            *arm_db;
 	int                arm_sn;
 };
 
@@ -157,7 +157,7 @@ struct mthca_srq {
 
 	/* Next fields are mem-free only */
 	int           	   db_index;
-	uint32_t      	  *db;
+	__be32      	  *db;
 	uint16_t      	   counter;
 };
 
@@ -174,7 +174,7 @@ struct mthca_wq {
 
 	/* Next fields are mem-free only */
 	int                db_index;
-	uint32_t          *db;
+	__be32		  *db;
 };
 
 struct mthca_qp {
@@ -191,16 +191,16 @@ struct mthca_qp {
 };
 
 struct mthca_av {
-	uint32_t port_pd;
+	__be32   port_pd;
 	uint8_t  reserved1;
 	uint8_t  g_slid;
-	uint16_t dlid;
+	__be16   dlid;
 	uint8_t  reserved2;
 	uint8_t  gid_index;
 	uint8_t  msg_sr;
 	uint8_t  hop_limit;
-	uint32_t sl_tclass_flowlabel;
-	uint32_t dgid[4];
+	__be32   sl_tclass_flowlabel;
+	__be32   dgid[4];
 };
 
 struct mthca_ah {
@@ -215,7 +215,7 @@ static inline unsigned long align(unsigned long val, unsigned long align)
 	return (val + align - 1) & ~(align - 1);
 }
 
-static inline uintptr_t db_align(uint32_t *db)
+static inline uintptr_t db_align(__be32 *db)
 {
 	return (uintptr_t) db & ~((uintptr_t) MTHCA_DB_REC_PAGE_SIZE - 1);
 }
@@ -268,8 +268,8 @@ int mthca_alloc_buf(struct mthca_buf *buf, size_t size, int page_size);
 void mthca_free_buf(struct mthca_buf *buf);
 
 int mthca_alloc_db(struct mthca_db_table *db_tab, enum mthca_db_type type,
-		   uint32_t **db);
-void mthca_set_db_qn(uint32_t *db, enum mthca_db_type type, uint32_t qn);
+		   __be32 **db);
+void mthca_set_db_qn(__be32 *db, enum mthca_db_type type, uint32_t qn);
 void mthca_free_db(struct mthca_db_table *db_tab, enum mthca_db_type type, int db_index);
 struct mthca_db_table *mthca_alloc_db_tab(int uarc_size);
 void mthca_free_db_tab(struct mthca_db_table *db_tab);
@@ -340,7 +340,7 @@ struct mthca_qp *mthca_find_qp(struct mthca_context *ctx, uint32_t qpn);
 int mthca_store_qp(struct mthca_context *ctx, uint32_t qpn, struct mthca_qp *qp);
 void mthca_clear_qp(struct mthca_context *ctx, uint32_t qpn);
 int mthca_free_err_wqe(struct mthca_qp *qp, int is_send,
-		       int index, int *dbd, uint32_t *new_wqe);
+		       int index, int *dbd, __be32 *new_wqe);
 struct ibv_ah *mthca_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr);
 int mthca_destroy_ah(struct ibv_ah *ah);
 int mthca_alloc_av(struct mthca_pd *pd, struct ibv_ah_attr *attr,
diff --git a/providers/mthca/qp.c b/providers/mthca/qp.c
index 1907f2b82d6987..f4289032a5d2a9 100644
--- a/providers/mthca/qp.c
+++ b/providers/mthca/qp.c
@@ -852,7 +852,7 @@ int mthca_alloc_qp_buf(struct ibv_pd *pd, struct ibv_qp_cap *cap,
 
 	if (mthca_is_memfree(pd->context)) {
 		struct mthca_data_seg *scatter;
-		uint32_t sz;
+		__be32 sz;
 
 		sz = htobe32((sizeof (struct mthca_next_seg) +
 			    qp->rq.max_gs * sizeof (struct mthca_data_seg)) / 16);
@@ -926,7 +926,7 @@ void mthca_clear_qp(struct mthca_context *ctx, uint32_t qpn)
 }
 
 int mthca_free_err_wqe(struct mthca_qp *qp, int is_send,
-		       int index, int *dbd, uint32_t *new_wqe)
+		       int index, int *dbd, __be32 *new_wqe)
 {
 	struct mthca_next_seg *next;
 
diff --git a/providers/mthca/wqe.h b/providers/mthca/wqe.h
index dfd600a26d6022..e56ed9c26cfb6b 100644
--- a/providers/mthca/wqe.h
+++ b/providers/mthca/wqe.h
@@ -60,57 +60,57 @@ enum {
 };
 
 struct mthca_next_seg {
-	uint32_t	nda_op;	/* [31:6] next WQE [4:0] next opcode */
-	uint32_t	ee_nds;	/* [31:8] next EE  [7] DBD [6] F [5:0] next WQE size */
-	uint32_t	flags;	/* [3] CQ [2] Event [1] Solicit */
-	uint32_t	imm;	/* immediate data */
+	__be32		nda_op;	/* [31:6] next WQE [4:0] next opcode */
+	__be32		ee_nds;	/* [31:8] next EE  [7] DBD [6] F [5:0] next WQE size */
+	__be32		flags;	/* [3] CQ [2] Event [1] Solicit */
+	__be32		imm;	/* immediate data */
 };
 
 struct mthca_tavor_ud_seg {
-	uint32_t	reserved1;
-	uint32_t	lkey;
-	uint64_t	av_addr;
-	uint32_t	reserved2[4];
-	uint32_t	dqpn;
-	uint32_t	qkey;
-	uint32_t	reserved3[2];
+	__be32		reserved1;
+	__be32		lkey;
+	__be64		av_addr;
+	__be32		reserved2[4];
+	__be32		dqpn;
+	__be32		qkey;
+	__be32		reserved3[2];
 };
 
 struct mthca_arbel_ud_seg {
-	uint32_t	av[8];
-	uint32_t	dqpn;
-	uint32_t	qkey;
-	uint32_t	reserved[2];
+	__be32		av[8];
+	__be32		dqpn;
+	__be32		qkey;
+	__be32		reserved[2];
 };
 
 struct mthca_bind_seg {
-	uint32_t	flags;	/* [31] Atomic [30] rem write [29] rem read */
-	uint32_t	reserved;
-	uint32_t	new_rkey;
-	uint32_t	lkey;
-	uint64_t	addr;
-	uint64_t	length;
+	__be32		flags;	/* [31] Atomic [30] rem write [29] rem read */
+	__be32		reserved;
+	__be32		new_rkey;
+	__be32		lkey;
+	__be64		addr;
+	__be64		length;
 };
 
 struct mthca_raddr_seg {
-	uint64_t	raddr;
-	uint32_t	rkey;
-	uint32_t	reserved;
+	__be64		raddr;
+	__be32		rkey;
+	__be32		reserved;
 };
 
 struct mthca_atomic_seg {
-	uint64_t	swap_add;
-	uint64_t	compare;
+	__be64		swap_add;
+	__be64		compare;
 };
 
 struct mthca_data_seg {
-	uint32_t	byte_count;
-	uint32_t	lkey;
-	uint64_t	addr;
+	__be32		byte_count;
+	__be32		lkey;
+	__be64		addr;
 };
 
 struct mthca_inline_seg {
-	uint32_t	byte_count;
+	__be32		byte_count;
 };
 
 #endif /* WQE_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
