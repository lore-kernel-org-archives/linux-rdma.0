From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors.c: use common node_name
Date: Fri, 23 Oct 2009 18:34:30 +0200
Message-ID: <20091023163430.GC718@me>
References: <20090924235011.a9a16022.weiny2@llnl.gov>
 <f0e08f230909250707t36c1ebc4od5df33e36f6cd38a@mail.gmail.com>
 <20090925093358.f9f747d4.weiny2@llnl.gov>
 <20091023163337.GB718@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091023163337.GB718@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Get common node_name string using remap_node_name() and use it over
reporting functions - in this way simplify the code, avoid multiple
remap_node searches and fix minor memory leaks.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/ibqueryerrors.c |   48 ++++++++++++---------------------
 1 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index fdd9246..0842eb3 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -113,7 +113,7 @@ static void get_msg(char *width_msg, char *speed_msg, int msg_size,
 				      buf, 64, &max_speed));
 }
 
-static void print_port_config(ibnd_node_t * node, int portnum)
+static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 {
 	char width[64], speed[64], state[64], physstate[64];
 	char remote_str[256];
@@ -145,10 +145,6 @@ static void print_port_config(ibnd_node_t * node, int portnum)
 		 mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64, &iphystate));
 
 	if (port->remoteport) {
-		char *remap =
-		    remap_node_name(node_name_map, port->remoteport->node->guid,
-				    port->remoteport->node->nodedesc);
-
 		if (port->remoteport->ext_portnum)
 			snprintf(ext_port_str, 256, "%d",
 				 port->remoteport->ext_portnum);
@@ -162,9 +158,8 @@ static void print_port_config(ibnd_node_t * node, int portnum)
 			 port->remoteport->node->guid,
 			 port->remoteport->base_lid ? port->remoteport->
 			 base_lid : port->remoteport->node->smalid,
-			 port->remoteport->portnum, ext_port_str, remap,
+			 port->remoteport->portnum, ext_port_str, node_name,
 			 width_msg, speed_msg);
-		free(remap);
 	} else
 		snprintf(remote_str, 256, "           [  ] \"\" ( )\n");
 
@@ -203,8 +198,8 @@ static void report_suppressed(void)
 	}
 }
 
-static void print_results(ibnd_node_t * node, uint8_t * pc, int portnum,
-			  int *header_printed)
+static void print_results(char *node_name, ibnd_node_t * node, uint8_t * pc,
+			  int portnum, int *header_printed)
 {
 	char buf[1024];
 	char *str = buf;
@@ -245,23 +240,19 @@ static void print_results(ibnd_node_t * node, uint8_t * pc, int portnum,
 			}
 
 		if (!*header_printed) {
-			char *nodename =
-			    remap_node_name(node_name_map, node->guid,
-					    node->nodedesc);
 			printf("Errors for 0x%" PRIx64 " \"%s\"\n", node->guid,
-			       nodename);
+			       node_name);
 			*header_printed = 1;
-			free(nodename);
 		}
 
 		printf("   GUID 0x%" PRIx64 " port %d:%s\n", node->guid,
 		       portnum, str);
 		if (port_config)
-			print_port_config(node, portnum);
+			print_port_config(node_name, node, portnum);
 	}
 }
 
-static int query_cap_mask(ib_portid_t *portid, ibnd_node_t * node, int portnum,
+static int query_cap_mask(ib_portid_t *portid, char *node_name, int portnum,
 			  uint16_t * cap_mask)
 {
 	uint8_t pc[1024];
@@ -271,9 +262,7 @@ static int query_cap_mask(ib_portid_t *portid, ibnd_node_t * node, int portnum,
 	if (!pma_query_via(pc, portid, portnum, ibd_timeout, CLASS_PORT_INFO,
 			   ibmad_port)) {
 		IBWARN("classportinfo query failed on %s, %s port %d",
-		       remap_node_name(node_name_map, node->guid,
-				       node->nodedesc), portid2str(portid),
-		       portnum);
+		       node_name, portid2str(portid), portnum);
 		return -1;
 	}
 
@@ -284,30 +273,25 @@ static int query_cap_mask(ib_portid_t *portid, ibnd_node_t * node, int portnum,
 	return 0;
 }
 
-static void print_port(ib_portid_t * portid, uint16_t cap_mask,
+static void print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
 		       ibnd_node_t * node, int portnum, int *header_printed)
 {
 	uint8_t pc[1024];
-	char *nodename =
-	    remap_node_name(node_name_map, node->guid, node->nodedesc);
 
 	memset(pc, 0, 1024);
 
 	if (!pma_query_via(pc, portid, portnum, ibd_timeout,
 			   IB_GSI_PORT_COUNTERS, ibmad_port)) {
 		IBWARN("IB_GSI_PORT_COUNTERS query failed on %s, %s port %d\n",
-		       nodename, portid2str(portid), portnum);
-		goto cleanup;
+		       node_name, portid2str(portid), portnum);
+		return;
 	}
 	if (!(cap_mask & 0x1000)) {
 		/* if PortCounters:PortXmitWait not suppported clear this counter */
 		uint32_t foo = 0;
 		mad_encode_field(pc, IB_PC_XMT_WAIT_F, &foo);
 	}
-	print_results(node, pc, portnum, header_printed);
-
-cleanup:
-	free(nodename);
+	print_results(node_name, node, pc, portnum, header_printed);
 }
 
 static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
@@ -365,6 +349,8 @@ void print_node(ibnd_node_t * node, void *user_data)
 		startport = 0;
 
 	for (p = startport; p <= node->numports; p++) {
+		char *node_name = remap_node_name(node_name_map, node->guid,
+						  node->nodedesc);
 		if (node->ports[p]) {
 			if (node->type == IB_NODE_SWITCH)
 				ib_portid_set(&portid, node->smalid, 0, 0);
@@ -372,16 +358,18 @@ void print_node(ibnd_node_t * node, void *user_data)
 				ib_portid_set(&portid, node->ports[p]->base_lid,
 					      0, 0);
 
-			if (query_cap_mask(&portid, node, p, &cap_mask) < 0)
+			if (query_cap_mask(&portid, node_name, p, &cap_mask) < 0)
 				continue;
 
 			if (cap_mask & 0x100)
 				all_port_sup = 1;
 
-			print_port(&portid, cap_mask, node, p, &header_printed);
+			print_port(&portid, cap_mask, node_name, node, p,
+				   &header_printed);
 			if (!all_port_sup)
 				clear_port(&portid, cap_mask, node, p);
 		}
+		free(node_name);
 	}
 
 	if (all_port_sup)
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
