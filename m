From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/6] IB/mlx5: Add tunneling offloads support
Date: Thu, 19 Oct 2017 08:25:55 +0300
Message-ID: <20171019052556.8514-6-leon@kernel.org>
References: <20171019052556.8514-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019052556.8514-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The device can support receive Stateless Offloads for the inner
packet's fields only when the packet is processed by TIR which is
enabled to support tunneling. Otherwise, the device treats the
packet as an ordinary non-tunneling packet and receive offloads
can be done only for the outer packet's field.
In order to enable receive Stateless Offloading support for incoming
tunneling traffic the TIR should be created with tunneled_offload_en.
Tunneling offloads is supported only be raw ethernet QP.

This patch includes:
* New QP creation flag for tunneling offloads.
* Reports device capabilities.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 14 +++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 ++
 drivers/infiniband/hw/mlx5/qp.c      | 39 +++++++++++++++++++++++++++++++-----
 include/uapi/rdma/mlx5-abi.h         | 11 +++++++++-
 4 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 107c038da328..c44dd0896f80 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -875,6 +875,20 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		}
 	}
 
+	if (field_avail(typeof(resp), tunnel_offloads_caps,
+			uhw->outlen)) {
+		resp.response_length += sizeof(resp.tunnel_offloads_caps);
+		if (MLX5_CAP_ETH(mdev, tunnel_stateless_vxlan))
+			resp.tunnel_offloads_caps |=
+				MLX5_IB_TUNNELED_OFFLOADS_VXLAN;
+		if (MLX5_CAP_ETH(mdev, tunnel_stateless_geneve_rx))
+			resp.tunnel_offloads_caps |=
+				MLX5_IB_TUNNELED_OFFLOADS_GENEVE;
+		if (MLX5_CAP_ETH(mdev, tunnel_stateless_gre))
+			resp.tunnel_offloads_caps |=
+				MLX5_IB_TUNNELED_OFFLOADS_GRE;
+	}
+
 	if (uhw->outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2063d1dfc101..14b155413d7c 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -399,6 +399,7 @@ struct mlx5_ib_qp {
 	struct list_head	cq_send_list;
 	u32			rate_limit;
 	u32                     underlay_qpn;
+	bool			tunnel_offload_en;
 };
 
 struct mlx5_ib_cq_buf {
@@ -422,6 +423,7 @@ enum mlx5_ib_qp_flags {
 	MLX5_IB_QP_CVLAN_STRIPPING		= 1 << 9,
 	MLX5_IB_QP_UNDERLAY			= 1 << 10,
 	MLX5_IB_QP_SCATTER_END_PADDING		= 1 << 11,
+	MLX5_IB_QP_TUNNEL_OFFLOAD		= 1 << 12,
 };
 
 struct mlx5_umr_wr {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 511d4fdcaaae..0f1106040a45 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1204,8 +1204,16 @@ static void destroy_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 	mlx5_core_destroy_rq_tracked(dev->mdev, &rq->base.mqp);
 }
 
+static bool tunnel_offload_supported(struct mlx5_core_dev *dev)
+{
+	return  (MLX5_CAP_ETH(dev, tunnel_stateless_vxlan) ||
+		 MLX5_CAP_ETH(dev, tunnel_stateless_gre) ||
+		 MLX5_CAP_ETH(dev, tunnel_stateless_geneve_rx));
+}
+
 static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
-				    struct mlx5_ib_rq *rq, u32 tdn)
+				    struct mlx5_ib_rq *rq, u32 tdn,
+				    bool tunnel_offload_en)
 {
 	u32 *in;
 	void *tirc;
@@ -1221,6 +1229,8 @@ static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_DIRECT);
 	MLX5_SET(tirc, tirc, inline_rqn, rq->base.mqp.qpn);
 	MLX5_SET(tirc, tirc, transport_domain, tdn);
+	if (tunnel_offload_en)
+		MLX5_SET(tirc, tirc, tunneled_offload_en, 1);
 
 	err = mlx5_core_create_tir(dev->mdev, in, inlen, &rq->tirn);
 
@@ -1273,7 +1283,8 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			goto err_destroy_sq;
 
 
-		err = create_raw_packet_qp_tir(dev, rq, tdn);
+		err = create_raw_packet_qp_tir(dev, rq, tdn,
+					       qp->tunnel_offload_en);
 		if (err)
 			goto err_destroy_rq;
 	}
