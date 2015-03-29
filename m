From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 9/9] IB/mlx4: Change alias guids default to be host assigned
Date: Sun, 29 Mar 2015 16:51:33 +0300
Message-ID: <1427637093-6711-10-git-send-email-ogerlitz@mellanox.com>
References: <1427637093-6711-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427637093-6711-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Change the default mode to be HOST assigned instead of SM assigned. This is
the expected operational mode, because it doesn't depend on SM availability.

As PF generates random GUIDs as the initial admin values, this gives
out of the box experience.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 35f00ae..7a55fee 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -66,9 +66,9 @@ MODULE_DESCRIPTION("Mellanox ConnectX HCA InfiniBand driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(DRV_VERSION);
 
-int mlx4_ib_sm_guid_assign = 1;
+int mlx4_ib_sm_guid_assign = 0;
 module_param_named(sm_guid_assign, mlx4_ib_sm_guid_assign, int, 0444);
-MODULE_PARM_DESC(sm_guid_assign, "Enable SM alias_GUID assignment if sm_guid_assign > 0 (Default: 1)");
+MODULE_PARM_DESC(sm_guid_assign, "Enable SM alias_GUID assignment if sm_guid_assign > 0 (Default: 0)");
 
 static const char mlx4_ib_version[] =
 	DRV_NAME ": Mellanox ConnectX InfiniBand driver v"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
