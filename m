From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest] Fix unused variable warnings for pl_index, sg_l
Date: Wed, 18 May 2016 13:44:08 -0400
Message-ID: <1463593448-30864-3-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These variables will be unused if certain #define's aren't set, so wrap
them with the same #ifdef's as the places they're used.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_resources.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index 71a1541..4071989 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -2778,8 +2778,12 @@ int run_iter_bw(struct pingpong_context *ctx,struct perftest_parameters *user_pa
 	int 			cpu_mhz = 0;
 	int 			return_value = 0;
 	int			wc_id;
+	#ifdef HAVE_VERBS_EXP
+	#ifdef HAVE_ACCL_VERBS
 	int pl_index;
 	struct ibv_sge		*sg_l;
+	#endif
+	#endif
 
 	ALLOCATE(wc ,struct ibv_wc ,CTX_POLL_BATCH);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
