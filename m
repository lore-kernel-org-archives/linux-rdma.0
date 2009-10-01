From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] typeof() not supported in Windows WDK compiler
Date: Thu, 1 Oct 2009 15:41:21 -0700
Message-ID: <DB05C7E7F5BE4BE585F311B2437350A5@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: 'Sasha Khapyorsky' <sashak@voltaire.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


Added Obj TypeOf argument to the Windows version of cl_item_obj() macro to compensate for missing typeof() operator.

Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/opensm/osm_drop_mgr.c b/opensm/opensm/osm_drop_mgr.c
index 4f98cc9..8fe5129 100644
--- a/opensm/opensm/osm_drop_mgr.c
+++ b/opensm/opensm/osm_drop_mgr.c
@@ -209,8 +209,13 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 	drop_mgr_clean_physp(sm, p_port->p_physp);
 
 	while (!cl_is_qlist_empty(&p_port->mcm_list)) {
+#ifndef __WIN__
 		mcm_port = cl_item_obj(cl_qlist_head(&p_port->mcm_list),
 				       mcm_port, list_item);
+#else
+		mcm_port = cl_item_obj(cl_qlist_head(&p_port->mcm_list),
+				       mcm_port, list_item, (osm_mcm_port_t*) );
+#endif
 		osm_mgrp_delete_port(sm->p_subn, sm->p_log, mcm_port->mgrp,
 				     p_port->guid);
 	}
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index 185c700..a260b8a 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -503,7 +503,11 @@ Exit:
 static void query_sm_info(cl_map_item_t * item, void *cxt)
 {
 	osm_madw_context_t context;
+#ifndef __WIN__
 	osm_remote_sm_t *r_sm = cl_item_obj(item, r_sm, map_item);
+#else
+	osm_remote_sm_t *r_sm = cl_item_obj(item, r_sm, map_item,(osm_remote_sm_t *));
+#endif
 	osm_sm_t *sm = cxt;
 	ib_api_status_t ret;
 
diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
index 39d825c..a1f5c72 100644
--- a/opensm/opensm/osm_ucast_mgr.c
+++ b/opensm/opensm/osm_ucast_mgr.c
@@ -388,7 +388,11 @@ static void ucast_mgr_process_tbl(IN cl_map_item_t * p_map_item,
 		cl_list_item_t *item;
 		for (item = cl_qlist_head(list); item != cl_qlist_end(list);
 		     item = cl_qlist_next(item)) {
+#ifndef __WIN__
 			osm_port_t *port = cl_item_obj(item, port, list_item);
+#else
+			osm_port_t *port = cl_item_obj(item, port, list_item,(osm_port_t*));
+#endif
 			ucast_mgr_process_port(p_mgr, p_sw, port, i);
 		}
 	}
