From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Handle bad SMP status
Date: Sat, 01 Feb 2014 11:42:59 -0500
Message-ID: <52ED2413.8040307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Terminate receive processing when SMP status is not 0

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_subnet.h |    1 +
 opensm/osm_guid_info_rcv.c  |    7 +++++++
 opensm/osm_lin_fwd_rcv.c    |    8 ++++++++
 opensm/osm_mcast_fwd_rcv.c  |    8 ++++++++
 opensm/osm_node_desc_rcv.c  |    8 ++++++++
 opensm/osm_node_info_rcv.c  |    7 +++++++
 opensm/osm_pkey_rcv.c       |    8 ++++++++
 opensm/osm_slvl_map_rcv.c   |    9 +++++++++
 opensm/osm_sminfo_rcv.c     |    6 ++++++
 opensm/osm_subnet.c         |    9 +++++++--
 opensm/osm_sw_info_rcv.c    |   10 +++++++++-
 opensm/osm_vl_arb_rcv.c     |    8 ++++++++
 12 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index e420b51..5022944 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -294,6 +294,7 @@ typedef struct osm_subn_opt {
 	uint8_t sm_assigned_guid;
 	boolean_t qos;
 	char *qos_policy_file;
+	boolean_t suppress_sl2vl_mad_status_errors;
 	boolean_t accum_log_file;
 	char *console;
 	uint16_t console_port;
diff --git a/opensm/osm_guid_info_rcv.c b/opensm/osm_guid_info_rcv.c
index ce9ff5e..bed4ca2 100644
--- a/opensm/osm_guid_info_rcv.c
+++ b/opensm/osm_guid_info_rcv.c
@@ -96,6 +96,13 @@ void osm_gi_rcv_process(IN void *context, IN void *data)
 	osm_dump_guid_info_v2(sm->p_log, node_guid, port_guid, block_num, p_gi,
 			      FILE_ID, OSM_LOG_DEBUG);
 
+	if (ib_smp_get_status(p_smp)) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(ib_smp_get_status(p_smp)));
+		goto Exit;
+	}
+
 	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 	p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
 	if (!p_port) {
diff --git a/opensm/osm_lin_fwd_rcv.c b/opensm/osm_lin_fwd_rcv.c
index f13b9a8..da490a1 100644
--- a/opensm/osm_lin_fwd_rcv.c
+++ b/opensm/osm_lin_fwd_rcv.c
@@ -80,6 +80,13 @@ void osm_lft_rcv_process(IN void *context, IN void *data)
 	p_lft_context = osm_madw_get_lft_context_ptr(p_madw);
 	node_guid = p_lft_context->node_guid;
 
+	if (ib_smp_get_status(p_smp)) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(ib_smp_get_status(p_smp)));
+		goto Exit;
+	}
+
 	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 	p_sw = osm_get_switch_by_guid(sm->p_subn, node_guid);
 
@@ -99,5 +106,6 @@ void osm_lft_rcv_process(IN void *context, IN void *data)
 	}
 
 	CL_PLOCK_RELEASE(sm->p_lock);
+Exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
diff --git a/opensm/osm_mcast_fwd_rcv.c b/opensm/osm_mcast_fwd_rcv.c
index d855cbb..6404f8c 100644
--- a/opensm/osm_mcast_fwd_rcv.c
+++ b/opensm/osm_mcast_fwd_rcv.c
@@ -96,6 +96,13 @@ void osm_mft_rcv_process(IN void *context, IN void *data)
 		block_num, position, cl_ntoh64(node_guid),
 		cl_ntoh64(p_smp->trans_id));
 
+	if (ib_smp_get_status(p_smp)) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(ib_smp_get_status(p_smp)));
+		goto Exit;
+	}
+
 	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 	p_sw = osm_get_switch_by_guid(sm->p_subn, node_guid);
 
@@ -118,5 +125,6 @@ void osm_mft_rcv_process(IN void *context, IN void *data)
 	}
 
 	CL_PLOCK_RELEASE(sm->p_lock);
+Exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
diff --git a/opensm/osm_node_desc_rcv.c b/opensm/osm_node_desc_rcv.c
index 741c944..6c91aca 100644
--- a/opensm/osm_node_desc_rcv.c
+++ b/opensm/osm_node_desc_rcv.c
@@ -102,6 +102,13 @@ void osm_nd_rcv_process(IN void *context, IN void *data)
 	CL_ASSERT(p_madw);
 
 	p_smp = osm_madw_get_smp_ptr(p_madw);
+	if (ib_smp_get_status(p_smp)) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(ib_smp_get_status(p_smp)));
+		goto Exit;
+	}
+
 	p_nd = ib_smp_get_payload_ptr(p_smp);
 
 	/* Acquire the node object and add the node description. */
@@ -116,5 +123,6 @@ void osm_nd_rcv_process(IN void *context, IN void *data)
 		nd_rcv_process_nd(sm, p_node, p_nd);
 
 	CL_PLOCK_RELEASE(sm->p_lock);
+Exit:
 	OSM_LOG_EXIT(sm->p_log);
 }
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index e76ea1e..e08230a 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -955,6 +955,13 @@ void osm_ni_rcv_process(IN void *context, IN void *data)
 		goto Exit;
 	}
 
+	if (ib_smp_get_status(p_smp)) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(ib_smp_get_status(p_smp)));
+		goto Exit;
+	}
+
 	/*
 	   Determine if this node has already been discovered,
 	   and process accordingly.
diff --git a/opensm/osm_pkey_rcv.c b/opensm/osm_pkey_rcv.c
index b818485..d950bfe 100644
--- a/opensm/osm_pkey_rcv.c
+++ b/opensm/osm_pkey_rcv.c
@@ -84,6 +84,13 @@ void osm_pkey_rcv_process(IN void *context, IN void *data)
 
 	CL_ASSERT(p_smp->attr_id == IB_MAD_ATTR_P_KEY_TABLE);
 
+	if (ib_smp_get_status(p_smp)) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(ib_smp_get_status(p_smp)));
+		goto Exit2;
+	}
+
 	cl_plock_excl_acquire(sm->p_lock);
 	p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
 	if (!p_port) {
@@ -139,5 +146,6 @@ void osm_pkey_rcv_process(IN void *context, IN void *data)
 Exit:
 	cl_plock_release(sm->p_lock);
 
+Exit2:
 	OSM_LOG_EXIT(sm->p_log);
 }
diff --git a/opensm/osm_slvl_map_rcv.c b/opensm/osm_slvl_map_rcv.c
index f5f4240..67f0e19 100644
--- a/opensm/osm_slvl_map_rcv.c
+++ b/opensm/osm_slvl_map_rcv.c
@@ -92,6 +92,14 @@ void osm_slvl_rcv_process(IN void *context, IN void *p_data)
 
 	CL_ASSERT(p_smp->attr_id == IB_MAD_ATTR_SLVL_TABLE);
 
+	if (!sm->p_subn->opt.suppress_sl2vl_mad_status_errors &&
+	    ib_smp_get_status(p_smp)) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(ib_smp_get_status(p_smp)));
+		goto Exit2;
+	}
+
 	cl_plock_excl_acquire(sm->p_lock);
 	p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
 
@@ -159,5 +167,6 @@ void osm_slvl_rcv_process(IN void *context, IN void *p_data)
 Exit:
 	cl_plock_release(sm->p_lock);
 
+Exit2:
 	OSM_LOG_EXIT(sm->p_log);
 }
diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
index 45bfa07..58bc64f 100644
--- a/opensm/osm_sminfo_rcv.c
+++ b/opensm/osm_sminfo_rcv.c
@@ -529,6 +529,12 @@ static void smi_rcv_process_set_response(IN osm_sm_t * sm,
 	CL_ASSERT(p_madw);
 
 	p_smp = osm_madw_get_smp_ptr(p_madw);
+	if (ib_smp_get_status(p_smp)) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(ib_smp_get_status(p_smp)));
+		goto Exit;
+	}
 
 	if (p_smp->method != IB_MAD_METHOD_GET_RESP) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F16: "
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 437764a..6fe90f6 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -777,6 +777,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "sm_assigned_guid", OPT_OFFSET(sm_assigned_guid), opts_parse_uint8, NULL, 1 },
 	{ "qos", OPT_OFFSET(qos), opts_parse_boolean, NULL, 1 },
 	{ "qos_policy_file", OPT_OFFSET(qos_policy_file), opts_parse_charp, NULL, 0 },
+	{ "suppress_sl2vl_mad_status_errors", OPT_OFFSET(suppress_sl2vl_mad_status_errors), opts_parse_boolean, NULL, 1 },
 	{ "dump_files_dir", OPT_OFFSET(dump_files_dir), opts_parse_charp, NULL, 0 },
 	{ "lid_matrix_dump_file", OPT_OFFSET(lid_matrix_dump_file), opts_parse_charp, NULL, 0 },
 	{ "lfts_file", OPT_OFFSET(lfts_file), opts_parse_charp, NULL, 0 },
@@ -1544,6 +1545,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->sm_assigned_guid = 0;
 	p_opt->qos = FALSE;
 	p_opt->qos_policy_file = strdup(OSM_DEFAULT_QOS_POLICY_FILE);
+	p_opt->suppress_sl2vl_mad_status_errors = FALSE;
 	p_opt->accum_log_file = TRUE;
 	p_opt->port_prof_ignore_file = NULL;
 	p_opt->hop_weights_file = NULL;
@@ -2844,8 +2846,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# Enable QoS setup\n"
 		"qos %s\n\n"
 		"# QoS policy file to be used\n"
-		"qos_policy_file %s\n\n",
-		p_opts->qos ? "TRUE" : "FALSE", p_opts->qos_policy_file);
+		"qos_policy_file %s\n"
+		"# Supress QoS MAD status errors\n"
+		"suppress_sl2vl_mad_status_errors %s\n\n",
+		p_opts->qos ? "TRUE" : "FALSE", p_opts->qos_policy_file,
+		p_opts->suppress_sl2vl_mad_status_errors ? "TRUE" : "FALSE");
 
 	subn_dump_qos_options(out,
 			      "QoS default options", "qos",
diff --git a/opensm/osm_sw_info_rcv.c b/opensm/osm_sw_info_rcv.c
index 84e7fe0..cc40ee6 100644
--- a/opensm/osm_sw_info_rcv.c
+++ b/opensm/osm_sw_info_rcv.c
@@ -346,6 +346,13 @@ void osm_si_rcv_process(IN void *context, IN void *data)
 		"Switch GUID 0x%016" PRIx64 ", TID 0x%" PRIx64 "\n",
 		cl_ntoh64(node_guid), cl_ntoh64(p_smp->trans_id));
 
+	if (ib_smp_get_status(p_smp)) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(ib_smp_get_status(p_smp)));
+		goto Exit2;
+	}
+
 	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 
 	p_node = osm_get_node_by_guid(sm->p_subn, node_guid);
@@ -378,7 +385,8 @@ void osm_si_rcv_process(IN void *context, IN void *data)
 		/* we might get back a request for signaling change was detected */
 		sm->p_subn->force_heavy_sweep = TRUE;
 
