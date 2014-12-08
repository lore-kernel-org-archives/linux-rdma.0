From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mlx4_core: Modify default value of log_rdmarc_per_qp to be consistent with HW capability
Date: Mon,  8 Dec 2014 09:45:58 -0800
Message-ID: <1418060758-22411-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This value is used to calculate max_qp_dest_rdma.
Default value of 4 brings us to 16 while HW supports 128 (max_requester_per_qp).
Although this value can be changed by module param it is best that default be optimized.

Acked-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 90de6e1..f076689 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -114,7 +114,7 @@ static char mlx4_version[] =
 static struct mlx4_profile default_profile = {
 	.num_qp		= 1 << 18,
 	.num_srq	= 1 << 16,
-	.rdmarc_per_qp	= 1 << 4,
+	.rdmarc_per_qp	= 1 << 7,
 	.num_cq		= 1 << 16,
 	.num_mcg	= 1 << 13,
 	.num_mpt	= 1 << 19,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
