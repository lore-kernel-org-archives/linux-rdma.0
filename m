From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] mlx5: Update PCI supported list
Date: Tue, 28 Feb 2017 12:48:55 +0200
Message-ID: <1488278935-28386-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

-Rename the ConnectX-5 PCIe 4.0 to be ConnectX-5 Ex.
-Add the VF ID of the ConnectX-5 Ex.
-Add the upcoming ConnectX-6 ID and its VF.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/86

 providers/mlx5/mlx5.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 980e4df..95225c2 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -74,7 +74,10 @@ static struct {
 	HCA(MELLANOX, 4118),	/* ConnectX-4LX Virtual Function */
 	HCA(MELLANOX, 4119),	/* ConnectX-5, PCIe 3.0 */
 	HCA(MELLANOX, 4120),	/* ConnectX-5 Virtual Function */
-	HCA(MELLANOX, 4121),    /* ConnectX-5, PCIe 4.0 */
+	HCA(MELLANOX, 4121),    /* ConnectX-5 Ex */
+	HCA(MELLANOX, 4122),	/* ConnectX-5 Ex VF */
+	HCA(MELLANOX, 4123),    /* ConnectX-6 */
+	HCA(MELLANOX, 4124),	/* ConnectX-6 VF */
 };
 
 uint32_t mlx5_debug_mask = 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
