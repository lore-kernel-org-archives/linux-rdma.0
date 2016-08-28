From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/3] IB/mlx5: Expose RSS related capabilities
Date: Sun, 28 Aug 2016 11:28:45 +0300
Message-ID: <1472372925-17660-4-git-send-email-leon@kernel.org>
References: <1472372925-17660-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472372925-17660-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose RSS related capabilities on both IB and vendor channels.

In addition to the IB capabilities the driver reports some extra
capabilities on its vendor channel:
- Bit mask of the supported types of hash functions.
- Bit mask of the supported RX fields that can participate
  in the RX hashing.

Those capabilities are applicable only when the link layer
is Ethernet.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 31 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/user.h |  7 +++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f02a975..36706f7 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -531,6 +531,26 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 				resp.response_length += sizeof(resp.tso_caps);
 			}
 		}
+
+		if (field_avail(typeof(resp), rss_caps, uhw->outlen)) {
+			resp.rss_caps.rx_hash_function =
+						MLX5_RX_HASH_FUNC_TOEPLITZ;
+			resp.rss_caps.rx_hash_fields_mask =
+						MLX5_RX_HASH_SRC_IPV4 |
+						MLX5_RX_HASH_DST_IPV4 |
+						MLX5_RX_HASH_SRC_IPV6 |
+						MLX5_RX_HASH_DST_IPV6 |
+						MLX5_RX_HASH_SRC_PORT_TCP |
+						MLX5_RX_HASH_DST_PORT_TCP |
+						MLX5_RX_HASH_SRC_PORT_UDP |
+						MLX5_RX_HASH_DST_PORT_UDP;
+			resp.response_length += sizeof(resp.rss_caps);
+		}
+	} else {
+		if (field_avail(typeof(resp), tso_caps, uhw->outlen))
+			resp.response_length += sizeof(resp.tso_caps);
+		if (field_avail(typeof(resp), rss_caps, uhw->outlen))
+			resp.response_length += sizeof(resp.rss_caps);
 	}
 
 	if (MLX5_CAP_GEN(mdev, ipoib_basic_offloads)) {
@@ -594,6 +614,17 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (!mlx5_core_is_pf(mdev))
 		props->device_cap_flags |= IB_DEVICE_VIRTUAL_FUNCTION;
 
+	if (mlx5_ib_port_link_layer(ibdev, 1) ==
+	    IB_LINK_LAYER_ETHERNET) {
+		props->rss_caps.max_rwq_indirection_tables =
+			1 << MLX5_CAP_GEN(dev->mdev, log_max_rqt);
+		props->rss_caps.max_rwq_indirection_table_size =
+			1 << MLX5_CAP_GEN(dev->mdev, log_max_rqt_size);
+		props->rss_caps.supported_qpts = 1 << IB_QPT_RAW_PACKET;
+		props->max_wq_type_rq =
+			1 << MLX5_CAP_GEN(dev->mdev, log_max_rq);
+	}
+
 	if (uhw->outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 188dac4..0e49d5b 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -121,10 +121,17 @@ struct mlx5_ib_tso_caps {
 	__u32 supported_qpts;
 };
 
+struct mlx5_ib_rss_caps {
+	__u64 rx_hash_fields_mask; /* enum mlx5_rx_hash_fields */
+	__u8 rx_hash_function; /* enum mlx5_rx_hash_function_flags */
+	__u8 reserved[7];
+};
+
 struct mlx5_ib_query_device_resp {
 	__u32	comp_mask;
 	__u32	response_length;
 	struct	mlx5_ib_tso_caps tso_caps;
+	struct	mlx5_ib_rss_caps rss_caps;
 };
 
 struct mlx5_ib_create_cq {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
