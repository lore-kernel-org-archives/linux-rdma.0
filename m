From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 4/8] Replace sscanf() to strtol()
Date: Thu, 20 Sep 2012 23:31:03 +0300
Message-ID: <1348173067-12116-5-git-send-email-ogerlitz@mellanox.com>
References: <1348173067-12116-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348173067-12116-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

When converting a string to a numeric value, strtol() is more safe to use.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index 4989c46..0a9139f 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -224,12 +224,12 @@ static struct ibv_device *mlx4_driver_init(const char *uverbs_sys_path,
 	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
 				value, sizeof value) < 0)
 		return NULL;
-	sscanf(value, "%i", &vendor);
+	vendor = strtol(value, NULL, 16);
 
 	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
 				value, sizeof value) < 0)
 		return NULL;
-	sscanf(value, "%i", &device);
+	device = strtol(value, NULL, 16);
 
 	for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
 		if (vendor == hca_table[i].vendor &&
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
