From: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] ibsim/sim_cmd.c: Add ULLONG_MAX if not defined
Date: Wed, 22 Apr 2015 09:21:53 +0300
Message-ID: <1429683713-19991-1-git-send-email-ilyan@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In old glibc versions (< 2.9.90) it is not defined

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 ibsim/sim_cmd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/ibsim/sim_cmd.c b/ibsim/sim_cmd.c
index 4822a0b..249228a 100644
--- a/ibsim/sim_cmd.c
+++ b/ibsim/sim_cmd.c
@@ -934,6 +934,11 @@ static int do_perf_counter_set(FILE *f, char *line)
 		field_trim--;
 	*(field_trim + 1) = 0;
 
+#ifndef ULLONG_MAX
+/* Maximum value an `unsigned long long int' can hold. (Minimum is 0.) */
+#   define ULLONG_MAX   18446744073709551615ULL
+#endif
+
 	errno = 0;
 	value = strtoull(s, &val_error, 0);
 	if((value == 0 || value == ULLONG_MAX) && errno != 0) {
-- 
1.8.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
