From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] Add trap details to notice log message
Date: Thu, 30 May 2013 06:55:08 -0700 (PDT)
Message-ID: <8fb9ecd6-7a69-4d10-b7e7-07046067cd71@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index d5cf287..5c238ae 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -7619,6 +7620,23 @@ ib_member_set_join_state(IN OUT ib_member_rec_t * p_mc_rec,
 #define IB_NOTICE_TYPE_INFO				0x04
 #define IB_NOTICE_TYPE_EMPTY				0x7F
 
+#define SM_GID_IN_SERVICE_TRAP				64
+#define SM_GID_OUT_OF_SERVICE_TRAP			65
+#define SM_MGID_CREATED_TRAP				66
+#define SM_MGID_DESTROYED_TRAP				67
+#define SM_UNPATH_TRAP					68
+#define SM_REPATH_TRAP					69
+#define SM_LINK_STATE_CHANGED_TRAP			128
+#define SM_LINK_INTEGRITY_THRESHOLD_TRAP		129
+#define SM_BUFFER_OVERRUN_THRESHOLD_TRAP		130
+#define SM_WATCHDOG_TIMER_EXPIRED_TRAP			131
+#define SM_LOCAL_CHANGES_TRAP				144
+#define SM_SYS_IMG_GUID_CHANGED_TRAP			145
+#define SM_BAD_MKEY_TRAP				256
+#define SM_BAD_PKEY_TRAP				257
+#define SM_BAD_QKEY_TRAP				258
+#define SM_BAD_SWITCH_PKEY_TRAP				259
+
 #include <complib/cl_packon.h>
 typedef struct _ib_mad_notice_attr	// Total Size calc  Accumulated
 {
diff --git a/opensm/osm_inform.c b/opensm/osm_inform.c
index f5abbc6..3ccbc12 100644
--- a/opensm/osm_inform.c
+++ b/opensm/osm_inform.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -316,7 +317,8 @@ static ib_api_status_t send_report(IN osm_infr_t * p_infr_rec,	/* the informinfo
 
 	if (!p_report_madw) {
 		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0203: "
-			"osm_mad_pool_get failed\n");
+			"Cannot send report to LID %u, osm_mad_pool_get failed\n",
+			cl_ntoh16(p_infr_rec->report_addr.dest_lid));
 		status = IB_ERROR;
 		goto Exit;
 	}
@@ -584,6 +586,7 @@ static void log_notice(osm_log_t * log, osm_log_level_t level,
 {
 	char gid_str[INET6_ADDRSTRLEN];
 	ib_gid_t *gid;
+	ib_gid_t *gid1, *gid2;
 
 	/* an official Event information log */
 	if (ib_notice_is_generic(ntc)) {
@@ -594,14 +597,145 @@ static void log_notice(osm_log_t * log, osm_log_level_t level,
 			gid = &ntc->data_details.ntc_64_67.gid;
 		else
 			gid = &ntc->issuer_gid;
-		OSM_LOG(log, level,
-			"Reporting Generic Notice type:%u num:%u (%s)"
-			" from LID:%u GID:%s\n",
-			ib_notice_get_type(ntc),
-			cl_ntoh16(ntc->g_or_v.generic.trap_num),
-			ib_get_trap_str(ntc->g_or_v.generic.trap_num),
-			cl_ntoh16(ntc->issuer_lid),
-			inet_ntop(AF_INET6, gid->raw, gid_str, sizeof gid_str));
+
+		switch (cl_ntoh16(ntc->g_or_v.generic.trap_num)) {
+		case SM_GID_IN_SERVICE_TRAP:
+		case SM_GID_OUT_OF_SERVICE_TRAP:
+			OSM_LOG(log, level,
+				"Reporting Informational Notice \"%s\", GID:%s\n",
+				ib_get_trap_str(ntc->g_or_v.generic.trap_num),
+				inet_ntop(AF_INET6, gid->raw, gid_str, sizeof gid_str));
+			break;
+		case SM_MGID_CREATED_TRAP:
+		case SM_MGID_DESTROYED_TRAP:
+			OSM_LOG(log, level,
+				"Reporting Informational Notice \"%s\", MGID:%s\n",
+				ib_get_trap_str(ntc->g_or_v.generic.trap_num),
+				inet_ntop(AF_INET6, gid->raw, gid_str, sizeof gid_str));
+			break;
+		case SM_UNPATH_TRAP:
+		case SM_REPATH_TRAP:
+			/* TODO: Fill in details once SM starts to use these traps */
+			OSM_LOG(log, level,
+				"Reporting Informational Notice \"%s\"n",
+				ib_get_trap_str(ntc->g_or_v.generic.trap_num));
+			break;
+		case SM_LINK_STATE_CHANGED_TRAP:
+			OSM_LOG(log, level,
+				"Reporting Urgent Notice \"%s\" from switch LID %u, "
+				"GUID 0x%016" PRIx64 "\n",
+				ib_get_trap_str(ntc->g_or_v.generic.trap_num),
+				cl_ntoh16(ntc->issuer_lid),
+				cl_ntoh64(gid->unicast.interface_id));
+			break;
+		case SM_LINK_INTEGRITY_THRESHOLD_TRAP:
+		case SM_BUFFER_OVERRUN_THRESHOLD_TRAP:
+		case SM_WATCHDOG_TIMER_EXPIRED_TRAP:
+			OSM_LOG(log, level,
+				"Reporting Urgent Notice \"%s\" from LID %u, "
+				"GUID 0x%016" PRIx64 ", port %u\n",
+				ib_get_trap_str(ntc->g_or_v.generic.trap_num),
+				cl_ntoh16(ntc->issuer_lid),
+				cl_ntoh64(gid->unicast.interface_id),
+				ntc->data_details.ntc_129_131.port_num);
+			break;
+		case SM_LOCAL_CHANGES_TRAP:
+			if (ntc->data_details.ntc_144.local_changes == 1)
+				OSM_LOG(log, level,
+					"Reporting Informational Notice \"%s\" from LID %u, "
+					"GUID 0x%016" PRIx64 ", ChangeFlags 0x%04x, "
+					"CapabilityMask2 0x%04x\n",
+					ib_get_trap_str(ntc->g_or_v.generic.trap_num),
+					cl_ntoh16(ntc->issuer_lid),
+					cl_ntoh64(gid->unicast.interface_id),
+					cl_ntoh16(ntc->data_details.ntc_144.change_flgs),
+					cl_ntoh16(ntc->data_details.ntc_144.cap_mask2));
+			else
+				OSM_LOG(log, level,
+					"Reporting Informational Notice \"%s\" from LID %u, "
+					"GUID 0x%016" PRIx64 ", new CapabilityMask 0x%08x\n",
+					ib_get_trap_str(ntc->g_or_v.generic.trap_num),
+					cl_ntoh16(ntc->issuer_lid),
+					cl_ntoh64(gid->unicast.interface_id),
+					cl_ntoh32(ntc->data_details.ntc_144.new_cap_mask));
+			break;
+		case SM_SYS_IMG_GUID_CHANGED_TRAP:
+			OSM_LOG(log, level,
+				"Reporting Informational Notice \"%s\" from LID %u, "
+				"GUID 0x%016" PRIx64 ", new SysImageGUID 0x%016" PRIx64 "\n",
+				ib_get_trap_str(ntc->g_or_v.generic.trap_num),
+				cl_ntoh16(ntc->issuer_lid),
+				cl_ntoh64(gid->unicast.interface_id),
+				cl_ntoh64(ntc->data_details.ntc_145.new_sys_guid));
+			break;
+		case SM_BAD_MKEY_TRAP:
+			OSM_LOG(log, level,
+				"Reporting Security Notice \"%s\" from LID %u, "
+				"GUID 0x%016" PRIx64 ", Method 0x%x, Attribute 0x%x, "
+				"AttrMod 0x%x, M_Key 0x%016" PRIx64 "\n",
+				ib_get_trap_str(ntc->g_or_v.generic.trap_num),
+				cl_ntoh16(ntc->issuer_lid),
+				cl_ntoh64(gid->unicast.interface_id),
+				ntc->data_details.ntc_256.method,
+				cl_ntoh16(ntc->data_details.ntc_256.attr_id),
+				cl_ntoh32(ntc->data_details.ntc_256.attr_mod),
+				cl_ntoh64(ntc->data_details.ntc_256.mkey));
+			break;
+		case SM_BAD_PKEY_TRAP:
+		case SM_BAD_QKEY_TRAP:
+			gid1 = &ntc->data_details.ntc_257_258.gid1;
+			gid2 = &ntc->data_details.ntc_257_258.gid2;
+			OSM_LOG(log, level,
+				"Reporting Security Notice \"%s\" from LID %u, "
+				"GUID 0x%016" PRIx64 " : LID1 %u, LID2 %u, %s 0x%x, "
+				"SL %d, QP1 0x%x, QP2 0x%x, GID1 %s, GID2 %s\n",
+				ib_get_trap_str(ntc->g_or_v.generic.trap_num),
+				cl_ntoh16(ntc->issuer_lid),
+				cl_ntoh64(gid->unicast.interface_id),
+				cl_ntoh16(ntc->data_details.ntc_257_258.lid1),
+				cl_ntoh16(ntc->data_details.ntc_257_258.lid2),
+				cl_ntoh16(ntc->g_or_v.generic.trap_num) == SM_BAD_QKEY_TRAP ?
+					"Q_Key" : "P_Key",
+				cl_ntoh32(ntc->data_details.ntc_257_258.key),
+				cl_ntoh32(ntc->data_details.ntc_257_258.qp1) >> 28,
+				cl_ntoh32(ntc->data_details.ntc_257_258.qp1) & 0xffffff,
+				cl_ntoh32(ntc->data_details.ntc_257_258.qp2) & 0xffffff,
+				inet_ntop(AF_INET6, gid1->raw, gid_str, sizeof gid_str),
+				inet_ntop(AF_INET6, gid2->raw, gid_str, sizeof gid_str));
+			break;
+		case SM_BAD_SWITCH_PKEY_TRAP:
+			gid1 = &ntc->data_details.ntc_259.gid1;
+			gid2 = &ntc->data_details.ntc_259.gid2;
+			OSM_LOG(log, level,
+				"Reporting Security Notice \"%s\" from switch LID %u, "
+				"GUID 0x%016" PRIx64 " port %d : data_valid 0x%04x, "
+				"LID1 %u, LID2 %u, PKey 0x%04x, "
+				"SL %d, QP1 0x%x, QP2 0x%x, GID1 %s, GID2 %s\n",
+				ib_get_trap_str(ntc->g_or_v.generic.trap_num),
+				cl_ntoh16(ntc->issuer_lid),
+				cl_ntoh64(gid->unicast.interface_id),
+				ntc->data_details.ntc_259.port_no,
+				cl_ntoh16(ntc->data_details.ntc_259.data_valid),
+				cl_ntoh16(ntc->data_details.ntc_259.lid1),
+				cl_ntoh16(ntc->data_details.ntc_259.lid2),
+				cl_ntoh16(ntc->data_details.ntc_257_258.key),
+				cl_ntoh32(ntc->data_details.ntc_259.sl_qp1) >> 28,
+				cl_ntoh32(ntc->data_details.ntc_259.sl_qp1) & 0xffffff,
+				cl_ntoh32(ntc->data_details.ntc_259.qp2),
+				inet_ntop(AF_INET6, gid1->raw, gid_str, sizeof gid_str),
+				inet_ntop(AF_INET6, gid2->raw, gid_str, sizeof gid_str));
+			break;
+		default:
+			OSM_LOG(log, level,
+				"Reporting Generic Notice type:%u num:%u (%s)"
+				" from LID:%u GID:%s\n",
+				ib_notice_get_type(ntc),
+				cl_ntoh16(ntc->g_or_v.generic.trap_num),
+				ib_get_trap_str(ntc->g_or_v.generic.trap_num),
+				cl_ntoh16(ntc->issuer_lid),
+				inet_ntop(AF_INET6, gid->raw, gid_str, sizeof gid_str));
+			break;
+		}
 	} else
 		OSM_LOG(log, level,
 			"Reporting Vendor Notice type:%u vend:%u dev:%u"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
