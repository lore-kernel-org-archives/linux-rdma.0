From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 18/23] perftest_resources: do 64-bit math setting tarr_size
Date: Thu, 18 Aug 2016 13:32:13 -0400
Message-ID: <1471541538-20270-19-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Error: OVERFLOW_BEFORE_WIDEN: [#def28]
perftest-3.0/src/perftest_resources.c:650: overflow_before_widen: Potentially overflowing expression "user_param->iters * user_param->num_of_qps" with type "int" (32 bits, signed) is evaluated
using 32-bit arithmetic, and then used in a context that expects an expression of type "uint64_t" (64 bits, unsigned).
perftest-3.0/src/perftest_resources.c:650: remediation: To avoid overflow, cast either "user_param->iters" or "user_param->num_of_qps" to type "uint64_t".

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_resources.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index 91c6d1e..7e982e9 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -650,7 +650,7 @@ void alloc_ctx(struct pingpong_context *ctx,struct perftest_parameters *user_par
 
 	ALLOCATE(user_param->port_by_qp, uint64_t, user_param->num_of_qps);
 
-	tarr_size = (user_param->noPeak) ? 1 : user_param->iters*user_param->num_of_qps;
+	tarr_size = (user_param->noPeak) ? 1UL : (uint64_t)user_param->iters*user_param->num_of_qps;
 	ALLOCATE(user_param->tposted, cycles_t, tarr_size);
 	memset(user_param->tposted, 0, sizeof(cycles_t)*tarr_size);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
