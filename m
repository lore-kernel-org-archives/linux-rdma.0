From: Jared Carr <jared.carr-Y2zl/4KMd60@public.gmane.org>
Subject: [PATCH] OpenSM - Reverse Sort Routing Order
Date: Wed, 23 Mar 2011 16:23:13 -0700
Message-ID: <20110324170633.5B8DF451AAE@cu0login3.emsl.pnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ken Schmidt <kenneth.schmidt-Y2zl/4KMd60@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adds the reverse_sort_routing_order configuration parameter.
This parameter provides a better balance in some fabrics which have a
non-constant oversubscription ratio and uplinks and CA nodes connected
to the same switch nodes.

In the default routing order the higher oversubscription ratio CA nodes
will be routed first causing the path count on the uplink switches to
favor the less connected Spine switch when the lower oversubscription
ratio CA nodes are routed (until path count balance is restored). The
end result is that certain single cables are utilized for a very high
percentage of traffic to a few nodes.

This patch duplicates functionality that can be obtained using the
guid_routing_order_file option. And potentially is only of use to a very
few clusters, Chinook being one of them.
---
 include/opensm/osm_base.h   |   11 +++++++++++
 include/opensm/osm_subnet.h |    1 +
 opensm/osm_subnet.c         |    7 +++++++
 opensm/osm_ucast_mgr.c      |    9 ++++++++-
 4 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/include/opensm/osm_base.h b/include/opensm/osm_base.h
index fa4c78d..9f3a091 100644
--- a/include/opensm/osm_base.h
+++ b/include/opensm/osm_base.h
@@ -158,6 +158,17 @@ BEGIN_C_DECLS
 */
 #define OSM_DEFAULT_SL 0
 /********/
+/****s* OpenSM: Base/OSM_DEFAULT_REVERSE_SORT_ROUTING_ORDER
+* NAME
+*	OSM_DEFAULT_REVERSE_SORT_ROUTING_ORDER
+*
+* DESCRIPTION
+*	Default Reverse Sort value used by OpenSM.
+*
+* SYNOPSIS
+*/
+#define OSM_DEFAULT_REVERSE_SORT_ROUTING_ORDER FALSE
+/********/
 /****s* OpenSM: Base/OSM_DEFAULT_SM_PRIORITY
 * NAME
 *	OSM_DEFAULT_SM_PRIORITY
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 42ae416..4c74e34 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -236,6 +236,7 @@ typedef struct osm_subn_opt {
 	struct osm_subn_opt *file_opts; /* used for update */
 	uint8_t lash_start_vl;			/* starting vl to use in lash */
 	uint8_t sm_sl;			/* which SL to use for SM/SA communication */
+	boolean_t reverse_sort_routing_order;
 } osm_subn_opt_t;
 /*
 * FIELDS
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 228418f..970a7f8 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -402,6 +402,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "lash_start_vl", OPT_OFFSET(lash_start_vl), opts_parse_uint8, NULL, 1 },
 	{ "sm_sl", OPT_OFFSET(sm_sl), opts_parse_uint8, NULL, 1 },
 	{ "log_prefix", OPT_OFFSET(log_prefix), opts_parse_charp, NULL, 1 },
+	{ "reverse_sort_routing_order", OPT_OFFSET(reverse_sort_routing_order), opts_parse_boolean, NULL, 1 },
 	{0}
 };
 
@@ -755,6 +756,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->lash_start_vl = 0;
 	p_opt->sm_sl = OSM_DEFAULT_SL;
 	p_opt->log_prefix = NULL;
+	p_opt->reverse_sort_routing_order = OSM_DEFAULT_REVERSE_SORT_ROUTING_ORDER;
 	subn_init_qos_options(&p_opt->qos_options, NULL);
 	subn_init_qos_options(&p_opt->qos_ca_options, NULL);
 	subn_init_qos_options(&p_opt->qos_sw0_options, NULL);
@@ -1371,6 +1373,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 		p_opts->dimn_ports_file ? p_opts->dimn_ports_file : null_str);
 
 	fprintf(out,
+		"# Reverse the normal order in which routes are assigned. \n"
+		"reverse_sort_routing_order %s\n\n",
+		p_opts->reverse_sort_routing_order ? "TRUE" : "FALSE");
+
+	fprintf(out,
 		"# Routing engine\n"
 		"# Multiple routing engines can be specified separated by\n"
 		"# commas so that specific ordering of routing algorithms will\n"
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 4019589..b1dc4e4 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -824,6 +824,10 @@ static int compar_sw_load(const void *s1, const void *s2)
 	return get_sw_endport_links(s2) - get_sw_endport_links(s1);
 }
 
+static int compar_sw_load_r(const void *s1, const void *s2) {
+	return compar_sw_load(s2, s1);
+}
+
 static void sort_ports_by_switch_load(osm_ucast_mgr_t * m)
 {
 	int i, num = cl_qmap_count(&m->p_subn->sw_guid_tbl);
@@ -840,7 +844,10 @@ static void sort_ports_by_switch_load(osm_ucast_mgr_t * m)
 	for (i = 0; i < num; i++)
 		sw_count_endport_links(s[i]);
 
-	qsort(s, num, sizeof(*s), compar_sw_load);
+	if (m->p_subn->opt.reverse_sort_routing_order == TRUE) {
+		qsort(s, num, sizeof(*s), compar_sw_load_r);
+	} else
+		qsort(s, num, sizeof(*s), compar_sw_load);
 
 	for (i = 0; i < num; i++)
 		add_sw_endports_to_order_list(s[i], m);
-- 
1.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
