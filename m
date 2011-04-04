From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] osmtest/osmtest.c: Fix trap flow not implemented log message
Date: Mon, 04 Apr 2011 14:46:24 -0400
Message-ID: <4D9A1200.1040206@dev.mellanox.co.il>
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
diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
index 4854779..7ecc8ce 100644
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -7367,7 +7367,7 @@ ib_api_status_t osmtest_run(IN osmtest_t * const
p_osmt)
 				}
 #else
 				OSM_LOG(&p_osmt->log, OSM_LOG_INFO,
-					"The event forwarding flow "
+					"Trap 64/65 flow "
 					"is not implemented yet!\n");
 				status = IB_SUCCESS;
 				goto Exit;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
