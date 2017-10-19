From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/6] IB/mlx5: Support 128B CQE compression feature
Date: Thu, 19 Oct 2017 08:25:52 +0300
Message-ID: <20171019052556.8514-3-leon@kernel.org>
References: <20171019052556.8514-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019052556.8514-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In commit 1cbe6fc86ccf ("IB/mlx5: Add support for CQE compressing") the
concept of CQE compression was introduced and added a support for 64B
CQE size. This change update the code to support 128B CQE size as well.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c   | 6 ++++--
 drivers/infiniband/hw/mlx5/main.c | 8 ++++++--
 include/uapi/rdma/mlx5-abi.h      | 7 ++++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index b8a116d0e063..51871f049c57 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -804,8 +804,10 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 	*index = to_mucontext(context)->bfregi.sys_pages[0];
 
 	if (ucmd.cqe_comp_en == 1) {
-		if (unlikely((*cqe_size != 64) ||
-			     !MLX5_CAP_GEN(dev->mdev, cqe_compression))) {
+		if (!((*cqe_size == 128 &&
+		       MLX5_CAP_GEN(dev->mdev, cqe_compression_128)) ||
+		      (*cqe_size == 64  &&
+		       MLX5_CAP_GEN(dev->mdev, cqe_compression)))) {
 			err = -EOPNOTSUPP;
 			mlx5_ib_warn(dev, "CQE compression is not supported for size %d!\n",
 				     *cqe_size);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f66f693c058b..249c01c24eac 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -827,8 +827,12 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			sizeof(resp.mlx5_ib_support_multi_pkt_send_wqes);
 	}
 
-	if (field_avail(typeof(resp), reserved, uhw->outlen))
-		resp.response_length += sizeof(resp.reserved);
+	if (field_avail(typeof(resp), flags, uhw->outlen)) {
+		resp.response_length += sizeof(resp.flags);
+		if (MLX5_CAP_GEN(mdev, cqe_compression_128))
+			resp.flags |=
+				MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP;
+	}
 
 	if (field_avail(typeof(resp), sw_parsing_caps,
 			uhw->outlen)) {
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index b1d5b87ba3fd..a8fc1f0956d0 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -203,6 +203,11 @@ struct mlx5_ib_striding_rq_caps {
 	__u32 supported_qpts;
 };
 
+enum mlx5_ib_query_dev_resp_flags {
+	/* Support 128B CQE compression */
+	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP = 1 << 0,
+};
+
 struct mlx5_ib_query_device_resp {
 	__u32	comp_mask;
 	__u32	response_length;
@@ -211,7 +216,7 @@ struct mlx5_ib_query_device_resp {
 	struct	mlx5_ib_cqe_comp_caps cqe_comp_caps;
 	struct	mlx5_packet_pacing_caps packet_pacing_caps;
 	__u32	mlx5_ib_support_multi_pkt_send_wqes;
-	__u32	reserved;
+	__u32	flags; /* Use enum mlx5_ib_query_dev_resp_flags */
 	struct mlx5_ib_sw_parsing_caps sw_parsing_caps;
 	struct mlx5_ib_striding_rq_caps striding_rq_caps;
 };
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
