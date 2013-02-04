From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_congestion_control.c: fix use-after-free found by coverity
Date: Mon,  4 Feb 2013 15:20:03 +0200
Message-ID: <1359984011-30753-2-git-send-email-alexne@mellanox.com>
References: <1359984011-30753-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359984011-30753-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Read from pointer "p_madw" after free

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_congestion_control.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
index e103ab1..17af407 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -521,6 +521,7 @@ static void cc_poller_send(osm_congestion_control_t *p_cc,
 {
 	osm_subn_opt_t *p_opt = &p_cc->subn->opt;
 	ib_api_status_t status;
+	osm_madw_context_t mad_context = p_madw->context;
 
 	status = osm_vendor_send(p_cc->bind_handle, p_madw, TRUE);
 	if (status == IB_SUCCESS) {
@@ -530,15 +531,11 @@ static void cc_poller_send(osm_congestion_control_t *p_cc,
 			cl_event_wait_on(&p_cc->sig_mads_on_wire_continue,
 					 EVENT_NO_TIMEOUT,
 					 TRUE);
-	}
-	else {
-		osm_madw_context_t *mad_context = &p_madw->context;
-
+	} else
 		OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C104: "
 			"send failed to node 0x%" PRIx64 "port %u\n",
-			mad_context->cc_context.node_guid,
-			mad_context->cc_context.port);
-	}
+			mad_context.cc_context.node_guid,
+			mad_context.cc_context.port);
 }
 
 static void cc_poller(void *p_ptr)
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
