From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 10/10] IB/mlx4_ib: Advertize MW support
Date: Wed,  6 Feb 2013 18:19:16 +0200
Message-ID: <1360167556-20756-11-git-send-email-ogerlitz@mellanox.com>
References: <1360167556-20756-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360167556-20756-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shanim-xlywION9k29BDgjK7y7TUQ@public.gmane.org, Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Indicate memory windows support through device capabilities, kernel
verb entries and the relevant uverbs command mask entries.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index e7d81c0..f77ff4f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -137,6 +137,14 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
 	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC)
 		props->device_cap_flags |= IB_DEVICE_XRC;
+	if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_MEM_WINDOW)
+		props->device_cap_flags |= IB_DEVICE_MEM_WINDOW;
+	if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_TYPE_2_WIN) {
+		if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_WIN_TYPE_2B)
+			props->device_cap_flags |= IB_DEVICE_MEM_WINDOW_TYPE_2B;
+		else
+			props->device_cap_flags |= IB_DEVICE_MEM_WINDOW_TYPE_2A;
+	}
 
 	props->vendor_id	   = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
 		0xffffff;
@@ -1434,6 +1442,17 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		ibdev->ib_dev.dealloc_fmr	= mlx4_ib_fmr_dealloc;
 	}
 
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_MEM_WINDOW ||
+	    dev->caps.bmme_flags & MLX4_BMME_FLAG_TYPE_2_WIN) {
+		ibdev->ib_dev.alloc_mw = mlx4_ib_alloc_mw;
+		ibdev->ib_dev.bind_mw = mlx4_ib_bind_mw;
+		ibdev->ib_dev.dealloc_mw = mlx4_ib_dealloc_mw;
+
+		ibdev->ib_dev.uverbs_cmd_mask |=
+			(1ull << IB_USER_VERBS_CMD_ALLOC_MW) |
+			(1ull << IB_USER_VERBS_CMD_DEALLOC_MW);
+	}
+
 	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC) {
 		ibdev->ib_dev.alloc_xrcd = mlx4_ib_alloc_xrcd;
 		ibdev->ib_dev.dealloc_xrcd = mlx4_ib_dealloc_xrcd;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
