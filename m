From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/3 opensm] complib/cl_event_wheel.c: Fix duplicate error
 codes
Date: Fri, 12 Jul 2013 09:31:08 -0400
Message-ID: <51E0051C.6030409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

New prefix is 62XX.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 complib/cl_event_wheel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/complib/cl_event_wheel.c b/complib/cl_event_wheel.c
index 21d1ed1..901ef8e 100644
--- a/complib/cl_event_wheel.c
+++ b/complib/cl_event_wheel.c
@@ -173,7 +173,7 @@ static void __cl_event_wheel_callback(IN void *context)
 		       "%u [msec]\n", new_timeout);
 		cl_status = cl_timer_start(&p_event_wheel->timer, new_timeout);
 		if (cl_status != CL_SUCCESS) {
-			CL_DBG("__cl_event_wheel_callback : ERR 6100: "
+			CL_DBG("__cl_event_wheel_callback : ERR 6200: "
 			       "Failed to start timer\n");
 		}
 	}
@@ -371,7 +371,7 @@ cl_status_t cl_event_wheel_reg(IN cl_event_wheel_t * const p_event_wheel,
 		/* start the timer to the timeout [msec] */
 		cl_status = cl_timer_start(&p_event_wheel->timer, to);
 		if (cl_status != CL_SUCCESS) {
-			CL_DBG("cl_event_wheel_reg : ERR 6103: "
+			CL_DBG("cl_event_wheel_reg : ERR 6203: "
 			       "Failed to start timer\n");
 			goto Exit;
 		}
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
