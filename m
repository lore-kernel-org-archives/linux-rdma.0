From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 4/4] IB/mlx4: Expose RSS capabilities
Date: Tue,  4 Jul 2017 16:24:27 +0300
Message-ID: <20170704132427.25937-5-leon@kernel.org>
References: <20170704132427.25937-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170704132427.25937-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

As a final step to support RSS feature, expose the RSS capabilities in
query device verb.

It includes:
- Max rwq indirection tables.
- Max rwq indirection table size.
- Supported qp types.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 0e1cb209b9cb..ce1abf269f99 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -556,8 +556,13 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 
 	if ((dev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS) &&
 	    (mlx4_ib_port_link_layer(ibdev, 1) == IB_LINK_LAYER_ETHERNET ||
-	     mlx4_ib_port_link_layer(ibdev, 2) == IB_LINK_LAYER_ETHERNET))
+	     mlx4_ib_port_link_layer(ibdev, 2) == IB_LINK_LAYER_ETHERNET)) {
+		props->rss_caps.max_rwq_indirection_tables = props->max_qp;
+		props->rss_caps.max_rwq_indirection_table_size =
+			dev->dev->caps.max_rss_tbl_sz;
+		props->rss_caps.supported_qpts = 1 << IB_QPT_RAW_PACKET;
 		props->max_wq_type_rq = props->max_qp;
+	}
 
 	if (!mlx4_is_slave(dev->dev))
 		err = mlx4_get_internal_clock_params(dev->dev, &clock_params);
-- 
2.13.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
