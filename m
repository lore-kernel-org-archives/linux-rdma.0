From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 10/25] IB/mlx5: Set uid as part of RQ commands
Date: Mon, 17 Sep 2018 14:04:03 +0300
Message-ID: <20180917110418.18937-11-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of RQ commands so that the firmware can manage the
RQ object in a secured way.

The uid for the destroy command is set by mlx5_core.

This will enable using an RQ that was created by verbs application to
be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 786db05dfb91..31c69da7ccdf 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1190,7 +1190,7 @@ static size_t get_rq_pas_size(void *qpc)
 
 static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 				   struct mlx5_ib_rq *rq, void *qpin,
-				   size_t qpinlen)
+				   size_t qpinlen, u16 uid)
 {
 	struct mlx5_ib_qp *mqp = rq->base.container_mibqp;
 	__be64 *pas;
@@ -1211,6 +1211,7 @@ static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 	if (!in)
 		return -ENOMEM;
 
+	MLX5_SET(create_rq_in, in, uid, uid);
 	rqc = MLX5_ADDR_OF(create_rq_in, in, ctx);
 	if (!(rq->flags & MLX5_IB_RQ_CVLAN_STRIPPING))
 		MLX5_SET(rqc, rqc, vsd, 1);
@@ -1328,6 +1329,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	struct mlx5_ib_ucontext *mucontext = to_mucontext(ucontext);
 	int err;
 	u32 tdn = mucontext->tdn;
+	u16 uid = mucontext->devx_uid;
 
 	if (qp->sq.wqe_cnt) {
 		err = create_raw_packet_qp_tis(dev, qp, sq, tdn);
@@ -1349,7 +1351,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			rq->flags |= MLX5_IB_RQ_CVLAN_STRIPPING;
 		if (qp->flags & MLX5_IB_QP_PCI_WRITE_END_PADDING)
 			rq->flags |= MLX5_IB_RQ_PCI_WRITE_END_PADDING;
-		err = create_raw_packet_qp_rq(dev, rq, in, inlen);
+		err = create_raw_packet_qp_rq(dev, rq, in, inlen, uid);
 		if (err)
 			goto err_destroy_sq;
 
@@ -2840,7 +2842,8 @@ static int ib_mask_to_mlx5_opt(int ib_mask)
 
 static int modify_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 				   struct mlx5_ib_rq *rq, int new_state,
-				   const struct mlx5_modify_raw_qp_param *raw_qp_param)
+				   const struct mlx5_modify_raw_qp_param *raw_qp_param,
+				   u16 uid)
 {
 	void *in;
 	void *rqc;
@@ -2853,6 +2856,7 @@ static int modify_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 		return -ENOMEM;
 
 	MLX5_SET(modify_rq_in, in, rq_state, rq->state);
+	MLX5_SET(modify_rq_in, in, uid, uid);
 
 	rqc = MLX5_ADDR_OF(modify_rq_in, in, ctx);
 	MLX5_SET(rqc, rqc, state, new_state);
@@ -2957,6 +2961,7 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 				u8 tx_affinity)
 {
 	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
+	u16 uid = to_mucontext(qp->ibqp.uobject->context)->devx_uid;
 	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
 	struct mlx5_ib_sq *sq = &raw_packet_qp->sq;
 	int modify_rq = !!qp->rq.wqe_cnt;
@@ -3000,7 +3005,8 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	}
 
 	if (modify_rq) {
-		err =  modify_raw_packet_qp_rq(dev, rq, rq_state, raw_qp_param);
+		err =  modify_raw_packet_qp_rq(dev, rq, rq_state, raw_qp_param,
+					       uid);
 		if (err)
 			return err;
 	}
@@ -5407,6 +5413,8 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	if (!in)
 		return -ENOMEM;
 
+	MLX5_SET(create_rq_in, in, uid,
+		 to_mucontext(pd->uobject->context)->devx_uid);
 	rqc = MLX5_ADDR_OF(create_rq_in, in, ctx);
 	MLX5_SET(rqc,  rqc, mem_rq_type,
 		 MLX5_RQC_MEM_RQ_TYPE_MEMORY_RQ_INLINE);
@@ -5792,6 +5800,8 @@ int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 	if (wq_state == IB_WQS_ERR)
 		wq_state = MLX5_RQC_STATE_ERR;
 	MLX5_SET(modify_rq_in, in, rq_state, curr_wq_state);
+	MLX5_SET(modify_rq_in, in, uid,
+		 to_mucontext(wq->uobject->context)->devx_uid);
 	MLX5_SET(rqc, rqc, state, wq_state);
 
 	if (wq_attr_mask & IB_WQ_FLAGS) {
-- 
2.14.4
