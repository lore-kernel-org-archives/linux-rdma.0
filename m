From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2 opensm] Add option to disable M_Key lookup
Date: Tue, 27 Aug 2013 08:58:29 -0400
Message-ID: <521CA275.9070006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

M_Key lookup can be time consuming. This patch adds an option to
disable M_Key lookup upon SMP send.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_subnet.h |    1 +
 opensm/osm_req.c            |    6 ++++--
 opensm/osm_subnet.c         |    5 +++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 0256230..4042f9b 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -251,6 +251,7 @@ typedef struct osm_subn_opt {
 	ib_net64_t subnet_prefix;
 	ib_net16_t m_key_lease_period;
 	uint8_t m_key_protect_bits;
+	boolean_t m_key_lookup;
 	uint32_t sweep_interval;
 	uint32_t max_wire_smps;
 	uint32_t max_wire_smps2;
diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index fe62aab..7b68411 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -192,7 +192,8 @@ ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 		tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id)
 							 & (uint64_t)(0xFFFFFFFF));
 
-	m_key = req_determine_mkey(sm, p_path);
+	m_key = (sm->p_subn->opt.m_key_lookup == TRUE) ?
+		req_determine_mkey(sm, p_path) : sm->p_subn->opt.m_key;
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 		"Getting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64
@@ -268,7 +269,8 @@ osm_madw_t *osm_prepare_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_pat
 		tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id)
 							 & (uint64_t)(0xFFFFFFFF));
 
-	m_key = req_determine_mkey(sm, p_path);
+	m_key = (sm->p_subn->opt.m_key_lookup == TRUE) ?
+		req_determine_mkey(sm, p_path) : sm->p_subn->opt.m_key;
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 		"Setting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 3971e96..a0c9dc4 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -764,6 +764,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "subnet_prefix", OPT_OFFSET(subnet_prefix), opts_parse_net64, NULL, 1 },
 	{ "m_key_lease_period", OPT_OFFSET(m_key_lease_period), opts_parse_net16, NULL, 1 },
 	{ "m_key_protection_level", OPT_OFFSET(m_key_protect_bits), opts_parse_uint8, NULL, 1 },
+	{ "m_key_lookup", OPT_OFFSET(m_key_lookup), opts_parse_boolean, NULL, 1 },
 	{ "sweep_interval", OPT_OFFSET(sweep_interval), opts_parse_uint32, NULL, 1 },
 	{ "max_wire_smps", OPT_OFFSET(max_wire_smps), opts_parse_uint32, NULL, 1 },
 	{ "max_wire_smps2", OPT_OFFSET(max_wire_smps2), opts_parse_uint32, NULL, 1 },
@@ -1644,6 +1645,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->subnet_prefix = IB_DEFAULT_SUBNET_PREFIX;
 	p_opt->m_key_lease_period = 0;
 	p_opt->m_key_protect_bits = 0;
+	p_opt->m_key_lookup = TRUE;
 	p_opt->sweep_interval = OSM_DEFAULT_SWEEP_INTERVAL_SECS;
 	p_opt->max_wire_smps = OSM_DEFAULT_SMP_MAX_ON_WIRE;
 	p_opt->max_wire_smps2 = p_opt->max_wire_smps;
@@ -2614,6 +2616,8 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"m_key_lease_period %u\n\n"
 		"# The protection level used for the M_Key on this subnet\n"
 		"m_key_protection_level %u\n\n"
+		"# If FALSE, SM won't try to determine the m_key of unknown ports\n"
+		"m_key_lookup %s\n\n"
 		"# SM_Key value of the SM used for SM authentication\n"
 		"sm_key 0x%016" PRIx64 "\n\n"
 		"# SM_Key value to qualify rcv SA queries as 'trusted'\n"
@@ -2696,6 +2700,7 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		cl_ntoh64(p_opts->m_key),
 		cl_ntoh16(p_opts->m_key_lease_period),
 		p_opts->m_key_protect_bits,
+		p_opts->m_key_lookup ? "TRUE" : "FALSE",
 		cl_ntoh64(p_opts->sm_key),
 		cl_ntoh64(p_opts->sa_key),
 		cl_ntoh64(p_opts->subnet_prefix),
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
