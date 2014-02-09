From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.14 V1] IB: Report using RoCE IP based gids in port caps
Date: Sun,  9 Feb 2014 11:54:34 +0200
Message-ID: <1391939674-16782-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

For user-space RoCE UD QPs we need to know the GID format that the
kernel uses, e.g when working over older kernels. For that end, add
new port capability IB_PORT_IP_BASED_GIDS and report it when a port
query is issued.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

V0 --> V1 changes:
  - make sure ocrdma advertizes the new bit too

 drivers/infiniband/hw/mlx4/main.c           |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
 include/rdma/ib_verbs.h                     |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c2702f5..5d4088a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -347,7 +347,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->active_width	=  (((u8 *)mailbox->buf)[5] == 0x40) ?
 						IB_WIDTH_4X : IB_WIDTH_1X;
 	props->active_speed	= IB_SPEED_QDR;
-	props->port_cap_flags	= IB_PORT_CM_SUP;
+	props->port_cap_flags	= IB_PORT_CM_SUP | IB_PORT_IP_BASED_GIDS;
 	props->gid_tbl_len	= mdev->dev->caps.gid_table_len[port];
 	props->max_msg_sz	= mdev->dev->caps.max_msg_sz;
 	props->pkey_tbl_len	= 1;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index aa92f40..7890e7b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -176,7 +176,7 @@ int ocrdma_query_port(struct ib_device *ibdev,
 	props->port_cap_flags =
 	    IB_PORT_CM_SUP |
 	    IB_PORT_REINIT_SUP |
-	    IB_PORT_DEVICE_MGMT_SUP | IB_PORT_VENDOR_CLASS_SUP;
+	    IB_PORT_DEVICE_MGMT_SUP | IB_PORT_VENDOR_CLASS_SUP | IB_PORT_IP_BASED_GIDS;
 	props->gid_tbl_len = OCRDMA_MAX_SGID;
 	props->pkey_tbl_len = 1;
 	props->bad_pkey_cntr = 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8d4a1c0..6793f32 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -226,7 +226,8 @@ enum ib_port_cap_flags {
 	IB_PORT_CAP_MASK_NOTICE_SUP		= 1 << 22,
 	IB_PORT_BOOT_MGMT_SUP			= 1 << 23,
 	IB_PORT_LINK_LATENCY_SUP		= 1 << 24,
-	IB_PORT_CLIENT_REG_SUP			= 1 << 25
+	IB_PORT_CLIENT_REG_SUP			= 1 << 25,
+	IB_PORT_IP_BASED_GIDS			= 1 << 26
 };
 
 enum ib_port_width {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
