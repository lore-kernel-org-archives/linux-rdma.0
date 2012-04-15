From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_state_mgr.c: Cosmetic change to log message
Date: Sun, 15 Apr 2012 11:56:29 -0400
Message-ID: <4F8AEFAD.8060504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


It's been quite a while since QoS setup was completed here

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index eb5ddee..4e6c880 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1311,7 +1311,7 @@ repeat_discovery:
 		return;
 
 	OSM_LOG_MSG_BOX_V2(sm->p_log, OSM_LOG_VERBOSE,
-			   "PKEY and QOS setup completed - STARTING SM LID CONFIG");
+			   "PKEY setup completed - STARTING SM LID CONFIG");
 
 	osm_lid_mgr_process_sm(&sm->lid_mgr);
 	if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
