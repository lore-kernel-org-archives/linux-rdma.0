From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: don't query CA ports not connected to a
 fabric
Date: Wed, 14 Apr 2010 12:59:46 +0300
Message-ID: <20100414095946.GS10830@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413104658.GA10830@me>
 <20100413171824.GP10830@me>
 <20100413112412.de66586d.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100413112412.de66586d.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


We can save some amount of MADs by not querying CA/Router ports which
is not connected to our fabric. When discovery reaches CA or Router
node it will always get PortInfo for a port which was discovered and
not others.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 2ce15b7..51b36e5 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -339,19 +339,18 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 		link_ports(node, port, rem_node, rem_node->ports[rem_port_num]);
 	}
 
-	if (!node_is_new)
-		return 0;
-
-	query_node_desc(engine, &smp->path, node);
+	if (node_is_new) {
+		query_node_desc(engine, &smp->path, node);
 
-	if (node->type == IB_NODE_SWITCH)
-		query_switch_info(engine, &smp->path, node);
-
-	/* process all the ports on this node */
-	for (i = (node->type == IB_NODE_SWITCH) ? 0 : 1;
-	     i <= node->numports; i++) {
-		query_port_info(engine, &smp->path, node, i);
+		if (node->type == IB_NODE_SWITCH) {
+			query_switch_info(engine, &smp->path, node);
+			for (i = 0; i <= node->numports; i++)
+				query_port_info(engine, &smp->path, node, i);
+		}
 	}
+	
+	if (node->type != IB_NODE_SWITCH)
+		query_port_info(engine, &smp->path, node, port_num);
 
 	return 0;
 }
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
