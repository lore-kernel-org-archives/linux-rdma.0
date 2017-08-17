From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] verbs: Set default MTU for the xsrq ping-pong to be 1024
Date: Thu, 17 Aug 2017 16:42:28 +0300
Message-ID: <1502977348-22485-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

According to Annex 16 (RoCE), the Rate and MTU values are obtained using
Ethernet management practices. The default MTU for the Ethernet is 1500,
so let's change the default MTU for ibv_xsrq_pingpong to be consistent
with Ethernet practices.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/185

 libibverbs/examples/xsrq_pingpong.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libibverbs/examples/xsrq_pingpong.c b/libibverbs/examples/xsrq_pingpong.c
index 46f59a6..bfab2b8 100644
--- a/libibverbs/examples/xsrq_pingpong.c
+++ b/libibverbs/examples/xsrq_pingpong.c
@@ -825,7 +825,7 @@ static void init(void)
 	ctx.ib_port = 1;
 	ctx.num_clients  = 1;
 	ctx.num_tests = 5;
-	ctx.mtu = IBV_MTU_2048;
+	ctx.mtu = IBV_MTU_1024;
 	ctx.sl = 0;
 	ctx.gidx = -1;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
