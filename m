From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/8] mlx4: sl_vid field in struct mlx4_cqe should be 16 bit
Date: Wed, 25 Jan 2017 16:49:44 +0200
Message-ID: <1485355791-27646-2-git-send-email-yishaih@mellanox.com>
References: <1485355791-27646-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485355791-27646-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This fix adjusts the sl_vid fields size in struct mlx4_cqe
to be 16 bit.

Fixes: 9a90176880 ("Add support for 64B CQEs")
Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/mlx4.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index b851e95..5a73ed6 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -272,8 +272,7 @@ struct mlx4_cqe {
 	uint32_t	vlan_my_qpn;
 	uint32_t	immed_rss_invalid;
 	uint32_t	g_mlpath_rqpn;
-	uint8_t		sl_vid;
-	uint8_t		reserved1;
+	uint16_t	sl_vid;
 	uint16_t	rlid;
 	uint32_t	status;
 	uint32_t	byte_cnt;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
