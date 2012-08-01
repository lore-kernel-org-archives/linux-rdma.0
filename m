From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 4/9 v2] opensm: Add support for setting mkey protection levels
Date: Wed,  1 Aug 2012 07:52:30 -0700
Message-ID: <1343832755-26753-4-git-send-email-foraker1@llnl.gov>
References: <1343832537.26423.8.camel@auk75.llnl.gov>
 <1343832755-26753-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343832755-26753-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, alexne-LTKPlh9/A5tDPfheJLI6IQ@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The M_Key Protection Level for the subnet may now be set
in the config file by specifying a numeric value for
m_key_protection_level (defaults to 0).

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 include/opensm/osm_subnet.h |    1 +
 opensm/osm_lid_mgr.c        |   21 +++++++++++----------
 opensm/osm_link_mgr.c       |    2 +-
 opensm/osm_subnet.c         |    5 +++++
 4 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 0061f3a..ee97f14 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -250,6 +250,7 @@ typedef struct osm_subn_opt {
 	ib_net64_t sa_key;
 	ib_net64_t subnet_prefix;
 	ib_net16_t m_key_lease_period;
+	uint8_t m_key_protect_bits;
 	uint32_t sweep_interval;
 	uint32_t max_wire_smps;
 	uint32_t max_wire_smps2;
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index 7799ee3..aa48eab 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -889,6 +889,11 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 		   sizeof(p_pi->m_key_lease_period)))
 		send_set = TRUE;
 
+	p_pi->mkey_lmc = 0;
+	ib_port_info_set_mpb(p_pi, p_mgr->p_subn->opt.m_key_protect_bits);
+	if (ib_port_info_get_mpb(p_pi) != ib_port_info_get_mpb(p_old_pi))
+		send_set = TRUE;
+
 	/*
 	   we want to set the timeout for both the switch port 0
 	   and the CA ports
@@ -910,12 +915,10 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 			   sizeof(p_pi->link_width_enabled)))
 			send_set = TRUE;
 
-		/* M_KeyProtectBits are currently always zero */
-		p_pi->mkey_lmc = p_mgr->p_subn->opt.lmc;
+		/* p_pi->mkey_lmc is initialized earlier */
+		ib_port_info_set_lmc(p_pi, p_mgr->p_subn->opt.lmc);
 		if (ib_port_info_get_lmc(p_pi) !=
-		    ib_port_info_get_lmc(p_old_pi) ||
-		    ib_port_info_get_mpb(p_pi) !=
-		    ib_port_info_get_mpb(p_old_pi))
+		    ib_port_info_get_lmc(p_old_pi))
 			send_set = TRUE;
 
 		/* calc new op_vls and mtu */
@@ -996,12 +999,10 @@ static int lid_mgr_set_physp_pi(IN osm_lid_mgr_t * p_mgr,
 
 		/* Determine if enhanced switch port 0 and if so set LMC */
 		if (osm_switch_sp0_is_lmc_capable(p_node->sw, p_mgr->p_subn)) {
-			/* M_KeyProtectBits are currently always zero */
-			p_pi->mkey_lmc = p_mgr->p_subn->opt.lmc;
+			/* p_pi->mkey_lmc is initialized earlier */
+			ib_port_info_set_lmc(p_pi, p_mgr->p_subn->opt.lmc);
 			if (ib_port_info_get_lmc(p_pi) !=
-			    ib_port_info_get_lmc(p_old_pi) ||
-			    ib_port_info_get_mpb(p_pi) !=
-			    ib_port_info_get_mpb(p_old_pi))
+			    ib_port_info_get_lmc(p_old_pi))
 				send_set = TRUE;
 		}
 	}
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index b700977..7799c46 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -240,8 +240,8 @@ static int link_mgr_set_physp_pi(osm_sm_t * sm, IN osm_physp_t * p_physp,
 				   sizeof(p_pi->m_key_lease_period)))
 				send_set = TRUE;
 
-			/* M_KeyProtectBits are currently always zero */
 			p_pi->mkey_lmc = 0;
+			ib_port_info_set_mpb(p_pi, sm->p_subn->opt.m_key_protect_bits);
 			if (esp0 == FALSE || sm->p_subn->opt.lmc_esp0)
 				ib_port_info_set_lmc(p_pi, sm->p_subn->opt.lmc);
 			if (ib_port_info_get_lmc(p_old_pi) !=
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 3e461f5..a4c5150 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -699,6 +699,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "sa_key", OPT_OFFSET(sa_key), opts_parse_net64, NULL, 1 },
 	{ "subnet_prefix", OPT_OFFSET(subnet_prefix), opts_parse_net64, NULL, 1 },
 	{ "m_key_lease_period", OPT_OFFSET(m_key_lease_period), opts_parse_net16, NULL, 1 },
+	{ "m_key_protection_level", OPT_OFFSET(m_key_protect_bits), opts_parse_uint8, NULL, 1 },
 	{ "sweep_interval", OPT_OFFSET(sweep_interval), opts_parse_uint32, NULL, 1 },
 	{ "max_wire_smps", OPT_OFFSET(max_wire_smps), opts_parse_uint32, NULL, 1 },
 	{ "max_wire_smps2", OPT_OFFSET(max_wire_smps2), opts_parse_uint32, NULL, 1 },
@@ -1318,6 +1319,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->sa_key = OSM_DEFAULT_SA_KEY;
 	p_opt->subnet_prefix = IB_DEFAULT_SUBNET_PREFIX;
 	p_opt->m_key_lease_period = 0;
+	p_opt->m_key_protect_bits = 0;
 	p_opt->sweep_interval = OSM_DEFAULT_SWEEP_INTERVAL_SECS;
 	p_opt->max_wire_smps = OSM_DEFAULT_SMP_MAX_ON_WIRE;
 	p_opt->max_wire_smps2 = p_opt->max_wire_smps;
@@ -2071,6 +2073,8 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		"m_key 0x%016" PRIx64 "\n\n"
 		"# The lease period used for the M_Key on this subnet in [sec]\n"
 		"m_key_lease_period %u\n\n"
+		"# The protection level used for the M_Key on this subnet\n"
+		"m_key_protection_level %u\n\n"
 		"# SM_Key value of the SM used for SM authentication\n"
 		"sm_key 0x%016" PRIx64 "\n\n"
 		"# SM_Key value to qualify rcv SA queries as 'trusted'\n"
@@ -2152,6 +2156,7 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		cl_ntoh64(p_opts->guid),
 		cl_ntoh64(p_opts->m_key),
 		cl_ntoh16(p_opts->m_key_lease_period),
+		p_opts->m_key_protect_bits,
 		cl_ntoh64(p_opts->sm_key),
 		cl_ntoh64(p_opts->sa_key),
 		cl_ntoh64(p_opts->subnet_prefix),
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
