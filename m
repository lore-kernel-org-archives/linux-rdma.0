From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fix some obvious -Wsign-compare warnings
Date: Thu, 1 Oct 2009 21:25:36 +0200
Message-ID: <20091001192536.GY17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fix some obvious (not all) compile warnings generated when
-Wsign-compare flag is used.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/main.c             |    2 +-
 opensm/opensm/osm_console.c      |    4 ++--
 opensm/opensm/osm_helper.c       |    3 ++-
 opensm/opensm/osm_mcast_mgr.c    |    2 +-
 opensm/opensm/osm_qos_parser_y.y |    2 +-
 opensm/opensm/osm_switch.c       |    4 ++--
 opensm/opensm/osm_ucast_ftree.c  |   10 ++++------
 opensm/opensm/osm_ucast_lash.c   |    2 +-
 8 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index 36a0cc6..2e28c83 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -541,7 +541,7 @@ int main(int argc, char *argv[])
 	uint32_t temp, dbg_lvl;
 	boolean_t run_once_flag = FALSE;
 	int32_t vendor_debug = 0;
-	uint32_t next_option;
+	int next_option;
 	char *conf_template = NULL, *config_file = NULL;
 	uint32_t val;
 	const char *const short_option =
diff --git a/opensm/opensm/osm_console.c b/opensm/opensm/osm_console.c
index d351261..db9a49d 100644
--- a/opensm/opensm/osm_console.c
+++ b/opensm/opensm/osm_console.c
@@ -492,7 +492,7 @@ static void logflush_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 
 static void querylid_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 {
-	int p = 0;
+	unsigned int p = 0;
 	uint16_t lid = 0;
 	osm_port_t *p_port = NULL;
 	char *p_cmd = next_token(p_last);
@@ -528,7 +528,7 @@ static void querylid_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 		p = 1;
 	for ( /* see above */ ; p < p_port->p_node->physp_tbl_size; p++) {
 		fprintf(out,
-			"   Port %d health       : %s\n",
+			"   Port %u health       : %s\n",
 			p,
 			p_port->p_node->physp_table[p].
 			healthy ? "OK" : "ERROR");
diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index ea9e21f..6b1f55f 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -442,7 +442,8 @@ static const char *__ib_sa_attr_str[] = {
 static int sprint_uint8_arr(char *buf, size_t size,
 			    const uint8_t * arr, size_t len)
 {
-	int i, n;
+	int n;
+	unsigned int i;
 	for (i = 0, n = 0; i < len; i++) {
 		n += snprintf(buf + n, size - n, "%s%u", i == 0 ? "" : ",",
 			      arr[i]);
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 6f51404..aaab91a 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -1004,7 +1004,7 @@ static int mcast_mgr_set_mftables(osm_sm_t * sm)
 	osm_switch_t *p_sw;
 	osm_mcast_tbl_t *p_tbl;
 	int block_notdone, ret = 0;
-	int16_t block_num, max_block = -1;
+	uint16_t block_num, max_block = -1;
 
 	p_sw = (osm_switch_t *) cl_qmap_head(p_sw_tbl);
 	while (p_sw != (osm_switch_t *) cl_qmap_end(p_sw_tbl)) {
diff --git a/opensm/opensm/osm_qos_parser_y.y b/opensm/opensm/osm_qos_parser_y.y
index 571082b..7a2ce13 100644
--- a/opensm/opensm/osm_qos_parser_y.y
+++ b/opensm/opensm/osm_qos_parser_y.y
@@ -2394,7 +2394,7 @@ static void yyerror(const char *format, ...)
 
 static char * __parser_strip_white(char * str)
 {
-   int i;
+   unsigned int i;
    for (i = (strlen(str)-1); i >= 0; i--)
    {
       if (isspace(str[i]))
diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
index ce1ca63..8a83523 100644
--- a/opensm/opensm/osm_switch.c
+++ b/opensm/opensm/osm_switch.c
@@ -193,7 +193,7 @@ osm_switch_find_guid_common(IN const osm_switch_t * const p_sw,
 	osm_node_t *p_rem_node;
 	uint64_t sys_guid;
 	uint64_t node_guid;
-	int i;
+	unsigned int i;
 
 	CL_ASSERT(p_sw);
 
@@ -406,7 +406,7 @@ osm_switch_recommend_path(IN const osm_switch_t * const p_sw,
 			if (routing_for_lmc) {
 				struct osm_remote_guids_count *r = p_port->priv;
 				uint8_t rem_port = osm_physp_get_port_num(p_rem_physp);
-				int j;
+				unsigned int j;
 
 				for (j = 0; j < r->count; j++) {
 					p_remote_guid = &r->guids[j];
diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
index 0ec0341..1defd95 100644
--- a/opensm/opensm/osm_ucast_ftree.c
+++ b/opensm/opensm/osm_ucast_ftree.c
@@ -2710,8 +2710,7 @@ static void fabric_route_to_cns(IN ftree_fabric_t * p_ftree)
 	ftree_port_group_t *p_leaf_port_group;
 	ftree_port_group_t *p_hca_port_group;
 	ftree_port_t *p_port;
-	uint32_t i;
-	uint32_t j;
+	unsigned int i, j;
 	uint16_t hca_lid;
 	unsigned routed_targets_on_leaf;
 
@@ -2788,10 +2787,9 @@ static void fabric_route_to_cns(IN ftree_fabric_t * p_ftree)
 				"Routing %u dummy CAs\n",
 				p_ftree->max_cn_per_leaf -
 				p_sw->down_port_groups_num);
-			for (j = 0;
-			     ((int)j) <
-			     (p_ftree->max_cn_per_leaf -
-			      routed_targets_on_leaf); j++) {
+			for (j = 0; j <
+			     p_ftree->max_cn_per_leaf - routed_targets_on_leaf;
+			     j++) {
 				/* assign downgoing ports by stepping up */
 				fabric_route_downgoing_by_going_up(p_ftree, p_sw,	/* local switch - used as a route-downgoing alg. start point */
 								   NULL,	/* prev. position switch */
diff --git a/opensm/opensm/osm_ucast_lash.c b/opensm/opensm/osm_ucast_lash.c
index 63300b5..8b0a190 100644
--- a/opensm/opensm/osm_ucast_lash.c
+++ b/opensm/opensm/osm_ucast_lash.c
@@ -70,7 +70,7 @@ static void connect_switches(lash_t * p_lash, int sw1, int sw2, int phy_port_1)
 	mesh_node_t *node = s1->node;
 	switch_t *s2;
 	link_t *l;
-	int i;
+	unsigned int i;
 
 	/*
 	 * if doing mesh analysis:
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
