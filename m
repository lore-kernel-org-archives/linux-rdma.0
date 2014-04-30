From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_console_io.c: Handle return value of function
 setsockopt
Date: Wed, 30 Apr 2014 10:35:20 -0400
Message-ID: <53610A28.7040201@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Found by Coverity

Signed-off-by: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_console_io.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_console_io.c b/opensm/osm_console_io.c
index dfc903f..2426b84 100644
--- a/opensm/osm_console_io.c
+++ b/opensm/osm_console_io.c
@@ -208,8 +208,15 @@ int osm_console_init(osm_subn_opt_t * opt, osm_console_t * p_oct, osm_log_t * p_
 				strerror(errno));
 			return -1;
 		}
-		setsockopt(p_oct->socket, SOL_SOCKET, SO_REUSEADDR,
-			   &optval, sizeof(optval));
+
+		if (setsockopt(p_oct->socket, SOL_SOCKET, SO_REUSEADDR,
+			       &optval, sizeof(optval))) {
+			OSM_LOG(p_log, OSM_LOG_ERROR,
+		                "ERR 4B06: Failed to set socket option: %s\n",
+		                strerror(errno));
+		        return -1;
+		}
+
 		sin.sin_family = AF_INET;
 		sin.sin_port = htons(opt->console_port);
 #ifdef ENABLE_OSM_CONSOLE_SOCKET
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
