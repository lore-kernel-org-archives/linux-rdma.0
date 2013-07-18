From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] complib/cl_event_wheel.c: Roundup timeout to nearest
 msec
Date: Thu, 18 Jul 2013 09:53:34 -0400
Message-ID: <51E7F35E.1050208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/complib/cl_event_wheel.c b/complib/cl_event_wheel.c
index 24f3e31..27443f6 100644
--- a/complib/cl_event_wheel.c
+++ b/complib/cl_event_wheel.c
@@ -167,8 +167,7 @@ static void __cl_event_wheel_callback(IN void *context)
 
 		/* start the timer to the timeout [msec] */
 		new_timeout =
-		    (uint32_t) (((p_event->aging_time - current_time) / 1000) +
-				0.5);
+		    (uint32_t) ((p_event->aging_time - current_time + 500) / 1000);
 		CL_DBG("__cl_event_wheel_callback: Restart timer in: "
 		       "%u [msec]\n", new_timeout);
 		cl_status = cl_timer_start(&p_event_wheel->timer, new_timeout);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
