From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/2] mlx5: Update supported PCI devices list
Date: Tue,  9 May 2017 19:45:22 +0300
Message-ID: <1494348322-4526-3-git-send-email-yishaih@mellanox.com>
References: <1494348322-4526-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494348322-4526-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add the BlueField device and VF IDs to the supported devices list.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 30f165b..1bbc3f2 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -78,6 +78,8 @@ static struct {
 	HCA(MELLANOX, 4122),	/* ConnectX-5 Ex VF */
 	HCA(MELLANOX, 4123),    /* ConnectX-6 */
 	HCA(MELLANOX, 4124),	/* ConnectX-6 VF */
+	HCA(MELLANOX, 41682),	/* BlueField integrated ConnectX-5 network controller */
+	HCA(MELLANOX, 41683),	/* BlueField integrated ConnectX-5 network controller VF */
 };
 
 uint32_t mlx5_debug_mask = 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
