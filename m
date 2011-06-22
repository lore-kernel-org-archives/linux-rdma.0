From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osmtest/osmt_multicast.: Fix typo in log message
Date: Wed, 22 Jun 2011 09:50:14 -0400
Message-ID: <4E01F316.4020007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/osmtest/osmt_multicast.c b/osmtest/osmt_multicast.c
index e4eba64..9ea56c8 100644
--- a/osmtest/osmt_multicast.c
+++ b/osmtest/osmt_multicast.c
@@ -1216,7 +1216,7 @@ ib_api_status_t osmt_run_mcast_flow(IN osmtest_t * const p_osmt)
 	OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
 		"Checking Create given MGID=0 valid Set several options :\n\t\t"
 		"First above min RATE, Second less than max RATE\n\t\t"
-		"Third above min MTU, Second less than max MTU\n\t\t"
+		"Third above min MTU, Fourth less than max MTU\n\t\t"
 		"Fifth exact MTU & RATE feasible, Sixth exact RATE feasible\n\t\t"
 		"Seventh exact MTU feasible (o15.0.1.4)...\n");
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
