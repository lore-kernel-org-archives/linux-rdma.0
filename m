From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: Manage ports that do not support congestion control
Date: Wed, 29 Aug 2012 10:40:32 -0700
Message-ID: <1346262032.15926.22.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Support the ability to run congestion support in an environment
where some IB hardware does not support congestion control.

In addition, by flagging ports that do not support congestion
control, we can reduce the amount of MAD traffic and log messages.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_congestion_control.h |    2 +
 include/opensm/osm_port.h               |    8 ++++
 opensm/osm_congestion_control.c         |   68 ++++++++++++++++++++++++++-----
 3 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/include/opensm/osm_congestion_control.h b/include/opensm/osm_congestion_control.h
index 94e4ffb..78e4a64 100644
--- a/include/opensm/osm_congestion_control.h
+++ b/include/opensm/osm_congestion_control.h
@@ -67,6 +67,8 @@
 
 #define OSM_CC_DEFAULT_MAX_OUTSTANDING_QUERIES 500
 
+#define OSM_CC_TIMEOUT_COUNT_THRESHOLD 3
+
 /****s* OpenSM: CongestionControl/osm_congestion_control_t
 *  This object should be treated as opaque and should
 *  be manipulated only through the provided functions.
diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index 5fc186c..8e34b84 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -1163,6 +1163,8 @@ typedef struct osm_port {
 	osm_physp_t *p_physp;
 	cl_qlist_t mcm_list;
 	int flag;
+	unsigned int cc_timeout_count;
+	int cc_unavailable_flag;
 	void *priv;
 } osm_port_t;
 /*
@@ -1195,6 +1197,12 @@ typedef struct osm_port {
 *	flag
 *		Utility flag for port management
 *
+*	cc_timeout_count
+*		Count number of times congestion control config times out.
+*
+*	cc_unavailable_flag
+*		Flag indicating if congestion control is not supported.
+*
 * SEE ALSO
 *	Port, Physical Port, Physical Port Table
 *********/
diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
index 8be333d..3a7be18 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -378,6 +378,9 @@ int osm_congestion_control_setup(struct osm_opensm *p_osm)
 
 		p_next = cl_qmap_next(p_next);
 
+		if (p_port->cc_unavailable_flag)
+			continue;
+
 		if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH) {
 			status = cc_send_sw_cong_setting(&p_osm->sm, p_node);
 			if (status != IB_SUCCESS)
@@ -468,6 +471,18 @@ static void cc_rcv_mad(void *context, void *data)
 		goto Exit;
 	}
 
+	p_port->cc_timeout_count = 0;
+
+	if (p_cc_mad->header.status) {
+		if (p_cc_mad->header.status & IB_MAD_STATUS_UNSUP_METHOD
+		    || p_cc_mad->header.status & IB_MAD_STATUS_UNSUP_METHOD_ATTR)
+			p_port->cc_unavailable_flag = 1;
+		cl_plock_release(&p_osm->lock);
+		goto Exit;
+	}
+	else
+		p_port->cc_unavailable_flag = 0;
+
 	if (p_cc_mad->header.attr_id == IB_MAD_ATTR_SW_CONG_SETTING) {
 		ib_sw_cong_setting_t *p_sw_cong_setting;
 
@@ -637,23 +652,56 @@ static void cc_mad_send_err_callback(void *bind_context,
 {
 	osm_congestion_control_t *p_cc = bind_context;
 	osm_madw_context_t *p_madw_context = &p_madw->context;
+	osm_opensm_t *p_osm = p_cc->osm;
 	uint64_t node_guid = p_madw_context->cc_context.node_guid;
+	uint64_t port_guid = p_madw_context->cc_context.port_guid;
 	uint8_t port = p_madw_context->cc_context.port;
+	osm_port_t *p_port;
+	int log_flag = 1;
 
 	OSM_LOG_ENTER(p_cc->log);
 
-	OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C106: MAD Error (%s): "
-		"attr id = %u LID %u GUID 0x%016" PRIx64 " port %u "
-		"TID 0x%" PRIx64 "\n",
-		ib_get_err_str(p_madw->status),
-		p_madw->p_mad->attr_id,
-		cl_ntoh16(p_madw->mad_addr.dest_lid),
-		node_guid,
-		port,
-		cl_ntoh64(p_madw->p_mad->trans_id));
+	cl_plock_acquire(&p_osm->lock);
+
+	p_port = osm_get_port_by_guid(p_cc->subn, port_guid);
+	if (!p_port) {
+		OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C106A: "
+			"Port guid not in table 0x%" PRIx64 "\n",
+			port_guid);
+		cl_plock_release(&p_osm->lock);
+		goto Exit;
+	}
 
-	p_cc->subn->subnet_initialization_error = TRUE;
+	/* If timed out before, don't bothering logging again
+	 * we assume no CC support
+	 */
+	if (p_madw->status == IB_TIMEOUT
+	    && p_port->cc_timeout_count)
+		log_flag = 0;
+
+	if (log_flag)
+		OSM_LOG(p_cc->log, OSM_LOG_ERROR, "ERR C106: MAD Error (%s): "
+			"attr id = %u LID %u GUID 0x%016" PRIx64 " port %u "
+			"TID 0x%" PRIx64 "\n",
+			ib_get_err_str(p_madw->status),
+			p_madw->p_mad->attr_id,
+			cl_ntoh16(p_madw->mad_addr.dest_lid),
+			node_guid,
+			port,
+			cl_ntoh64(p_madw->p_mad->trans_id));
+
+	if (p_madw->status == IB_TIMEOUT) {
+		p_port->cc_timeout_count++;
+		if (p_port->cc_timeout_count > OSM_CC_TIMEOUT_COUNT_THRESHOLD
+		    && !p_port->cc_unavailable_flag)
+			p_port->cc_unavailable_flag++; 
+	}
+	else
+		p_cc->subn->subnet_initialization_error = TRUE;
 
+	cl_plock_release(&p_osm->lock);
+
+Exit:
 	osm_mad_pool_put(p_cc->mad_pool, p_madw);
 
 	decrement_outstanding_mads(p_cc);
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
