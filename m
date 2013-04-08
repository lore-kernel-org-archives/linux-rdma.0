From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_log.c: Remove unnecessary initialization in osm_log
Date: Mon, 08 Apr 2013 07:36:53 -0400
Message-ID: <5162ABD5.1050006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_log.c b/opensm/osm_log.c
index 327a89a..3460cc5 100644
--- a/opensm/osm_log.c
+++ b/opensm/osm_log.c
@@ -119,7 +119,7 @@ void osm_log(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
 	SYSTEMTIME st;
 	uint32_t pid = GetCurrentThreadId();
 #else
-	pid_t pid = 0;
+	pid_t pid;
 	time_t tim;
 	struct tm result;
 	uint64_t time_usecs;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
