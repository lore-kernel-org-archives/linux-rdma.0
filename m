From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: no backward NodeInfo queries
Date: Sat, 10 Apr 2010 03:58:57 +0300
Message-ID: <20100410005857.GN4808@me>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
 <20100410005245.GH4808@me>
 <20100410005536.GI4808@me>
 <20100410005752.GL4808@me>
 <20100410005819.GM4808@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100410005819.GM4808@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Then switch is reached via port N we don't need to query back via this
port - source node is discovered already. Finally this saves some amount
of unnecessary MADs.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 65126dd..03b678e 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -199,7 +199,8 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 
 	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
 	    == IB_PORT_PHYS_STATE_LINKUP
-	    && (node->type == IB_NODE_SWITCH || node == fabric->from_node)) {
+	    && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
+		 node == fabric->from_node)) {
 		ib_portid_t path = smp->path;
 		if (extend_dpath(engine, &path, port_num) > 0)
 			query_node_info(engine, &path, node);
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
