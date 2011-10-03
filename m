From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: PATCH for-3.2 v1 4/5] ib/mlx4: Configure extended active speeds
Date: Mon, 3 Oct 2011 18:56:19 +0300
Message-ID: <201110031756.19487.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Set the extended active speeds based on the hardware configuration.

Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   41 
++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -185,6 +185,8 @@ static int ib_link_query_port(struct ib_
 			      struct ib_port_attr *props,
 			      struct ib_smp *out_mad)
 {
+	int ext_active_speed;
+
 	props->lid		= be16_to_cpup((__be16 *) (out_mad->data + 16));
 	props->lmc		= out_mad->data[34] & 0x7;
 	props->sm_lid		= be16_to_cpup((__be16 *) (out_mad->data + 18));
@@ -205,6 +207,20 @@ static int ib_link_query_port(struct ib_
 	props->max_vl_num	= out_mad->data[37] >> 4;
 	props->init_type_reply	= out_mad->data[41] >> 4;
 
+	/* Check if extended speeds (EDR/FDR/...) are supported */
+	if (props->port_cap_flags & IB_PORT_EXTENDED_SPEEDS_SUP) {
+		ext_active_speed = out_mad->data[62] >> 4;
+
+		switch (ext_active_speed) {
+		case 1:
+			props->active_speed = 16; /* FDR */
+			break;
+		case 2:
+			props->active_speed = 32; /* EDR */
+			break;
+		}
+	}
+
 	return 0;
 }
 
@@ -275,8 +291,29 @@ static int mlx4_ib_query_port(struct ib_
 	if (err)
 		goto out;
 
-	err = mlx4_ib_port_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND ?
-		ib_link_query_port(ibdev, port, props, out_mad) :
+	if (mlx4_ib_port_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND) {
+		ib_link_query_port(ibdev, port, props, out_mad);
+
+		/* If reported active speed is QDR, check if is FDR-10 */
+		if (props->active_speed == 4) {
+			if (to_mdev(ibdev)->dev->caps.ext_port_cap[port] &
+			    MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO) {
+
+				init_query_mad(in_mad);
+				in_mad->attr_id = MLX4_ATTR_EXTENDED_PORT_INFO;
+				in_mad->attr_mod = cpu_to_be32(port);
+
+				err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port,
+						   NULL, NULL, in_mad, out_mad);
+				if (err)
+					goto out;
+
+				/* Checking LinkSpeedActive for FDR-10 */
+				if (out_mad->data[15] & 0x1)
+					props->active_speed = 8;
+			}
+		}
+	} else
 		eth_link_query_port(ibdev, port, props, out_mad);
 
 out:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
