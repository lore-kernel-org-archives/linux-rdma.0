From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: restore show_progress functionality
Date: Sat, 10 Apr 2010 03:56:22 +0300
Message-ID: <20100410005622.GJ4808@me>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
 <20100410005245.GH4808@me>
 <20100410005536.GI4808@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100410005536.GI4808@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Restore show_progress functionality. This output is used by scripts like
'dump_lfts.sh -D', also sometimes useful for debug.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 4780810..b438d4f 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -270,6 +270,18 @@ static void link_ports(ibnd_node_t * node, ibnd_port_t * port,
 	remoteport->remoteport = port;
 }
 
+static void dump_endnode(ib_portid_t * path, char *prompt,
+			 ibnd_node_t * node, ibnd_port_t * port)
+{
+	char type[64];
+	mad_dump_node_type(type, sizeof(type), &node->type, sizeof(int));
+	printf("%s -> %s %s {%016" PRIx64 "} portnum %d lid %d-%d \"%s\"\n",
+	       portid2str(path), prompt, type, node->guid,
+	       node->type == IB_NODE_SWITCH ? 0 : port->portnum,
+	       port->base_lid, port->base_lid + (1 << port->lmc) - 1,
+	       node->nodedesc);
+}
+
 static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 			  uint8_t * mad, void *cb_data)
 {
@@ -303,6 +315,10 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	}
 	port->guid = port_guid;
 
+	if (show_progress)
+		dump_endnode(&smp->path, node_is_new ? "new" : "known",
+			     node, port);
+
 	if (rem_node == NULL)	/* this is the start node */
 		fabric->from_node = node;
 	else {
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
