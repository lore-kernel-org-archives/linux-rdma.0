From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] net/mlx4_core: Fix XRC QPs detection in the resource tracker
Date: Thu,  1 Aug 2013 18:49:52 +0300
Message-ID: <1375372194-23339-2-git-send-email-ogerlitz@mellanox.com>
References: <1375372194-23339-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375372194-23339-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Recognize XRC QPs in the SRIOV resource tracker based on transport
type. The previous check didn't match IB_QPT_XRC_INI and caused an
invalid calculation for required mtt pages.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index f984a89..dd68763 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -1909,7 +1909,8 @@ static int qp_get_mtt_size(struct mlx4_qp_context *qpc)
 	int log_rq_stride = qpc->rq_size_stride & 7;
 	int srq = (be32_to_cpu(qpc->srqn) >> 24) & 1;
 	int rss = (be32_to_cpu(qpc->flags) >> 13) & 1;
-	int xrc = (be32_to_cpu(qpc->local_qpn) >> 23) & 1;
+	u32 ts = (be32_to_cpu(qpc->flags) >> 16) & 0xff;
+	int xrc = (ts == MLX4_QP_ST_XRC) ? 1 : 0;
 	int sq_size;
 	int rq_size;
 	int total_pages;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
