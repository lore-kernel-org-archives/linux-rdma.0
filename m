From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] IB/mlx5: Report mlx5 TSO capabilities when querying device
Date: Fri, 17 Jun 2016 15:02:20 +0300
Message-ID: <1466164940-31400-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable mlx5 based hardware to report TCP segmentation offload (TSO)
capabilities from kernel to user space. A TSO enabled NIC will accept
big chunks of data with sizes greater than MTU for TCP traffic.  The TSO
engine will break the data into separate packets and will insert headers
automatically.

The capabilities are exposed to user space through query_device by uhw
directly. The following capabilities are reported:

1. The maximum payload size in bytes supported for segmentation by TSO
   engine.
2. Bitmap showing which QP types are supported by TSO operation. The bitmap
   is built by members from 'enmu ib_qp_type'. For example, similar code
   should be performed if UD QP is supported:
	supported_qpts |= 1 << IB_QPT_UD;

To make user-space library aware of whether kernel supports uhw or not, a
new flag: cmds_supp_uhw will be returned back to user-space through
alloc_ucontext.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 41 ++++++++++++++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/user.h | 24 +++++++++++++++++++++--
 2 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c72797c..b6edb1f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -457,8 +457,17 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	int max_rq_sg;
 	int max_sq_sg;
 	u64 min_page_size = 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
+	struct mlx5_ib_query_device_resp resp = {};
+	size_t resp_len;
+	u64 max_tso;
 
-	if (uhw->inlen || uhw->outlen)
+	resp_len = sizeof(resp.comp_mask) + sizeof(resp.response_length);
+	if (uhw->outlen && uhw->outlen < resp_len)
+		return -EINVAL;
+	else
+		resp.response_length = resp_len;
+
+	if (uhw->inlen && !ib_is_udata_cleared(uhw, 0, uhw->inlen))
 		return -EINVAL;
 
 	memset(props, 0, sizeof(*props));
@@ -511,10 +520,21 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (MLX5_CAP_GEN(mdev, block_lb_mc))
 		props->device_cap_flags |= IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
 
-	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
-	    (MLX5_CAP_ETH(dev->mdev, csum_cap)))
+	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads)) {
+		if (MLX5_CAP_ETH(mdev, csum_cap))
 			props->device_cap_flags |= IB_DEVICE_RAW_IP_CSUM;
 
+		if (field_avail(typeof(resp), tso_caps, uhw->outlen)) {
+			max_tso = MLX5_CAP_ETH(mdev, max_lso_cap);
+			if (max_tso) {
+				resp.tso_caps.max_tso = 1 << max_tso;
+				resp.tso_caps.supported_qpts |=
+					1 << IB_QPT_RAW_PACKET;
+				resp.response_length += sizeof(resp.tso_caps);
+			}
+		}
+	}
+
 	if (MLX5_CAP_GEN(mdev, ipoib_basic_offloads)) {
 		props->device_cap_flags |= IB_DEVICE_UD_IP_CSUM;
 		props->device_cap_flags |= IB_DEVICE_UD_TSO;
@@ -573,6 +593,13 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (!mlx5_core_is_pf(mdev))
 		props->device_cap_flags |= IB_DEVICE_VIRTUAL_FUNCTION;
 
+	if (uhw->outlen) {
+		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
+
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -988,6 +1015,11 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (field_avail(typeof(resp), cqe_version, udata->outlen))
 		resp.response_length += sizeof(resp.cqe_version);
 
+	if (field_avail(typeof(resp), cmds_supp_uhw, udata->outlen)) {
+		resp.cmds_supp_uhw |= MLX5_USER_CMDS_SUPP_UHW_QUERY_DEVICE;
+		resp.response_length += sizeof(resp.cmds_supp_uhw);
+	}
+
 	if (field_avail(typeof(resp), hca_core_clock_offset, udata->outlen)) {
 		resp.comp_mask |=
 			MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET;
@@ -995,8 +1027,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 			offsetof(struct mlx5_init_seg, internal_timer_h) %
 			PAGE_SIZE;
 		resp.response_length += sizeof(resp.hca_core_clock_offset) +
-					sizeof(resp.reserved2) +
-					sizeof(resp.reserved3);
+					sizeof(resp.reserved2);
 	}
 
 	err = ib_copy_to_udata(udata, &resp, resp.response_length);
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 61bc308..03615e3 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -79,6 +79,10 @@ enum mlx5_ib_alloc_ucontext_resp_mask {
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET = 1UL << 0,
 };
 
+enum mlx5_user_cmds_supp_uhw {
+	MLX5_USER_CMDS_SUPP_UHW_QUERY_DEVICE = 1 << 0,
+};
+
 struct mlx5_ib_alloc_ucontext_resp {
 	__u32	qp_tab_size;
 	__u32	bf_reg_size;
@@ -94,8 +98,8 @@ struct mlx5_ib_alloc_ucontext_resp {
 	__u32	comp_mask;
 	__u32	response_length;
 	__u8	cqe_version;
-	__u8	reserved2;
-	__u16	reserved3;
+	__u8	cmds_supp_uhw;
+	__u16	reserved2;
 	__u64	hca_core_clock_offset;
 };
 
@@ -103,6 +107,22 @@ struct mlx5_ib_alloc_pd_resp {
 	__u32	pdn;
 };
 
+struct mlx5_ib_tso_caps {
+	__u32 max_tso; /* Maximum tso payload size in bytes */
+
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_UD
+	 */
+	__u32 supported_qpts;
+};
+
+struct mlx5_ib_query_device_resp {
+	__u32	comp_mask;
+	__u32	response_length;
+	struct	mlx5_ib_tso_caps tso_caps;
+};
+
 struct mlx5_ib_create_cq {
 	__u64	buf_addr;
 	__u64	db_addr;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
