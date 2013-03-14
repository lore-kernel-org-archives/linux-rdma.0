From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sw_info_rcv.c: Fix double release of lock in osm_si_rcv_process
Date: Thu, 14 Mar 2013 10:13:44 -0400
Message-ID: <5141DB18.1000408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


when node GUID is not found

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sw_info_rcv.c b/opensm/osm_sw_info_rcv.c
index 122af89..84e7fe0 100644
--- a/opensm/osm_sw_info_rcv.c
+++ b/opensm/osm_sw_info_rcv.c
@@ -378,7 +378,7 @@ void osm_si_rcv_process(IN void *context, IN void *data)
 		/* we might get back a request for signaling change was detected */
 		sm->p_subn->force_heavy_sweep = TRUE;
 
-Exit:
 	CL_PLOCK_RELEASE(sm->p_lock);
+Exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
