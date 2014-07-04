From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2 opensm] Shorten long lines while calculating SA rate
Date: Fri, 04 Jul 2014 11:24:27 -0400
Message-ID: <53B6C72B.1090702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_port_info_rcv.c       |    5 +++--
 opensm/osm_sa_mcmember_record.c  |   15 ++++++++++-----
 opensm/osm_sa_multipath_record.c |   23 ++++++++++++-----------
 opensm/osm_sa_path_record.c      |   23 ++++++++++++-----------
 4 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index 9707496..4d42470 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -85,6 +85,7 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 	osm_madw_context_t context;
 	ib_api_status_t status;
 	ib_net64_t port_guid;
+	int extended;
 	uint8_t rate, mtu, mpb;
 	unsigned data_vls;
 	cl_qmap_t *p_sm_tbl;
@@ -106,8 +107,8 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 			sm->p_subn->min_ca_mtu = mtu;
 		}
 
-		rate = ib_port_info_compute_rate(p_pi,
-						 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+		extended = p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
+		rate = ib_port_info_compute_rate(p_pi, extended);
 		if (rate < sm->p_subn->min_ca_rate) {
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 				"Setting endport minimal rate to:%u defined by port:0x%"
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index afc795f..7e18e46 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -334,6 +334,7 @@ static boolean_t validate_port_caps(osm_log_t * p_log,
 	uint8_t mtu_mgrp;
 	uint8_t rate_required;
 	uint8_t rate_mgrp;
+	int extended;
 
 	mtu_required = ib_port_info_get_mtu_cap(&p_physp->port_info);
 	mtu_mgrp = (uint8_t) (p_mgrp->mcmember_rec.mtu & 0x3F);
@@ -345,8 +346,8 @@ static boolean_t validate_port_caps(osm_log_t * p_log,
 	}
 
 	p_pi = &p_physp->port_info;
-	rate_required = ib_port_info_compute_rate(p_pi,
-						  p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+	extended = p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
+	rate_required = ib_port_info_compute_rate(p_pi, extended);
 	rate_mgrp = (uint8_t) (p_mgrp->mcmember_rec.rate & 0x3F);
 	if (ib_path_compare_rates(rate_required, rate_mgrp) < 0) {
 		OSM_LOG(p_log, OSM_LOG_VERBOSE,
@@ -652,6 +653,7 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 	uint8_t rate_required, rate, port_rate;
 	const ib_port_info_t *p_pi;
 	osm_log_t *p_log = sa->p_log;
+	int extended;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -715,9 +717,12 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 	}
 	p_mcm_rec->mtu = (mtu_sel << 6) | mtu;
 
-	port_rate =
-	    p_physp ? ib_port_info_compute_rate(p_pi,
-						p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) : 0;
+	if (p_physp) {
+		extended = p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
+		port_rate = ib_port_info_compute_rate(p_pi, extended);
+	} else
+		port_rate = 0;
+
 	if (!(comp_mask & IB_MCR_COMPMASK_RATE)
 	    || !(comp_mask & IB_MCR_COMPMASK_RATE_SEL)
 	    || (rate_sel = (p_mcm_rec->rate >> 6)) == 3)
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 1f7ee86..1804943 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -165,6 +165,7 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 	uint8_t i;
 	osm_qos_level_t *p_qos_level = NULL;
 	uint16_t valid_sl_mask = 0xffff;
+	int extended, p0_extended;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -176,8 +177,8 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 	p_pi = &p_physp->port_info;
 
 	mtu = ib_port_info_get_mtu_cap(p_pi);
-	rate = ib_port_info_compute_rate(p_pi,
-					 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+	extended = p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
+	rate = ib_port_info_compute_rate(p_pi, extended);
 
 	/*
 	   Mellanox Tavor device performance is better using 1K MTU.
@@ -353,11 +354,11 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
 		p_pi0 = &p_physp0->port_info;
+		p0_extended = p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
 		if (ib_path_compare_rates(rate,
 					  ib_port_info_compute_rate(p_pi,
-								    p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
-			rate = ib_port_info_compute_rate(p_pi,
-							 p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+								    p0_extended)) > 0)
+			rate = ib_port_info_compute_rate(p_pi, p0_extended);
 
 		/*
 		   Continue with the egress port on this switch.
@@ -381,11 +382,11 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
 		p_pi0 = &p_physp0->port_info;
+		p0_extended = p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
 		if (ib_path_compare_rates(rate,
 					  ib_port_info_compute_rate(p_pi,
-								    p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
-			rate = ib_port_info_compute_rate(p_pi,
-							 p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+								    p0_extended)) > 0)
+			rate = ib_port_info_compute_rate(p_pi, p0_extended);
 
 		if (sa->p_subn->opt.qos) {
 			/*
@@ -417,11 +418,11 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 	if (mtu > ib_port_info_get_mtu_cap(p_pi))
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 
+	extended = p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
 	if (ib_path_compare_rates(rate,
 				  ib_port_info_compute_rate(p_pi,
-							    p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
-		rate = ib_port_info_compute_rate(p_pi,
-						 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+							    extended)) > 0)
+		rate = ib_port_info_compute_rate(p_pi, extended);
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Path min MTU = %u, min rate = %u\n", mtu, rate);
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 0d8a867..42af2b9 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -175,6 +175,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	osm_qos_level_t *p_qos_level = NULL;
 	uint16_t valid_sl_mask = 0xffff;
 	int hops = 0;
+	int extended, p0_extended;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -188,8 +189,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	p_re = p_osm->routing_engine_used;
 
 	mtu = ib_port_info_get_mtu_cap(p_pi);
-	rate = ib_port_info_compute_rate(p_pi,
-					 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+	extended = p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
+	rate = ib_port_info_compute_rate(p_pi, extended);
 
 	/*
 	   Mellanox Tavor device performance is better using 1K MTU.
@@ -347,11 +348,11 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
 		p_pi0 = &p_physp0->port_info;
+		p0_extended = p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
 		if (ib_path_compare_rates(rate,
 					  ib_port_info_compute_rate(p_pi,
-								    p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
-			rate = ib_port_info_compute_rate(p_pi,
-							 p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+								    p0_extended)) > 0)
+			rate = ib_port_info_compute_rate(p_pi, p0_extended);
 
 		/*
 		   Continue with the egress port on this switch.
@@ -375,11 +376,11 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
 		p_pi0 = &p_physp0->port_info;
+		p0_extended = p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
 		if (ib_path_compare_rates(rate,
 					  ib_port_info_compute_rate(p_pi,
-								    p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
-			rate = ib_port_info_compute_rate(p_pi,
-							 p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+								    p0_extended)) > 0)
+			rate = ib_port_info_compute_rate(p_pi, p0_extended);
 
 		if (sa->p_subn->opt.qos) {
 			/*
@@ -431,11 +432,11 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	if (mtu > ib_port_info_get_mtu_cap(p_pi))
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 
+	extended = p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
 	if (ib_path_compare_rates(rate,
 				  ib_port_info_compute_rate(p_pi,
-							    p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)) > 0)
-		rate = ib_port_info_compute_rate(p_pi,
-						 p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS);
+							    extended)) > 0)
+		rate = ib_port_info_compute_rate(p_pi, extended);
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Path min MTU = %u, min rate = %u\n", mtu, rate);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