@@ -1360,7 +1371,7 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (udata->outlen < min_resp_len)
 		return -EINVAL;
 
-	required_cmd_sz = offsetof(typeof(ucmd), reserved1) + sizeof(ucmd.reserved1);
+	required_cmd_sz = offsetof(typeof(ucmd), flags) + sizeof(ucmd.flags);
 	if (udata->inlen < required_cmd_sz) {
 		mlx5_ib_dbg(dev, "invalid inlen\n");
 		return -EINVAL;
@@ -1383,8 +1394,14 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		return -EOPNOTSUPP;
 	}
 
-	if (memchr_inv(ucmd.reserved, 0, sizeof(ucmd.reserved)) || ucmd.reserved1) {
-		mlx5_ib_dbg(dev, "invalid reserved\n");
+	if (ucmd.flags & ~MLX5_QP_FLAG_TUNNEL_OFFLOADS) {
+		mlx5_ib_dbg(dev, "invalid flags\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (ucmd.flags & MLX5_QP_FLAG_TUNNEL_OFFLOADS &&
+	    !tunnel_offload_supported(dev->mdev)) {
+		mlx5_ib_dbg(dev, "tunnel offloads isn't supported\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -1407,6 +1424,10 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	MLX5_SET(tirc, tirc, transport_domain, tdn);
 
 	hfso = MLX5_ADDR_OF(tirc, tirc, rx_hash_field_selector_outer);
+
+	if (ucmd.flags & MLX5_QP_FLAG_TUNNEL_OFFLOADS)
+		MLX5_SET(tirc, tirc, tunneled_offload_en, 1);
+
 	switch (ucmd.rx_hash_function) {
 	case MLX5_RX_HASH_FUNC_TOEPLITZ:
 	{
@@ -1606,6 +1627,14 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 		qp->wq_sig = !!(ucmd.flags & MLX5_QP_FLAG_SIGNATURE);
 		qp->scat_cqe = !!(ucmd.flags & MLX5_QP_FLAG_SCATTER_CQE);
+		if (ucmd.flags & MLX5_QP_FLAG_TUNNEL_OFFLOADS) {
+			if (init_attr->qp_type != IB_QPT_RAW_PACKET ||
+			    !tunnel_offload_supported(mdev)) {
+				mlx5_ib_dbg(dev, "Tunnel offload isn't supported\n");
+				return -EOPNOTSUPP;
+			}
+			qp->tunnel_offload_en = true;
+		}
 
 		if (init_attr->create_flags & IB_QP_CREATE_SOURCE_QPN) {
 			if (init_attr->qp_type != IB_QPT_UD ||
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 201a60f032dd..791655ec4aff 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -39,6 +39,7 @@
 enum {
 	MLX5_QP_FLAG_SIGNATURE		= 1 << 0,
 	MLX5_QP_FLAG_SCATTER_CQE	= 1 << 1,
+	MLX5_QP_FLAG_TUNNEL_OFFLOADS	= 1 << 2,
 };
 
 enum {
@@ -209,6 +210,12 @@ enum mlx5_ib_query_dev_resp_flags {
 	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD  = 1 << 1,
 };
 
+enum mlx5_ib_tunnel_offloads {
+	MLX5_IB_TUNNELED_OFFLOADS_VXLAN  = 1 << 0,
+	MLX5_IB_TUNNELED_OFFLOADS_GRE    = 1 << 1,
+	MLX5_IB_TUNNELED_OFFLOADS_GENEVE = 1 << 2
+};
+
 struct mlx5_ib_query_device_resp {
 	__u32	comp_mask;
 	__u32	response_length;
@@ -220,6 +227,8 @@ struct mlx5_ib_query_device_resp {
 	__u32	flags; /* Use enum mlx5_ib_query_dev_resp_flags */
 	struct mlx5_ib_sw_parsing_caps sw_parsing_caps;
 	struct mlx5_ib_striding_rq_caps striding_rq_caps;
+	__u32	tunnel_offloads_caps; /* enum mlx5_ib_tunnel_offloads */
+	__u32	reserved;
 };
 
 enum mlx5_ib_create_cq_flags {
@@ -304,7 +313,7 @@ struct mlx5_ib_create_qp_rss {
 	__u8 reserved[6];
 	__u8 rx_hash_key[128]; /* valid only for Toeplitz */
 	__u32   comp_mask;
-	__u32   reserved1;
+	__u32	flags;
 };
 
 struct mlx5_ib_create_qp_resp {
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
