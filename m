From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Add new option for guid_routing_order_no_scatter
Date: Mon, 13 Jan 2014 13:45:09 -0500
Message-ID: <52D43435.9030807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

It avoids using scatter option for guids defined in guid_routing_order file

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_port.h   |    1 +
 include/opensm/osm_subnet.h |    1 +
 opensm/main.c               |    6 ++++++
 opensm/osm_subnet.c         |    2 ++
 opensm/osm_ucast_mgr.c      |    5 ++++-
 5 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/opensm/osm_port.h b/include/opensm/osm_port.h
index 73f7663..206c4a9 100644
--- a/include/opensm/osm_port.h
+++ b/include/opensm/osm_port.h
@@ -1194,6 +1194,7 @@ typedef struct osm_port {
 	osm_physp_t *p_physp;
 	cl_qlist_t mcm_list;
 	int flag;
+	int use_scatter;
 	unsigned int cc_timeout_count;
 	int cc_unavailable_flag;
 	void *priv;
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 606c63e..03f116e 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -317,6 +317,7 @@ typedef struct osm_subn_opt {
 	uint16_t max_reverse_hops;
 	char *ids_guid_file;
 	char *guid_routing_order_file;
+	boolean_t guid_routing_order_no_scatter;
 	char *sa_db_file;
 	boolean_t sa_db_dump;
 	char *torus_conf_file;
diff --git a/opensm/main.c b/opensm/main.c
index e92a6c2..6b5cae7 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -369,6 +369,8 @@ static void show_usage(void)
 	printf("--consolidate_ipv6_snm_req\n"
 	       "          Use shared MLID for IPv6 Solicited Node Multicast groups\n"
 	       "          per MGID scope and P_Key.\n\n");
+	printf("--guid_routing_order_no_scatter\n"
+	       "          Don't use scatter for ports defined in guid_routing_order file\n\n");
 	printf("--log_prefix <prefix text>\n"
 	       "          Prefix to syslog messages from OpenSM.\n\n");
 	printf("--verbose, -v\n"
@@ -687,6 +689,7 @@ int main(int argc, char *argv[])
 		{"retries", 1, NULL, 8},
 		{"log_prefix", 1, NULL, 9},
 		{"torus_config", 1, NULL, 10},
+		{"guid_routing_order_no_scatter", 0, NULL, 13},
 		{NULL, 0, NULL, 0}	/* Required at the end of the array */
 	};
 
@@ -1133,6 +1136,9 @@ int main(int argc, char *argv[])
 			SET_STR_OPT(opt.torus_conf_file, optarg);
 			printf("Torus-2QoS config file = %s\n", opt.torus_conf_file);
 			break;
+		case 13:
+			opt.guid_routing_order_no_scatter = TRUE;
+			break;
 		case 'h':
 		case '?':
 		case ':':
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 59a988f..7bc9676 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -767,6 +767,7 @@ static const opt_rec_t opt_tbl[] = {
 	{ "max_reverse_hops", OPT_OFFSET(max_reverse_hops), opts_parse_uint16, NULL, 0 },
 	{ "ids_guid_file", OPT_OFFSET(ids_guid_file), opts_parse_charp, NULL, 0 },
 	{ "guid_routing_order_file", OPT_OFFSET(guid_routing_order_file), opts_parse_charp, NULL, 0 },
+	{ "guid_routing_order_no_scatter", OPT_OFFSET(guid_routing_order_no_scatter), opts_parse_boolean, NULL, 0 },
 	{ "sa_db_file", OPT_OFFSET(sa_db_file), opts_parse_charp, NULL, 0 },
 	{ "sa_db_dump", OPT_OFFSET(sa_db_dump), opts_parse_boolean, NULL, 1 },
 	{ "torus_config", OPT_OFFSET(torus_conf_file), opts_parse_charp, NULL, 1 },
@@ -1535,6 +1536,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->max_reverse_hops = 0;
 	p_opt->ids_guid_file = NULL;
 	p_opt->guid_routing_order_file = NULL;
+	p_opt->guid_routing_order_no_scatter = FALSE;
 	p_opt->sa_db_file = NULL;
 	p_opt->sa_db_dump = FALSE;
 	p_opt->torus_conf_file = strdup(OSM_DEFAULT_TORUS_CONF_FILE);
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 4950edc..f53e288 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -259,7 +259,7 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
 					 p_mgr->p_subn->opt.lmc,
 					 p_mgr->is_dor,
 					 p_mgr->p_subn->opt.port_shifting,
-					 p_mgr->p_subn->opt.scatter_ports);
+					 p_port->use_scatter);
 
 	if (port == OSM_NO_PATH) {
 		/* do not try to overwrite the ppro of non existing port ... */
@@ -729,6 +729,7 @@ static int add_guid_to_order_list(void *ctx, uint64_t guid, char *p)
 
 	cl_qlist_insert_tail(&m->port_order_list, &port->list_item);
 	port->flag = 1;
+	port->use_scatter =  (m->p_subn->opt.guid_routing_order_no_scatter == TRUE) ? 0 : m->p_subn->opt.scatter_ports;
 
 	return 0;
 }
@@ -738,9 +739,10 @@ static void add_port_to_order_list(cl_map_item_t * p_map_item, void *ctx)
 	osm_port_t *port = (osm_port_t *) p_map_item;
 	osm_ucast_mgr_t *m = ctx;
 
-	if (!port->flag)
+	if (!port->flag) {
+		port->use_scatter = m->p_subn->opt.scatter_ports;
 		cl_qlist_insert_tail(&m->port_order_list, &port->list_item);
-	else
+	} else
 		port->flag = 0;
 }
 
@@ -804,6 +806,7 @@ static void add_sw_endports_to_order_list(osm_switch_t * sw,
 			cl_qlist_insert_tail(&m->port_order_list,
 					     &port->list_item);
 			port->flag = 1;
+			port->use_scatter = m->p_subn->opt.scatter_ports;
 		}
 	}
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
