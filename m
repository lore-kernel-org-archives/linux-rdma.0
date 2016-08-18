From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 14/23] perftest_communication: fix ibv_create_ah failure check
Date: Thu, 18 Aug 2016 13:32:09 -0400
Message-ID: <1471541538-20270-15-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We've already dereferenced ctx->ah by assigning the return value of
ibv_create_ah to ctx->ah[0], so this check as-is will currently never
trip. I believe what was meant was to check for a failure of
ibv_create_ah, which returns 0 on success or the value of errno on
failure. Just check for non-zero ctx->ah[0] instead.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_communication.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/perftest_communication.c b/src/perftest_communication.c
index bec973a..d938e41 100755
--- a/src/perftest_communication.c
+++ b/src/perftest_communication.c
@@ -1007,7 +1007,7 @@ int rdma_client_connect(struct pingpong_context *ctx,struct perftest_parameters
 
 		ctx->ah[0] = ibv_create_ah(ctx->pd,&event->param.ud.ah_attr);
 
-		if (!ctx->ah) {
+		if (ctx->ah[0]) {
 			printf(" Unable to create address handler for UD QP\n");
 			return FAILURE;
 		}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
