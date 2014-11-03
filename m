From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Better way to handle polling other MASTER SM
Date: Mon, 03 Nov 2014 11:28:35 -0500
Message-ID: <5457AD33.4080209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In the case where another MASTER SM disappears, call
OSM_SM_SIGNAL_POLLING_TIMEOUT to reconfigure the fabric from scratch.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_drop_mgr.c  |    3 ---
 opensm/osm_state_mgr.c |    7 +++++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index ab06bf8..8441f89 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -257,9 +257,6 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"Cleaned SM for port guid 0x%016" PRIx64 "\n",
 			cl_ntoh64(port_guid));
-		/* clean up the polling_sm_guid */
-		if (sm->polling_sm_guid == p_sm->smi.guid)
-			sm->polling_sm_guid = 0;
 		free(p_sm);
 	}
 
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 9798b41..1dc6e19 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1404,10 +1404,17 @@ repeat_discovery:
 				 * need to wait for that SM to relinquish control
 				 * of its portion of the subnet. C14-60.2.1.
 				 * Also - need to start polling on that SM. */
+				CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 				sm->polling_sm_guid = p_remote_sm->smi.guid;
+				CL_PLOCK_RELEASE(sm->p_lock);
 				osm_sm_state_mgr_process(sm,
 							 OSM_SM_SIGNAL_WAIT_FOR_HANDOVER);
 				return;
+			} else if (sm->polling_sm_guid) {
+				/* Stop polling SM if it's not found */
+				osm_sm_state_mgr_process(sm,
+							 OSM_SM_SIGNAL_POLLING_TIMEOUT);
+				return;
 			}
 		}
 	}
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
