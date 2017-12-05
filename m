From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 4/8] verbs: Bitwise flag values should be unsigned
Date: Tue,  5 Dec 2017 16:17:17 -0700
Message-ID: <20171205231721.19410-5-jgg@ziepe.ca>
References: <20171205231721.19410-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205231721.19410-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Casting rules in C call for sign extension in a number of
cases, so if a bitwise value has the high bit set, then
it can become subtly corrupted if the value is carelessly
casted to a larger type. eg:

  uint64_t val64 = (int32_t)(1ULL<<31);

Gives 0xffffffff80000000 instead of 0x80000000

A trivial fix is to make all the storage for bitwise
values unsigned.

Since switching 'int' to 'unsigned int' is an ABI compatible
change, just go ahead and switch all obvious cases.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_query_device.3 |  2 +-
 libibverbs/verbs.h                | 16 ++++++++--------
 providers/mlx4/cq.c               |  2 +-
 providers/mlx5/cq.c               |  2 +-
 providers/mlx5/mlx5.h             |  2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/libibverbs/man/ibv_query_device.3 b/libibverbs/man/ibv_query_device.3
index 0e9d2860d2b4f4..94dc8a50c06b87 100644
--- a/libibverbs/man/ibv_query_device.3
+++ b/libibverbs/man/ibv_query_device.3
@@ -32,7 +32,7 @@ uint32_t                vendor_part_id;         /* Vendor supplied part ID */
 uint32_t                hw_ver;                 /* Hardware version */
 int                     max_qp;                 /* Maximum number of supported QPs */
 int                     max_qp_wr;              /* Maximum number of outstanding WR on any work queue */
-int                     device_cap_flags;       /* HCA capabilities mask */
+unsigned int            device_cap_flags;       /* HCA capabilities mask */
 int                     max_sge;                /* Maximum number of s/g per WR for SQ & RQ of QP for non RDMA Read operations */
 int                     max_sge_rd;             /* Maximum number of s/g per WR for RDMA Read operations */
 int                     max_cq;                 /* Maximum number of supported CQs */
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 9a3d09e27dc7f8..34995d9c4437fa 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -161,7 +161,7 @@ struct ibv_device_attr {
 	uint32_t		hw_ver;
 	int			max_qp;
 	int			max_qp_wr;
-	int			device_cap_flags;
+	unsigned int		device_cap_flags;
 	int			max_sge;
 	int			max_sge_rd;
 	int			max_cq;
@@ -527,7 +527,7 @@ struct ibv_wc {
 	};
 	uint32_t		qp_num;
 	uint32_t		src_qp;
-	int			wc_flags;
+	unsigned int		wc_flags;
 	uint16_t		pkey_index;
 	uint16_t		slid;
 	uint8_t			sl;
@@ -548,7 +548,7 @@ struct ibv_mw_bind_info {
 	struct ibv_mr	*mr;
 	uint64_t	 addr;
 	uint64_t	 length;
-	int		 mw_access_flags; /* use ibv_access_flags */
+	unsigned int	 mw_access_flags; /* use ibv_access_flags */
 };
 
 struct ibv_pd {
@@ -954,7 +954,7 @@ struct ibv_qp_attr {
 	uint32_t		rq_psn;
 	uint32_t		sq_psn;
 	uint32_t		dest_qp_num;
-	int			qp_access_flags;
+	unsigned int		qp_access_flags;
 	struct ibv_qp_cap	cap;
 	struct ibv_ah_attr	ah_attr;
 	struct ibv_ah_attr	alt_ah_attr;
@@ -1008,7 +1008,7 @@ struct ibv_send_wr {
 	struct ibv_sge	       *sg_list;
 	int			num_sge;
 	enum ibv_wr_opcode	opcode;
-	int			send_flags;
+	unsigned int		send_flags;
 	/* When opcode is *_WITH_IMM: Immediate data in network byte order.
 	 * When opcode is *_INV: Stores the rkey to invalidate
 	 */
@@ -1090,7 +1090,7 @@ struct ibv_ops_wr {
 
 struct ibv_mw_bind {
 	uint64_t		wr_id;
-	int			send_flags;
+	unsigned int		send_flags;
 	struct ibv_mw_bind_info bind_info;
 };
 
@@ -1204,7 +1204,7 @@ struct ibv_cq_ex {
 	__be32 (*read_imm_data)(struct ibv_cq_ex *current);
 	uint32_t (*read_qp_num)(struct ibv_cq_ex *current);
 	uint32_t (*read_src_qp)(struct ibv_cq_ex *current);
-	int (*read_wc_flags)(struct ibv_cq_ex *current);
+	unsigned int (*read_wc_flags)(struct ibv_cq_ex *current);
 	uint32_t (*read_slid)(struct ibv_cq_ex *current);
 	uint8_t (*read_sl)(struct ibv_cq_ex *current);
 	uint8_t (*read_dlid_path_bits)(struct ibv_cq_ex *current);
@@ -1290,7 +1290,7 @@ static inline uint32_t ibv_wc_read_src_qp(struct ibv_cq_ex *cq)
 	return cq->read_src_qp(cq);
 }
 
-static inline int ibv_wc_read_wc_flags(struct ibv_cq_ex *cq)
+static inline unsigned int ibv_wc_read_wc_flags(struct ibv_cq_ex *cq)
 {
 	return cq->read_wc_flags(cq);
 }
diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 8ced49e9592430..697525f43ecaef 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -501,7 +501,7 @@ static uint32_t mlx4_cq_read_wc_qp_num(struct ibv_cq_ex *ibcq)
 	return be32toh(cq->cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK;
 }
 
-static int mlx4_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
+static unsigned int mlx4_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
 {
 	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
 	int is_send  = cq->cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK;
diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 8a1b1671c77426..e96418f6c66ad5 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -1300,7 +1300,7 @@ static inline uint32_t mlx5_cq_read_wc_qp_num(struct ibv_cq_ex *ibcq)
 	return be32toh(cq->cqe64->sop_drop_qpn) & 0xffffff;
 }
 
-static inline int mlx5_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
+static inline unsigned int mlx5_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
 {
 	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
 	int wc_flags = 0;
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index b4782dd0e313c1..f5b493104cf197 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -278,7 +278,7 @@ struct mlx5_context {
 	struct list_head                hugetlb_list;
 	int				cqe_version;
 	uint8_t				cached_link_layer[MLX5_MAX_PORTS_NUM];
-	int				cached_device_cap_flags;
+	unsigned int			cached_device_cap_flags;
 	enum ibv_atomic_cap		atomic_cap;
 	struct {
 		uint64_t                offset;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
