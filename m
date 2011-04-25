From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibnetdiscover: Make --ports option use
 remap_node_name()
Date: Mon, 25 Apr 2011 11:29:54 -0600
Message-ID: <1303752594-19381-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: weiny2-i2BcT+NCU+M@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marcus Epperson <mrepper-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Marcus Epperson <mrepper-4OHPYypu0djtX7QSmKvirg@public.gmane.org>

Signed-off-by: Marcus Epperson <mrepper-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 src/ibnetdiscover.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
index e081a36..fdbe3b5 100644
--- a/src/ibnetdiscover.c
+++ b/src/ibnetdiscover.c
@@ -574,6 +574,8 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
 {
 	int p = 0;
 	ibnd_port_t *port = NULL;
+	char *nodename = NULL;
+	char *rem_nodename = NULL;
 
 	/* for each port */
 	for (p = node->numports, port = node->ports[p]; p > 0;
@@ -585,6 +587,9 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
 		    mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
 		ispeed =
 		    mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+		nodename = remap_node_name(node_name_map,
+					   port->node->guid,
+					   port->node->nodedesc);
 		fprintf(stdout, "%2s %5d %2d 0x%016" PRIx64 " %s %s",
 			ports_nt_str_compat(node),
 			node->type ==
@@ -592,7 +597,10 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
 			port->portnum, port->guid,
 			dump_linkwidth_compat(iwidth),
 			dump_linkspeed_compat(ispeed));
-		if (port->remoteport)
+		if (port->remoteport) {
+			rem_nodename = remap_node_name(node_name_map,
+					      port->remoteport->node->guid,
+					      port->remoteport->node->nodedesc);
 			fprintf(stdout,
 				" - %2s %5d %2d 0x%016" PRIx64
 				" ( '%s' - '%s' )\n",
@@ -601,10 +609,12 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
 				port->remoteport->node->smalid :
 				port->remoteport->base_lid,
 				port->remoteport->portnum,
-				port->remoteport->guid, port->node->nodedesc,
-				port->remoteport->node->nodedesc);
-		else
-			fprintf(stdout, "%36s'%s'\n", "", port->node->nodedesc);
+				port->remoteport->guid, nodename, rem_nodename);
+			free(rem_nodename);
+		} else
+			fprintf(stdout, "%36s'%s'\n", "", nodename);
+
+		free(nodename);
 	}
 }
 
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
