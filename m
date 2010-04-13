From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: don't try to cross discovery over CA
Date: Tue, 13 Apr 2010 19:58:57 +0300
Message-ID: <20100413165857.GO10830@me>
References: <20100218124933.c018a23d.weiny2@llnl.gov>
 <20100413104658.GA10830@me>
 <20100413165325.GN10830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100413165325.GN10830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When discovery is running from CA node it shouldn't try to cross over
all ports, but only via local one (send over non-local ports will fail
since CA doesn't route MADs).

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 03b678e..2ce15b7 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -200,7 +200,7 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
 	    == IB_PORT_PHYS_STATE_LINKUP
 	    && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
-		 node == fabric->from_node)) {
+		 (node == fabric->from_node && port_num == local_port))) {
 		ib_portid_t path = smp->path;
 		if (extend_dpath(engine, &path, port_num) > 0)
 			query_node_info(engine, &path, node);
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
