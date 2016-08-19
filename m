From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest] perftest: make inline send on ocrdma work better
Date: Fri, 19 Aug 2016 15:06:51 -0400
Message-ID: <1471633611-41155-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ocrdma driver supports a maximum inline send size of 224, while the
current code sets this size to 236. Add an ocrdma-specific check when
setting max inline size to eliminate the need to always pass -I 224 when
running ib_send_lat on ocrdma hardware.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_parameters.c | 8 ++++++++
 src/perftest_parameters.h | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
index 3ffddd7..65ce731 100755
--- a/src/perftest_parameters.c
+++ b/src/perftest_parameters.c
@@ -1465,6 +1465,14 @@ static void ctx_set_max_inline(struct ibv_context *context,struct perftest_param
 		}
 	}
 
+	if (strncmp("ocrdma", user_param->ib_devname, 6) == 0) {
+		if (user_param->inline_size > DEF_INLINE_SEND_MAX_OCRDMA) {
+			fprintf(stdout, "lowering inline size to ocrdma supported maximum of %d\n",
+				DEF_INLINE_SEND_MAX_OCRDMA);
+			user_param->inline_size = DEF_INLINE_SEND_MAX_OCRDMA;
+		}
+	}
+
 	return;
 }
 /******************************************************************************
diff --git a/src/perftest_parameters.h b/src/perftest_parameters.h
index 1122792..a566f42 100755
--- a/src/perftest_parameters.h
+++ b/src/perftest_parameters.h
@@ -133,6 +133,9 @@
 #define DEF_INLINE_SEND_UD (188)
 #define DEF_INLINE_DC (150)
 
+/* OCRDMA has an inline max of 224 */
+#define DEF_INLINE_SEND_MAX_OCRDMA (224)
+
 /* Max and Min allowed values for perftest parameters. */
 #define MIN_TOS		(0)
 #define MAX_TOS		(256)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
