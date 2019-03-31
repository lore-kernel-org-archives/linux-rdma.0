From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 8/8] IB/mlx5: Expose TIR ICM address to user space
Date: Sun, 31 Mar 2019 19:44:50 +0300
Message-ID: <20190331164450.23618-9-leon@kernel.org>
References: <20190331164450.23618-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190331164450.23618-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

This patch exposes the TIR ICM address of raw packet and RSS
QPs to user space.

In order to pass the new field, the patch extends the mlx5
specific QP creation response structure and fills it with
the icm address returned by the FW command, if available.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 46 +++++++++++++++++++++++++++++----
 include/uapi/rdma/mlx5-abi.h    |  2 ++
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 3ff7c32207b9..6b332b896c57 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1397,7 +1397,8 @@ static void destroy_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 				    struct mlx5_ib_rq *rq, u32 tdn,
 				    u32 *qp_flags_en,
-				    struct ib_pd *pd)
+				    struct ib_pd *pd,
+				    u32 *out, int outlen)
 {
 	u8 lb_flag = 0;
 	u32 *in;
@@ -1431,8 +1432,9 @@ static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 
 	MLX5_SET(tirc, tirc, self_lb_block, lb_flag);
 
-	err = mlx5_core_create_tir(dev->mdev, in, inlen, &rq->tirn);
+	err = mlx5_core_create_tir_out(dev->mdev, in, inlen, out, outlen);
 
+	rq->tirn = MLX5_GET(create_tir_out, out, tirn);
 	if (!err && MLX5_GET(tirc, tirc, self_lb_block)) {
 		err = mlx5_ib_enable_lb(dev, false, true);
 
@@ -1458,6 +1460,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	int err;
 	u32 tdn = mucontext->tdn;
 	u16 uid = to_mpd(pd)->uid;
+	u32 out[MLX5_ST_SZ_DW(create_tir_out)] = {};
 
 	if (qp->sq.wqe_cnt) {
 		err = create_raw_packet_qp_tis(dev, qp, sq, tdn, pd);
@@ -1490,7 +1493,9 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		if (err)
 			goto err_destroy_sq;
 
-		err = create_raw_packet_qp_tir(dev, rq, tdn, &qp->flags_en, pd);
+		err = create_raw_packet_qp_tir(
+			dev, rq, tdn, &qp->flags_en, pd, out,
+			MLX5_ST_SZ_BYTES(create_tir_out));
 		if (err)
 			goto err_destroy_rq;
 
@@ -1499,6 +1504,20 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_RQN;
 			resp->tirn = rq->tirn;
 			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_TIRN;
+			if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner)) {
+				resp->tir_icm_addr = MLX5_GET(
+					create_tir_out, out, icm_address_31_0);
+				resp->tir_icm_addr |=
+					(u64)MLX5_GET(create_tir_out, out,
+						      icm_address_39_32)
+					<< 32;
+				resp->tir_icm_addr |=
+					(u64)MLX5_GET(create_tir_out, out,
+						      icm_address_63_40)
+					<< 40;
+				resp->comp_mask |=
+					MLX5_IB_CREATE_QP_RESP_MASK_TIR_ICM_ADDR;
+			}
 		}
 	}
 
@@ -1572,8 +1591,10 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		udata, struct mlx5_ib_ucontext, ibucontext);
 	struct mlx5_ib_create_qp_resp resp = {};
 	int inlen;
+	int outlen;
 	int err;
 	u32 *in;
+	u32 *out;
 	void *tirc;
 	void *hfso;
 	u32 selected_fields = 0;
@@ -1653,10 +1674,12 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	}
 
 	inlen = MLX5_ST_SZ_BYTES(create_tir_in);
-	in = kvzalloc(inlen, GFP_KERNEL);
+	outlen = MLX5_ST_SZ_BYTES(create_tir_out);
+	in = kvzalloc(inlen + outlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
+	out = in + MLX5_ST_SZ_DW(create_tir_in);
 	MLX5_SET(create_tir_in, in, uid, to_mpd(pd)->uid);
 	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 	MLX5_SET(tirc, tirc, disp_type,
@@ -1768,8 +1791,9 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	MLX5_SET(rx_hash_field_select, hfso, selected_fields, selected_fields);
 
 create_tir:
-	err = mlx5_core_create_tir(dev->mdev, in, inlen, &qp->rss_qp.tirn);
+	err = mlx5_core_create_tir_out(dev->mdev, in, inlen, out, outlen);
 
+	qp->rss_qp.tirn = MLX5_GET(create_tir_out, out, tirn);
 	if (!err && MLX5_GET(tirc, tirc, self_lb_block)) {
 		err = mlx5_ib_enable_lb(dev, false, true);
 
@@ -1784,6 +1808,18 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (mucontext->devx_uid) {
 		resp.comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_TIRN;
 		resp.tirn = qp->rss_qp.tirn;
+		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner)) {
+			resp.tir_icm_addr =
+				MLX5_GET(create_tir_out, out, icm_address_31_0);
+			resp.tir_icm_addr |= (u64)MLX5_GET(create_tir_out, out,
+							   icm_address_39_32)
+					     << 32;
+			resp.tir_icm_addr |= (u64)MLX5_GET(create_tir_out, out,
+							   icm_address_63_40)
+					     << 40;
+			resp.comp_mask |=
+				MLX5_IB_CREATE_QP_RESP_MASK_TIR_ICM_ADDR;
+		}
 	}
 
 	err = ib_copy_to_udata(udata, &resp, min(udata->outlen, sizeof(resp)));
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 87b3198f4b5d..0ef404f75f56 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -359,6 +359,7 @@ enum mlx5_ib_create_qp_resp_mask {
 	MLX5_IB_CREATE_QP_RESP_MASK_TISN = 1UL << 1,
 	MLX5_IB_CREATE_QP_RESP_MASK_RQN  = 1UL << 2,
 	MLX5_IB_CREATE_QP_RESP_MASK_SQN  = 1UL << 3,
+	MLX5_IB_CREATE_QP_RESP_MASK_TIR_ICM_ADDR  = 1UL << 4,
 };
 
 struct mlx5_ib_create_qp_resp {
@@ -370,6 +371,7 @@ struct mlx5_ib_create_qp_resp {
 	__u32	rqn;
 	__u32	sqn;
 	__u32   reserved1;
+	__u64	tir_icm_addr;
 };
 
 struct mlx5_ib_alloc_mw {
-- 
2.20.1
