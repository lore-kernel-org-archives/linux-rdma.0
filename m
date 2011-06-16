From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sminfo_rcv.c: Eliminate unneeded return parameter
 from internal routine
Date: Thu, 16 Jun 2011 09:31:59 -0400
Message-ID: <4DFA05CF.1080200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


smi_rcv_process_get_sm only returns 0 so no need for return parameter.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
index b6bc558..66eb886 100644
--- a/opensm/osm_sminfo_rcv.c
+++ b/opensm/osm_sminfo_rcv.c
@@ -293,9 +293,9 @@ Exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
 
-static int smi_rcv_process_get_sm(IN osm_sm_t * sm,
-				  IN const osm_remote_sm_t * p_sm,
-				  boolean_t light_sweep)
+static void smi_rcv_process_get_sm(IN osm_sm_t * sm,
+				   IN const osm_remote_sm_t * p_sm,
+				   boolean_t light_sweep)
 {
 	const ib_sm_info_t *p_smi;
 
@@ -405,7 +405,6 @@ static int smi_rcv_process_get_sm(IN osm_sm_t * sm,
 	}
 
 	OSM_LOG_EXIT(sm->p_log);
-	return 0;
 }
 
 static void smi_rcv_process_get_response(IN osm_sm_t * sm,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
