From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 22/25] IB/mlx5: Expose RAW QP device handles to user space
Date: Mon, 17 Sep 2018 14:04:15 +0300
Message-ID: <20180917110418.18937-23-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Expose RAW QP device handles to user space by extending the UHW part of
mlx5_ib_create_qp_resp.

This data is returned only when DEVX context is used where it may be
applicable.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 38 ++++++++++++++++++++++++++++++++++++--
 include/uapi/rdma/mlx5-abi.h    | 13 +++++++++++++
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 00b36b971ffa..9a04f8b12a75 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1325,7 +1325,9 @@ static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 
 static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 				u32 *in, size_t inlen,
-				struct ib_pd *pd)
+				struct ib_pd *pd,
+				struct ib_udata *udata,
+				struct mlx5_ib_create_qp_resp *resp)
 {
 	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
 	struct mlx5_ib_sq *sq = &raw_packet_qp->sq;
@@ -1346,6 +1348,13 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		if (err)
 			goto err_destroy_tis;
 
+		if (uid) {
+			resp->tisn = sq->tisn;
+			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_TISN;
+			resp->sqn = sq->base.mqp.qpn;
+			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_SQN;
+		}
+
 		sq->base.container_mibqp = qp;
 		sq->base.mqp.event = mlx5_ib_qp_event;
 	}
@@ -1365,13 +1374,26 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 					       uid);
 		if (err)
 			goto err_destroy_rq;
+
+		if (uid) {
+			resp->rqn = rq->base.mqp.qpn;
+			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_RQN;
+			resp->tirn = rq->tirn;
+			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_TIRN;
+		}
 	}
 
 	qp->trans_qp.base.mqp.qpn = qp->sq.wqe_cnt ? sq->base.mqp.qpn :
 						     rq->base.mqp.qpn;
 
+	err = ib_copy_to_udata(udata, resp, min(udata->outlen, sizeof(*resp)));
+	if (err)
+		goto err_destroy_tir;
+
 	return 0;
 
+err_destroy_tir:
+	destroy_raw_packet_qp_tir(dev, rq, qp->flags_en, uid);
 err_destroy_rq:
 	destroy_raw_packet_qp_rq(dev, rq);
 err_destroy_sq:
@@ -1643,12 +1665,23 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (err)
 		goto err;
 
+	if (mucontext->devx_uid) {
+		resp.comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_TIRN;
+		resp.tirn = qp->rss_qp.tirn;
+	}
+
+	err = ib_copy_to_udata(udata, &resp, min(udata->outlen, sizeof(resp)));
+	if (err)
+		goto err_copy;
+
 	kvfree(in);
 	/* qpn is reserved for that QP */
 	qp->trans_qp.base.mqp.qpn = 0;
 	qp->flags |= MLX5_IB_QP_RSS;
 	return 0;
 
+err_copy:
+	mlx5_cmd_destroy_tir(dev->mdev, qp->rss_qp.tirn, mucontext->devx_uid);
 err:
 	kvfree(in);
 	return err;
@@ -2030,7 +2063,8 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	    qp->flags & MLX5_IB_QP_UNDERLAY) {
 		qp->raw_packet_qp.sq.ubuffer.buf_addr = ucmd.sq_buf_addr;
 		raw_packet_qp_copy_info(qp, &qp->raw_packet_qp);
-		err = create_raw_packet_qp(dev, qp, in, inlen, pd);
+		err = create_raw_packet_qp(dev, qp, in, inlen, pd, udata,
+					   &resp);
 	} else {
 		err = mlx5_core_create_qp(dev->mdev, &base->mqp, in, inlen);
 	}
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 3ddb31a0bc47..8fa9f90e2bb1 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -352,9 +352,22 @@ struct mlx5_ib_create_qp_rss {
 	__u32	flags;
 };
 
+enum mlx5_ib_create_qp_resp_mask {
+	MLX5_IB_CREATE_QP_RESP_MASK_TIRN = 1UL << 0,
+	MLX5_IB_CREATE_QP_RESP_MASK_TISN = 1UL << 1,
+	MLX5_IB_CREATE_QP_RESP_MASK_RQN  = 1UL << 2,
+	MLX5_IB_CREATE_QP_RESP_MASK_SQN  = 1UL << 3,
+};
+
 struct mlx5_ib_create_qp_resp {
 	__u32	bfreg_index;
 	__u32   reserved;
+	__u32	comp_mask;
+	__u32	tirn;
+	__u32	tisn;
+	__u32	rqn;
+	__u32	sqn;
+	__u32   reserved1;
 };
 
 struct mlx5_ib_alloc_mw {
-- 
2.14.4
