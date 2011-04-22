From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Provide option to disable use of MulticastFDBTop
 even if advertised
Date: Fri, 22 Apr 2011 17:21:48 -0400
Message-ID: <4DB1F16C.6090907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Default is on; as this is a workaround for non compliance:
this feature is advertised but the SMA rejects sets of SwitchInfo that
actually set MFTTop.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index a9499dd..4bab8ee 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -171,6 +171,7 @@ typedef struct osm_subn_opt {
 	uint8_t leaf_head_of_queue_lifetime;
 	uint8_t local_phy_errors_threshold;
 	uint8_t overrun_errors_threshold;
+	boolean_t use_mfttop;
 	uint32_t sminfo_polling_timeout;
 	uint32_t polling_retry_number;
 	uint32_t max_msg_fifo_timeout;
diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index ea52bfe..e33c716 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -1041,7 +1041,8 @@ static void mcast_mgr_set_mfttop(IN osm_sm_t * sm, IN osm_switch_t * p_sw)
 	p_path = osm_physp_get_dr_path_ptr(p_physp);
 	p_tbl = osm_switch_get_mcast_tbl_ptr(p_sw);
 
-	if (p_physp->port_info.capability_mask & IB_PORT_CAP_HAS_MCAST_FDB_TOP) {
+	if (sm->p_subn->opt.use_mfttop &&
+	    p_physp->port_info.capability_mask & IB_PORT_CAP_HAS_MCAST_FDB_TOP) {
 		/*
 		   Set the top of the multicast forwarding table.
 		 */
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 84ac6ed..e4ea841 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -322,6 +322,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "leaf_head_of_queue_lifetime", OPT_OFFSET(leaf_head_of_queue_lifetime), opts_parse_uint8, NULL, 1 },
 	{ "local_phy_errors_threshold", OPT_OFFSET(local_phy_errors_threshold), opts_parse_uint8, NULL, 1 },
 	{ "overrun_errors_threshold", OPT_OFFSET(overrun_errors_threshold), opts_parse_uint8, NULL, 1 },
+	{ "use_mfttop", OPT_OFFSET(use_mfttop), opts_parse_boolean, NULL, 1},
 	{ "sminfo_polling_timeout", OPT_OFFSET(sminfo_polling_timeout), opts_parse_uint32, opts_setup_sminfo_polling_timeout, 1 },
 	{ "polling_retry_number", OPT_OFFSET(polling_retry_number), opts_parse_uint32, NULL, 1 },
 	{ "force_heavy_sweep", OPT_OFFSET(force_heavy_sweep), opts_parse_boolean, NULL, 1 },
@@ -703,6 +704,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	    OSM_DEFAULT_LEAF_HEAD_OF_QUEUE_LIFE;
 	p_opt->local_phy_errors_threshold = OSM_DEFAULT_ERROR_THRESHOLD;
 	p_opt->overrun_errors_threshold = OSM_DEFAULT_ERROR_THRESHOLD;
+	p_opt->use_mfttop = TRUE;
 	p_opt->sminfo_polling_timeout =
 	    OSM_SM_DEFAULT_POLLING_TIMEOUT_MILLISECS;
 	p_opt->polling_retry_number = OSM_SM_DEFAULT_POLLING_RETRY_NUMBER;
@@ -1313,7 +1315,9 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"# Threshold of local phy errors for sending Trap 129\n"
 		"local_phy_errors_threshold 0x%02x\n\n"
 		"# Threshold of credit overrun errors for sending Trap 130\n"
-		"overrun_errors_threshold 0x%02x\n\n",
+		"overrun_errors_threshold 0x%02x\n\n"
+		"# Use SwitchInfo:MulticastFDBTop if advertised in PortInfo:CapabilityMask\n"
+		"use_mfttop %s\n\n",
 		cl_ntoh64(p_opts->guid),
 		cl_ntoh64(p_opts->m_key),
 		cl_ntoh16(p_opts->m_key_lease_period),
@@ -1332,7 +1336,8 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->force_link_speed,
 		p_opts->subnet_timeout,
 		p_opts->local_phy_errors_threshold,
-		p_opts->overrun_errors_threshold);
+		p_opts->overrun_errors_threshold,
+		p_opts->use_mfttop ? "TRUE" : "FALSE");
 
 	fprintf(out,
 		"#\n# PARTITIONING OPTIONS\n#\n"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
