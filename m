From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 12/23] perftest_communication: fix gid_index2 copy-pasta
Date: Thu, 18 Aug 2016 13:32:07 -0400
Message-ID: <1471541538-20270-13-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I believe this should be user_param->gid_index2 here.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_communication.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/perftest_communication.c b/src/perftest_communication.c
index fd71436..d46d21e 100755
--- a/src/perftest_communication.c
+++ b/src/perftest_communication.c
@@ -761,7 +761,7 @@ int set_up_connection(struct pingpong_context *ctx,
 				return 0;
 
 			if (user_param->use_gid_user) {
-				if (ibv_query_gid(ctx->context, user_param->ib_port2, user_param->gid_index, &temp_gid2))
+				if (ibv_query_gid(ctx->context, user_param->ib_port2, user_param->gid_index2, &temp_gid2))
 					return -1;
 			} else {
 				user_param->gid_index2 = get_best_gid_index(ctx, user_param, &attr, user_param->ib_port2);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
