From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH v2] opensm/osm_sm_mad_ctrl.c Changes to some error messages
Date: Thu, 03 Dec 2009 15:27:15 +0100
Message-ID: <4B17CAC3.7070507@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added info to some error messages and lowered log level on
subsequent call to osm_dump_dr_smp() to reduce amount of logging
with default log level setting.

Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

---

diff --git a/opensm/opensm/osm_sm_mad_ctrl.c b/opensm/opensm/osm_sm_mad_ctrl.c
index 74beb1c..c4c5032 100644
--- a/opensm/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/opensm/osm_sm_mad_ctrl.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -567,6 +568,44 @@ static void sm_mad_ctrl_process_trap_repress(IN osm_sm_mad_ctrl_t * p_ctrl,
 	OSM_LOG_EXIT(p_ctrl->p_log);
 }
 
+static void log_rcv_cb_error(osm_log_t *p_log, ib_smp_t *p_smp, ib_net16_t status)
+{
+	char buf[BUF_SIZE];
+	char ipath[BUF_SIZE], rpath[BUF_SIZE];
+	char tmp[10];
+	uint32_t i;
+
+	if (p_smp->mgmt_class == IB_MCLASS_SUBN_DIR) {
+
+		for (i = 0; i <= p_smp->hop_count; i++) {
+			if (i == 0) {
+				sprintf(ipath, "%d", p_smp->initial_path[i]);
+				sprintf(rpath, "%d", p_smp->return_path[i]);
+			} else {
+				sprintf(tmp, ",%d", p_smp->initial_path[i]);
+				strcat(ipath, tmp);
+				sprintf(tmp, ",%d", p_smp->return_path[i]);
+				strcat(rpath, tmp);
+			}
+		}
+		sprintf(buf, "\n\t\t\tInitial path: ");
+		strcat(buf, ipath);
+		strcat(buf, " Return path: ");
+		strcat(buf, rpath);
+	}
+
+	OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 3111: "
+		"Received MAD with error status = 0x%X\n"
+		"\t\t\t%s(%s), attr_mod 0x%x, TID 0x%" PRIx64 "%s\n",
+		cl_ntoh16(status), ib_get_sm_method_str(p_smp->method),
+		ib_get_sm_attr_str(p_smp->attr_id),
+		cl_ntoh32(p_smp->attr_mod),
+		cl_ntoh64(p_smp->trans_id),
+		p_smp->mgmt_class == IB_MCLASS_SUBN_DIR ? buf : "");
+
+		osm_dump_dr_smp(p_log, p_smp, OSM_LOG_VERBOSE);
+}
+
 /*
  * PARAMETERS
  *
@@ -635,11 +674,8 @@ static void sm_mad_ctrl_rcv_callback(IN osm_madw_t * p_madw,
 	else
 		status = p_smp->status;
 
-	if (status != 0) {
-		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3111: "
-			"Error status = 0x%X\n", cl_ntoh16(status));
-		osm_dump_dr_smp(p_ctrl->p_log, p_smp, OSM_LOG_ERROR);
-	}
+	if (status != 0)
+		log_rcv_cb_error(p_ctrl->p_log, p_smp, status);
 
 	switch (p_smp->method) {
 	case IB_MAD_METHOD_GET_RESP:
@@ -708,9 +744,15 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
 
 	CL_ASSERT(p_madw);
 
+	p_smp = osm_madw_get_smp_ptr(p_madw);
 	OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3113: "
-		"MAD completed in error (%s)\n",
-		ib_get_err_str(p_madw->status));
+		"MAD completed in error (%s): "
+		"%s(%s), attr_mod 0x%x, TID 0x%" PRIx64 "\n",
+		ib_get_err_str(p_madw->status),
+		ib_get_sm_method_str(p_smp->method),
+		ib_get_sm_attr_str(p_smp->attr_id),
+		cl_ntoh32(p_smp->attr_mod),
+		cl_ntoh64(p_smp->trans_id));
 
 	/*
 	   If this was a SubnSet MAD, then this error might indicate a problem
@@ -718,7 +760,6 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
 	   such a problem. The subnet will not be up, and the next sweep should
 	   be a heavy sweep as well.
 	 */
-	p_smp = osm_madw_get_smp_ptr(p_madw);
 	if (p_smp->method == IB_MAD_METHOD_SET &&
 	    (p_smp->attr_id == IB_MAD_ATTR_PORT_INFO ||
 	     p_smp->attr_id == IB_MAD_ATTR_MCAST_FWD_TBL ||
@@ -734,6 +775,8 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
 		p_ctrl->p_subn->subnet_initialization_error = TRUE;
 	}
 
+	osm_dump_dr_smp(p_ctrl->p_log, p_smp, OSM_LOG_VERBOSE);
+
 	/*
 	   Since we did not get any response we suspect the DR path
 	   used for the target port.
@@ -764,10 +807,6 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
 	   An error occurred.  No response was received to a request MAD.
 	   Retire the original request MAD.
 	 */
-
-	osm_dump_dr_smp(p_ctrl->p_log, osm_madw_get_smp_ptr(p_madw),
-			OSM_LOG_ERROR);
-
 	sm_mad_ctrl_update_wire_stats(p_ctrl);
 
 	if (osm_madw_get_err_msg(p_madw) != CL_DISP_MSGID_NONE) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
