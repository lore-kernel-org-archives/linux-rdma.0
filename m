From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH OpenSM] osm_trap_rcv.c: Log DR path to node when trap 128
Date: Mon, 07 Oct 2013 16:35:40 -0400
Message-ID: <52531B1C.4070702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


So can see if any subsequent transaction timeouts are related

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_helper.h b/include/opensm/osm_helper.h
index bc4bad3..f7b92f6 100644
--- a/include/opensm/osm_helper.h
+++ b/include/opensm/osm_helper.h
@@ -622,6 +622,10 @@ void osm_dump_sa_mad(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_smp,
 void osm_dump_sa_mad_v2(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_smp,
 			IN const int file_id, IN osm_log_level_t level);
 
+void osm_dump_dr_path_as_buf(IN size_t max_len, IN const osm_dr_path_t * p_path,
+			     OUT char* buf);
+
+
 /****f* IBA Base: Types/osm_get_sm_signal_str
 * NAME
 *	osm_get_sm_signal_str
diff --git a/opensm/libopensm.map b/opensm/libopensm.map
index e75d424..721e0e8 100644
--- a/opensm/libopensm.map
+++ b/opensm/libopensm.map
@@ -65,6 +65,7 @@ OPENSM_1.5 {
 		osm_dump_sa_mad_v2;
 		osm_dump_dr_path;
 		osm_dump_dr_path_v2;
+		osm_dump_dr_path_as_buf;
 		osm_dump_smp_dr_path;
 		osm_dump_smp_dr_path_v2;
 		osm_dump_pkey_block;
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index aa40650..e3ea3a7 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -2875,6 +2875,13 @@ void osm_dump_smp_dr_path_v2(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 	}
 }
 
+void osm_dump_dr_path_as_buf(IN size_t max_len,
+			     IN const osm_dr_path_t * p_path,
+			     OUT char* buf)
+{
+	sprint_uint8_arr(buf, max_len, p_path->path, p_path->hop_count + 1);
+}
+
 static const char *sm_signal_str[] = {
 	"OSM_SIGNAL_NONE",	/* 0 */
 	"OSM_SIGNAL_SWEEP",	/* 1 */
diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index ae08012..9b1d271 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -364,6 +364,9 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 	boolean_t physp_change_trap = FALSE;
 	uint64_t event_wheel_timeout = OSM_DEFAULT_TRAP_SUPRESSION_TIMEOUT;
 	boolean_t run_heavy_sweep = FALSE;
+	char buf[1024];
+	osm_dr_path_t *p_path;
+	unsigned n;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -555,6 +558,26 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 	}
 
 check_sweep:
+	if (osm_log_is_active_v2(sm->p_log, OSM_LOG_INFO, FILE_ID)) {
+		if (ib_notice_is_generic(p_ntci) &&
+		    cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == SM_LINK_STATE_CHANGED_TRAP) {
+			p_path = osm_physp_get_dr_path_ptr(p_physp);
+			if (p_path) {
+				n = sprintf(buf, "SM class trap %u: ",
+					    cl_ntoh16(p_ntci->g_or_v.generic.trap_num));
+				n += snprintf(buf + n, sizeof(buf) - n,
+					      "Directed Path Dump of %u hop path: "
+					      "Path = ", p_path->hop_count);
+
+				osm_dump_dr_path_as_buf(sizeof(buf) - n, p_path,
+							buf + n);
+
+				osm_log_v2(sm->p_log, OSM_LOG_INFO, FILE_ID,
+					   "%s\n", buf);
+			}
+		}
+	}
+
 	/* do a sweep if we received a trap */
 	if (sm->p_subn->opt.sweep_on_trap) {
 		/* if this is trap number 128 or run_heavy_sweep is TRUE -
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
