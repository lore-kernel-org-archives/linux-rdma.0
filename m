From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] mlx4: fill the attribute masked_atomic_cap according to device capabilities
Date: Wed, 31 Aug 2011 16:28:54 +0300
Message-ID: <201108311628.54361.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the user queries for device capabilities, fill the attribute masked_atomic_cap
according to the support level of the regular atomic capabilities and not using a
hard coded value.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1e734da..321ca4d 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -175,7 +175,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->local_ca_ack_delay  = dev->dev->caps.local_ca_ack_delay;
 	props->atomic_cap	   = dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_ATOMIC ?
 		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
-	props->masked_atomic_cap   = IB_ATOMIC_HCA;
+	props->masked_atomic_cap   = props->atomic_cap;
 	props->max_pkeys	   = dev->dev->caps.pkey_table_len[1];
 	props->max_mcast_grp	   = dev->dev->caps.num_mgms + dev->dev->caps.num_amgms;
 	props->max_mcast_qp_attach = dev->dev->caps.num_qp_per_mgm;
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
