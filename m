From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors: Fix remote node name
 printing
Date: Tue, 3 Nov 2009 19:54:15 -0800
Message-ID: <20091103195415.fb9254cf.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 3 Nov 2009 19:51:32 -0800
Subject: [PATCH] infiniband-diags/ibqueryerrors: Fix remote node name printing

	"-r" option was reporting the current node name, not the remote node
	name of the port as it should have been.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/src/ibqueryerrors.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index f83f29e..37acd70 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -145,6 +145,8 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 		 mad_dump_val(IB_PORT_PHYS_STATE_F, physstate, 64, &iphystate));
 
 	if (port->remoteport) {
+		char *rem_node_name = NULL;
+
 		if (port->remoteport->ext_portnum)
 			snprintf(ext_port_str, 256, "%d",
 				 port->remoteport->ext_portnum);
@@ -153,13 +155,19 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 
 		get_msg(width_msg, speed_msg, 256, port);
 
+		rem_node_name = remap_node_name(node_name_map,
+						port->remoteport->node->guid,
+						port->remoteport->node->nodedesc);
+
 		snprintf(remote_str, 256,
 			 "0x%016" PRIx64 " %6d %4d[%2s] \"%s\" (%s %s)\n",
 			 port->remoteport->node->guid,
 			 port->remoteport->base_lid ? port->remoteport->
 			 base_lid : port->remoteport->node->smalid,
-			 port->remoteport->portnum, ext_port_str, node_name,
+			 port->remoteport->portnum, ext_port_str, rem_node_name,
 			 width_msg, speed_msg);
+
+		free(rem_node_name);
 	} else
 		snprintf(remote_str, 256, "           [  ] \"\" ( )\n");
 
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
