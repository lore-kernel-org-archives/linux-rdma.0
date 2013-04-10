From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_mad_ctrl.c: Drop incoming SA queries when shutting
 down
Date: Wed, 10 Apr 2013 06:36:07 -0400
Message-ID: <51654097.1080703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_mad_ctrl.c b/opensm/osm_sa_mad_ctrl.c
index 86c8fda..902803e 100644
--- a/opensm/osm_sa_mad_ctrl.c
+++ b/opensm/osm_sa_mad_ctrl.c
@@ -54,6 +54,7 @@
 #include <opensm/osm_msgdef.h>
 #include <opensm/osm_helper.h>
 #include <opensm/osm_sa.h>
+#include <opensm/osm_opensm.h>
 
 /****f* opensm: SA/sa_mad_ctrl_disp_done_callback
  * NAME
@@ -357,7 +358,11 @@ static void sa_mad_ctrl_rcv_callback(IN osm_madw_t * p_madw, IN void *context,
 #endif
 	case IB_MAD_METHOD_SET:
 	case IB_MAD_METHOD_DELETE:
-		sa_mad_ctrl_process(p_ctrl, p_madw);
+		/* if we are closing down simply do nothing */
+		if (osm_exit_flag)
+			osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
+		else
+			sa_mad_ctrl_process(p_ctrl, p_madw);
 		break;
 
 	default:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
