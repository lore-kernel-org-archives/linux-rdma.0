From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/6] IB/mlx4: Fill the masked_atomic_cap attribute in query device
Date: Wed, 11 Jul 2012 18:33:42 +0300
Message-ID: <1342020825-18878-4-git-send-email-ogerlitz@mellanox.com>
References: <1342020825-18878-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342020825-18878-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-LDSdmyG8hGU/bZweECJiwQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

When the user queries for device capabilities, fill the masked_atomic_cap
attrbiute according to the support level of atomic capabilities instead of
hard coded value.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-LDSdmyG8hGU/bZweECJiwQ@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 4f230c2..5f50d4f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -157,7 +157,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->local_ca_ack_delay  = dev->dev->caps.local_ca_ack_delay;
 	props->atomic_cap	   = dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_ATOMIC ?
 		IB_ATOMIC_HCA : IB_ATOMIC_NONE;
-	props->masked_atomic_cap   = IB_ATOMIC_HCA;
+	props->masked_atomic_cap   = props->atomic_cap;
 	props->max_pkeys	   = dev->dev->caps.pkey_table_len[1];
 	props->max_mcast_grp	   = dev->dev->caps.num_mgms + dev->dev->caps.num_amgms;
 	props->max_mcast_qp_attach = dev->dev->caps.num_qp_per_mgm;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
