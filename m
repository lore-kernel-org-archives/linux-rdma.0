From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_congestion_control.c: Fix endian of node and port
 GUIDs in some log messages
Date: Sat, 13 Dec 2014 10:00:10 -0500
Message-ID: <548C547A.4050309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Qian Liu <qga2-Ziy7KYdZgCFYQ+XSgtFfGw@public.gmane.org>
Cc: "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


based on obtaining these from cc_context
where GUID endian is network rather than host endian

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_congestion_control.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
index 11be555..c04ae07 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -448,16 +448,16 @@ static void cc_rcv_mad(void *context, void *data)
 	ib_cc_mad_t *p_cc_mad;
 	osm_madw_context_t *p_mad_context = &p_madw->context;
 	ib_mad_t *p_mad = osm_madw_get_mad_ptr(p_madw);
-	uint64_t node_guid = p_mad_context->cc_context.node_guid;
-	uint64_t port_guid = p_mad_context->cc_context.port_guid;
+	ib_net64_t node_guid = p_mad_context->cc_context.node_guid;
+	ib_net64_t port_guid = p_mad_context->cc_context.port_guid;
 	uint8_t port = p_mad_context->cc_context.port;
 	osm_port_t *p_port;
 
 	OSM_LOG_ENTER(p_cc->log);
 
 	OSM_LOG(p_cc->log, OSM_LOG_VERBOSE,
-		"Processing received MAD status 0x%x context 0x%"
-		PRIx64 " port %u\n", p_mad->status, node_guid, port);
+		"Processing received MAD status 0x%x node 0x%" PRIx64 " port %u\n",
+		p_mad->status, cl_ntoh64(node_guid), port);
 
 	p_cc_mad = osm_madw_get_cc_mad_ptr(p_madw);
 
@@ -466,8 +466,8 @@ static void cc_rcv_mad(void *context, void *data)
 	p_port = osm_get_port_by_guid(p_cc->subn, port_guid);
 	if (!p_port) {
 		OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C109: "
-			"Port GUID not in table 0x%" PRIx64 "\n",
-			port_guid);
+			"Port GUID 0x%" PRIx64 " not in table\n",
+			cl_ntoh64(port_guid));
 		cl_plock_release(&p_osm->lock);
 		goto Exit;
 	}
@@ -539,7 +539,7 @@ wait:
 	} else
 		OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C104: "
 			"send failed to node 0x%" PRIx64 "port %u\n",
-			mad_context.cc_context.node_guid,
+			cl_ntoh64(mad_context.cc_context.node_guid),
 			mad_context.cc_context.port);
 }
 
@@ -673,8 +673,8 @@ static void cc_mad_send_err_callback(void *bind_context,
 	p_port = osm_get_port_by_guid(p_cc->subn, port_guid);
 	if (!p_port) {
 		OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C10B: "
-			"Port guid not in table 0x%" PRIx64 "\n",
-			port_guid);
+			"Port GUID 0x%" PRIx64 " not in table\n",
+			cl_ntoh64(port_guid));
 		cl_plock_release(&p_osm->lock);
 		goto Exit;
 	}
@@ -693,7 +693,7 @@ static void cc_mad_send_err_callback(void *bind_context,
 			ib_get_err_str(p_madw->status),
 			p_madw->p_mad->attr_id,
 			cl_ntoh16(p_madw->mad_addr.dest_lid),
-			node_guid,
+			cl_ntoh64(node_guid),
 			port,
 			cl_ntoh64(p_madw->p_mad->trans_id));
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
