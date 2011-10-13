From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: saquery: use ib-node-name-map file
Date: Wed, 12 Oct 2011 17:02:17 -0700
Message-ID: <20111012170217.fa4446c7.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 man/saquery.8 |    7 +++++++
 src/saquery.c |   26 +++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/man/saquery.8 b/man/saquery.8
index 921fd5a..6ae7425 100644
--- a/man/saquery.8
+++ b/man/saquery.8
@@ -125,6 +125,13 @@ enable debugging
 \fB\-h\fR
 show help
 
+.SH FILES
+
+ib-node-name-map -- see ibnetdiscover for more information
+
+The node name map is used to specify user friendly names for nodes in the
+output.  Node GUIDs are used to perform the lookup.
+
 .SH DEPENDENCIES
 
 OpenSM (or other running SM/SA), libosmcomp, libibumad, libibmad
diff --git a/src/saquery.c b/src/saquery.c
index bdf5e9a..e29a1d0 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -134,16 +134,24 @@ static void print_node_desc(ib_node_record_t * node_record)
 {
 	ib_node_info_t *p_ni = &(node_record->node_info);
 	ib_node_desc_t *p_nd = &(node_record->node_desc);
+	char *name;
 
-	if (p_ni->node_type == IB_NODE_TYPE_CA)
-		printf("%6d  \"%s\"\n", cl_ntoh16(node_record->lid),
-		       clean_nodedesc((char *)p_nd->description));
+	if (p_ni->node_type == IB_NODE_TYPE_CA) {
+		name = remap_node_name(node_name_map,
+					node_record->node_info.node_guid,
+					(char *)p_nd->description);
+		printf("%6d  \"%s\"\n", cl_ntoh16(node_record->lid), name);
+		free(name);
+	}
 }
 
 static void dump_node_record(void *data)
 {
 	ib_node_record_t *nr = data;
 	ib_node_info_t *ni = &nr->node_info;
+	char *name = remap_node_name(node_name_map,
+				       cl_ntoh64(ni->node_guid),
+				       (char *)nr->node_desc.description);
 
 	printf("NodeRecord dump:\n"
 	       "\t\tlid.....................0x%X\n"
@@ -169,7 +177,9 @@ static void dump_node_record(void *data)
 	       cl_ntoh16(ni->device_id), cl_ntoh32(ni->revision),
 	       ib_node_info_get_local_port_num(ni),
 	       cl_ntoh32(ib_node_info_get_vendor_id(ni)),
-	       clean_nodedesc((char *)nr->node_desc.description));
+	       name);
+
+	free(name);
 }
 
 static void print_node_record(ib_node_record_t * node_record)
@@ -361,7 +371,7 @@ static void dump_multicast_member_record(ib_member_rec_t *p_mcmr,
 	char gid_str2[INET6_ADDRSTRLEN];
 	uint16_t mlid = cl_ntoh16(p_mcmr->mlid);
 	unsigned i = 0;
-	char *node_name = "<unknown>";
+	char *node_name = strdup("<unknown>");
 
 	/* go through the node records searching for a port guid which matches
 	 * this port gid interface id.
@@ -371,8 +381,9 @@ static void dump_multicast_member_record(ib_member_rec_t *p_mcmr,
 		ib_node_record_t *nr = sa_get_query_rec(nr_result->p_result_madw, i);
 		if (nr->node_info.port_guid ==
 		    p_mcmr->port_gid.unicast.interface_id) {
-			node_name =
-			    clean_nodedesc((char *)nr->node_desc.description);
+			node_name = remap_node_name(node_name_map,
+						nr->node_info.node_guid,
+						(char *)nr->node_desc.description);
 			break;
 		}
 	}
@@ -397,6 +408,7 @@ static void dump_multicast_member_record(ib_member_rec_t *p_mcmr,
 				 gid_str2, sizeof gid_str2),
 		       p_mcmr->scope_state, p_mcmr->proxy_join, node_name);
 	}
+	free(node_name);
 }
 
 static void dump_service_record(void *data)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