-	CL_PLOCK_RELEASE(sm->p_lock);
 Exit:
+	CL_PLOCK_RELEASE(sm->p_lock);
+Exit2:
 	OSM_LOG_EXIT(sm->p_log);
 }
diff --git a/opensm/osm_vl_arb_rcv.c b/opensm/osm_vl_arb_rcv.c
index 3967574..fe6b8c7 100644
--- a/opensm/osm_vl_arb_rcv.c
+++ b/opensm/osm_vl_arb_rcv.c
@@ -92,6 +92,13 @@ void osm_vla_rcv_process(IN void *context, IN void *data)
 
 	CL_ASSERT(p_smp->attr_id == IB_MAD_ATTR_VL_ARBITRATION);
 
+	if (ib_smp_get_status(p_smp)) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(ib_smp_get_status(p_smp)));
+		goto Exit2;
+	}
+
 	cl_plock_excl_acquire(sm->p_lock);
 	p_port = osm_get_port_by_guid(sm->p_subn, port_guid);
 	if (!p_port) {
@@ -149,5 +156,6 @@ void osm_vla_rcv_process(IN void *context, IN void *data)
 Exit:
 	cl_plock_release(sm->p_lock);
 
+Exit2:
 	OSM_LOG_EXIT(sm->p_log);
 }
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
