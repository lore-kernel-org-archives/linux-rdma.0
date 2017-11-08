From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/2] mlx4: Cleanup upon fatal in the destroy flow
Date: Wed,  8 Nov 2017 18:18:17 +0200
Message-ID: <1510157897-10384-3-git-send-email-yishaih@mellanox.com>
References: <1510157897-10384-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510157897-10384-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch handles the cleanup upon fatal scenario in the destroy flow.
It follows other objects in mlx4. (e.g. QP/CQ/WQ, etc.) that were
previously handled in the same way.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 7ecaeb1..042a8e0 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -1542,7 +1542,7 @@ int mlx4_destroy_flow(struct ibv_flow *flow_id)
 
 	ret = ibv_cmd_destroy_flow(flow_id);
 
-	if (ret)
+	if (ret && !cleanup_on_fatal(ret))
 		return ret;
 
 	free(flow_id);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
